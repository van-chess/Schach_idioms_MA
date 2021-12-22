# -*- coding: utf-8 -*-

from csv import reader, writer
from statistics import mean

from transformers import pipeline, AutoTokenizer, AutoModelForSequenceClassification
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import pandas as pd
import csv
import re
from removeaccents import removeaccents
import unicodedata
import os
import time
#from SortedSet.sorted_set import SortedSet
from datetime import datetime, timedelta


## simple code interval timer
class TimeThat:
    def __init__(self):
        self.t_start = datetime.now()
        self.t_end = datetime.now()
        self.name = ""
        self.t_elapsed = self.t_end - self.t_start

    # start timing
    def start(self, name: str):
        self.name = name
        self.t_start = datetime.now()
        self.t_end = self.start

    # end timing
    def stop(self, print_time=True):
        self.t_end = datetime.now()
        self.t_elapsed = self.t_end - self.t_start
        if print_time:
            self.print()
        return self.t_elapsed / timedelta(milliseconds=1)

    # print elapsed time
    def print(self):
        print("<{:s}> took {} ms".format(self.name, self.t_elapsed / timedelta(milliseconds=1)))



def convert_to_uncased_no_accents(text):
    text = str(text).lower()  # convert to lowercase for processing in sentiment annotator
    cleaned_text = removeaccents.remove_accents(text)#remove accents
    return cleaned_text

def getVaderSentiment(sentence, context_window, sentiment_model):
    sentiment_label_sentence = sentiment_model.polarity_scores(sentence)['compound']  # accesses compound score for sentence
    sentiment_label_context = sentiment_model.polarity_scores(context_window)['compound']  # accesses compound score for context
    return sentiment_label_sentence,sentiment_label_context

def transform_Labels_toNumber(label):
    # here the label in Cardiff is converted to binary number
    if label == 'Neutral':
        label_as_number = '0.0'
    elif label == 'Negative':
        label_as_number = '-1.0'
    else:
        label_as_number = '1.0'
    return label_as_number


def get_sentiment_scores(sentence, context_window, sentiment_model, model_path):
    # sentence
    sentiment_label_sentence = sentiment_model(sentence)[0]['label']  # access label for sentence
    sentiment_label_context = sentiment_model(context_window)[0]['label']  # access label for sentence
    if model_path == "nlptown/bert-base-multilingual-uncased-sentiment":
        sentiment_label_sentence = re.sub(r'([a-z]+)', "", sentiment_label_sentence)  # replace('star')
        sentiment_label_context = re.sub(r'([a-z]+)', "", sentiment_label_context)  # replace('star')
    if model_path == "cardiffnlp/twitter-xlm-roberta-base-sentiment":
        sentiment_label_context=transform_Labels_toNumber(sentiment_label_context)
        sentiment_label_sentence=transform_Labels_toNumber(sentiment_label_sentence)
    return sentiment_label_sentence,sentiment_label_context

def annotateSentiment(file):
    timer = TimeThat()
    timer.start("read csv")
    csv_input = pd.read_csv(file, sep="\t", header=0)# import data as pd dataframe
    # adding columns for saving sentiment scores
    csv_input["NLP_town_stars_context_window"]=''
    csv_input["NLP_town_stars_sentence"] = ''
    csv_input["Cardiff_NLP_context_window"] = ''
    csv_input["Cardiff_NLP_sentence"] = ''
    csv_input["Vader_context_window"] = ''
    csv_input["Vader_sentence"] = ''
    timer.stop()


    #getting scores from NLP town model
    #NLP town Model  # Instantiate a pipeline object with our task and model passed as parameters,
    #https://www.kdnuggets.com/2021/06/create-deploy-sentiment-analysis-app-api.html
    model_path= 'nlptown/bert-base-multilingual-uncased-sentiment'
    sentiment_task_nlptown = pipeline(task='sentiment-analysis',
                                      model=model_path)  # loading the model
    print("NLP town initiated.")
    with open('NLP_town_scores.tsv','a+') as f:#a+ append if it doesn't exist
        f.write(f"Index\tContext_Score\tSentence_score\n")

        times_context_conv = []
        times_sentence_conv = []
        times_model = []
        times_df = []
        times_file = []

        for line_number,row in enumerate(csv_input.itertuples()):
            #print(line_number)
            sentence= row.sentence_clean
            context_window=row.context_clean
            #(zip(csv_input["sentence_clean"],csv_input["context_clean"])):#enumerate over lines and add score
            #(sentence, context_window)
            timer.start("context win conv")
            context_win_uncased = convert_to_uncased_no_accents(context_window)
            times_context_conv.append(timer.stop())
            timer.start("sentence conv")
            sentence_uncased = convert_to_uncased_no_accents(sentence)
            times_sentence_conv.append(timer.stop())

            timer.start("model")
            sentence_score_sentiment_NLP_town,context_score_sentiment_NLP_town= get_sentiment_scores(context_win_uncased, sentence_uncased, sentiment_task_nlptown, model_path)
            times_model.append(timer.stop())

            timer.start("fill df")
            csv_input.at[line_number, "NLP_town_stars_context_window"]=context_score_sentiment_NLP_town
            csv_input.at[line_number, "NLP_town_stars_sentence"] = sentence_score_sentiment_NLP_town
            times_df.append(timer.stop())
            timer.start("write file")
            f.write(f"{line_number}\t{context_score_sentiment_NLP_town}\t{sentence_score_sentiment_NLP_town}\n")# writes score in file to save
            times_file.append(timer.stop())
        csv_input.to_csv('NLP_town_full_scores.tsv', sep="\t", index= False)

        with open('Processing times.tsv', 'a+') as f:  # a+ append if it doesn't exist
            f.write(f"avg time context_conv ms: \t{mean(times_context_conv)}")
            f.write(f"avg time sentence ms: \t{mean(times_sentence_conv)}")
            f.write(f"avg time model ms: \t{mean(times_model)}")
            f.write(f"avg time df ms: \t{mean(times_df)}")
            f.write(f"avg time file ms: \t{mean(times_file)}")
        print("avg time context_conv ms: {}".format(mean(times_context_conv)))
        print("avg time sentence_conv ms: {}".format(mean(times_sentence_conv)))
        print("avg time model: {}".format(mean(times_model)))
        print("avg time df: {}".format(mean(times_df)))
        print("avg time file: {}".format(mean(times_file)))

    # # getting scores from Cardiff NLP
    # '''Load Models'''
    # ''' Pipeline with CardiffNLP'''
    model_path = "cardiffnlp/twitter-xlm-roberta-base-sentiment"
    sentiment_task_cardiff = pipeline("sentiment-analysis", model=model_path, tokenizer=model_path)
    print("Model CNLP initiated")
    with open('Cardiff_scores.tsv', 'a+') as f:  # a+ append if it doesn't exist
        f.write(f"Index\tContext_Score\tSentence_score\n")
        for line_number, row in enumerate(csv_input.itertuples()):
            sentence = row.sentence_clean
            context_window = row.context_clean
            sentence_score_sentiment_Cardiff, context_score_sentiment_Cardiff = get_sentiment_scores(convert_to_uncased_no_accents(context_window),
                                                                                                     convert_to_uncased_no_accents(sentence),
                                                                                                     sentiment_task_cardiff, model_path)
            csv_input.at[line_number, "Cardiff_NLP_context_window"] = context_score_sentiment_Cardiff
            csv_input.at[line_number, "Cardiff_NLP_sentence"] = sentence_score_sentiment_Cardiff
            f.write(f"{line_number}\t{context_score_sentiment_Cardiff}\t{sentence_score_sentiment_Cardiff}\n")  # writes score in file to save
        csv_input.to_csv('Cardiff_full_scores.tsv', sep="\t", index=False)

    # ''' Using Vader'''  # https://github.com/cjhutto/vaderSentiment
    # # using vader multihttps://pypi.org/project/vader-multi/
    # # https://github.com/brunneis/vader-multi"
    Vader_analyzer = SentimentIntensityAnalyzer()
    print("Vader initiated.")
    with open('Vader_scores.tsv', 'a+') as f:  # a+ append if it doesn't exist
        f.write(f"Index\tContext_Score\tSentence_score\n")
        for line_number, row in enumerate(csv_input.itertuples()):
            sentence = row.sentence_clean
            context_window = row.context_clean  # enumerate over lines and add score
            sentence_score_sentiment_Vader, context_score_sentiment_Vader = getVaderSentiment(context_window,sentence,Vader_analyzer)
            csv_input.at[line_number, "Vader_context_window"] = context_score_sentiment_Vader
            csv_input.at[line_number, "Vader_sentence"] = sentence_score_sentiment_Vader
            f.write(f"{line_number}\t{context_score_sentiment_Vader}\t{sentence_score_sentiment_Vader}\n")  # writes score in file to save
        csv_input.to_csv('Vader_full_scores.tsv', sep="\t", index=False)

    csv_input.to_csv('sentiment_all_pipelines_cased.tsv', sep='\t', index=False)  # writes data in tsv with original writing



if __name__ == "__main__":
    filename = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/sentiment_test_2.tsv"
    timer = TimeThat()
    timer.start("sentiment programm")
    #timer.start("sleep timer")
    #time.sleep(3.531)
    #timer.stop()
    startTime = time.time()
    annotateSentiment(filename)
    timer.stop()



    executionTime = (time.time() - startTime)
    print('Execution time in seconds: ' + str(executionTime))

#Execution time in seconds for sample: 1072.0286486148834
#Execution time in seconds: 17685.57010126114 12.11.2021


#Summary 13.11.2021 for 100 lines
# Only NLP town and Vader test_sentiment 49.70870518684387
#only Vader and Cardiff 48.7380313873291
# only Vader 0.08795714378356934
# Only NLP town 34.83814477920532
#only Cardiff 36.78884696960449
#All: 89.38630652427673
# Colab 104, using CPU (no GPU)
# -*- coding: utf-8 -*-

from csv import reader, writer
from transformers import pipeline, AutoTokenizer, AutoModelForSequenceClassification
from urllib3 import response
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import pandas as pd
import csv
import re
from removeaccents import removeaccents
import unicodedata
import os
import time
import requests


# def convert_to_uncased_no_accents(text):
#     text = str(text).lower()  # convert to lowercase for processing in sentiment annotator
#     cleaned_text = removeaccents.remove_accents(text)#remove accents
#     return cleaned_text


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
    csv_input = pd.read_csv(file, sep="\t", header=0)# import data as pd dataframe
    # adding columns for saving sentiment scores
    csv_input["NLP_town_stars_context_window"]=''
    csv_input["NLP_town_stars_sentence"] = ''
    csv_input["Cardiff_NLP_context_window"] = ''
    csv_input["Cardiff_NLP_sentence"] = ''


    #getting scores from NLP town model
    #NLP town Model  # Instantiate a pipeline object with our task and model passed as parameters,
    #https://www.kdnuggets.com/2021/06/create-deploy-sentiment-analysis-app-api.html
    model_path= 'nlptown/bert-base-multilingual-uncased-sentiment'
    sentiment_task_nlptown = pipeline(task='sentiment-analysis',
                                      model=model_path)#, cache_dir="/mount/studenten/arbeitsdaten-studenten2/schachva/")  # loading the model
    print("NLP town initiated.")
    with open('NLP_town_scores.tsv','a+') as f:#a+ append if it doesn't exist
        f.write(f"Index\tContext_Score\tSentence_score\n")
        for line_number,row in enumerate(csv_input.itertuples()):
            #print("NLP town", line_number)
            sentence= row.sentence_clean
            context_window=row.context_clean
            try:
                sentence_score_sentiment_NLP_town,context_score_sentiment_NLP_town= get_sentiment_scores(context_window, sentence, sentiment_task_nlptown, model_path)
                csv_input.at[line_number, "NLP_town_stars_context_window"]=context_score_sentiment_NLP_town
                csv_input.at[line_number, "NLP_town_stars_sentence"] = sentence_score_sentiment_NLP_town
            except ValueError:# text input must of type `str` (single example), `List[str]` (batch or single pretokenized example) or `List[List[str]]` (batch of pretokenized examples)
                csv_input.at[line_number, "NLP_town_stars_context_window"] = "NA"
                csv_input.at[line_number, "NLP_town_stars_sentence"] = "NA"

            f.write(f"{line_number}\t{context_score_sentiment_NLP_town}\t{sentence_score_sentiment_NLP_town}\n")# writes score in file to save
        print("NLP town saved")
        csv_input.to_csv('NLP_town_full_scores.tsv', sep="\t", index= False)

    # # getting scores from Cardiff NLP
    # '''Load Models'''
    # ''' Pipeline with CardiffNLP'''
    model_path = "cardiffnlp/twitter-xlm-roberta-base-sentiment"
    sentiment_task_cardiff = pipeline("sentiment-analysis", model=model_path, tokenizer=model_path)#, cache_dir="/mount/studenten/arbeitsdaten-studenten2/schachva/")
    print("Model CNLP initiated")
    with open('Cardiff_scores.tsv', 'a+') as f:  # a+ append if it doesn't exist
        f.write(f"Index\tContext_Score\tSentence_score\n")
        for line_number, row in enumerate(csv_input.itertuples()):
            #print("Cardiff", line_number)
            sentence = row.sentence_clean # row in df
            context_window = row.context_clean # row in df
            try:
                sentence_score_sentiment_Cardiff, context_score_sentiment_Cardiff = get_sentiment_scores(context_window, sentence, sentiment_task_cardiff, model_path)#(convert_to_uncased_no_accents(context_window),convert_to_uncased_no_accents(sentence) sentiment_task_cardiff, model_path)
                csv_input.at[line_number, "Cardiff_NLP_context_window"] = context_score_sentiment_Cardiff
                csv_input.at[line_number, "Cardiff_NLP_sentence"] = sentence_score_sentiment_Cardiff
            except ValueError:
                csv_input.at[line_number, "Cardiff_NLP_context_window"] = "NA"
                csv_input.at[line_number, "Cardiff_NLP_sentence"] = "NA"
            f.write(f"{line_number}\t{context_score_sentiment_Cardiff}\t{sentence_score_sentiment_Cardiff}\n")  # writes score in file to save
        print("Cardiff saved")
        csv_input.to_csv('Cardiff_full.tsv', sep="\t", index=False)

        csv_input.to_csv('sentiment_sample_pipelines_13_11_21.tsv', sep='\t', index=False)  # writes data in tsv with original writing



if __name__ == "__main__":
    filename = "sentences_and_context_clean_100sample_removed_htmltags_131221.tsv"#C:/Users/Vanessa/PycharmProjects/venv_idioms_project/
    startTime = time.time()
    annotateSentiment(filename)



    executionTime = (time.time() - startTime)
    print('Execution time in seconds: ' + str(executionTime))

# -*- coding: utf-8 -*-

from csv import reader, writer
import pandas as pd
import csv
import re
import unicodedata
import os
import time
from SortedSet.sorted_set import SortedSet
from nltk.tokenize import sent_tokenize


startTime = time.time()

filename = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/idiom_sentences_final_1312_final.tsv" # new text with domain_name
csv_input = pd.read_csv(filename, sep="\t", header=0)
all_idioms = csv_input["idiom_id"].to_list() # all_idioms = [1,1,2,2,2]
unique_ids = SortedSet(all_idioms) # a set is a datastructure which contains only unique items --> unique_ids = set(1,2)
dfs = []  # empty list which will hold dataframes

'''This function creates a sample of 100 sentences per idiom_id, if less than 100 it takes the shape (len lines of of the idiom_id group) '''
def get_sample(dataframe, sample_size):
	try:
		sample_dataframe = dataframe.sample(n = sample_size, random_state=1)
	except ValueError:
		sample_size = dataframe.shape[0] # to get rid of where id < 100
		sample_dataframe = dataframe.sample(n= sample_size, random_state =1)
	return sample_dataframe



for id in unique_ids: # for every group with a unique id, you want to draw a sample of size x
    grouped_data= csv_input[csv_input['idiom_id']==id] # create an extra dataframe which only consists of the items where the 'idiom_id' equals the id
    group_sample = get_sample(grouped_data, 100)
    dfs.append(group_sample)
all_dataframes = pd.concat(dfs)  # concatenate list of dataframes
#all_dataframes.reset_index(drop = True).to_csv('Random_100_test.tsv', sep='\t', index= False)#writes data in tsv with original writing



'''This  function inserts the cleaned sentences '''
def cleaned_context_frames(dataframe):
	#Iterate through random sample and replace sentence breaks and accents
	#sentence_list=[]
	dataframe["sentence_clean"]=''
	dataframe["context_clean"]=''
	dataframe.reset_index(drop=True, inplace=True)
	for reihe, row in enumerate(dataframe.itertuples(index=False, name=None)): # [['Left','KWIC','Right']] # itertuples is faster in runtime than iterrow, reihe is index
		print(reihe)
		index = str(row[0])
		left = str(row[7])
		#print(left)
		kwic= str(row[8])
		if "</s><s>" in kwic: # sometimes tag is in falsely kwic/idiom, remove tag
			#print(kwic)
			kwic = kwic.split("</s><s>")
			kwic= ''.join(kwic)
			#print(kwic, reihe)
		right= str(row[9])
		#print(right)
		complete_sentence= left + ' ' + kwic + ' ' + right #concatenate to sentence
		cleaned_context_of_idiom= re.sub('<.*?>', '', complete_sentence)#remove html tags
		#print('context: ', cleaned_context_of_idiom)


		''' add cleaned context to dataframe'''
		dataframe.at[reihe,"context_clean"]=cleaned_context_of_idiom # insert context in row
		#dataframe.at[reihe, "context_clean"] = cleaned_context  # insert context in row

		#tokenize sentences in context frame
		sentence= sent_tokenize(cleaned_context_of_idiom)# use nltk tokenizer

		# ''' add cleaned sentence to dataframe'''
		for item in sentence:
		# for sentence in split_sentence:
			#print(item)
			if kwic in item: # only split so that kwic/idiom is part of sentence
		# 		#pass
		 		#print('sentence: ', item)
		 		dataframe.at[reihe,"sentence_clean"]=item  # insert sentence in row
			 	#print('sentence: ', item)
		# 	#if kwic not in sentence:
		# 		#print(index)
	return dataframe


result_dataframe=cleaned_context_frames(csv_input).reset_index(drop=True).to_csv('sentences_and_context_clean_full_removed_htmltag_131221.tsv', sep='\t',
												index=False)  # writes data in tsv with cleaned sentences
result_dataframe=cleaned_context_frames(all_dataframes).reset_index(drop=True).to_csv('sentences_and_context_clean_100sample_removed_htmltags_131221.tsv', sep='\t',
												index=False)  # writes data in tsv with cleaned sentences (sample<)
print("all done")


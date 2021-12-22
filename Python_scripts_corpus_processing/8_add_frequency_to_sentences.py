import pandas as pd
import numpy as np
from pathlib import Path
import os
import glob
import time
import re
import os.path
from glob import iglob
import itertools



sentences_file = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/merged.tsv" # new text with domain_name
frequency_file ="C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/THIS_table_idioms_cleaned.csv"
col_names = ["full_relative_frequency", "idiom_id"]
csv_input_sentences = pd.read_csv(sentences_file, sep="\t", header=0)
csv_input_frequency = pd.read_csv(frequency_file, sep=";", header=0,  error_bad_lines=False)

#all_idioms = csv_input_sentences["idiom_id"].to_list() # all_idioms = [1,1,2,2,2]
relative_frequency_list=[]
#print(len(all_idioms))
relative_frequency_list_sentence =[]

for idiom_frequency, corpus_size in zip(csv_input_frequency.idiom_frequency, csv_input_frequency.corpus_size):
    #print(idiom_frequency, corpus_size)
    relative_frequency = int(idiom_frequency)/int(corpus_size)
    relative_frequency_list.append(relative_frequency)

#insert relative frequency to idioms table
csv_input_frequency.insert(17, 'relative_frequency', relative_frequency_list)

#create frequency dict from table
frequency_dict= pd.Series(csv_input_frequency.relative_frequency.values, index=csv_input_frequency.idiom_id_lang).to_dict()
#map relative frequency to sentences according to dic from frequency table, no value =NA
csv_input_sentences['relative_frequency'] = csv_input_sentences['idiom_id'].map(frequency_dict).fillna('NA')


csv_input_sentences.to_csv('added_relative_frequency_to_sentences_new161221.tsv', sep='\t', index= False)#writes data in tsv with original writing
#csv_input_frequency.to_csv('added_relative_frequency_to_table.tsv', sep='\t', index= False)#writes data in tsv with original writing
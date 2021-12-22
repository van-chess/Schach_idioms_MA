import pandas as pd
import numpy as np
from pathlib import Path
import os
import glob
import time
import re
import os.path
from glob import iglob


filename = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/added_relative_frequency_to_sentences_new161221.tsv" # new text with domain_name
csv_input = pd.read_csv(filename, sep="\t", header=0)
all_idioms = csv_input["idiom_id"].to_list() # all_idioms = [1,1,2,2,2]
new_id_list=[]
for id in all_idioms:
    id_sub = re.sub('(en)|(enb)|(ge|(geb)|(fr)|(frb))', '', id)  # remove en, fr. ge
    new_id_list.append(id_sub)


csv_input.insert(2, 'idiom_id_only', new_id_list)
csv_input.to_csv('added_idiom_id_to_sentences_161221.tsv', sep='\t')#writes data in tsv with original writing
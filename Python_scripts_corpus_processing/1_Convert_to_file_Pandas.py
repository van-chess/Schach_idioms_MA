

import pandas as pd
import numpy as np
from pathlib import Path
import os
import glob
import time
import re
import os.path
from glob import iglob

startTime = time.time()

# giving directory name of csv data
folderdir = ('C:\\Users\\Vanessa\\Desktop/Masterarbeit\\MA_repository\\Sketch_engine_corpus\\TenTenSubcorpora')

dfs = []  # empty list which will hold dataframes
filename_list=[]
directory_list=[]
culture_list=['i', 'k', 'm', 'p']
intertextuality_list=['a', 'b', 'c', 'e', 'f']
nature_list= ['n', 'o', 'r', 's']
start_dir = r"C:\\Users\\Vanessa\\Desktop/Masterarbeit\\MA_repository\\Sketch_engine_corpus\\TenTenSubcorpora"

id_dictionary = {
    "a": "ancient_sources",
    "b": "bible",
    "c": "ancient_sources",
    "e": "proverbs",
    "f": "fables_folk_narratives",
    "i": "intellectual_technical_achievements",
    "k": "special_concepts_world",
    "m": "material_culture_money_living",
    "n": "forces_of_nature",
    "o": "time_space",
    "p": "gestures_postures_facial_expressions",
    "r": "physical_reactions_sensations",
    "s": "human_body"
}

# traverse whole directory
for root, dirs, files in os.walk(folderdir):
    for dir in dirs:
        directory_list.append(dir)
        #print("directory is: ", dir)
    #print(directory_list)
    for file in files:
        #print(file)
        # check the extension of files
        if file.endswith('.csv'):
            idiom_id_list = [] # this list saves the idiom ids
            filename = file
            # print(filename)
            idiom_id = filename.removesuffix('.csv')
            filename_list.append(idiom_id)
            print('idiom_id: ', idiom_id)

            domain_name = re.sub(r'\d+\w+', "", idiom_id)  # i01en becomes i
            #print(domain_name)

            language_name = re.sub(r'b', "", idiom_id)  # replace b which appears in alternative idiom forms
            language_name = re.sub(r'\w+\d+', "", language_name)  # i01en becomes en,
            #print(language_name)

            # whole path of files
            pathtofile = os.path.join(root, file)
            # print(pathtofile)

            # skip first four rows because they contain frequency
            dataframe = pd.read_csv(pathtofile,
                                    skiprows=4)  # https://thispointer.com/pandas-skip-rows-while-reading-csv-file-to-a-dataframe-using-read_csv-in-python/

            # create new index list for renaming of index according to idiom id
            index_list = []
            # create domain letter column in list
            domain_id_list = []
            # create language list
            language_id_list = []
            # create super domain name list
            super_domain_name_list = []
            #create domain name list
            domain_name_list = []


            '''Add superdomain to dataframe'''
            for i in range(len(dataframe)):
                new_sentence_id = filename.removesuffix('.csv') + '_' + str(i + 1)
                # print(new_sentence_id)
                index_list.append(new_sentence_id)  # this is the new index column
                idiom_id_list.append(idiom_id)  # this column is added to identify which idiom id sentence belongs to
                domain_id_list.append(domain_name)  # append domain list
                language_id_list.append(language_name)  # append language name
                #
                # '''Add domain name to dataframe'''
                # for letter in domain_id_list:
                #     for key, value in id_dictionary.items():
                #         if letter == key:
                #             domain_name_list.append(value)

                # add names of domain
                if domain_name in culture_list:
                    # print(domain_name, "culture")
                    super_domain_name_list.append("culture")

                elif domain_name in intertextuality_list:
                    # print(domain_name, ":  intertextuality")
                    super_domain_name_list.append("intertextuality")

                else:
                    # print(domain_name, ":  nature")
                    super_domain_name_list.append("natural_phenomena")


                '''Add domain name to dataframe'''
            for letter in domain_id_list:
                for key, value in id_dictionary.items():
                    if letter == key:
                        domain_name_list.append(value)



            '''Here new columns are added in the dataframe'''
            dataframe.index = list(index_list)  # make sentence ID index
            dataframe.insert(0, 'idiom_id', idiom_id_list)  # insert idiom id
            dataframe.insert(1, 'language_id', language_id_list)  # insert language id
            dataframe.insert(2, 'domain_id', domain_id_list)  # insert domain id
            dataframe.insert(3, 'super_domain_name', super_domain_name_list)  # insert supedomain
            dataframe.insert(4, 'domain_name', domain_name_list)  # insert domain name

            # print(idiom_id_list)
            # print(dataframe)

            dfs.append(dataframe)  # append dataframe to list

            res = pd.concat(dfs)  # concatenate list of dataframes

            res.to_csv('idiom_sentences_final_1312_final.tsv', sep='\t')
            print('Dataframe for idiom: ' + (idiom_id) + ' saved')

executionTime = (time.time() - startTime)
print('Execution time in seconds: ' + str(executionTime))
print (domain_name_list)
# Execution time in seconds: 1056.006834745407

# print(filename_list)

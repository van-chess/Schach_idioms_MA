# importing libraries
import pandas as pd
import glob
import os
path= r'C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/all_files_sentiment'

all_files = glob.glob(path + "/*.tsv")
all_files

df_from_each_file = (pd.read_csv(f, sep='\t', error_bad_lines=False, engine ='python') for f in all_files)# ignore lines where empty
df_merged   = pd.concat(df_from_each_file, ignore_index=True)
df_merged.to_csv( "merged.tsv", sep= '\t')


# merging the files
#joined_files = os.path.join("C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/all_files_sentiment", "sentiment_*.tsv")

# A list of all joined files is returned
#joined_list = glob.glob(joined_files)

# Finally, the files are joined
#df = pd.concat(map(pd.read_csv, joined_list, ), ignore_index=True)
#df.to_csv('full_sentiment_sentences_141221.tsv', sep='\t')
#print(df)



#df = pd.read_csv('C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/all_files_sentiment/sentiment_a.tsv', error_bad_lines=False, engine ='python', sep="\t")
#df



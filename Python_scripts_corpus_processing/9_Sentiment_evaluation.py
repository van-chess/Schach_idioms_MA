#https://vitalflux.com/accuracy-precision-recall-f1-score-python-example/
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix
from sklearn.metrics import precision_score, recall_score, f1_score, accuracy_score
import matplotlib.pyplot as plt
from sklearn import metrics
from sklearn.metrics import cohen_kappa_score
from sklearn.metrics import matthews_corrcoef
from scipy.stats.stats import pearsonr
import numpy



#define function for adding adjusted rating
def f(row, rowname):
    if row[rowname] < 3:
        val = -1
    elif row[rowname] >3:
        val = 1
    else:
        val = 0
    return val

#all
filename = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/merged.tsv"
csv_input = pd.read_csv(filename, sep="\t", header=0)
csv_input=csv_input.dropna(subset=['NLP_town_stars_sentence'])
#create new converted column in full dataframe
csv_input['converted_rating_NLP_stars']= csv_input.apply(f,rowname='NLP_town_stars_sentence', axis=1)
#csv_input.to_csv('converted_column_sentiment.tsv', sep='\t', index = False)

''' Goldstandard is always the human annotation, prediction is the output by the sentiment pipeline
    Converted rating is NLP stars converted to a 1, 0, -1 scale'''
#German
prediction_German= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/NLP_Stars_sample_German_final.tsv"
annotation_German= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/Idiom_survey_German_annotated_AW.tsv"
prediction_German = pd.read_csv(prediction_German, sep=",", header=0)
annotation_German = pd.read_csv(annotation_German, sep="\t", header=0)
#create new column German
annotation_German['converted_rating']= annotation_German.apply(f,rowname='Rating', axis=1)
prediction_German['converted_rating']= prediction_German.apply(f,rowname='NLP_town_stars_sentence', axis=1)


#English
prediction_English= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/NLP_Stars_sample_English_final.tsv"
annotation_English= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/idioms_survey_English_annotated_WR.tsv"
prediction_English = pd.read_csv(prediction_English, sep=",", header=0)
annotation_English = pd.read_csv(annotation_English, sep="\t", header=0)
#create new column converted column English
annotation_English['converted_rating']= annotation_English.apply(f,rowname='Rating', axis=1)
prediction_English['converted_rating']= prediction_English.apply(f,rowname='NLP_town_stars_sentence', axis=1)

#French
prediction_French= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/NLP_Stars_sample_French_final.tsv"
annotation_French= "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/Correlation_files/Idioms_survey_French_annotated_DJ.tsv"
prediction_French = pd.read_csv(prediction_French, sep="\t", header=0)
annotation_French = pd.read_csv(annotation_French, sep="\t", header=0)
#create new column converted column English
annotation_French['converted_rating']= annotation_French.apply(f,rowname='Rating', axis=1)
prediction_French['converted_rating']= prediction_French.apply(f,rowname='NLP_town_stars_sentence', axis=1)


'''Comment out as desired'''
#true values for original rating
#y_true_English= annotation_English["Rating"]
#y_true_French= annotation_French["Rating"]
#y_true_German= annotation_German["Rating"]
#
# #Predicted values for original rating NLP town
#y_pred_English= prediction_English["NLP_town_stars_sentence"]##
#y_pred_French= prediction_French["NLP_town_stars_sentence"]##
#y_pred_German= prediction_German["NLP_town_stars_sentence"]##
#--------------------------------------------------------------
#comparison NLP converted vs Cardiff
y_true_all= csv_input['converted_rating_NLP_stars']
y_pred_all=csv_input["Cardiff_NLP_sentence"]
#correlation = np.corrcoef(y_pred_all, y_true_all)


#to compare context vs. sentence
#y_pred_all= csv_input["NLP_town_stars_context_window"]
#y_true_all= csv_input["NLP_town_stars_sentence"]


#----------------------------------------------------
#Predicted values for original rating Cardiff (against converted NLP true
y_pred_English= prediction_English["Cardiff_NLP_sentence"]#["NLP_town_stars_sentence"]##
y_pred_French= prediction_French["Cardiff_NLP_sentence"]#["NLP_town_stars_sentence"]##
y_pred_German= prediction_German["Cardiff_NLP_sentence"]#["NLP_town_stars_sentence"]##
#----------------------------------------------------------------
# True values for  converted rating NLP stars
y_true_English= annotation_English["converted_rating"]
y_true_French= annotation_French["converted_rating"]
y_true_German= annotation_German["converted_rating"]

#Predicted values for converted rating NLP stars
#y_pred_English= prediction_English["converted_rating"]
#y_pred_French= prediction_French["converted_rating"]
#y_pred_German= prediction_German["converted_rating"]


#----------------------#Sentence vs. context
# Print the confusion matrix for sentence vs. context 
print(metrics.confusion_matrix(y_true_all, y_pred_all))

# Print the precision and recall, among other metrics
print(metrics.classification_report(y_true_all, y_pred_all, digits=3, zero_division=True))


conf_matrix = confusion_matrix(y_true=y_true_all, y_pred=y_pred_all)
# #
# # Print the confusion matrix using Matplotlib
# #
fig, ax = plt.subplots(figsize=(5, 5))
ax.matshow(conf_matrix, cmap=plt.cm.Oranges, alpha=0.3)
for i in range(conf_matrix.shape[0]):
     for j in range(conf_matrix.shape[1]):
         ax.text(x=j, y=i, s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
#
plt.xlabel('Cardiff NLP sentence' , fontsize=18)#Predictions
plt.ylabel('NLP Town sentence transformed', fontsize=18)#Actuals
plt.title('NLP Town vs. Cardiff', fontsize=18)
plt.show()

#cohensKappa
print('Cohens kappa: ', cohen_kappa_score(y_true_all, y_pred_all))
print('Matthews correlation: ', matthews_corrcoef(y_true_all, y_pred_all))
print(pearsonr(y_true_all, y_pred_all))



#-------------------------------------
#English
print('ENGLISH')
# Print the confusion matrix for prediction vs. annotation
print(metrics.confusion_matrix(y_true_English, y_pred_English))

# Print the precision and recall, among other metrics
print(metrics.classification_report(y_true_English, y_pred_English, digits=3, zero_division=True))


conf_matrix = confusion_matrix(y_true=y_true_English, y_pred=y_pred_English)
# #
# # Print the confusion matrix using Matplotlib
# #
fig, ax = plt.subplots(figsize=(5, 5))
ax.matshow(conf_matrix, cmap=plt.cm.Oranges, alpha=0.3)
for i in range(conf_matrix.shape[0]):
     for j in range(conf_matrix.shape[1]):
         ax.text(x=j, y=i, s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
#
plt.xlabel('Cardiff sentence', fontsize=18)#Predictions
plt.ylabel('Annotation', fontsize=18)#Actuals
plt.title('English NLP town', fontsize=18)
plt.show()


#cohensKappa
print('Kappa: ',cohen_kappa_score(y_true_English, y_pred_English))
print('Matthews correlation: ', matthews_corrcoef(y_true_English, y_pred_English))
print(pearsonr(y_true_English, y_pred_English))


#German
print('GERMAN')
# Print the confusion matrix for annotation vs. prediction
print(metrics.confusion_matrix(y_true_German, y_pred_German))

# Print the precision and recall, among other metrics
print(metrics.classification_report(y_true_German, y_pred_German, digits=3, zero_division=True))


conf_matrix = confusion_matrix(y_true=y_true_German, y_pred=y_pred_German)
# #
# # Print the confusion matrix using Matplotlib
# #
fig, ax = plt.subplots(figsize=(5, 5))
ax.matshow(conf_matrix, cmap=plt.cm.Oranges, alpha=0.3)
for i in range(conf_matrix.shape[0]):
     for j in range(conf_matrix.shape[1]):
         ax.text(x=j, y=i, s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
#
plt.xlabel('Cardiffsentence', fontsize=18)#Predictions
plt.ylabel('Annotation', fontsize=18)#Actuals
plt.title('German Cardiff', fontsize=18)
plt.show()

#cohensKappa
print('Kappa: ', cohen_kappa_score(y_true_German, y_pred_German))
print('Matthews correlation: ', matthews_corrcoef(y_true_German, y_pred_German))
print(pearsonr(y_true_German, y_pred_German))

#French
print('FRENCH')
# Print the confusion matrix for annotation vs. prediction
print(metrics.confusion_matrix(y_true_French, y_pred_French))

# Print the precision and recall, among other metrics
print(metrics.classification_report(y_true_French, y_pred_French, digits=3, zero_division=True))


conf_matrix = confusion_matrix(y_true=y_true_French, y_pred=y_pred_French)
# #
# # Print the confusion matrix using Matplotlib
# #
fig, ax = plt.subplots(figsize=(5, 5))
ax.matshow(conf_matrix, cmap=plt.cm.Oranges, alpha=0.3)
for i in range(conf_matrix.shape[0]):
     for j in range(conf_matrix.shape[1]):
         ax.text(x=j, y=i, s=conf_matrix[i, j], va='center', ha='center', size='xx-large')
#
plt.xlabel('Cardiff sentence', fontsize=18)#Predictions
plt.ylabel('Annotation', fontsize=18)#Actuals
plt.title('French Cardiff', fontsize=18)
plt.show()


#cohensKappa
print('Kappa: ', cohen_kappa_score(y_true_French, y_pred_French))
print('Matthews correlation: ', matthews_corrcoef(y_true_French, y_pred_French))
print(pearsonr(y_true_French, y_pred_French))

import re
import json
import csv
idiomList=[]
csvList=[]
Id_List=[]
LanguageDict={}
LanguageKeys= ['English']


filename= "C:/Users/Vanessa/Desktop/Masterarbeit/Idioms/Piirainen_Lexika/Piirainen_2012.txt"
filename2= "C:/Users/Vanessa/Desktop/Masterarbeit/Idioms/Piirainen_Lexika/Piirainen_2016.txt"

'''Volume I'''
with open(filename) as f:
    content = f.readlines()

''' Find idioms in document'''
for line in content:
   Idiom_patterns = re.findall(r'\([A-F]*\s\d+\)\s+\**\(*[A-Z]+/*\s.+', line)
   Idiom_Id= re.findall(r'\([A-F]*\s\d+\)', line)
   for Id in Idiom_Id:
       if Id not in Id_List:
           #print(Id)
           Id_List.append(Id)
           Id_List.sort()
    #print(Id_List)

   #Idiom_pattern_German= re.findall(r'(^German:*)(.*?)\..*',line, re.DOTALL)  #\s+[A-Z]+\s.+', line)
   #for item in Idiom_pattern_German:
       #print(item)
   for element in Idiom_patterns:
       #print(element)
       if element not in idiomList:
           idiomList.append(element)


'''Volume II'''
with open(filename2) as f:
    content = f.readlines()

''' Find idioms in document'''
for line in content:
   Idiom_patterns = re.findall(r'\([G-U]*\s\d+\)\s+\**\(*[A-Z]+/*\s.+', line)
   Idiom_Id= re.findall(r'\([G-U]*\s\d+\)', line)
   for Id in Idiom_Id:
       if Id not in Id_List:
           Id_List.append(Id)
           Id_List.sort()


   for element in Idiom_patterns:
       #print(element)
       if element not in idiomList:
           #print(element)
           idiomList.append(element)

'''Write data in nested dictionary'''
## DICTIONARY IS MISSING DATA; ADD LATER
LanguageDict['Language'] = {}
for key in LanguageKeys:
    LanguageDict['Language'][key]=[]
    for idiom in idiomList:
        LanguageDict['Language'][key].append(idiom)
#print(LanguageDict)

'''Write in csv'''
###https://stackoverflow.com/questions/8199041/writing-a-python-list-into-a-single-csv-column
# dict = LanguageDict['Language']['English']
# with open('Idioms.csv','w')as f:
#     writer=csv.writer(f,lineterminator='\n')
#     for val in dict:
#         writer.writerow([val])
# print('CSV saved')

with open('Dictionary_Idioms_English_Full_0405.json', 'w') as fp:
    json.dump(LanguageDict, fp, indent=2, sort_keys=True)
print('Dictionary done.')


with open('Idioms_List_Full_0405.txt', 'w') as json_file:
    json.dump(idiomList, json_file, indent=2, sort_keys=True)
print('Idiom Pattern List saved')

with open('Id_List_Full.txt_0405', 'w') as json_file:
    json.dump(Id_List, json_file, indent=2, sort_keys=True)
print('ID List saved')

import json
from Structure_CQL import CQL_dict

CQL_query_dict={}
keylist = [ 'i'
           ] #die Elemente, die als keys verwendet werden um CQL zu generiern

with open('GER_i_list.json') as f:
    datenbank = json.load(f)
    print(datenbank)
    #for idiom in datenbank:
     #   print(idiom)
      #  for idiom in CQL_dict['i']:  # gehe durch jede Frage in Fragentemplate und füge sie Fragendictionary zu
       #     print(idiom)
                #CQL_query_dict['i' + ":" + element].append(
                 #   idiom.format(element=element))  # Macht append keine doppelten Werte?'''

#with open('KeyWord_Questions_JA_Dict.json', 'w') as fp:
 #   json.dump(CQL_query_dict, fp, indent=2, sort_keys=True)
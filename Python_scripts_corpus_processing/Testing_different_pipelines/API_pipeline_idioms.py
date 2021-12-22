import requests
import json
import time

CQL_list = [#'q[lemma="wie"] [lemma="ein"] [lemma="Elephant" | lemma="Elefant"] [lemma="im"] [word= "Porzellan"]*',# funktioniert in Dewac aber nicht in tenten
           # 'q[] [lemma="(?i)ruhe"] [lemma="vor"] [] [lemma="(?i)sturm"]',
            'q[lemma="schwarz"] [lemma="auf"] [lemma="weiß"]',
    ]
Id_list= ["a1", "a2", "a3"]
list_idioms = []
endpoint = 'https://api.sketchengine.eu/bonito/run.cgi'
# Replace DEMO_KEY below with your own key if you generated one.
api_key = 'b96e23b1d2ca4c668b94f2d0871390cf'
user_name = 'VChess'

for CQL in CQL_list:
    response = requests.get(endpoint + '/view', auth=(user_name, api_key),
                            params={
                                'corpname': 'preloaded/detenten13_rft3',
                                'q': CQL,
                                # 'fcrit': 'q[lemma="Ruhe"][lemma="vor"][][lemma="Sturm"]'
                                'format': 'json',
                                'kwicleftctx': -100,
                                'kwicrightctx': 100,
                                'asyn': 0,
                                'pagesize': 10000,
                            }).json()
    #print(response)
    responsecleaned = response['Lines']
    print("fetching response")

    Metadata= response['Desc'] #location of metadata in JSON
    for tag in Metadata:
        print(Metadata[0]['arg'], Metadata[0]['size'], Metadata[0]['rel'] )
    time.sleep(5)
    print("NEXT IDIOM")


    for Lines_Tag in responsecleaned: # locations of required items in JSON
        print("NEXT")
        # print left Context
        for left_string in Lines_Tag["Left"]:
            Left_Context = left_string['str']
            print("Left: " + Left_Context)
        # print(Kwic)
        for string_kwic in Lines_Tag['Kwic']:
            Kwic = string_kwic['str']
            print("Idiom: " + (Kwic))
     #print right Context
        for right_string in Lines_Tag["Right"]:
            Right_Context = right_string['str']
            print("Right: " + Right_Context)


    time.sleep(4)

with open('Ruhetenten.json', 'w') as fp:
    json.dump(response, fp, indent=2, sort_keys=False)
print('TestResponse Saved.')










#print(response)
#for g in response ['Lines']:
    #print(g)
    #for ['Lines'] in item:
      # print(result)


#print(response)
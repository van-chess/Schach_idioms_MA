# #https://cloudacademy.com/blog/natural-language-processing-stanford-corenlp/
# from pprint import pprint
# from pycorenlp.corenlp import StanfordCoreNLP
# host = "http://localhost"
# port = "9000"
# nlp = StanfordCoreNLP(host + ":" + port)
# text = "Joshua Brown, 40, was killed in Florida in May when his Tesla failed to " \
#        "differentiate between the side of a turning truck and the sky while " \
#        "operating in autopilot mode."
# output = nlp.annotate(
#     text,
#     properties={
#         "outputFormat": "json",
#         "annotators": "sentiment"
#     }
# )
#
# pprint(output)


# with Stanza https://stanfordnlp.github.io/stanza/tutorials.html#pipeline-building
# import stanza
# nlp = stanza.Pipeline(lang='en', processors='tokenize,sentiment')
# doc = nlp('I hate that they banned Mox Opal')
# for i, sentence in enumerate(doc.sentences):
#     print(i, sentence.sentiment)
# import stanza
# stanza.download('en') # download English model
# nlp = stanza.Pipeline('en') # initialize English neural pipeline
# doc = nlp("Barack Obama was born in Hawaii.") # run annotation over a sentence
# print(doc)
# print(doc.entities)


#https://github.com/Lynten/stanford-corenlp
# Simple usage
# from stanfordcorenlp import StanfordCoreNLP
#
# nlp = StanfordCoreNLP(r'C:\Users\Vanessa\Desktop\Masterarbeit\MA_repository\respository\stanford-corenlp-4.2.2')
#
# # Use an existing server
# #nlp = StanfordCoreNLP('http://localhost', port=9000)
# sentence = ('Guangdong University of Foreign Studies is located in Guangzhou.')
# print ('Tokenize:'), nlp.word_tokenize(sentence)
# print ('Part of Speech:'), nlp.pos_tag(sentence)
# print ('Named Entities:'), nlp.ner(sentence)
# print ('Constituency Parsing:'), nlp.parse(sentence)
# print ('Dependency Parsing:'), nlp.dependency_parse(sentence)
#
# nlp.close() # Do not forget to close! The backend server will consume a lot memery.
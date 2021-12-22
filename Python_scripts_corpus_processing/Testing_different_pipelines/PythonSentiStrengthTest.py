from sentistrength import PySentiStr
senti = PySentiStr()
senti.setSentiStrengthPath('C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/respository.jar') # Note: Provide absolute path instead of relative path
senti.setSentiStrengthLanguageFolderPath('C:/Documents/SentiStrengthData/') # Note: Provide absolute path instead of relative path
result = senti.getSentiment('What a lovely day')
print(result)
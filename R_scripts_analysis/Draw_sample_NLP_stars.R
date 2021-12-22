library(tidyverse)

idioms_csv <- read.csv('data/sentiment_scores_huggingface.tsv', sep = "\t")
idioms_tibble <- as_tibble(idioms_csv)
idioms_tibble
#view(idioms_tibble)
#summary(idioms_tibble)


French_only<- filter(idioms_tibble, language_id == "fr")
English_only<- filter(idioms_tibble, language_id == "en")
German_only<- filter(idioms_tibble, language_id == "ge")


# GROUP by NLP_stars

#FRENCH
#make this example reproducible
set.seed(1)
#get sample of 10 each
Stars_sample_French <- French_only %>%
  group_by(NLP_town_stars_sentence) %>%
  drop_na(NLP_town_stars_sentence)  %>%
  drop_na(NLP_town_stars_context_window)  %>%
  sample_n(size=901) # na.rm = TRUE)# len dara


#ENGLISH
#make this example reproducible
set.seed(1)
#get sample of 10 each
Stars_sample_English <- English_only %>%
  group_by(NLP_town_stars_sentence) %>%
  drop_na(NLP_town_stars_sentence) %>%
  drop_na(NLP_town_stars_context_window)  %>%
  sample_n(size=901)# len data

#GERMAN
#make this example reproducible
set.seed(3)
#get sample of 10 each
Stars_sample_German <- German_only %>%
  group_by(NLP_town_stars_sentence) %>%
  drop_na(NLP_town_stars_sentence)%>%
  drop_na(NLP_town_stars_context_window)  %>%
  sample_n(size=901)# len data


# group by idiom_id

#FRENCH
#make this example reproducible
set.seed(4)#21
#get sample by fraction (no equal len)
domain_sample_French <- Stars_sample_French %>%
  group_by(idiom_id) %>%
  sample_n(size=44)#len data

#ENGLISH
#make this example reproducible
set.seed(5)#22
#get sample by fraction (no equal len)
domain_sample_English <- Stars_sample_English %>%
  group_by(idiom_id) %>%
  sample_n(size=44)#len data

#make this example reproducible
set.seed(6)#23
#get sample by fraction (no equal len)
domain_sample_German <- Stars_sample_German %>%
  group_by(idiom_id) %>%
  sample_n(size=44)#len data

# GROUP by NLP_stars again

#FRENCH
#make this example reproducible
set.seed(7)#24
#get sample of 10 each
Ten_sample_French <- domain_sample_French %>%
  group_by(NLP_town_stars_sentence) %>%
  sample_n(size=10)


#ENGLISH
#make this example reproducible
set.seed(8)#25
#get sample of 10 each
Ten_sample_English <- domain_sample_English %>%
  group_by(NLP_town_stars_sentence) %>%
  sample_n(size=10)

#GERMAN
#make this example reproducible
set.seed(10)#26
#get sample of 10 each
Ten_sample_German <- domain_sample_German %>%
  group_by(NLP_town_stars_sentence) %>%
  sample_n(size=10)



# SAVE

write.csv(Ten_sample_English, file = "NLP_Stars_sample_English_final.tsv")


write.csv(Ten_sample_French, file = "NLP_Stars_sample_French_final.tsv")


write.csv(Ten_sample_German, file = "NLP_Stars_sample_German_final.tsv")
#CORRELATION


Stars_French <- French_only %>%
  drop_na(NLP_town_stars_sentence)  

write.csv(Stars_French, file = "NLP_Town_French.tsv",
            sep = "\t", row.names = T)

cor(Stars_French$NLP_town_stars_sentence, Stars_French$NLP_town_stars_context_window)


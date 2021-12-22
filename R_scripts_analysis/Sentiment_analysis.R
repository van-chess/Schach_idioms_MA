library(tidyverse)
library(broom)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(stargazer)
library(scales)
library(ggthemes)
library(pixiedust)

#data
idioms_frequency <- read.csv('data/THIS_table_idioms_cleaned.csv', sep= ";")
#CHANGE !!!
idioms_sentences <- read.csv('data/sentences_idioms_final.tsv', sep = "\t")#s.tsv#added_idiom_id_to_sentences.tsv
#sample <- read.csv('sample_sentences_1312_v2.tsv', sep="\t")

idioms_tibble_sentences <- tibble(idioms_sentences)

#drop first row 
idioms_sentences <- subset(idioms_sentences, select = -c(1))

#rename sentence_id and index column 

names(idioms_sentences)[2] <- "sentence_id"
names(idioms_sentences)

names(idioms_sentences)[1] <- "index"
names(idioms_sentences)

#find out how many sentences per id 
idioms_sentences %>% count(idiom_id_only, sort=TRUE)
#per domain
nr_sentences <- idioms_sentences %>% count(domain_id, sort=TRUE)
nr_sentence <- dust(nr_sentences)
write.csv(nr_sentence, file = "data/sentiment_tables/sentences_per domain.csv",
          sep = "\t", row.names = F)
#per language
idioms_sentences %>% count(language_id, sort=TRUE)


#####SENTIMENT #####

#convert Cardiff to 1-3 scale
idioms_sentences$Cardiff_NLP_sentence[idioms_sentences$Cardiff_NLP_sentence == 1 ] <- 3
idioms_sentences$Cardiff_NLP_sentence[idioms_sentences$Cardiff_NLP_sentence == 0] <- 2
idioms_sentences$Cardiff_NLP_sentence[idioms_sentences$Cardiff_NLP_sentence  < 0] <- 1


English_sentences_only <- filter(idioms_sentences, language_id %in% c('en'))
French_sentences_only <- filter(idioms_sentences, language_id %in% c('fr'))
German_sentences_only <- filter(idioms_sentences, language_id %in% c('ge'))
language <- idioms_sentences$language_id
domain <- idioms_sentences$domain_id
superdomain <- idioms_sentences$super_domain_name
idiom_id_lang <- idioms_sentences$idiom_id
idiom_id_only <- idioms_sentences$idiom_id_only
NLP_town_sentence_sentiment <- idioms_sentences$NLP_town_stars_sentence
NLP_town_context_sentiment <- idioms_sentences$NLP_town_stars_context_window
Cardiff_sentence <- idioms_sentences$Cardiff_NLP_sentence
NLP_sentence_transformed <- idioms_sentences$converted_rating_NLP_stars


#most_pos_idioms accross all languages 
pos_ids <- idioms_sentences %>% group_by(idiom_id_only) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence), SD = sd(NLP_town_stars_sentence))

pos_idioms<-pos_ids %>% arrange(desc(M))
pos_idioms

#most pos idioms including which language 
mean_ids <- idioms_sentences %>% group_by(idiom_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence))
mean_ids<-mean_ids %>% arrange(desc(M))
mean_ids


#most positive domains (by name)
dom_name <- idioms_sentences %>% group_by(domain_name) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence), SD = sd(NLP_town_stars_sentence))
dom_name<-dom_name %>% arrange(desc(M))
dom_name

#most positive domains (by id)
dom_ids <- idioms_sentences %>% group_by(domain_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence), SD = sd(NLP_town_stars_sentence))
dom_ids<-dom_ids %>% arrange(desc(M))
dom_ids

#most positive superdomain
dom_sup <- idioms_sentences %>% group_by(super_domain_name) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence), SD = sd(NLP_town_stars_sentence))

dom_sup<-dom_sup %>% arrange(desc(M))

dom_sup

#most positive language 
ranking_language_sentiment<- idioms_sentences %>% group_by(language_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = mean(NLP_town_stars_sentence), SD = sd(NLP_town_stars_sentence))
#NLP_town_stars_sentence
ranking_language_sentiment<-ranking_language_sentiment %>% arrange(desc(M))
ranking_language_sentiment

#per language idiom sentiment mean

#NLP English
English_sentiment_ranking_idiom <- English_sentences_only %>% 
  group_by(idiom_id_only) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
English_sentiment_ranking_idiom<-English_sentiment_ranking_idiom %>% arrange(desc(M))
English_sentiment_ranking_idiom

#Cardiff English
English_Cardiff_sentiment_ranking_idiom <- English_sentences_only %>% group_by(idiom_id_only) %>%
  drop_na(Cardiff_NLP_sentence) %>%
  summarize(M = round(mean(Cardiff_NLP_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
English_Cardiff_sentiment_ranking_idiom<-English_Cardiff_sentiment_ranking_idiom %>% arrange(desc(M))
English_Cardiff_sentiment_ranking_idiom

#NLP French
French_sentiment_ranking_idiom <- French_sentences_only%>% group_by(idiom_id_only) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
French_sentiment_ranking_idiom<-French_sentiment_ranking_idiom %>% arrange(desc(M))
French_sentiment_ranking_idiom

#Cardiff French
French_Cardiff_sentiment_ranking_idiom <- French_sentences_only %>% group_by(idiom_id_only) %>%
  drop_na(Cardiff_NLP_sentence) %>%
  summarize(M = round(mean(Cardiff_NLP_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))

French_Cardiff_sentiment_ranking_idiom<-French_Cardiff_sentiment_ranking_idiom %>% arrange(desc(M))
French_Cardiff_sentiment_ranking_idiom

#NLP German
German_sentiment_ranking_idiom <- German_sentences_only %>% group_by(idiom_id_only) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
German_sentiment_ranking_idiom<-German_sentiment_ranking_idiom %>% arrange(desc(M))
German_sentiment_ranking_idiom

#Cardiff German
German_Cardiff_sentiment_ranking_idiom <- German_sentences_only %>% group_by(idiom_id_only) %>%
  drop_na(Cardiff_NLP_sentence) %>%
  summarize(M = round(mean(Cardiff_NLP_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))

German_Cardiff_sentiment_ranking_idiom<-German_Cardiff_sentiment_ranking_idiom %>% arrange(desc(M))
German_Cardiff_sentiment_ranking_idiom


#per language domain id sentiment mean 
English_sentiment_ranking_domain <- English_sentences_only %>% group_by(domain_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits=2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
English_sentiment_ranking_domain<-English_sentiment_ranking_domain %>% arrange(desc(M))
English_sentiment_ranking_domain


French_sentiment_ranking_domain <- French_sentences_only %>% group_by(domain_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits = 2), SD = round(sd(NLP_town_stars_sentence), digits=2))
French_sentiment_ranking_domain<-French_sentiment_ranking_domain %>% arrange(desc(M))
French_sentiment_ranking_domain

German_sentiment_ranking_domain <-German_sentences_only %>% group_by(domain_id) %>%
  drop_na(NLP_town_stars_sentence) %>%
  summarize(M = round(mean(NLP_town_stars_sentence), digits = 2), SD = round(sd(NLP_town_stars_sentence), digits = 2))
German_sentiment_ranking_domain<-German_sentiment_ranking_domain %>% arrange(desc(M))
German_sentiment_ranking_domain


#write in tables

write.csv(pos_idioms, file = "data/sentiment_tables/mean_sentiment_idioms_NLP.csv",
            sep = "\t", row.names = F)
write.csv(dom_idioms, file = "data/sentiment_tables/mean_sentiment_domain_NLP.csv",
            sep = "\t", row.names = F)
write.csv(dom_sup, file = "data/sentiment_tables/mean_sentiment_superdomains_NLP.csv",
            sep = "\t", row.names = F)

#languages NLP
write.csv(English_sentiment_ranking_idiom, file = "data/sentiment_tables/mean_sentiment_idioms_English_NLP.tsv",
            sep = "\t", row.names = F)
write.csv(French_sentiment_ranking_idiom, file = "data/sentiment_tables/mean_sentiment_idioms_French_NLP.tsv",
            sep = "\t", row.names = F)
write.csv(German_sentiment_ranking_idiom, file = "data/sentiment_tables/mean_sentiment_idioms_German_NLP.tsv",
            sep = "\t", row.names = F)

write.csv(English_sentiment_ranking_domain, file = "data/sentiment_tables/mean_sentiment_domains_English_NLP.tsv",
          sep = "\t", row.names = F)
write.csv(French_sentiment_ranking_domain, file = "data/sentiment_tables/mean_sentiment_domains_French_NLP.tsv",
          sep = "\t", row.names = F)
write.csv(German_sentiment_ranking_domain, file = "data/sentiment_tables/mean_sentiment_domains_German_NLP.tsv",
          sep = "\t", row.names = F)

#Languages Cardiff
#languages
write.table(English_Cardiff_sentiment_ranking_idiom, file = "data/mean_sentiment_idioms_English_Cardiff.tsv",
            sep = "\t", row.names = F)
write.table(French_Cardiff_sentiment_ranking_idiom, file = "data/sentiment_tables/mean_sentiment_idioms_French_Cardiff.tsv",
            sep = "\t", row.names = F)
write.table(German_Cardiff_sentiment_ranking_idiom, file = "data/sentiment_tables/mean_sentiment_idioms_German_Cardiff.tsv",
            sep = "\t", row.names = F)

#----------------boxplots with distributions of ratings 
# test with c
c_domain <- filter(idioms_sentences, domain_id == "c")
c_domain<-c_domain %>% 
  drop_na(NLP_town_stars_sentence)

c_NLP_town <- c_domain$NLP_town_stars_sentence
c_id <- c_domain$idiom_id

ggplot(c_domain, aes(x = c_id, y = c_NLP_town, fill = c_NLP_town)) +
  geom_bar(stat = "identity", position= "fill") +
  scale_y_continuous("Proportion") +
  scale_x_discrete("", expand = c(0, 0)) +
  coord_flip()



#-----------------Plots of sentiment variables variable-------------

#convert numerical column to categorical column 

#----------English ----------#

#convert numerical column to categorical column 
English_sentences_only$NLP_town_stars_sentence = as.character(English_sentences_only$NLP_town_stars_sentence) # converting to categorical


dt_English <- English_sentences_only%>%
  dplyr::group_by(domain_id, NLP_town_stars_sentence)%>%
  drop_na(NLP_town_stars_sentence) %>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_English%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x=domain_id, y = n, fill = NLP_town_stars_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains NLP town",subtitle = "English",
       x ="domain id", y = "Percentage", fill= "Ratings ")
#facet_wrap(~super_domain_name, scale = "free_x")
#scale_fill_brewer(palette = 'Spectral')#(palette = 'Spectral')

# Cardiff NLP sentence
English_sentences_only$Cardiff_NLP_sentence = as.character(English_sentences_only$Cardiff_NLP_sentence ) # converting to categorical

#create percetages df
dt_cardiff_english <- English_sentences_only%>%
  drop_na(Cardiff_NLP_sentence) %>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  dplyr::group_by(domain_id, Cardiff_NLP_sentence)%>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_cardiff_english%>%
  ggplot(aes(domain_id, y = n, fill = Cardiff_NLP_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains Cardiff", subtitle = "English",
       x ="domain id", y = "Percentage", fill= "Ratings ")

#--------------French -----------#


#convert numerical column to categorical column 
French_sentences_only$NLP_town_stars_sentence = as.character(French_sentences_only$NLP_town_stars_sentence) # converting to categorical
df <- data.frame(English_sentences_only)

dt_French <- French_sentences_only%>%
  dplyr::group_by(domain_id, NLP_town_stars_sentence)%>%
  drop_na(NLP_town_stars_sentence) %>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_French%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(domain_id, y = n, fill = NLP_town_stars_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains NLP town", subtitle = "French",
       x ="domain id", y = "Percentage", fill= "Ratings ")
#facet_wrap(~super_domain_name, scale = "free_x")
#scale_fill_brewer(palette = 'Spectral')#(palette = 'Spectral')

# Cardiff NLP sentence
French_sentences_only$Cardiff_NLP_sentence = as.character(French_sentences_only$Cardiff_NLP_sentence ) # converting to categorical

#create percetages df
dt_cardiff_french <- French_sentences_only%>%
  dplyr::group_by(domain_id, Cardiff_NLP_sentence)%>%
  drop_na(Cardiff_NLP_sentence) %>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_cardiff_french%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(domain_id, y = n, fill = Cardiff_NLP_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains Cardiff", subtitle = "French",
       x ="domain id", y = "Percentage", fill= "Ratings ")

#-------------German -------------#



#convert numerical column to categorical column 
German_sentences_only$NLP_town_stars_sentence = as.character(German_sentences_only$NLP_town_stars_sentence ) # converting to categorical


dt_German <- German_sentences_only%>%
  dplyr::group_by(domain_id, NLP_town_stars_sentence)%>%
  drop_na(NLP_town_stars_sentence) %>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_German%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x=domain_id, y = n, fill = NLP_town_stars_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains NLP town", subtitle = "German",
       x ="domain id", y = "Percentage", fill= "Ratings ")
#facet_wrap(~super_domain_name, scale = "free_x")
#scale_fill_brewer(palette = 'Spectral')#(palette = 'Spectral')

# Cardiff NLP sentence
German_sentences_only$Cardiff_NLP_sentence = as.character(German_sentences_only$Cardiff_NLP_sentence ) # converting to categorical

#create percetages df
dt_cardiff_german <- German_sentences_only%>%
  drop_na(Cardiff_NLP_sentence) %>%
  dplyr::group_by(domain_id, Cardiff_NLP_sentence)%>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_cardiff_german%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x=domain_id, y = n, fill = Cardiff_NLP_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains Cardiff", subtitle = "German",
       x ="domain id", y = "Percentage", fill= "Ratings ")



#------------------------------------------------------------------

#Transformed NLP ratings------------------------------------
idioms_sentences$converted_rating_NLP_stars = as.character(idioms_sentences$converted_rating_NLP_stars) # converting to categorical
df <- data.frame(idioms_sentences)


dt <- idioms_sentences%>%
  dplyr::group_by(domain_id, converted_rating_NLP_stars)%>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

# change order domains
#dt$super_domain_name = factor(dt$super_domain_name, levels = c("intertextuality","culture", "natural_phenomena"))
#dt$domain_id= factor(dt$domain_id, levels = c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))

#create barplot with percentages 
dt%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x=domain_id, y = n, fill = converted_rating_NLP_stars))+
    geom_bar(stat="identity") +
#produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
                     position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains NLP Town",
       x ="domain id", y = "Percentage", fill= "Ratings ")


# Cardiff NLP sentence------------------------------------------
idioms_sentences$Cardiff_NLP_sentence = as.character(idioms_sentences$Cardiff_NLP_sentence ) # converting to categorical

#create percetages df
dt_cardiff <- idioms_sentences%>%
  dplyr::group_by(domain_id, Cardiff_NLP_sentence)%>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))

dt_cardiff%>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x=domain_id, y = n, fill = Cardiff_NLP_sentence))+
  geom_bar(stat="identity") +
  #produce geometrical text for percentages 
  geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
            position=position_stack(vjust=0.5), colour="white", size = 2)+
  theme(axis.text.x = element_text(angle = 90,hjust =0 ))+
  scale_y_continuous(labels = comma)+
  labs(title ="Sentiment ratings across domains",
       x ="domain id", y = "Percentage", fill= "Ratings ")



  #facet_wrap(~super_domain_name, scale = "free_x")
  #scale_fill_brewer(palette = 'Paired')#(palette = 'Spectral')

#-------------------------------assess normality -------------------

sum_data_all <- summary(idioms_sentences)
view(sum_data_all)

sentences <- idioms_sentences$NLP_town_stars_sentence
hist(sentences, col = 'steelblue')
abline(v=mean(sentences), lty=2, lwd=2)

qqnorm(idioms_sentences$NLP_town_stars_sentence)

barplot(idioms_sentences$NLP_town_stars_sentence)

shapiro.test(idioms_sentences$NLP_town_stars_sentence)
#https://www.programmingr.com/animation-graphics-r/qq-plot/
ggqqplot(idioms_sentences$NLP_town_stars_sentence)


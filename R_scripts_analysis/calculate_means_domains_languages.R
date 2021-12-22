
# --------------------------------------------------------


library(tidyverse)
library(broom)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(stargazer)

# Load idioms data:

idioms_frequency <- read.csv('data/THIS_table_idioms_cleaned.csv', sep= ";")
idioms_sentences <- read.csv('data/added_idiom_id_to_sentences.tsv', sep = "\t")


#idioms_dummy_nettle<- read.csv('data/table_idioms_final_version.csv', sep = ";")
#View(idioms_dummy_nettle)

# This is a data frame. Transform to tibble as follows:

idioms_frequency <- as_tibble(idioms_frequency)
idioms_sentences <- as_tibble(idioms_sentences)

#add relative_frequency
idioms_frequency<- transform(idioms_frequency, full_relative_frequency= idioms_frequency$idiom_frequency/idioms_frequency$corpus_size)


summary(idioms_frequency)






#----------------------ENGLISH---------------------------------

English_only_frequency <- filter(idioms_frequency, language %in% c('en'))
English_only_sentences <- filter(idioms_sentences, language_id %in% c('en'))


# Calculate idiom ranking and change weird column name for idiom_id
colnames(English_only_frequency)
colnames(English_only_frequency)[1] <- gsub('^...','',colnames(English_only_frequency)[1])#https://www.roelpeters.be/removing-i-umlaut-two-dots-data-frame-column-read-csv/
colnames(English_only_frequency)
#relevant columns 
English_only_frequency
English_ranked_frequency <- select(English_only_frequency, language, idiom_id, idiom_id_lang, idiom_string, domain_name,  idiom_frequency, idiom_frequency_per_mill, full_relative_frequency)
summary(English_ranked_frequency)

English_ranked_frequency_idioms <- English_ranked_frequency %>% arrange(desc(full_relative_frequency))
English_ranked_frequency_idioms

# save as csv 
write.csv2(English_ranked_frequency_idioms,"data/idioms_frequency_English_ranked.csv", row.names = TRUE)

# Compute descriptive averages of domains and idioms:
mean_domains_english <- English_only_frequency %>% group_by(domain_name) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))
mean_domains_english <- mean_domains_english %>% arrange(desc(M)) 
# save as csv 
write.csv2(mean_domains_english,"data/idioms_mean_domain_English.csv", row.names = TRUE)





#-------------------------FRENCH--------------------------------


French_only_frequency <- filter(idioms_frequency, language %in% c('fr'))
French_only_sentences <- filter(idioms_sentences, language_id %in% c('fr'))



# Compute descriptive averages:
# Calculate idiom ranking and change weird column name for idiom_id
colnames(French_only_frequency)
colnames(French_only_frequency)[1] <- gsub('^...','',colnames(French_only_frequency)[1])#https://www.roelpeters.be/removing-i-umlaut-two-dots-data-frame-column-read-csv/
colnames(French_only_frequency)
#relevant columns 
French_only_frequency
French_ranked_frequency <- select(French_only_frequency, language, idiom_id, idiom_id_lang, idiom_string, domain_name,domain_id, idiom_frequency, idiom_frequency_per_mill, full_relative_frequency)
summary(French_ranked_frequency)
French_ranked_frequency <- French_ranked_frequency %>% arrange(desc(full_relative_frequency))
French_ranked_frequency
# save as csv 
write.csv2(French_ranked_frequency,"data/idioms_frequency_French_ranked.csv", row.names = TRUE)

# Compute descriptive averages of domains and idioms:
mean_domains_french <- French_only_frequency %>% group_by(domain_name) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))
mean_domains_french <-mean_domains_french %>% arrange(desc(M))
mean_domains_french
# save as csv 
write.csv2(mean_domains_french,"data/idioms_mean_domain_French.csv", row.names = TRUE)

# --------------------------GERMAN-------------------------

German_only_frequency <- filter(idioms_frequency, language %in% c('ge'))
German_only_sentences <- filter(idioms_sentences, language_id %in% c('ge'))

# Calculate idiom ranking and change weird column name for idiom_id
colnames(German_only_frequency)
colnames(German_only_frequency)[1] <- gsub('^...','',colnames(German_only_frequency)[1])#https://www.roelpeters.be/removing-i-umlaut-two-dots-data-frame-column-read-csv/
colnames(German_only_frequency)
#relevant columns 
German_only_frequency
German_ranked_frequency <- select(German_only_frequency, language, idiom_id, idiom_id_lang, idiom_string, domain_name,domain_id, idiom_frequency, idiom_frequency_per_mill, full_relative_frequency)
summary(German_ranked_frequency)
German_ranked_frequency <- German_ranked_frequency %>% arrange(desc(full_relative_frequency))



# save as csv 
write.csv2(German_ranked_frequency,"data/idioms_frequency_German_ranked.csv", row.names = TRUE)

# Compute descriptive averages:

mean_domains_german<- German_only_frequency %>% group_by(domain_name) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))
mean_domains_german <-mean_domains_german %>% arrange(desc(M))
# save as csv 
write.csv2(mean_domains_german,"data/idioms_mean_domain_German.csv", row.names = TRUE)


# sample plots


English_only_frequency %>%
  group_by(domain_name) %>%
  summarize(M = mean(idiom_frequency_per_mill))
ggplot(aes(y=M, x=reorder(domain_name, -M), fill=domain_name)) + 
  geom_tile() +
  scale_fill_viridis_c() + 
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

English_only_frequency %>%
  group_by(domain_name) %>%
  summarize(M = mean(idiom_frequency_per_mill)) %>%
  ggplot(aes(x =reorder(domain_name, -M), y = M, fill = domain_name)) +
  geom_bar(stat = "identity") +
  theme(axis.ticks.x = element_blank()) +
  labs(
    x = "Domain id",
    y = "Mean domain ",
    title = paste(
      "Mean of idiom domain ids"
    )
  )

# SAVE

write.table(mean_domains_english, file = "mean_domain_english.csv",
            sep = "\t", row.names = F)


write.table(mean_domains_french, file = "mean_domain_french.csv",
            sep = "\t", row.names = F)


write.table(mean_domains_german, file = "mean_domain_german.csv",
            sep = "\t", row.names = F)

######MEAN Superdomains #####

#ENGLISH


# Compute descriptive averages:

mean_domains_super_english <- English_only_frequency %>% group_by(superdomain) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))


mean_domains_super_english <-mean_domains_super_english %>% arrange(desc(M))

# French


# Compute descriptive averages:

mean_domains_super_french <- French_only %>% group_by(superdomain) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))

mean_domains_super_french <-mean_domains_super_french %>% arrange(desc(M))

# German

# Compute descriptive averages:

mean_domains_super_german<- German_only %>% group_by(superdomain) %>%
  summarize(M = round(mean(idiom_frequency_per_mill),digits = 4), SD = round(sd(idiom_frequency_per_mill), digits = 4))

mean_domains_super_german <-mean_domains_super_german %>% arrange(desc(M))

# SAVE

write.table(mean_domains_english, file = "mean_domain_super_english.csv",
            sep = "\t", row.names = F)


write.table(mean_domains_french, file = "mean_domain_super_french.csv",
            sep = "\t", row.names = F)


write.table(mean_domains_german, file = "mean_domain_super_german.csv",
            sep = "\t", row.names = F)



#visualise
#https://statisticsglobe.com/plot-mean-in-ggplot2-barplot-r
ggplot(idioms_sentences, aes(x =reorder(idiom_id_only, -NLP_town_stars_sentence),NLP_town_stars_sentence, fill = domain_name)) +
  geom_bar(position = "dodge",
    show.legend = FALSE,   stat = "summary",
           fun = "mean") +
  facet_wrap(~domain_name, ncol = 2, scales = "free_x")

#(x =reorder(domain_id, -idiom_frequency_per_mill)


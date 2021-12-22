
# Load tidyverse:
#devtools::install_github("ewenharrison/finalfit")
#("effects")
#install.packages("pixiedust")
library(tidyverse)
library(dplyr)
library(GGally)
library(broom)
library(effects)
library(car)
library(pixiedust)
Idioms_sentences<- read.csv('data/sentences_idioms_final.tsv', sep = "\t")#data/full_sentiment_sentences.tsv
#sample <- read.csv('added_idiom_id_to_sentences_sample2211.tsv', sep="\t")

#Transform to tibble as follows:

Idioms_sentences <- as_tibble(Idioms_sentences)

# Check:
#View(Idioms_sentences)

#drop first row 
Idioms_sentences <- subset(Idioms_sentences, select = -c(1))

#rename sentence_id and index column 

names(Idioms_sentences)[2] <- "sentence_id"
names(Idioms_sentences)

names(Idioms_sentences)[1] <- "index"
names(Idioms_sentences)



#variables for regression

language <- Idioms_sentences$language_id
domain_id <- Idioms_sentences$domain_id
domain_name <- Idioms_sentences$domain_name
superdomain <- Idioms_sentences$super_domain_name
idiom_id <- Idioms_sentences$idiom_id_only
idiom_id_lang <- Idioms_sentences$idiom_id
sentence_id <- Idioms_sentences$sentence_id
NLP_town_sentence_sentiment <- Idioms_sentences$NLP_town_stars_sentence
NLP_town_context_sentiment <- Idioms_sentences$NLP_town_stars_context_window
Cardiff_sentence <- Idioms_sentences$Cardiff_NLP_sentence
Cardiff_context <- Idioms_sentences$Cardiff_NLP_context_window
NLP_sentence_transformed <- Idioms_sentences$converted_rating_NLP_stars
relative_frequency <- Idioms_sentences$relative_frequency

# create variables for regression 

#English_sentences_only <- filter(Idioms_sentences, language_id %in% c('en'))
#French_sentences_only <- filter(Idioms_sentences, language_id %in% c('fr'))
#German_sentences_only <- filter(Idioms_sentences, language_id %in% c('ge'))


#model 1 sentiment ~language
lm_lang <- lm(NLP_town_sentence_sentiment  ~ language)
summary(lm_lang)
anova(lm_lang)


#save
m1 <- dust(lm_lang) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m1, 'data/regression_summaries/sent_m1.csv')


#model 2a sentiment ~superdomain
lm_superdomain <- lm(NLP_town_sentence_sentiment  ~ superdomain)
summary(lm_superdomain)
anova(lm_superdomain)
m2a <- dust(lm_superdomain) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2a, 'data/regression_summaries/sent_m2a.csv')

#model 2b sentiment ~ domain name
lm_domain_name <- lm(NLP_town_sentence_sentiment  ~ domain_name)
summary(lm_domain_name)
anova(lm_domain_name)

#save
m2b <- dust(lm_domain_name) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2b, 'data/regression_summaries/sent_m2b.csv')



#model 2c sentiment ~ domain id
lm_domain_id <- lm(NLP_town_sentence_sentiment  ~domain_id)
summary(lm_domain_id)
anova(lm_domain_id)
anova_domain_id <- aov(NLP_town_sentence_sentiment  ~ language )
TukeyHSD(anova_domain_id, conf.level=.95) 
plot(TukeyHSD(anova_domain_id, conf.level=.95))#,las = 2)
#effects plot 
plot(allEffects(lm_domain_id), confint = list(style = "auto"))

#save
m2c <- dust(lm_domain_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2c, 'data/regression_summaries/sent_2c.csv')

#model 3 sentiment ~idiom_id
lm_idiom_id <- lm(NLP_town_sentence_sentiment  ~idiom_id)
summary(lm_idiom_id)
anova(lm_idiom_id)
anova_idiom_id <- aov(NLP_town_sentence_sentiment  ~ language )
TukeyHSD(anova_idiom_id, conf.level=.95) 
plot(TukeyHSD(anova_idiom_id, conf.level=.95))#,las = 2)
#effects plot 
plot(allEffects(lm_idiom_id), confint = list(style = "auto"),cex.axis = 0.2, las= 2)

#save
m3 <- dust(lm_idiom_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m3, 'data/regression_summaries/sent_m3.csv')


# model 4a
lm_lang_superdomain <- lm( NLP_town_sentence_sentiment  ~language + superdomain)
summary(lm_lang_superdomain)
anova(lm_lang_superdomain)
anova(lm_lang, lm_lang_superdomain)#m1
anova(lm_superdomain, lm_lang_superdomain)#m2a

#collinearity
vif(lm_lang_superdomain)
#save
m4a <- dust(lm_lang_superdomain) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4a, 'data/regression_summaries/sent_m4a.csv')

#model 4b
lm_lang_domain_name <- lm(NLP_town_sentence_sentiment  ~ language + domain_name)
summary(lm_lang_domain_name)
anova(lm_lang_domain_name)
anova(lm_lang, lm_lang_domain_name)#m1
anova(lm_domain_name,lm_lang_domain_name)#m2b

#collinearity
vif(lm_lang_domain_name)

#save
m4b <- dust(lm_lang_domain_name) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4b, 'data/regression_summaries/sent_m4b.csv')

#model 4c
lm_lang_domain_id <- lm(NLP_town_sentence_sentiment  ~ language + domain_id)
summary(lm_lang_domain_id)
anova(lm_lang_domain_id)
anova(lm_lang, lm_lang_domain_id)#m1
anova(lm_domain_id, lm_lang_domain_id)#m2c


#collinearity
vif(lm_lang_domain_id)


m4c <- dust(lm_lang_domain_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4c, 'data/regression_summaries/sent_m4c.csv')


#model 4d
lm_lang_idiom_id <- lm(NLP_town_sentence_sentiment  ~language + idiom_id)
summary(lm_lang_idiom_id)
anova(lm_lang_idiom_id)
anova(lm_lang, lm_lang_idiom_id)
anova(lm_idiom_id, lm_lang_idiom_id)


#collinearity
vif(lm_lang_idiom_id)

m4d <- dust(lm_lang_idiom_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4d, 'data/regression_summaries/sent_m4d.csv')

R<- predictorEffect("type", lm1)
R> plot(e3.lm1, lines=list(multiline=TRUE))

# testmodel vif - just to test collinearity 
lm_lang_superdomain_domain_name <- lm(NLP_town_sentence_sentiment  ~ language + superdomain + domain_name + domain_id+ idiom_id)
summary(lm_lang_superdomain_domain_name)
vif(lm_lang_superdomain_domain_name) #there are aliased coefficients in the model

#model 5a
lm_lang_superdomain_int <- lm(NLP_town_sentence_sentiment  ~ language * superdomain)
summary(lm_lang_superdomain_int)
anova(lm_lang_superdomain_int)
anova(lm_lang_superdomain, lm_lang_superdomain_int)#m4a


#collinearity
vif(lm_lang_superdomain_int)


anova_int_sup <- aov(NLP_town_sentence_sentiment  ~ language * superdomain )
TukeyHSD(anova_int_sup, conf.level=.95) 
plot(TukeyHSD(anova_int_sup, conf.level=.95))#,las = 2)
#effects plot 
plot(allEffects(lm_lang_superdomain_int), confint = list(style = "auto"),cex.axis = 0.2, las= 2)

#save
m5a <- dust(lm_lang_superdomain_int) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5a, 'data/regression_summaries/sent_5a.csv')

#model 5b
lm_lang_domain_int <- lm(NLP_town_sentence_sentiment  ~ language * domain_name)
summary(lm_lang_domain_int)
anova(lm_lang_domain_int)
anova(lm_lang_domain_name, lm_lang_domain_int)


#collinearity
vif(lm_lang_domain_int)

anova_int_dom <- aov(NLP_town_sentence_sentiment  ~ language * domain_name )
TukeyHSD(anova_int_dom, conf.level=.95) 
plot(TukeyHSD(anova_int_dom, conf.level=.95))#,las = 2)
#effects plot 
plot(allEffects(lm_lang_domain_int), confint = list(style = "auto"),cex.axis = 0.2, las= 2)
#save
m5b <- dust(lm_lang_domain_int) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5b, 'data/regression_summaries/sent_m5b.csv')

#model 5c
lm_lang_domain_id_int <- lm(NLP_town_sentence_sentiment  ~ language * domain_id)
summary(lm_lang_domain_id_int)
anova(lm_lang_domain_id_int)
anova(lm_lang_domain_id, lm_lang_domain_id_int)#4c


#collinearity
vif(lm_lang_domain_id_int)

anova_int_dom_id <- aov(NLP_town_sentence_sentiment  ~ language * domain_id )
TukeyHSD(anova_int_dom_id, conf.level=.95) 
plot(TukeyHSD(anova_int_dom_id, conf.level=.95))#,las = 2)

#effects plot 
plot(predictorEffect("domain_id", lm_lang_domain_id_int), lines=list(multiline=TRUE), confint = list(style = "bars"), cex.axis = 0.2, las= 2)

#save
m5c <- dust(lm_lang_domain_id_int) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5c, 'data/regression_summaries/sent_m5c.csv')

#model 5d
lm_lang_idiom_id_int <- lm(NLP_town_sentence_sentiment  ~ language * idiom_id)
summary(lm_lang_idiom_id_int)
anova(lm_lang_idiom_id_int)
anova(lm_lang_idiom_id, lm_lang_idiom_id_int)#m3


#collinearity
vif(lm_lang_idiom_id_int)#there are aliased coefficients in the model

anova_int_idiom_id <- aov(NLP_town_sentence_sentiment  ~ language * idiom_id )
TukeyHSD(anova_int_idiom_id, conf.level=.95) 
plot(TukeyHSD(anova_int_idiom_id, conf.level=.95))#,las = 2)


m5d <- dust(lm_lang_idiom_id_int) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5d, 'data/regression_summaries/sent_m5d.csv')

#effects plots 
plot(predictorEffect("language", lm_lang_idiom_id_int,
                     #transformation = list(link = log, inverse = exp)),
                     lines = list(multiline = TRUE),
                     axes = list(
                       x = list(rotate = 45),
                       y = list(lab = "log rel")), 
                     confint = list(style = "auto")))


#plot(allEffects(lm_lang_idiom_id_int), confint = list(style = "auto"),cex.axis = 0.2, las= 2)
#---------------------------------------------------------------------
# use Cardiff 
# transform ratings to 1-3 

Idioms_sentences$Cardiff_NLP_sentence[Idioms_sentences$Cardiff_NLP_sentence == 1 ] <- 3
Idioms_sentences$Cardiff_NLP_sentence[Idioms_sentences$Cardiff_NLP_sentence == 0] <- 2
Idioms_sentences$Cardiff_NLP_sentence[Idioms_sentences$Cardiff_NLP_sentence <0] <- 1

Cardiff_new <- Idioms_sentences$Cardiff_NLP_sentence
#use best model 
Cardiff_5d <- lm(Cardiff_new ~ language *idiom_id)
summary(Cardiff_5d)
anova(Cardiff_5d)

Cardiff_m5d <- dust(Cardiff_5d) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(Cardiff_m5d, 'data/regression_summaries/sent_cardiff_m5d.csv')



#plot effects
Cardiff_5c <- lm(Cardiff_new ~ language *domain_id)
plot(predictorEffect("domain_id", Cardiff_5c,
                     #transformation = list(link = log, inverse = exp)),
                     lines = list(multiline = TRUE),
                     axes = list(
                       x = list(rotate = 45),
                       y = list(lab = "log rel")), 
                     confint = list(style = "auto")))
plot(predictorEffect("domain_id", Cardiff_5c), lines=list(multiline=TRUE), 
     confint = list(style = "bars"), cex.axis = 0.2, las= 2)

#model 6, predict ferquency??? 
# replace values in Cardiff NLp to a scale of 1,2,3
Idioms_sentences$NLP_town_stars_sentence[Idioms_sentences$NLP_town_stars_sentence >= 4 ] <- "positive"
Idioms_sentences$NLP_town_stars_sentence[Idioms_sentences$NLP_town_stars_sentence == 3] <- "neutral"
Idioms_sentences$NLP_town_stars_sentence[Idioms_sentences$NLP_town_stars_sentence <= 2] <- "negative"

NLP_town_sentence_categorical <- Idioms_sentences$NLP_town_stars_sentence


lm_frequency_pred <- lm(relative_frequency ~ NLP_town_categorical)
summary(lm_frequency_pred)
vif(lm_frequency_pred)
anova(lm_frequency_pred)
plot(allEffects(lm_frequency_pred))
plot(predictorEffect("NLP_town_sentence_categorical", lm_frequency_pred))


m6 <- dust(lm_frequency_pred) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 3) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6, 'data/regression_summaries/sent_m6.csv')



#----------------Zoom into domain c---------
#filter c: c is most positive across languages 
c_domain <- filter(Idioms_sentences, domain_id %in% c("c"))
#view(c_domain)
c_lang <- c_domain$language_id
c_idiom_id <- c_domain$idiom_id_only
c_sent_cardifff <- c_domain$Cardiff_NLP_sentence
c_sentiment <- c_domain$NLP_town_stars_sentence


lm_c_domain_id <- lm(c_sentiment ~ c_idiom_id * c_lang)#, data= c_domain)
summary(lm_c_domain_id)
anova(lm_c_domain_id)

predicted_c <- allEffects(lm_c_domain_id)


plot(predictorEffect("c_idiom_id", 
                     lm_c_domain_id), lines = list(multiline=TRUE), confint = list(style = "auto"))

anova_selected_c<- aov(c_sentiment ~ c_idiom_id  * c_lang)
TukeyHSD(anova_selected_c, conf.level=.95) 
plot(TukeyHSD(anova_selected_c, conf.level=.95) )

#Cardiff model c

lm_c_domain_id_cardiff <- lm(c_sent_cardifff~ c_idiom_id * c_lang)#, data= c_domain)
summary(lm_c_domain_id_cardiff)
anova(lm_c_domain_id_cardiff)

predicted_c_cardiff <- allEffects(lm_c_domain_id_cardiff)
predicted_c_cardiff

plot(predictorEffect("c_idiom_id", 
                     lm_c_domain_id_cardiff), lines = list(multiline=TRUE), confint = list(style = "auto"))

anova_selected_c<- aov(c_sentiment ~ c_idiom_id  * c_lang)
TukeyHSD(anova_selected_c, conf.level=.95) 
plot(TukeyHSD(anova_selected_c, conf.level=.95) )

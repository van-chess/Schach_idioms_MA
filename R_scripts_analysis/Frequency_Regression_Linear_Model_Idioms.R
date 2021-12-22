#Model procedure
    #Step 1: frequency predictors: simple linear regression	
#Model 1	Relative frequency ~ language
#Model 2a	Relative frequency ~ superdomain
#Model 2.b	Relative frequency ~ domain
#Model 2c	Relative frequency ~ idiom_id
    #Step 2: Multiple linear regression 
#Model 4.a	Relative frequency ~ language + superdomain
#Model 4.b.	Relative frequency ~ language + domain
#Model 4.c.	Relative frequency ~ language + superdomain +domain
#Model 5	Relative frequency ~ language + superdomain +domain +idiom_id
    #Step 3: Interactions
#Model6	Relative frequency ~ most significant predictor1 * most significant predictor2

# --------------------------------------------------------
# Load packages
#install.packages("Hmisc")
library(tidyverse)
library(dplyr)
library(GGally)
library(broom)
library(effects)
library(car)
library(stargazer)
library(finalfit)
#install.packages('mctest')
library(gsubfn)
library(proto)
library(mctest)
library(Hmisc)
library(languageR)
library(corrplot)
library(rms)
#install.packages("emmeans")
library(emmeans)
library(MASS)
library(pixiedust)


#load original file 
Idioms <- read.csv('data/THIS_table_idioms_cleaned.csv'  , sep = ";")  
##

# this would be an alternative version where the "b-versions of c25 and m04enb are merged into one idiom
#Idioms<- read.csv('data/cleaned_table.csv', sep = ";")

#Another way would be dropping these alternative versions in total 
#Idioms <- Idioms[!(Idioms$idiom_id_lang =="m04enb"| Idioms$idiom_id =="c25enb" 
# | Idioms$idiom_id =="c25geb" | Idioms$idiom_id =="c25frb"),]


# change weird column name for idiom_id
colnames(Idioms)[1] <- gsub('^...','',colnames(Idioms)[1])#https://www.roelpeters.be/removing-i-umlaut-two-dots-data-frame-column-read-csv/
colnames(Idioms)




#Add RelFreq : relative_frequency = absolute_frequency/corpus_size
Idioms <- transform(Idioms, full_relative_frequency = Idioms$idiom_frequency/Idioms$corpus_size)
summary(Idioms)

#add log transformed relative frequency
Idioms <- transform(Idioms, log_relative_frequency = log(full_relative_frequency))
Idioms

#create variables 
idiom_only <- Idioms$idiom_id
idiom_id_lang <- Idioms$idiom_id_lang
superdomain <- Idioms$superdomain
domain_name <- Idioms$domain_name
domain_id <- Idioms$domain_id
language <- Idioms$language
relative_frequency_overall <- Idioms$full_relative_frequency
log_frequency <- Idioms$log_relative_frequency


#Model 1 frequency ~ language
lm_lang_only <- lm(relative_frequency_overall ~ language)
summary(lm_lang_only)
#save
m1 <- dust(lm_lang_only) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m1, 'data/regression_summaries/freq_m1.csv')




#Tukey
anova_language <- aov(relative_frequency_overall ~ language )
anova_language
TukeyHSD(anova_language, conf.level=.95) 
plot(TukeyHSD(anova_language, conf.level=.95))#,las = 2)
#effects plot 
plot(allEffects(lm_lang_only), confint = list(style = "auto"))


#Model 2a frequency ~ superdomain
lm_superdomain_only <- lm(relative_frequency_overall ~ superdomain )
summary(lm_superdomain_only)

#save
m2a <- dust(lm_superdomain_only) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2a, 'data/regression_summaries/freq_m2a.csv')



#anova
anova(lm_superdomain_only)

#Tukey test
anova_lm_only_superdomain <- aov(relative_frequency_overall ~ superdomain )
TukeyHSD(anova_lm_only_superdomain, conf.level=.95) 
plot(TukeyHSD(anova_lm_only_superdomain, conf.level=.95), las = 2, cex.axis=0.5)
#effects plot 
plot(allEffects(lm_superdomain_only), confint = list(style = "auto"),  cex.axis = 6)


#Model 2b frequency ~ domain_name
lm_domain_name <- lm(relative_frequency_overall ~domain_name)
summary(lm_domain_name)

#save
m2b <- dust(lm_domain_name) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2b, 'data/regression_summaries/freq_m2b.csv')

#anova
anova(lm_domain_name)
#Tukey test
anova_lm_domain <- aov(relative_frequency_overall ~ domain_name )
TukeyHSD(anova_lm_domain, conf.level=.95) 
plot(TukeyHSD(anova_lm_domain, conf.level=.95,las = 1))
#effects plot 
plot(allEffects(lm_domain_name), confint = list(style = "auto"), las =3)


#Model 2c frequency ~ domain_id
lm_ony_domain_id <- lm(relative_frequency_overall ~  domain_id )
summary(lm_ony_domain_id)

#save
m2c <- dust(lm_ony_domain_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m2c, 'data/regression_summaries/freq_m2c.csv')


#anova
anova(lm_ony_domain_id)
anova_model_2c <- aov(relative_frequency_overall ~domain_id)
TukeyHSD(anova_model_2c, conf.level=.95)
plot(TukeyHSD(anova_model_2c, conf.level=.95))
#effects plots
plot(predictorEffects(lm_ony_domain_id), lines=list(multiline=TRUE), confint = list(style = "auto"), las =3)


#Model 3	Relative frequency ~ idiom_id
lm_idiom_id <- lm(relative_frequency_overall ~ idiom_only)
summary(lm_idiom_id)

#save
#save
m3 <- dust(lm_idiom_id) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m3, 'data/regression_summaries/freq_m3.csv')


#anova
anova(lm_idiom_id)
#Tukey
#anova_model_3 <- aov(relative_frequency_overall ~idiom_only)
#TukeyHSD(anova_model_3, conf.level=.95)
#plot(TukeyHSD(anova_model_3, conf.level=.95))
#effects plots
#plot(predictorEffects(lm_ony_domain_id), lines=list(multiline=FALSE), confint = list(style = "auto"), las =3)


#Model 4a frequency ~ language + superdomain
#only used to confirm collinearity 
lm_lang_superdomain <- lm(relative_frequency_overall ~ language + superdomain)
summary(lm_lang_superdomain)

#save
m4a <- dust(lm_lang_superdomain) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4a, 'data/regression_summaries/freq_m4a.csv')


#anova
anova(lm_lang_superdomain)
anova(lm_superdomain_only, lm_lang_superdomain)
anova(lm_lang_only, lm_lang_superdomain )
vif(lm_lang_superdomain)# up to 1.3

#Model 4b frequency ~ language + domain_name
lm_domain_lang <- lm(relative_frequency_overall ~ language + domain_name )
summary(lm_domain_lang)

#save
m4b <- dust(lm_domain_name) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4b, 'data/regression_summaries/freq_m4b.csv')


anova(lm_domain_lang)
anova(lm_lang_only, lm_domain_lang)
anova(lm_superdomain_only, lm_domain_lang)
vif(lm_domain_lang)# upto 1.7


#plot(lm_domain_lang, which = 1)

#Model 4c frequency ~ language + domain_id
lm_domain_id_lang <- lm(relative_frequency_overall ~ language + domain_id )
summary(lm_domain_id_lang)

#save
m4c <- dust(lm_domain_id_lang) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4c, 'data/regression_summaries/freq_m4c.csv')

anova(lm_domain_id_lang)
anova(lm_lang_only, lm_domain_id_lang)
anova(lm_domain_name, lm_domain_id_lang)
vif(lm_domain_id_lang)

#post hoc turkey
anova_model_4c <- aov(relative_frequency_overall ~ language + domain_id)
tukey_4_c <- TukeyHSD(anova_model_4c, conf.level=.95)
tukey_4_c
plot(TukeyHSD(anova_model_4c, conf.level=.95), las=1 , col="brown", cex.axis = 0.2)
model_out_4c <- dust(tukey_4_c) 
write.csv(model_out_4c, "data/regression_summariesTukey_model_4c.csv" )

#emeans
emmeans(lm_domain_id_lang, list(pairwise~domain_id),
        adjust='bonferroni')


plot(predictorEffect(lm_domain_id_lang, "language"), lines=list(multiline=TRUE), confin)


plot(predictorEffect("domain_id", lm_domain_id_lang,
                     #transformation = list(link = log, inverse = exp)),
                     lines = list(multiline = TRUE),
                     axes = list(
                       x = list(rotate = 45),
                       y = list(lab = "log rel")), 
                     confint = list(style = "auto")))


res_4c <- residuals(lm_domain_id_lang)
hist(res_4c)
qqnorm(res_4c )
qqline(res_4c )



#Model 5a Relative frequency ~ language + superdomain + domain
lm_lang_superdomain_domain <- lm(relative_frequency_overall ~ language +superdomain + domain_name )
summary(lm_lang_superdomain_domain)

#save
m5a <- dust(lm_lang_superdomain_domain) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5a, 'data/regression_summaries/freq_m5a.csv')



anova(lm_lang_superdomain_domain)
anova(lm_lang_superdomain, lm_lang_superdomain_domain)
anova(lm_domain_lang, lm_lang_superdomain_domain)
vif(lm_lang_superdomain_domain)
alias(lm_lang_superdomain_domain)



#Model 5b Relative frequency ~ language + superdomain +domain_id
lm_domain_id_superdomain_lang <- lm(relative_frequency_overall ~ language +superdomain + domain_id )
summary(lm_domain_id_superdomain_lang)

#save
m5b <- dust(lm_domain_id_superdomain_lang) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m5b, 'data/regression_summaries/freq_m5b.csv')


#anova
anova(lm_domain_id_superdomain_lang)
anova(lm_lang_superdomain, lm_domain_id_superdomain_lang)
anova(lm_domain_id_lang, lm_domain_id_superdomain_lang)
#assess collinearity - correlation is perject between domain and supedomain
vif(lm_domain_id_superdomain_lang)#there are aliased coefficients in the model
alias(lm_domain_id_superdomain_lang)


#model 6a Relative frequency ~ language * superdomain
lm_superdomain_lang_int <- lm(relative_frequency_overall ~ language * superdomain)
summary(lm_superdomain_lang_int)

#save
m6a <- dust(lm_superdomain_lang_int) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6a, 'data/regression_summaries/freq_m6a.csv')


anova(lm_superdomain_lang_int)
anova(lm_lang_superdomain,lm_superdomain_lang_int)
#check collinearity 
vif(lm_superdomain_lang_int)#up to 3.9



#Model 6b Relative frequency ~ language * domain name
lm_domain_name_lang_interaction <- lm(relative_frequency_overall ~  language  *domain_name)
summary(lm_domain_name_lang_interaction)

#save
m6b <- dust(lm_domain_name_lang_interaction) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6a, 'data/regression_summaries/freq_6a.csv')

anova(lm_domain_name_lang_interaction)
anova(lm_domain_lang, lm_domain_name_lang_interaction)#m4b
#anova(lm_domain_name, lm_domain_name_lang_interaction)
vif(lm_domain_name_lang_interaction)


#Model 6c Relative frequency ~ language * domain id
lm_domain_id_lang_interaction <- lm(relative_frequency_overall ~  language  * domain_id)
summary(lm_domain_id_lang_interaction)

#save
m6c <- dust(lm_domain_id_lang_interaction) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6c, 'data/regression_summaries/freq_m6c.csv')



anova(lm_domain_id_lang_interaction)
anova(lm_domain_id_lang, lm_domain_id_lang_interaction)
vif(lm_domain_name_lang_interaction)#languagefr 13.936364 languagege 13.936364 

#post hoc turkey
anova_model_6c <- aov(relative_frequency_overall ~ language * domain_id)
tukey_6_c <- TukeyHSD(anova_model_6c, conf.level=.95)
tukey_6_c
#plot(TukeyHSD(anova_model_6c, conf.level=.95), las=1 , col="brown", cex.axis = 0.2)
#model_out_4c <- dust(tukey_6_c) 




#-----------------------work with model 4 c-----------------

#-----------------OUTLIERS---------------
 #log transformation

logarithmic_model_4c <- lm(log_frequency~ language + domain_id)
summary(logarithmic_model_4c)

#save
m4c_log <- dust(logarithmic_model_4c) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4c_log, 'data/regression_summaries/freq_m4c_log.csv')


anova(logarithmic_model_4c)
stargazer(logarithmic_model_4c)
model_4c_log <- dust(logarithmic_model_4c, digits = NA)
write.csv(model_4c_log, "data/4_c_log.csv" )
plot(predictorEffect("language", logarithmic_model_4c))

#6c log transfomred 
logarithmic_model_6c <- lm(log_frequency~ language*domain_id)
summary(logarithmic_model_6c)

#save
m6c_log <- dust(logarithmic_model_6c) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6c_log, 'data/regression_summaries/freq_m6c_log.csv')

anova(logarithmic_model_6c)

plot(predictorEffect("language", logarithmic_model_6c,
                     #transformation = list(link = log, inverse = exp)),
                     lines = list(multiline = TRUE),
                     axes = list(
                       x = list(rotate = 45),
                       y = list(lab = "log rel")), 
                     confint = list(style = "auto")))


res_4clog <- residuals(logarithmic_model_4c)
hist(res_4clog )
qqnorm(res_4clog )
qqline(res_4clog )
plot(fitted(logarithmic_model_4c, res_4clog ))
glance(res_4clog )

#---------------------outliers removal-----------#

#https://statsandr.com/blog/outliers-detection-in-r/

ids <- as.data.frame(Idioms[,c("idiom_id", "language", "idiom_string", "full_relative_frequency","domain_name", "superdomain")])

quantile(ids$full_relative_frequency, 0.25) # first quartile
quantile(ids$full_relative_frequency, 0.75) # third quartile
IQR(ids$full_relative_frequency)#interquartile range
sd(ids$full_relative_frequency) / mean(ids$full_relative_frequency)#coefficient of variation

out <- boxplot.stats(ids$full_relative_frequency)$out
out_ind <- which(ids$full_relative_frequency %in% c(out))
out_ind
outliers <- ids[out_ind, ]
write.csv(outliers, "data/outliers.csv" )

boxplot(ids$full_relative_frequency,
        ylab = "hwy",
        main = "Boxplot of highway miles per gallon"
)
mtext(paste("Outliers: ", paste(out, collapse = ", ")))

lower_bound <- quantile(ids$full_relative_frequency, 0.01)
lower_bound

upper_bound <- quantile(ids$full_relative_frequency, 0.99)
upper_bound

outlier_ind <- which(ids$full_relative_frequency < lower_bound | ids$full_relative_frequency > upper_bound)
outlier_ind

ids[outlier_ind, "full_relative_frequency"]
ids[outlier_ind, ]

plot(density(ids$full_relative_frequency))
qqnorm(ids$full_relative_frequency)


#dropping specific frequencies 
df_drop <- Idioms[!(Idioms$idiom_id =="m04" | Idioms$idiom_id =="c25" 
                    | Idioms$idiom_id =="p09"),]

#new boxplot
df_drop%>% 
  ggplot(aes(x =reorder(domain_id, -idiom_frequency_per_mill), y =idiom_frequency_per_mill, fill = domain_name)) +
  geom_boxplot() + theme_minimal() +
  scale_fill_brewer(palette = 'Set3')#(palette = 'Spectral')

#best model from previous step 4c
lm_drop_4c<- lm(df_drop$full_relative_frequency ~ df_drop$language + df_drop$domain_id)
summary(lm_drop_4c)
anova(lm_drop_4c)

#save
m4c_outliers <- dust(lm_drop_4c) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m4c_outliers, 'data/regression_summaries/freq_m4c_outliers.csv')

#normality plots
plot(lm_drop_4c)
res <- residuals(lm_drop_4c)
hist(res)
qqnorm(res)
qqline(res)
plot(fitted(lm_drop_4c, res))
glance(lm_drop_4c)


#interaction 6c without outliers

#variables
frequency <- df_drop$full_relative_frequency
language_df_drop <- df_drop$language 
idiom_id_drop <- df_drop$idiom_id
domain_id_drop <- df_drop$domain_id

#domain language interaction
lm_drop_6c<- lm(frequency ~ language_df_drop * domain_id_drop)
summary(lm_drop_6c)

#save
m6c_outliers <- dust(lm_drop_6c) %>% 
  sprinkle(cols = c("estimate", "std.error", "statistic"),
           round = 12) %>% 
  sprinkle(cols = "p.value", fn = quote(pvalString(value))) %>% 
  sprinkle_colnames(term = "Term", p.value = "P-value", 
                    std.error = "SE", statistic = "T-statistic",
                    estimate = "Coefficient")
write.csv(m6c_outliers, 'data/regression_summaries/freq_m6c_outliers.csv')

anova(lm_drop_6c)


plot(allEffects(lm_drop_6c))
plot(predictorEffect("domain_id_drop", lm_drop_lang_id), lines = list(multiline=TRUE))

#add residuals
plot(Effect(c("domain_id_drop"), lm_drop_6c, residuals=TRUE),
     axes=list(x=list(rotate=30)),
     partial.residuals=list(span=0.9))
     #layout=c(, ))

summary(lm_drop_6c)
plot(lm_drop_6c)
glance(lm_drop_6c)$r.squared

res <- residuals(lm_drop_lang_id)

hist(res)
qqnorm(res)
qqline(res)
plot(fitted(lm_drop_6c, res))



#---------------------------------------------------
#filter domains

#fit model on domain c

c_domain<-  filter(Idioms, domain_id %in% c('c'))
c_lang_fr <- c_domain$language
c_idiom_id_fr <- c_domain$idiom_id
c_domain_rel_freq <- c_domain$full_relative_frequency

lm_c_domain_id_fr <- lm(c_domain_rel_freq ~ c_idiom_id_fr  + c_lang_fr)#, data= c_domain)
summary(lm_c_domain_id_fr)
anova(lm_c_domain_id)

plot(allEffects(lm_c_domain_id_fr))

plot(predictorEffect("c_lang_fr", 
                     lm_c_domain_id_fr), lines = list(multiline=TRUE))#,# confint = list(style = "auto"))

anova_selected_c<- aov(c_domain_rel_freq ~ c_idiom_id_fr  * c_lang_fr)
TukeyHSD(anova_selected_c, conf.level=.95) 
plot(TukeyHSD(anova_selected_c, conf.level=.95) )

#-------------------------------------------------
#test dfs for comparisons
# selected domains 

selected_dom <- filter(Idioms, domain_id %in% c('m', 'p', 'a', 'c', 'i'))
anova_selected_dom<- aov( full_relative_frequency ~ language + domain_id , data=selected_dom)
TukeyHSD(anova_selected_dom, conf.level=.95) 
plot(TukeyHSD(anova_selected_dom, conf.level=.95) )


#m 
m_domain_lang <- filter(Idioms, domain_id %in% c('m'))
summary(m_domain_lang)
anova_m_domain_lang <- aov( full_relative_frequency ~ language, data=m_domain_lang)
TukeyHSD(anova_m_domain_lang, conf.level=.95) 
plot(TukeyHSD(anova_m_domain_lang, conf.level=.95) )


model_out_m <- dust(Tukey_c_a) 
write.csv(model_out_m, "data/Tukey_m.csv" )


#c and a
c_domain_lang <-  filter(Idioms, domain_id %in% c('a', 'c'))
anova_c_a_domain_lang <- aov( full_relative_frequency ~ language + domain_id, data=c_a_domain_lang)
Tukey_c_a <- TukeyHSD(anova_c_a_domain_lang, conf.level=.95) 
Tukey_c_a
plot(TukeyHSD(anova_c_a_domain_lang, conf.level=.95) )


model_out_c_a <- dust(Tukey_c_a) 
write.csv(model_out_c_a, "data/Tukey_A_c.csv" )


#p
p_domain_lang <- filter(Idioms, domain_id %in% c('p'))
summary(p_domain_lang)
anova_p_domain_lang <- aov( full_relative_frequency ~ language, data= p_domain_lang)
Tukey_p <- TukeyHSD(anova_p_domain_lang, conf.level=.95) 
Tukey_p
plot(TukeyHSD(anova_p_domain_lang, conf.level=.95) )
model_out_p <- dust(Tukey_p) 
write.csv(model_out_p, "data/Tukey_p.csv" )

#i
i_domain_lang <- filter(Idioms, domain_id %in% c('i'))
anova_i_domain_lang <- aov( full_relative_frequency ~ language, data= i_domain_lang)
Tukey_i <-TukeyHSD(anova_i_domain_lang, conf.level=.95) 
Tukey_i
plot(TukeyHSD(anova_i_domain_lang, conf.level=.95) )
model_out_i <- dust(Tukey_i) 
write.csv(model_out_i, "data/Tukey_i.csv" )







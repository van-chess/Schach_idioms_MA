library(tidyverse)
library(dplyr)
library(ggplot2)
library(data.table)
library(stargazer)
library(ggpubr)


Idioms<- read.csv('data/THIS_table_idioms_cleaned.csv', sep = ";")
view(Idioms)


Idioms <- transform(Idioms, full_relative_frequency= Idioms$idiom_frequency/Idioms$corpus_size)
#save 
write.csv2(Idioms,"idioms_frequency.csv", row.names = TRUE)



# select frequency rows
frequencies_idioms <- select(Idioms, idiom_frequency, idiom_frequency_per_mill, full_relative_frequency, language)
summary(frequencies_idioms)

#dataframes per language for frequency 

English_only_frequency  <- filter(frequencies_idioms, language %in% c('en'))
French_only_frequecy<- filter(frequencies_idioms, language %in% c('fr'))
German_only_frequency <- filter(frequencies_idioms, language %in% c('ge'))


#summary
summary(English_only_frequency)
summary(French_only_frequecy)
summary(German_only_frequency)
sd(English_only_frequency$full_relative_frequency)
sd(French_only_frequecy$full_relative_frequency)
sd(German_only_frequency$full_relative_frequency)




#save as latex table
stargazer(frequencies_idioms)
stargazer(English_only_frequency)
stargazer(French_only_frequecy)
stargazer(German_only_frequency)

# sum up all data assess normality 
sum_data_all <- summary(Idioms)
view(sum_data_all)

hist(Idioms$idiom_frequency_per_mill)
abline(v=mean(Idioms$idiom_frequency_per_mill), lty=2, lwd=2)

qqnorm(Idioms$idiom_frequency_per_mill)

barplot(Idioms$idiom_frequency_per_mill)

shapiro.test(Idioms$full_relative_frequency)
#https://www.programmingr.com/animation-graphics-r/qq-plot/
ggqqplot(Idioms$full_relative_frequency)


# Frequency distribution using relatuve frequency 
#https://www.r-tutor.com/elementary-statistics/quantitative-data/frequency-distribution-quantitative-data
#

frequency = Idioms$full_relative_frequency
range(frequency)
breaks = seq(0.000000005417225, 0.000007738856, by=0.0000001)    # hsmallest, biggest, step
breaks
frequency.cut = cut(frequency, breaks, right=FALSE) 
frequency.freq = table(frequency.cut) 
frequency.freq 
frequency.cut 
cbind(frequency.freq) 
cbind(frequency.freq, frequency.relfreq) 

#https://stackoverflow.com/questions/36280197/visualizing-relative-frequency-in-r-ggplot2
#Visualisation of frquencies 
gg <- ggplot(Idioms) 
gg <- gg + geom_point(aes(full_relative_frequency,domain_name, colour=superdomain),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000000007738856, 0.0000001))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg

#Visualization of proportions
ggplot(Idioms, aes(x = domain_name, y = idiom_frequency_per_mill, fill = idiom_frequency_per_mill)) +
  geom_bar(stat = "identity", position= "fill") +
  scale_y_continuous("Proportion") +
  scale_x_discrete("", expand = c(0, 0)) +
  coord_flip()



#https://influentialpoints.com/Critiques/displaying_distributions_using_R.htm
# arbitrarily set an x-value for each variable
x1 <- filter(Idioms, relative_frequency, language %in% c('en'))
 # Idioms$full_relative_frequency
x2=rep(2,n2)
x3=rep(3,n3)
# plot 3 univariate scatterplots (rugplots)
plot(x1,y1, pch='-', xlim=range(x1,x2,x3), ylim=range(y1,y2,y3))
points(x2,y2, pch='-', col='blue')
points(x3,y3, pch='-', col='red')


# Create Boxplots for frequency distribution 

library(tidyverse)
library(forcats)
library(ggplot2)

idioms_csv <- read.csv('data/THIS_table_idioms_cleaned.csv', sep = ";")
idioms <- as_tibble(idioms_csv)
idioms
view(idioms)

#add relative frequency
idioms<- transform(idioms, full_relative_frequency= idioms$idiom_frequency/idioms$corpus_size)



#Filter by language
French_only<- filter(idioms, language == "fr")
English_only<- filter(idioms, language == "en")
German_only<- filter(idioms, language == "ge")

#DEFINE DATA
boxplot_French<- French_only[c("language", "domain_name", "superdomain", "idiom_frequency_per_mill")]
boxplot_English <- English_only[c("language", "domain_name", "superdomain", "idiom_frequency_per_mill")]
boxplot_German <- German_only[c("language", "domain_name", "superdomain", "idiom_frequency_per_mill")]


#------------------create boxplots ----------------------#



#hint to reorder :https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2.html
idioms %>% 
  arrange(idiom_frequency_per_mill) %>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  ggplot(aes(x =domain_id, y =idiom_frequency_per_mill, fill = superdomain)) +
  geom_boxplot() + 
  theme_minimal() +
  #facet_wrap(~superdomain, ncol=3)+
  stat_summary(fun="mean", shape=15)+
  ggtitle("all idioms ") +
  xlab("Dose (mg)") + ylab("Teeth lenh")+
  #theme(legend.position = "none")
  scale_fill_brewer(palette = 'Paired')#(palette = 'Spectral')



English_only%>% 
  arrange(idiom_frequency_per_mill) %>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  mutate(superdomain= factor(superdomain, levels=c("intertextuality","culture", "natural_phenomena"))) %>%
  ggplot(aes(x =domain_id, y =idiom_frequency_per_mill, fill = domain_name)) +
  geom_boxplot() + theme_minimal() +
  stat_summary(fun="mean", shape= 17)+
  ggtitle("Frequency English idioms per domain") +
  xlab("domain id") + ylab("Frequency per million")+
  #theme(legend.position = "none")
  facet_wrap(~superdomain, scale = "free_x")+
  scale_fill_brewer(palette = 'Paired')#(palette = 'Spectral')


German_only%>% 
  arrange(idiom_frequency_per_mill) %>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  mutate(superdomain= factor(superdomain, levels=c("intertextuality","culture", "natural_phenomena"))) %>%
  ggplot(aes(x =domain_id, y =idiom_frequency_per_mill, fill = domain_name)) +
  geom_boxplot() + theme_minimal() +
  stat_summary(fun="mean", shape= 17)+
  ggtitle("Frequency German idioms per domain") +
  xlab("domain id") + ylab("Frequency per million")+
  #theme(legend.position = "none")
  facet_wrap(~superdomain, scale = "free_x")+
  scale_fill_brewer(palette = 'Paired')#(palette = 'Spectral')


French_only%>% 
  arrange(idiom_frequency_per_mill) %>%
  mutate(domain_id= factor(domain_id, levels=c("a","b", "c", "e", "f", "m", "p", "i", "k", "n", "o", "r", "s"))) %>%
  mutate(superdomain= factor(superdomain, levels=c("intertextuality","culture", "natural_phenomena"))) %>%
  ggplot(aes(x =domain_id, y =idiom_frequency_per_mill, fill = domain_name)) +
  geom_boxplot() + theme_minimal() +
  stat_summary(fun= "mean", shape= 17) +
  ggtitle("Frequency French idioms per domain") +
  xlab("domain id") + ylab("Frequency per million")+
  #theme(legend.position = "none")
  facet_wrap(~superdomain, scale = "free_x")+
  scale_fill_brewer(palette = 'Paired')#(palette = 'Spectral')

# Freuqency ststistics
#https://www.r-tutor.com/elementary-statistics/quantitative-data/frequency-distribution-quantitative-data



# sum up all data
sum_data_all <- summary(idioms)
view(sum_data_all)

qqnorm(Idioms$idiom_frequency_per_mill)

barplot(Idioms$idiom_frequency_per_mill)


# using relative frequency 

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

idioms %>%
#arrange(relative_frequency_overall) %>%    # First sort by val. This sort the dataframe but NOT the factor levels
#mutate(superdomain = factor(superdomain, levels=c("intertextuality", "culture", "natural_phenomena"))) %>%
gg <- ggplot(idioms) 
gg <- gg + geom_point(aes(full_relative_frequency,domain_name, colour=language),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000000007738856, 0.0000001))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution of idiom frequencies across domains")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg 
#FRENCH
gg <- ggplot(French_only) 
gg <- gg + geom_point(aes(full_relative_frequency,domain_name, colour=superdomain),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000000007738856, 0.0000001))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution of relative frequencies accross domains and superdomains in French")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg

#English
gg <- ggplot(English_only) 
gg <- gg + geom_point(aes(full_relative_frequency,domain_name, colour=superdomain),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000000007738856, 0.0000001))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution of relative frequencies accross domains and superdomains in English")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg

#GERMAN
gg <- ggplot(German_only) 
gg <- gg + geom_point(aes(full_relative_frequency,domain_name, colour=superdomain),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000000007738856, 0.0000001))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + mutate(name = fct_reorder(name, val)) %>%
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution of relative frequencies accross domains and superdomains in German")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg



# using frequency per mill

Idioms %>%
  #arrange(relative_frequency_overall) %>%    # First sort by val. This sort the dataframe but NOT the factor levels
  #mutate(superdomain = factor(superdomain, levels=c("intertextuality", "culture", "natural_phenomena"))) %>%
  gg <- ggplot(idioms) 
gg <- gg + geom_point(aes(idiom_frequency_per_mill,domain_name, colour=language),
                      shape="|", size=10)
#gg <- gg + scale_x_continuous(breaks=seq(0.000000005417225, 0.000007738856, 0.000001))# all 
gg <- gg + scale_x_continuous(breaks=seq(0.01, 0.01, 7.8))# all 
gg <- gg + scale_y_discrete(expand=c(0,0))
gg <- gg + scale_colour_brewer(name="", palette="Set1")
gg <- gg + facet_wrap(~domain_name, ncol=1, scales="free_y")
gg <- gg + guides(colour=guide_legend(override.aes=list(shape=15, size=3)))
gg <- gg + labs(x=NULL, y=NULL, title="Distribution of idiom frequencies across domains")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg 
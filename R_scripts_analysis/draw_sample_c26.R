# extract random sentences from c26 from head to toe

library(tidyverse)

idioms_csv <- read.csv('data/added_idiom_id_to_sentences_161221.tsv', sep = "\t")
idioms_tibble <- as_tibble(idioms_csv)
idioms_tibble
#view(idioms_tibble)

c26_only<- filter(idioms_tibble, idiom_id_only == "c26")

#make this example reproducible
set.seed(345)
#get sample by fraction (no equal len)
sample_c26 <- c26_only  %>%
  group_by(language_id) %>%
  sample_n(size=20)

write.csv(sample_c26, file = "data/sample_26.csv", row.names = F)

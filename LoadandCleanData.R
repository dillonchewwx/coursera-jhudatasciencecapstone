# Script to create the cleaned training data.

# Initialize environment
library(scales)
library(tidytext)
library(tidyverse)

# Load in the data
blogs_file<-"../Data/en_US.blogs.txt"
news_file<-"../Data/en_US.news.txt"
twitter_file<-"../Data/en_US.twitter.txt"

blogs<-read_lines(blogs_file, skip_empty_rows=TRUE) %>% 
    tibble() %>% 
    rename(text=colnames(.)) %>%
    mutate(source="blogs")
twitter<-read_lines(twitter_file, skip_empty_rows=TRUE) %>% 
    tibble() %>% 
    rename(text=colnames(.)) %>%
    mutate(source="twitter")
news<-read_lines(news_file, skip_empty_rows=TRUE) %>% 
    tibble() %>%
    rename(text=colnames(.)) %>%
    mutate(source="news")

profanities<-read_tsv("https://www.cs.cmu.edu/~biglou/resources/bad-words.txt", col_names=FALSE) %>%
    rename(word=colnames(.))

# Sample Data
set.seed(123)
blogs_sample<-slice_sample(blogs, prop=0.1)
news_sample<-slice_sample(news, prop=0.1)
twitter_sample<-slice_sample(twitter, prop=0.1)

# Clean Data
combined<-blogs_sample %>%
    full_join(news_sample) %>%
    full_join(twitter_sample)

cleaned_combined<-combined %>%
    mutate(text=str_remove_all(text, "(www|http:|https:)+[^\\s]+[\\w]")) %>% # Remove URLs
    mutate(text=str_remove_all(text, "@[^\\s]+")) %>% # Remove handles
    mutate(text=str_remove_all(text, "#[^\\s]+")) %>% # Remove hashtags
    mutate(text=str_remove_all(text, "\\b[A-Z a-z 0-9._ - ]*[@](.*?)[.]{1,3} \\b")) %>% # Remove emails
    mutate(text=str_remove_all(text, "[[:digit:]]+")) %>% # Remove numbers
    mutate(text=str_remove_all(text, "[^[\\da-zA-Z ]]")) # Remove non-English Characters

# Load in the n-gram models.
## Bigrams
bigrams<-cleaned_combined %>%
    unnest_tokens(bigram, text, token="ngrams", n=2)

bigrams_filtered<-bigrams %>%
    separate(bigram, into=c("word1", "word2"), sep=" ") %>%
    filter(!word1 %in% profanities$word) %>%
    filter(!word2 %in% profanities$word) %>%
    group_by(source) %>%
    unite(bigram, word1, word2, sep=" ") %>%
    count(bigram, sort=TRUE)

## Trigrams
trigrams<-cleaned_combined %>%
    unnest_tokens(trigram, text, token="ngrams", n=3)

trigrams_filtered<-trigrams %>%
    separate(trigram, c("word1", "word2", "word3"), sep=" ") %>%
    filter(!word1 %in% profanities$word) %>%
    filter(!word2 %in% profanities$word) %>%
    filter(!word3 %in% profanities$word) %>%
    group_by(source) %>%
    unite(trigram, word1, word2, word3, sep=" ") %>%
    count(trigram, sort=TRUE)

## Quadrigrams
quadrigrams<-cleaned_combined %>%
    unnest_tokens(quadrigram, text, token="ngrams", n=4)

quadrigrams_filtered<-quadrigrams %>%
    separate(quadrigram, c("word1", "word2", "word3", "word4"), sep=" ") %>%
    filter(!word1 %in% profanities$word) %>%
    filter(!word2 %in% profanities$word) %>%
    filter(!word3 %in% profanities$word) %>%
    filter(!word4 %in% profanities$word) %>%
    group_by(source) %>%
    unite(quadrigram, word1, word2, word3, word4, sep=" ") %>%
    count(quadrigram, sort=TRUE)

# Combine sources from the bi/tri/quadrigrams data
bigram_data<-bigrams_filtered %>%
    ungroup() %>%
    select(bigram, n) %>%
    group_by(bigram) %>%
    summarize(count=sum(n))

trigram_data<-trigrams_filtered %>%
    ungroup() %>%
    select(trigram, n) %>%
    group_by(trigram) %>%
    summarize(count=sum(n))

quadrigram_data<-quadrigrams_filtered %>%
    ungroup() %>%
    select(quadrigram, n) %>%
    group_by(quadrigram) %>%
    summarize(count=sum(n))

# Save training data
saveRDS(bigram_data, "../Data/bigram_data.rds")
saveRDS(trigram_data, "../Data/trigram_data.rds")
saveRDS(quadrigram_data, "../Data/quadrigram_data.rds")
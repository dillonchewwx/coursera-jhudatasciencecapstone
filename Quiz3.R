# Quiz 3 - Natural language processing II
# For each of the sentence fragments below, use your natural language processing algorithm to predict the next work in the sentence. 

# Initialize environment
library(tidytext)
library(tidyverse)

# Load training data
bigram_data<-readRDS("../Data/bigram_data.rds")
trigram_data<-readRDS("../Data/trigram_data.rds")
quadrigram_data<-readRDS("../Data/quadrigram_data.rds")

# Build algorithm

test_case<-c("When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd",
             "Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his", 
             "I'd give anything to see arctic monkeys this",
             "Talking to your mom has the same effect as a hug and helps reduce your",
             "When you were in Holland you were like 1 inch away from me but you hadn't time to take a",
             "I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the",
             "I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each", 
             "Every inch of you is perfect from the bottom to the",
             "I’m thankful my childhood was filled with imagination and bruises from playing",
             "I like how the same people are in almost all of Adam Sandler's")

# Use the last three words of the sentence to predict the 4th word based on the quadrigram model. If there are no predictions, then use the last two words with the trigram model, and then last word with the bigram model.

prediction<-function(input_string){
    if(str_count(input_string, "\\S+") > 3){
        ngram<-word(input_string, start=-3, end=-1)
        pred_ngram<-quadrigram_data %>%
            filter(str_detect(quadrigram, paste0("^", ngram))) %>%
            rename(ngram=quadrigram)
        if(nrow(pred_ngram)==0){
            ngram<-word(input_string, start=-2, end=-1)
            pred_ngram<-trigram_data %>%
                filter(str_detect(trigram, paste0("^", ngram))) %>%
                rename(ngram=trigram)
            if(nrow(pred_ngram)==0){
                ngram<-word(input_string, -1)
                pred_ngram<-bigram_data %>%
                    filter(str_detect(bigram, paste0("^", ngram))) %>% 
                    rename(ngram=bigram)
            }
        }
    }
    return(pred_ngram %>% slice_max(count, n=10))
}

# Testing 
res=tibble()
for(i in 1:length(test_case)){
    results<-prediction(test_case[i]) %>%
        mutate(question=i)w
    res<-bind_rows(res, results)
}

# This very simple approach works about 50-60% of the time and thus alternative models should be explored.
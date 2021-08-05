# Quiz 2 - Natural language processing I
# For each of the sentence fragments below, use your natural language processing algorithm to predict the next work in the sentence. 

# Initialize environment
library(tidytext)
library(tidyverse)

# Load training data
bigram_data<-readRDS("../Data/bigram_data.rds")
trigram_data<-readRDS("../Data/trigram_data.rds")
quadrigram_data<-readRDS("../Data/quadrigram_data.rds")

# Build algorithm

test_case<-c("The guy in front of me just bought a pound of bacon, a bouquet, and a case of", 
             "You're the reason why I smile everyday. Can you follow me please? It would mean the",
             "Hey sunshine, can you follow me and make me the",
             "Very early observations on the Bills game: Offense still struggling but the", 
             "Go on a romantic date at the", 
             "Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my",
             "Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some", 
             "After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little", 
             "Be grateful for the good times and keep the faith during the", 
             "If this isn't the cutest thing you've ever seen, then you must be")

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
        mutate(question=i)
    res<-bind_rows(res, results)
}

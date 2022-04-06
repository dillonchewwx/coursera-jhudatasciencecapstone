shinyServer(function(input, output, session){
    
    # Input Processing
    wordPrediction<-reactive({
        text<-str_to_lower(input$input_text)
        wordCount<-str_count(text, "\\S+")
        return(predictNextWord(wordCount, text))
    })
    
    output$predicted_word<-renderText(as.character(wordPrediction()))
    output$entered_words<-renderText(input$input_text)
    
    # Functions for next word prediction
    predictNextWordBigram<-function(text){
        query<-text # Use bigrams for wordCount=1
        if (query %in% bigram_data$bigram){
            output<-bigram_data %>% 
                filter(bigram==query) %>%
                arrange(desc(count))
            return(output$lastword[1])
        }
        else{
            return("the")
        }
    }
    
    predictNextWordTrigram<-function(text){
        query<-text # Use trigrams for wordCount=2
        if (query %in% trigram_data$trigram){
            output<-trigram_data %>%
                filter(trigram==query) %>%
                arrange(desc(count))
            return(output$lastword[1])
        }
        else{
            predictNextWordBigram(word(query, -1, sep="\\s"))
        }
    }
    
    predictNextWordQuadrigram<-function(text){
        query<-word(text, -3, -1, sep="\\s") # Use quadrigrams for wordCount=3
        if (query %in% quadrigram_data$quadrigram){
            output<-quadrigram_data %>%
                filter(quadrigram==query) %>%
                arrange(desc(count))
            return(output$lastword[1])
        }
        else{
            predictNextWordTrigram(word(query, start=-2, end=-1, sep="\\s"))
        }
    }
    
    predictNextWord<-function(wordCount, text){
        if (wordCount==1){
            output<-predictNextWordBigram(text)
            return(output)
        }
        else if (wordCount==2){
            output<-predictNextWordTrigram(text)
            return(output)
        }
        else if (wordCount>=3){
            output<-predictNextWordQuadrigram(text)
            return(output)
        }
        else if (wordCount==0){
            output<-""
            return(output)
        }
    }
    
})
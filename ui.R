shinyUI(
    dashboardPage(
        dashboardHeader(title="Text Prediction Application"),
        dashboardSidebar(
            sidebarMenu(
                menuItem("App", tabName="app", icon=icon("keyboard")),
                menuItem("About", tabName="about", icon=icon("info-circle"))
            )
        ),
    dashboardBody(
        tabItems(
            tabItem(tabName="app",
                    fluidRow(width=12,
                             box(title=tags$b("Instructions"),
                                 solidHeader=TRUE,
                                 width=12,
                                 "Enter a word or phrase and the program will attempt to predict the next word.",
                                 tags$br(),
                                 tags$br(),
                                 textInput("input_text", 
                                           label="Enter Text Here",
                                           value=""),
                                 )
                             ),
                    fluidRow(width=12,
                             box(title=tags$b("Predictions"),
                                 solidHeader=TRUE,
                                 width=12,
                                 tags$b("You entered: "),
                                 textOutput("entered_words"),
                                 tags$br(),
                                 tags$b("Predicted next word: "),
                                 textOutput("predicted_word")
                                 ))
                    ),
            tabItem(tabName="about",
                    fluidRow(width=12,
                             box(title="About this project",
                                 width=12,
                                 "This Shiny app was created as part of a Coursera capstone project on Data Science:",  
                                 tags$a(href="https://www.coursera.org/learn/data-science-project", "Data Science Capstone"),
                                 " by Johns Hopkins University. The goal is to create a Shiny app that takes a phrase (multiple words) in a text box input, and outputs a prediction of the next word.",
                                 tags$p(),
                                 "Feedback on how to improve is always appreciated.",
                                 tags$p(),
                                 "Last updated: 6 April 2022"
                                 )
                             ),
                    fluidRow(width=12,
                             box(title="Developer & Contact Information",
                                 width=12,
                                 "Dillon Chew @",
                                 tags$a(href="https://www.linkedin.com/in/dillonchewwx/", "Linkedin |"),
                                 tags$a(href="https://github.com/dillonchewwx", "Github")
                                 )
                             )
                    )
            )
        )
    )
)

library(shiny)
library(markdown)

shinyUI(fluidPage(

  # Application title
    titlePanel(list(img(src='yrax.jpg', align = "top", alt="YraX Solutions",
                        height = "50px"),
                    "Demo - Time Series Visualization"),
               "YraX Solutions Demo - Time Series Visualization"),
    
    

  # Radio button with exchanges
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId="selectExchange",
                  label="Select exchange to retrieve symbols from:",
                  choices=c("AMEX", "NASDAQ", "NYSE")),
      uiOutput("symbolList"),
      width=4
    ),

    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Main",
                plotOutput("Plot1")
                
            ),
            tabPanel("Description",
                     includeMarkdown("description.md")
            )
        )
        
    )
  )
))

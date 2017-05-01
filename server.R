

library(shiny)
library(quantmod)
library(ggplot2)
library(broom)
library(dplyr)
library(markdown)

shinyServer(function(input, output) {
    
    rv <- reactiveValues(symbols=NULL, data=NULL, plotReady=F, plotToShow=NULL)
    
    output$symbolList <- renderUI({
        d <- stockSymbols(input$selectExchange) %>%
            mutate(SymbolName = paste0(Name, " (", Symbol, ")"))
        rv$symbols <- d
        selectInput("selectSymbol", "Select a symbol to retrieve",
                    choices = rv$symbols$SymbolName,
                    selectize=F)
    })

    observeEvent(input$selectSymbol, {
        SymbolToGet <- rv$symbols$Symbol[rv$symbols$SymbolName == input$selectSymbol]
        d <- getSymbols(SymbolToGet, auto.assign = F)
        
        dataToPlot <- Cl(d)
        names(dataToPlot) <- "Close"
        index(dataToPlot) <- as.Date(index(dataToPlot))
        dataToPlot <- tidy(dataToPlot)
        
        g <- ggplot(dataToPlot, aes(x=index, y=value)) +
            geom_line(color="steelblue") +
            ggtitle(paste0("\n",input$selectSymbol),"\n") +
            theme(axis.title = element_blank(),
                  plot.title = element_text(size=16))
        rv$plotToShow <- g
        
        # rv$plotToShow <- barChart(d)
        
    })
    
    output$Plot1 <- renderPlot({rv$plotToShow})

})

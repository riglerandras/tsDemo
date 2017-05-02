

library(shiny)
library(quantmod)
library(ggplot2)
library(broom)
library(dplyr)
library(markdown)

shinyServer(function(input, output) {
    
    rv <- reactiveValues(symbols=NULL, data=NULL, plotReady=F, plotToShow=NULL, 
                         rawData=NULL)
    
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
        rv$rawData <- d
        dataToPlot <- Cl(d)
        names(dataToPlot) <- "Close"
        index(dataToPlot) <- as.Date(index(dataToPlot))
        dataToPlot <- tidy(dataToPlot)
        
        g <- ggplot(dataToPlot, aes(x=index, y=value)) +
            geom_line(color="steelblue") +
            ggtitle("rv$rawData") +
            theme(axis.title = element_blank(),
                  plot.title=element_text(size=14, face="bold", margin=margin(b=15)))
        rv$plotToShow <- g
        cat("Lineplot created\n")

    })
    
    # output$Plot1 <- renderPlot({rv$plotToShow})
    
    output$Plot1 <- renderImage({
        outfile1 <- tempfile(fileext=".png")
        png(outfile1, width=600, height=320)
        print(rv$plotToShow)
        dev.off()
        list(src = outfile1,
             alt = "Line plot output")
    }, deleteFile = TRUE)
    
    output$Plot2 <- renderImage({
        
        # Create the barchart as a temporary image file
        outfile2 <- tempfile(fileext=".png")
        png(outfile2, width=600, height=320)
        barChart(rv$rawData, title=input$selectSymbol)
        dev.off()
        cat("barChart created\n")
        
        # Return a list
        list(src = outfile2,
             alt = "Barchart output")
    }, deleteFile = TRUE)

})

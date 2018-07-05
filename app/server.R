library(shiny)
source('snakeplotter.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$snakePlot <- renderPlot({
    #x    <- faithful[, 2]  # Old Faithful Geyser data
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    snakePlot(input$ec1,input$tm1,
              input$ic1,input$tm2,
              input$ec2,input$tm3,
              input$ic2,input$tm4,
              input$ec3,input$tm5,
              input$ic3,input$tm6,
              input$ec4,input$tm7,input$ic4,
              pcirc=input$pcirc, pfill=input$pfill, psize=input$psize, lcol=input$lcol,
              aa=input$aa, aacol=input$aacol)
  }, height = 800, width = 800)
})
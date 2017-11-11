library(shiny)
library(shinyjs)
library(colourpicker)

Olfr62 <- "MQDFLWRNRSSLTEFVLLGFSSNTQINGILFGIFLLLYLTTLLGNGLIITLIHMDSRLHTPMYFFLSVLSILDMGYVTTTVPQMLVHLVCKKKTISYVGCVAQMYIFLMLGITESWLFAIMAYDRYVAICHPLRYKVIMSPLLRGSLVAFCGFWGITCALIYTVSAMILPYCGPNEINHFFCEVPAVLKLACADTSLNDQVDFILGFILLLVPLSLIIVVYINIFAAILRIRSTQGRIKAFSTCVSHIIVVTMFSIPCMVMYMRPGSESSPEEDKKLALFYNVISAFLNPIIYSLRNKDVKRAFLKVVGSRKGSE"

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("snakeplotter for GPCRs"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      p("Makes a snakeplot for G protein-coupled receptors. 
        You can specify the length of each extracellular, intracelluar and transmembrane regions."),
      colourInput("pcirc", "color of residues (circle)", value = "#74786F", showColour = "both"),
      colourInput("pfill", "color of residues (fill)", value = "#CEEBAB", showColour = "both"),
      colourInput("lcol", "color of connecting line", value = "#4D4D48", showColour = "both", allowTransparent = TRUE),
      textInput("aa", "amino acid sequence", value = Olfr62),
      colourInput("aacol", "color of residue text", value = "#03170C", showColour = "both", allowTransparent = TRUE),
      numericInput("psize", "size of residues", value = 7, min = 0),
      numericInput("ec1", "EC1: length of extracellular region 1", value = 20, min = 1),
      numericInput("tm1", "TM1: length of transmembrane region 1", value = 20, min = 1),
      numericInput("ic1", "IC1: length of intracellular region 1", value = 20, min = 1),
      numericInput("tm2", "TM2: length of transmembrane region 2", value = 20, min = 1),
      numericInput("ec2", "EC2: length of extracellular region 2", value = 20, min = 1),
      numericInput("tm3", "TM3: length of transmembrane region 3", value = 20, min = 1),
      numericInput("ic2", "IC2: length of intracellular region 2", value = 20, min = 1),
      numericInput("tm4", "TM4: length of transmembrane region 4", value = 20, min = 1),
      numericInput("ec3", "EC3: length of extracellular region 3", value = 20, min = 1),
      numericInput("tm5", "TM5: length of transmembrane region 5", value = 20, min = 1),
      numericInput("ic3", "IC3: length of intracellular region 3", value = 20, min = 1),
      numericInput("tm6", "TM6: length of transmembrane region 6", value = 20, min = 1),
      numericInput("ec4", "EC4: length of extracellular region 4", value = 20, min = 1),
      numericInput("tm7", "TM7: length of transmembrane region 7", value = 20, min = 1),
      numericInput("ic4", "IC4: length of intracellular region 4", value = 20, min = 1),
      p("by Yue Jiang, rivehill@gmail.com, 2016")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("snakePlot")
    )
  )
))
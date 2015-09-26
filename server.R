library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # read the ge data set
  gedat <- read.csv("data/GE2015ResultsData.csv")
  
  # create the reactive input for display
  dataSetInput <- reactive({gedat})
  # now render the output of the raw data
  output$dataView <- renderTable({dataSetInput()})
  
  # render the list of electoral divisions for choice
  output$divisionSelector <- renderUI({
    selectInput("division", 
                "Choose an Electoral Division:", 
                as.character(gedat$ElectorialDivisions)
    )
  })
  
  # generate the reactive for electoral division chosen
  divisionChosen <- reactive({ 
    gedat[gedat$ElectorialDivisions == input$division,]
    
  })
  output$divisionChose <- renderTable({divisionChosen()})
  
  # now compute the win percentages
  #chosenDivision <- gedat[gedat$ElectorialDivisions == divisionChosen(),]
  #output$elec <- renderText(chosenDivision)
})

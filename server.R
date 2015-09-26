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
                "Electoral Division:", 
                as.character(gedat$ElectorialDivisions)
    )
  })
  
  # generate the reactive for electoral division chosen
  divisionChosen <- reactive({ 
    gedat[gedat$ElectorialDivisions == input$division,]
  })
  
  # ------
  # now compute the electorial division results and set the output
  ## COMPUTATIONS 
  # compute total casted votes
  output$divisionTotalCast <- renderText({
    chose <- divisionChosen()
    format(chose$Cast1 + chose$Cast2 + chose$Cast3, big.mark=",")
  })
  
  # compute rejected votes
  output$divisionRejected <- renderText({
    chose <- divisionChosen()
    total <- chose$Cast1 + chose$Cast2 + chose$Cast3
    format(chose$Registered - total, big.mark=",")
  })
  output$divisionRejectedPct <- renderText({
    chose <- divisionChosen()
    total <- chose$Cast1 + chose$Cast2 + chose$Cast3
    round((chose$Registered - total) / chose$Registered * 100, digits=2)
  })
  
  # compute win percentages
  output$divisionFirstPct <- renderText({
    chose <- divisionChosen()
    total <- chose$Cast1 + chose$Cast2 + chose$Cast3
    round(chose$Cast1 / total * 100, digits=2)
  })
  output$divisionSecondPct <- renderText({
    chose <- divisionChosen()
    total <- chose$Cast1 + chose$Cast2 + chose$Cast3
    round(chose$Cast2 / total * 100, digits=2)
  })
  # render if there's a 3rd contestent
  output$divisionThirdBlock <- renderUI({
    chose <- divisionChosen()
    total <- chose$Cast1 + chose$Cast2 + chose$Cast3
    if (!is.na(chose$Third[1])) {
      span(
      h3(chose$Third, ":", round(chose$Cast3 / total * 100, digits=2), "%"),
      h5("(", format(chose$Cast3, big.mark=","), " votes )")
      )
    } else {
      p("")
    }
  })

  # the electorial division name
  output$divisionChose <- renderText({
    as.character(divisionChosen()$ElectorialDivisions)
    })
  # number of seats contested
  output$divisionSeats <- renderText({
    divisionChosen()$Seats
  })
  output$divisionSeatsString <- renderText({
    seatString <- "seat"
    if (divisionChosen()$Seats[1] > 1) {
      seatString <- paste(seatString, "s", sep="")
    }
    seatString
  })
  
  # total number of registered voters
  output$divisionRegistered <- renderText({
    format(divisionChosen()$Registered, big.mark=",")
  })
  # the candidates
  output$divisionFirst <- renderText({
    as.character(divisionChosen()$First)
  })
  output$divisionSecond <- renderText({
    as.character(divisionChosen()$Second)
  })
  output$divisionThird <- renderText({
    as.character(divisionChosen()$Third)
  })
  
  # the vote numbers
  output$divisionCast1 <- renderText({
    format(divisionChosen()$Cast1, big.mark=",")
  })
  output$divisionCast2 <- renderText({
    format(divisionChosen()$Cast2, big.mark=",")
  })
  output$divisionCast3 <- renderText({
    format(divisionChosen()$Cast3, big.mark=",")
  })
  
  
  
  # now compute the win percentages
  #chosenDivision <- gedat[gedat$ElectorialDivisions == divisionChosen(),]
  #output$elec <- renderText(chosenDivision)
})

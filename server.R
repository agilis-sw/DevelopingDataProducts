library(shiny)

# read the ge data set
gedat <- read.csv("data/GE2015ResultsData.csv")

# global function to determine if we should use seat or seats
getSeatsString <- function(numSeats)
{
  seatString <- "seat"
  if (numSeats > 1) {
    seatString <- paste(seatString, "s", sep="")
  }
  seatString
}

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
    
  # now render the output of the raw data
  output$dataView <- renderTable(gedat)
  
  # render the list of electoral divisions for choice
  output$divisionSelector <- renderUI({
    selectInput("division", 
                "Electoral Division:", 
                as.character(gedat$ElectorialDivisions),
                
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
    chose <- divisionChosen()
    paste(divisionChosen()$Seats, getSeatsString(chose$Seats[1]))
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
})

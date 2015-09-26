library(shiny)

# Define UI for application that plots random distributions 
shinyUI(
  # nav bar top
  navbarPage("Singapore General Elections 2015",
             
             # results by electoral divisions
             tabPanel("By Electoral Divisions",
                      sidebarPanel(
                        uiOutput("divisionSelector")
                      ),
                      mainPanel(
                        p(tableOutput("divisionChose"))
                        
                      )
             ),
             
             # here we show the raw data table that we base our calculations on
             tabPanel("RawData",
                      mainPanel(
                        p("This is the raw data that the app operates on for calculations."),
                        p("Percentages, totals and margins are computed using this raw data set."),
                        p("The data is obtained from the Singapore Elections Department webite."),
                        p("Sources are listed in the About tab."),
                        tableOutput("dataView")
                      )
             ),
             
             # about panel
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("about.md")
                      )
             )
  )
)
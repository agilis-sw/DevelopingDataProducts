library(shiny)
require(markdown)

# Define UI for application that plots random distributions 
shinyUI(
  # nav bar top
  navbarPage("2015 Singapore General Elections Results",
             
             # about panel
             tabPanel("About",
                      mainPanel(
                        tableOutput("preload"),
                        includeMarkdown("about.md")
                      )
             ),
             
             # results by electoral divisions
             tabPanel("By Electoral Divisions",
                      sidebarPanel(
                        uiOutput("divisionSelector")
                      ),
                      mainPanel(
                        h1(textOutput("divisionChose")),
                        h5(textOutput("divisionSeatsString", inline = TRUE), " contested."),
                        h2(textOutput("divisionFirst", inline = TRUE), " wins,", textOutput("divisionFirstPct", inline = TRUE), "%"),
                        h5("(", textOutput("divisionCast1", inline = TRUE), "votes )"),
                        h3(textOutput("divisionSecond", inline = TRUE), ":", textOutput("divisionSecondPct", inline=TRUE), "%"),
                        h5("(", textOutput("divisionCast2", inline = TRUE), "votes )"),
                        uiOutput("divisionThirdBlock"),
                        hr(),
                        h4("Division Details"),
                        HTML("<table>"),
                        HTML("<tr>"),
                        HTML("<td align=right>"), span("Total Registered Voters:"), HTML("</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("<td align=right>"), textOutput("divisionRegistered", inline = TRUE), HTML("</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("</tr>"),
                        
                        HTML("<tr>"),
                        HTML("<td align=right>"), span("Total Casted Votes:"), HTML("</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("<td align=right>"), textOutput("divisionTotalCast", inline = TRUE), HTML("</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("</tr>"),
                        
                        HTML("<tr>"),
                        HTML("<td align=right>"), span("Uncasted and Spoilt Votes:"), HTML("</td>"),
                        HTML("<td>&nbsp;</td>"),
                        HTML("<td align=right>"), textOutput("divisionRejected", inline = TRUE), HTML("</td>"),
                        HTML("<td>&nbsp;&nbsp;Percent:&nbsp;</td>"),
                        HTML("<td>"), span(textOutput("divisionRejectedPct", inline = TRUE), "%"), HTML("</td>"),
                        HTML("</tr>"),
                        HTML("</table>")
                      )
             ),
             
             # here we show the raw data table that we base our calculations on
             tabPanel("Raw Data",
                      mainPanel(
                        p("This is the raw data that the app operates on for calculations."),
                        p("Percentages are computed using this raw data set."),
                        p("The data is obtained from the Singapore Elections Department webite."),
                        p("Sources are listed in the About tab."),
                        tableOutput("dataView")
                      )
             )
  )
)
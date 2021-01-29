#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Slider App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h1("Move the Slider!"),
            sliderInput("slider2","slider me!",0,100,0)
        ),
        mainPanel(
            h3("Slider value"),
            textOutput("text1")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$text1=renderText(input$slider2+10)
}

# Run the application 
shinyApp(ui = ui, server = server)

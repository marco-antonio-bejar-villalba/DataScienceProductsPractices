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
    titlePanel("Plot random numbers"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            numericInput("numeric","how many random numbers should be plotted?",
                         value=1000, min=1, max=1000, step=1),
            sliderInput("sliderX","pick minimun and maximun X values",
                        -100,100,value = c(-50,50)),
            sliderInput("sliderY","pick minimun and maximun Y values",
                        -100,100,value = c(-50,50)),
            checkboxInput("show_xlab", "Show/hide X axis label",value = TRUE),
            checkboxInput("show_ylab", "Show/hide Y axis label",value = TRUE),
            checkboxInput("show_title", "Show/hide title")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           h3("Graph of randomPoints"),
           plotOutput("plot1")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot1 <- renderPlot({
        set.seed(2016-05-25)
        number_of_points<-input$numeric
        minX<-input$sliderX[1]
        maxX<-input$sliderX[2]
        minY<-input$sliderY[1]
        maxY<-input$sliderY[2]
        datax<-runif(number_of_points,minX,maxX)
        datay<-runif(number_of_points,minY,maxY)
        xlab<-ifelse(input$show_xlab,"X Axis","")
        ylab<-ifelse(input$show_ylab,"Y Axis","")
        main<-ifelse(input$show_title,"Title","")
        plot(datax,datay,xlab = xlab,ylab = ylab,main=main, xlim = c(-100,100),ylim = c(-100,100))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

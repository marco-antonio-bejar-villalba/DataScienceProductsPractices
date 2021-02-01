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
    titlePanel("Visualize many mofdels"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3("slope"),
            textOutput("slopeOut"),
            h3("intercept"),
            textOutput("inOut")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot1",brush=brushOpts(id="brush1")) #this is the brush points
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    model<-reactive({
        #here we use brush points
        brushed_data<-brushedPoints(trees,input$brush1,xvar="Girth",yvar="Volume")
        if(nrow(brushed_data)<2){
            return(NULL)
        }
        lm(Volume~Girth,data=brushed_data)
    })
    output$slopeOut<-renderText({
        if(is.null(model())){
            "No model found"
        }
        else{
            model()[[1]][2]
        }
    })
    output$inOut<-renderText({
        if(is.null(model())){
            "No model found"
        } else{
            model()[[1]][1]
        }
    })
    output$plot1<-renderPlot({
        plot(trees$Girth,trees$Volume,xlab="Girth",ylab="Volume",main="Tree measurements"
             , cex=1.5,pch=16,bty="n")
        if(!is.null(model())){
            abline(model(), col="blue",lwd=2)
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

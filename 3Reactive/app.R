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
    titlePanel("Predict hp for mpg"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderMPG","What is the MPG of the car?",
                        10,35,value = 20),
            checkboxInput("showModel1","Show/Hide Model 1", value=TRUE),
            checkboxInput("showModel2","Show/Hide Model 2", value=TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot1"),
           h3("predicted horsepower from model 1:"),
           textOutput("pred1"),
           h3("predicted horsepower from model 2:"),
           textOutput("pred2")
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  mtcars$mpgsp<-ifelse(mtcars$mpg-20>0, mtcars$mpg-20,0)
  model1<-lm(hp~mpg, data=mtcars)
  model2<-lm(hp~mpgsp+mpg, data=mtcars)
  model1Pred<-reactive({
      mpgInput<-input$sliderMPG
      predict(model1,newdata=data.frame(mpg=mpgInput))
  })
  
  model2Pred<-reactive({
      mpgInput<-input$sliderMPG
      predict(model2,newdata=data.frame(mpg=mpgInput
                                        ,mpgsp=ifelse(mpgInput-20>0,mpgInput-20,0)))
  })
  output$plot1<-renderPlot({
      mpgInput<-input$sliderMPG
      
      plot(mtcars$mpg,mtcars$hp,xlab="miles per gallon", ylab="hp",bty="n",pch=16,
           xlim=c(10,35),ylim=c(50,350))
      if(input$showModel1){
          abline(model1,col="red", lwd=2)
      }
      if(input$showModel2){
          model2lines<-predict(model2, newdata=data.frame(
              mpg=10:35,mpgsp=ifelse(10:35-20>0,10:35-20,0)
          ))
          lines(10:35,model2lines,col="blue",lwd=2)
      }
      legend(25,250,c("model 1 pred","moddel 2 pred"), pch=16,col=c("red","blue")
             ,bty="n",cex=1.2)
      points(mpgInput,model1Pred(),col="red", pch=16, cex=2)
      points(mpgInput,model2Pred(),col="blue", pch=16, cex=2)
  })
  output$pred1<-renderText({
      model1Pred()
  })
  output$pred2<-renderText({
      model2Pred()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

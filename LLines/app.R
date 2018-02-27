library(shiny)

ui <- fluidPage(

   titlePanel("Distribution Level lines"),

   sidebarLayout(
      sidebarPanel(
        fluidRow(h3("Case"),
                 column(10,
                        selectInput(
                          "case",
                          label = NULL,
                          choices = list("non correlated features" = "0", "features have same variances" = "1", "correlated features" = "2"),
                          selected = "0"
                      )
                  ) 
              ),
        fluidRow(textOutput("expl")) 
      ),
      mainPanel(
        plotOutput("plot", height = "600px")
      )
   )     
)
Bayes.MVND = function(x, y, mean, covar) {
  x = matrix(c(x, y), 1, 2)
  
  1 / sqrt((2 * pi) ^ 2 * det(covar)) * exp(-0.5 * (x - mean) %*% solve(covar) %*% t(x - mean))

}

server = function(input, output) {
  output$plot = renderPlot({

      if(input$case == "0") {
        
        mean = matrix(c(0, 0), 1, 2)
        covar = matrix(c(4, 0, 0, 4), 2, 2)
        
        output$expl = renderText("ellipsoids are spheres")
      } 
      else if(input$case == "1") {
        
        mean = matrix(c(0, 0), 1, 2)
        covar = matrix(c(4, 2, 0, 1), 2, 2)
        
        output$expl = renderText("covariation matrix isn't correlated, lines are ellipsoids w/ turned axis")
      }
      else if(input$case == "2") {
        
        mean = matrix(c(0, 0), 1, 2)
        covar = matrix(c(2, 0, 0, 8), 2, 2)
        
        output$expl = renderText("level lines are ellipsoids w/ axis parallel to the grid's axis")
      }
      #границы значений
      x = seq(-10, 10, len = 100)
      y = x
      z = outer(x, y, function(x, y) { 
        sapply(1:length(x), function(i) Bayes.MVND(x[i], y[i], mean, covar))
      })
        contour(x, y, z) 
  })
}

shinyApp(ui = ui, server = server)
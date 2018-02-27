library(shiny)
library(MASS)

# set normalizing
LC.normal = function(xl) {
  cols = dim(xl)[2]
  for (i in 1:(cols - 1)) {
    xl[, i] = (xl[, i] - mean(xl[, i])) / sd(xl[, i])
  }
  
  return(xl)
}

# add w0 = -1
LC.prep = function(xl) {
  rows = dim(xl)[1]
  cols = dim(xl)[2]
  xl = cbind(xl[, 1:(cols - 1)], rep(-1, rows), xl[, cols])
}

# loss func
LC.ADA.L = function(m) {
  (m - 1) ^ 2
}

LC.Perc.L = function(m) {
  max(-m, 0)
}

LC.LogRes.L = function(m) {
  log2(1 + exp(-m))
}

#various weight updates
LC.ADA.U = function(w, eta, xi, yi) {
  w - eta * (sum(w * xi) - yi) * xi
}

LC.Perc.U = function(w, eta, xi, yi) {
  w + eta * yi * xi
}

LC.LogRes.U = function(w, eta, xi, yi) {
  sigmoid = function(z) {
    1 / (1 + exp(-z))
  }
  
  w + eta * xi * yi * 1 / (1 + exp((sum(w * xi) * yi)))
}

server = function(input, output) {
  genData = reactive({
    if(input$case == "0") {
      n1 = 70
      n2 = 150
      
      covar1 = matrix(c(1, 0, 0, 5), 2, 2)
      covar2 = matrix(c(2, 0, 0, 2), 2, 2)
      mu1 = c(0, 0)
      mu2 = c(7, -1)
      xy1 = mvrnorm(n1, mu1, covar1)
      xy2 = mvrnorm(n2, mu2, covar2)
      
      #output$n1 = renderText({covar1})
      #output$n2 = renderText({n2})
    }
    else if(input$case == "1") {
      n1 = 150
      n2 = 150
    
      covar1 = matrix(c(1, 0, 0, 10), 2, 2)
      covar2 = matrix(c(10, 0, 0, 1), 2, 2)
      mu1 = c(0, 0)
      mu2 = c(6, -7)
      xy1 = mvrnorm(n1, mu1, covar1)
      xy2 = mvrnorm(n2, mu2, covar2)
    }
    
    list("xy1" = xy1, "xy2" = xy2)
  })
  
  drawPoints = function(xl) {
    colors = c("yellow", "white", "green")
    plot(xl[, 1], xl[, 2], pch = 21, bg = colors[xl[, 4] + 2], asp = 1, xlab = "X", ylab = "Y")
  }
  
  # merged/unified SG
  LC.SG = function(xl, L, update) {
    #default values
    eta = 1 / 10
    lambda = 1 / length(xl)
    
    rows = dim(xl)[1]
    cols = dim(xl)[2]
    w = rep(1 / 2, cols - 1)
    
    # initialize Q
    Q = 0
    for (i in 1:rows) {
      margin = sum(w * xl[i, 1:(cols - 1)]) * xl[i, cols]
      Q = Q + L(margin)
    }
    Q.prev = Q
    Q.sameCount = 0
    Q.sameMax = 10
    
    
    repeat {
      # select the error objects
      margins = rep(0, rows)
      for (i in 1:rows) {
        xi = xl[i, 1:(cols - 1)]
        yi = xl[i, cols]
        margins[i] = sum(w * xi) * yi
      }
      errIndexes = which(margins <= 0)
      
      #break if there are no errors in classification
      if (length(errIndexes) == 0) {
        break;
      }
      
      #select one random index from wrong classified ones            
      i = sample(errIndexes, 1)
      xi = xl[i, 1:(cols - 1)]
      yi = xl[i, cols]
      
      #get error
      margin = sum(w * xi) * yi
      error = L(margin)
      w = update(w, eta, xi, yi)
      
      #new iteration's Q
      Q = (1 - lambda) * Q + lambda * error
      
      #break if Q is relatively stable
      if (abs(Q.prev - Q) < 0.01) {
        Q.sameCount = Q.sameCount + 1
        if (Q.sameCount == Q.sameMax) {
          break;
        }
      } else {
        Q.sameCount = 0
      }
      
      Q.prev = Q
    }
    
    return(w)
  }
  
  L = list("ada" = LC.ADA.L, "per" = LC.Perc.L, "log" = LC.LogRes.L)
  update = list("ada" = LC.ADA.U, "per" = LC.Perc.U, "log" = LC.LogRes.U)
  
  output$plot = renderPlot({
    #Test data generation
    data = genData()
    xy1 = data$xy1
    xy2 = data$xy2
    xl = rbind(cbind(xy1, -1), cbind(xy2, +1))
    
    #Data normalization
    xl = LC.normal(xl)
    xl = LC.prep(xl)
    drawPoints(xl)
    
    # division line ploting
    w = LC.SG(xl, L[[input$algo]], update[[input$algo]])
    
    # 
    abline(a = w[3] / w[2], b = -w[1] / w[2], lwd = 3, col = "red")
  })
}

ui <- fluidPage(
  titlePanel("Merged linear algo's"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      fluidRow(
        column(2, h5("Algorithm")),
        column(10,
               selectInput(
                 "algo",
                 label = NULL,
                 choices = list("ADALINE" = "ada", "Perceptron" = "per", "Logistic Regression" = "log"),
                 selected = "ada"
               )
      
        ),
        column(10,
               selectInput(
                 "case",
                 label = NULL,
                 choices = list("Linear - divided set" = "0", "Linear non - divided set" = "1"),
                 selected = "0"
               )
            )
         )
      
      #fluidRow(textOutput("n1"),textOutput("n2")),
    ),
    
    mainPanel(
      
      plotOutput(outputId = "plot", height = "800px")
      )
   )
)

shinyApp(ui = ui, server = server)

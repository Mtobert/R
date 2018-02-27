DT.Util.xlim = c(min(DT.Util.petals[, 1]), max(DT.Util.petals[, 1]))
DT.Util.ylim = c(min(DT.Util.petals[, 2]), max(DT.Util.petals[, 2]))

DT.Util.petals = iris[, 3:4]
DT.Util.classes = iris[, 5]
DT.Util.colors = c("red", "green3", "blue")
names(DT.Util.colors) = unique(DT.Util.classes)

plot(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21, asp = 1, xlim = DT.Util.xlim, ylim = DT.Util.ylim, main = "Gaussian Naive Bayes")


  for (x in seq(DT.Util.xlim[1], DT.Util.xlim[2], 0.1)) {
    for (y in seq(DT.Util.ylim[1], DT.Util.ylim[2], 0.1)) {
      
      maxp = 0
      
      u = c(round(x, 1), round(y, 1))
      if (any(apply(DT.Util.petals, 1, function(v) all(v == u)))) next

     
      for(class in unique(DT.Util.classes))
      { 
        sd = var(iris$Petal.Length[iris$Species == class])
        mean = mean(iris$Petal.Length[iris$Species == class])
        sd2 = var(iris$Petal.Width[iris$Species == class])
        mean2 = mean(iris$Petal.Width[iris$Species == class])
        #p1 = (1/sqrt(2*pi*var(iris$Petal.Length[iris$Species == class])))*
         # exp((-(u[1]-mean(iris$Petal.Length[iris$Species == class]))^2)/2 * 
            #    var(iris$Petal.Length[iris$Species == class]))
        p1 = dnorm(u[1],sd,mean, log = FALSE)
        p2 = dnorm(u[2],sd2,mean2, log = FALSE)
        #p2 = (1/sqrt(2*pi*var(iris$Petal.Width[iris$Species == class])))*
         # exp((-(u[2]-mean(iris$Petal.Width[iris$Species == class]))^2)/2 * 
            #    var(iris$Petal.Width[iris$Species == class]))
        
        if(p1*p2 > maxp) {
          maxp = p1*p2
          bestClass = class
        }
      }
      points(u[1], u[2], col = DT.Util.colors[bestClass], pch = 21)
    }
  }
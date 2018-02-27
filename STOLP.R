source("util.R")

DT.STOLP.we = function(points, classes, u, outerClass) {
  k = 6
  distances = DT.Util.getDist(points, u, DT.Util.euclidDist)
  names(distances) = classes
  distances = sort(distances)[1:k]
  
  index = which(sapply(names(distances), function(v) any(v == outerClass)))
  if (length(index) == 0) return(0)
  distances = distances[index]
  
  return(max(table(names(distances))))
}

DT.STOLP.getMargin = function(points, classes, u, class) {
  DT.STOLP.we(points, classes, u, class) - DT.STOLP.we(points, classes, u, classes[-which(classes == class)])
}

DT.STOLP.plotMargins = function(margins) {
  n = length(margins)
  margins = sort(margins)
  
  plot(1:n, margins, type = "n", xlab = "", ylab = "") #drawing sorted margins
  box()
  lines(1:n, margins, lwd = 3, col = "red") #connecting it w/ lines
  lines(c(1, n), c(0, 0), col = "black", lwd = 2) # ground zero line
  title(main = "margins distribution for kNN (k = 25)", ylab = "margin value", xlab = "dataset items")
  
  ox = seq(0, 150, 5)
  axis(side = 1, at = ox)
  sapply(ox, function(x) abline(v = x, col = "grey", lty = 3)) # vertical division line for each 5 points
}

DT.STOLP.STOLP = function(points, classes, noises, threshold) {
  classes = as.array(levels(classes))[classes]
  n = length(classes)
  
  for (i in 1:n) {  #deleting all < M noise elements
    if (i > n) break
    if (DT.STOLP.getMargin(points, classes, points[i, ], classes[i]) <= noises) {
      points = points[-i,]
      classes = classes[-i]
      n = n - 1
    }
  }
  
  standards = data.frame()
  standards.classes = c() 
  for (class in unique(classes)) {   #taking elements with largest margin vals from each class
    ind = which(classes == class)
    margins = sapply(ind, function(i) DT.STOLP.getMargin(points, classes, points[i,], class))
    max.i = ind[which.max(margins)]
    print(margins)
    
    standards = rbind(standards, points[max.i,]) #merging this points w/ standards
    standards.classes = c(standards.classes, class)
    points = points[-max.i,] #exluding these points from source matrix 
    classes = classes[-max.i]
    n = n - 1
  }
  names(standards) = names(points)
  
  while (n > 0) {
    margins = c()
    margins.i = c()
    for (i in 1:n) {
      m = DT.STOLP.getMargin(standards, standards.classes, points[i,], classes[i])
      if (m <= 0) {
        margins = c(margins, m)
        margins.i = c(margins.i, i)
      }
    }
    
    print(margins)
    
    if (length(margins) <= threshold) break
    
    min.i = margins.i[which.min(margins)]
    standards = rbind(standards, points[min.i,])
    standards.classes = c(standards.classes, classes[min.i])
    points = points[-min.i,]
    classes = classes[-min.i]
    n = n - 1
  }
  
  return(list(pointsStandards = standards, classesStandards = standards.classes, restPoints = points, restClasses = classes))
}

DT.drawS = function(pointsStandards, classesStandards, restPoints, restClasses, colors) {
  uniqueClasses = unique(classesStandards)
  names(colors) = uniqueClasses
  
  plot(restPoints, col = colors[restClasses], pch = 21, asp = 1, main = "kNN classification with STOLP-based set")
  points(pointsStandards, bg = colors[classesStandards], pch = 21)
}

points = iris[, 3:4]
classes = iris[, 5]

leest = DT.STOLP.STOLP(points, classes, -3, 5)

DT.drawS(pointsStandards, classesStandards, restPoints, restClasses, c("red", "green3", "blue"))

names(colors) = unique(classesStandards)
DT.Util.drawMap(pointsStandards, classesStandards, DT.kNN.kNN, 0, kOpt = 6)

n = length(classes)
margins = rep(0, n)

for (i in 1:n) {
  margins[i] = DT.STOLP.getMargin(points, classes, points[i, ], classes[i])
}
DT.STOLP.plotMargins(margins)

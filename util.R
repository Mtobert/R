
DT.Util.xlim = c(min(DT.Util.petals[, 1]), max(DT.Util.petals[, 1]))
DT.Util.ylim = c(min(DT.Util.petals[, 2]), max(DT.Util.petals[, 2]))

DT.Util.petals = iris[, 3:4]
DT.Util.classes = iris[, 5]
DT.Util.colors = c("red", "green3", "blue")

DT.Util.euclidDist = function(p1, p2) sqrt(sum((p1 - p2) ^ 2))
DT.Util.getDist = function(points, g, dist_func) apply(points, 1, dist_func, g)


DT.Util.rectKer = function(r) 0.5 * (abs(r) <= 1)

DT.Util.triangleKer = function(r) (1 - abs(r)) * (abs(r) <= 1)

DT.Util.quartKer = function(r) (15 / 16) * (1 - r^2)^2 * (abs(r) <= 1)

DT.Util.epanKer = function(r) (3 / 4) * (1 - r^2) * (abs(r) <= 1)

DT.Util.gaussKer = function(r) dnorm(r) #((2 * pi)^(-1/2)) * exp(-1/2 * r^2) * (abs(r) <= 1) 

DT.Util.kernels = list("Rectangle" = DT.Util.rectKer, "Triangle" = DT.Util.triangleKer, 
                       "Quartic" = DT.Util.quartKer, "Epanechnikov" = DT.Util.epanKer, "Gauss" = DT.Util.gaussKer)

DT.Util.LOO = function(points, classes ,classFunc,hLims = 0) {
  n = dim(points)[1]
  if(identical(classFunc,DT.kNN.kNN) || identical(classFunc,DT.WkNN.WkNN)) {
  loo = double(n-1) #n-1 because one element in sample always missing
  
  for (i in 1:n) {
    
    distances = DT.Util.getDist(points[-i,], points[i,], DT.Util.euclidDist)
    names(distances) = classes[-i]
    sort_dist = sort(distances)
    
    for (l in 1:n - 1) {
      bestClass = classFunc(sort_dist, l)
      loo[l] = loo[l] + ifelse(bestClass == classes[i], 0, 1) #same as ternary operator
      }
    }
  } else if((identical(classFunc, DT.PW.PW))) {
  loo = double(length(hLims))
  
  for (i in 1:n) {
    distances = DT.Util.getDist(points[-i,], points[i,], DT.Util.euclidDist)
    names(distances) = classes[-i]
    
    for (j in 1:length(hLims)) {
      h = hLims[j]
      bestClass = DT.PW.PW(distances, classes[-i], h)
      loo[j] = loo[j] + ifelse(bestClass == classes[i], 0, 1)
        }
     }
  }
  loo = loo / n
  return(loo)
}

DT.Util.drawMap = function(points, classes, classFunc, hOpt = 0, kOpt = 0, potentials = 0, h = 0 ) {
  
  for (x in seq(DT.Util.xlim[1], DT.Util.xlim[2], 0.1)) {
  for (y in seq(DT.Util.ylim[1], DT.Util.ylim[2], 0.1)) {
    u = c(round(x, 1), round(y, 1))
    if (any(apply(DT.Util.petals, 1, function(v) all(v == u)))) next
    
    distances = DT.Util.getDist(points, u, DT.Util.euclidDist)
    
    if(identical(classFunc, DT.PW.PW)) {
      names(distances) = classes
      bestClass = classFunc(distances, classes, hOpt)
    }
    
    else if(identical(classFunc,DT.kNN.kNN) || identical(classFunc,DT.WkNN.WkNN)) {
      names(distances) = classes
      bestClass = classFunc(sort(distances), kOpt)
    }
  
    else if(identical(classFunc,DT.PF.PF)) {
      
      bestClass = classFunc(distances, classes, potentials, h)
      
    }
    
    points(u[1], u[2], col = DT.Util.colors[bestClass], pch = 21)
    }
  }
}
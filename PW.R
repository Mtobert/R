source(file = "util.R", encoding = "UTF-8")

DT.PW.currkernel = NULL

DT.PW.PW = function(distances, classes, h) {
  distances = distances / h
  distances = DT.PW.currkernel(distances)
  
  classes = unique(classes)
  w = sapply(classes, function(name, arr) sum(arr[names(arr) == name]), distances)
  names(w) = classes
  
  if (max(w) == 0) return("fail")
  
  return(names(which.max(w)))
}

DT.PW.drawLoo = function(points, classes, hLims) {
  hs = NULL
  loos = NULL
  
  for (kernelName in names(DT.Util.kernels)) {
    DT.PW.currkernel <<- DT.Util.kernels[[kernelName]] #set kernel
    
    looY <- DT.Util.LOO(points, classes, DT.PW.PW, hLims)
    
    plot(hLims, looY, type = "l", main = paste(kernelName, "kernel's LOO CV for PW"), xlab = "h", ylab = "LOO")
    
    hOpt = hLims[which.min(looY)]
    minLoo = looY[which.min(looY)]
    
    points(hOpt, minLoo, pch = 19, col = "red")
    text(hOpt, minLoo, labels = paste("h=", hOpt, ", LOO=",minLoo), pos = 3, col = "red")
    
    hs = c(hs, hOpt)
    loos = c(loos, minLoo)
  }
  DT.PW.currkernel = DT.Util.kernels[which.min(loos)]
  
  return(min(hs))
}

par(xpd = NA)
layout(matrix(c(1,1,1,0,2,2,2,2,0,3,3,3,
                1,1,1,0,2,2,2,2,0,3,3,3,
                1,1,1,0,2,2,2,2,0,3,3,3,
                0,0,0,0,6,6,6,6,0,0,0,0,
                4,4,4,0,6,6,6,6,0,5,5,5,
                4,4,4,0,6,6,6,6,0,5,5,5,
                4,4,4,0,6,6,6,6,0,5,5,5), nrow = 7, byrow = T))

hOpt = DT.PW.drawLoo(DT.Util.petals, DT.Util.classes, hLims = seq(0.1, 1, 0.05))

names(DT.Util.colors) = unique(DT.Util.classes)
plot(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21, asp = 1.2, xlim = DT.Util.xlim, 
     ylim = DT.Util.ylim, main = "Parzen window classification map")

DT.Util.colors = c(DT.Util.colors, "fail" = "lightblue") #background layer, kinda deprecated since Gauss kernel was found.

DT.Util.drawMap(DT.Util.petals, DT.Util.classes, DT.PW.PW, hOpt)
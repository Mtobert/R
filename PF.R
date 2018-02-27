#install.packages("plotrix")
require("plotrix")
source("util.R")

DT.PF.PF = function(distances, classes, potentials, h) {
    w = potentials * DT.PF.currkernel(distances / h)
    names(w) = classes

    classes = unique(classes)
    w = sapply(classes, function(name, arr) sum(arr[names(arr) == name]), w)

    if (max(w) == 0) return("fail") #same as in previous appears, only mult w/ potentials

    return(classes[which.max(w)])
}

DT.PF.potentials = function(points, classes, h, treshold) {
    n = dim(points)[1]
    potentials = integer(n)

    mistakes = treshold + 1 #initial conditiom to run the loop
    while (mistakes > treshold) {
        flag = T
        while (flag) {
            i = sample(1:n, 1) #take
            u = points[i,] 
            distances = DT.Util.getDist(points, u, DT.Util.euclidDist)

            if (DT.PF.PF(distances, classes, potentials, h) != classes[i]) {
                potentials[i] = potentials[i] + 1
                flag = F #end of loop condition
            }
        }

        mistakes = 0
        for (i in 1:n) {
            u = points[i,]
            distances = DT.Util.getDist(points, u, DT.Util.euclidDist)

            if (DT.PF.PF(distances, classes, potentials, h) != classes[i]) {
                mistakes = mistakes + 1
            }
        }
            print(mistakes)
            print(potentials)
        }    

    return(potentials)
}
    
    n = dim(points)[1]
    h = rep(1, n)
    DT.PF.currkernel = DT.Util.triangleKer
    
    potentials <- DT.PF.potentials(DT.Util.petals, DT.Util.classes, h = h, 5)

      names(DT.Util.colors) = unique(DT.Util.classes)
      plot(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21, asp = 1, xlim = DT.Util.xlim, ylim = DT.Util.ylim)
      title(main = "Potential functions classification map")
      
      densities = potentials / max(potentials)
      n = length(potentials)
      for (i in 1:n) {
        x = DT.Util.petals[i, 1]
        y = DT.Util.petals[i, 2]
        r = h[i]
        d = densities[i] / 2 #setting for semi - transparent
        color = adjustcolor(DT.Util.colors[DT.Util.classes[i]], d)
        
        if (d > 0) draw.circle(x, y, r, 50, border = color, col = color)
      }
      
      points(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21)
      
      DT.Util.colors = c(DT.Util.colors, "fail" = "lightblue") #class for non-succesful cases
      
      DT.Util.drawMap(DT.Util.petals, DT.Util.classes, DT.PF.PF, 0, 0, potentials, h)

source("util.R") #a few general func merged to an external src

DT.kNN.kNN = function(sortedDist, k) {
    kDist = sortedDist[1:k]
    kClasses = names(kDist)
    class = names(which.max(table(kClasses)))
    
    return(class)
}

par(mfrow=c(1,2)) #plot two graphs in a single frame

loo <- DT.Util.LOO(DT.Util.petals, DT.Util.classes, DT.kNN.kNN)

plot(1:length(loo), loo, type = "l", main = "kNN's LOO measurement", xlab = "K", ylab = "LOO")
kOpt = which.min(loo)
points(kOpt, loo[kOpt], pch = 20, col = "blue")
text(kOpt, loo[kOpt], labels = paste("K=", kOpt, ", LOO=",loo[kOpt]), pos = 4, col = "blue")

names(DT.Util.colors) = unique(DT.Util.classes)

plot(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21, asp = 1, xlim = DT.Util.xlim, ylim = DT.Util.ylim, main = "kNN classifier map")

DT.Util.drawMap(DT.Util.petals, DT.Util.classes, DT.kNN.kNN, 0, kOpt)
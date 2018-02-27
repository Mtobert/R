source("util.R")

DT.WkNN.weight = function(i, k) return((k + 1 - i) / k)

DT.WkNN.WkNN = function(sortedDist, k) {
  kDist = sortedDist[1:k]
  w = DT.WkNN.weight(1:k, k)
  names(w) = names(kDist)
  w = sapply(unique(names(w)), function(name, arr) sum(arr[names(arr) == name]), w)
  
  return(names(which.max(w)))
}

par(mfrow = c(1, 2), xpd = NA)
loo <- DT.Util.LOO(DT.Util.petals, DT.Util.classes, DT.WkNN.WkNN)

plot(1:length(loo), loo, type = "l", main = "WkNN's LOO measurement", xlab = "K", ylab = "LOO")
kOpt = which.min(loo)
points(kOpt, loo[kOpt], pch = 19, col = "red")
text(kOpt, loo[kOpt], labels = paste("K=", kOpt, ", LOO=", loo[kOpt]), pos = 4, col = "blue")

names(DT.Util.colors) = unique(DT.Util.classes)
plot(DT.Util.petals, bg = DT.Util.colors[DT.Util.classes], pch = 21, asp = 1, xlim = DT.Util.xlim, ylim = DT.Util.ylim, 
     main = "WkNN classifier map")

DT.Util.drawMap(DT.Util.petals, DT.Util.classes, DT.WkNN.WkNN, 0, kOpt)
data = data.frame(
  x =  rep(log10(point_count),times=length(components)),
  y = rep(components,times=length(point_count))
)

library(lattice)
data$z = as.vector(as.matrix(log10(mucomponents)))

p1 <- wireframe(z ~ x * y, data=data, scales=list(cex=1.5),
               ylab="K",xlab="Points", zlab = "Error", main=expression(mu),
               drape = TRUE, 
               colorkey = TRUE,
               screen = list(z = -45, x = 300))  

data$z = as.vector(as.matrix(log10(betacomponents)))
p2 <- wireframe(z ~ x * y, data=data, scales=list(x=list(at=NULL,cex=0.5)),
                ylab="K",xlab="Points", zlab = "Error", main=expression(beta),
                drape = TRUE, 
                colorkey = TRUE,
                screen = list(z = -45, x = 300))  

data$z = as.vector(as.matrix(log10(alphacomponents)))
p3 <- wireframe(z ~ x * y, data=data, scales=list(x=list(at=NULL,cex=0.5)),
                ylab="K",xlab="Points", zlab = "Error", main=expression(alpha),
                drape = TRUE, 
                colorkey = TRUE,
                screen = list(z = -45, x = 300))  

require(gridExtra)
grid.arrange(p1,p2,p3, ncol=3)

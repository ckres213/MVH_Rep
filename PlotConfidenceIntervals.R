library(Hmisc) 
colors<-c("#FF0000", "#FFFF00", "#00FF00", "#00FFFF", "#0000FF", "#FF00FF")

x <- log10(point_count)  



par(mfrow=c(6,3),oma=c(0,0,0,0))

i<-1
plot(log10(point_count),log10(alphacomponents[,i]),pch = 19, type = "o", col = colors[i],
     main=bquote(alpha ~ ": " ~ .(i) ~ " component"),
     ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(alphabottom[,i])),0.5+max(c(log10(alphatop[,i]),log10(alphacomponents[,i])))))
lower <- log10(alphabottom[,i]) 
upper <- log10(alphatop[,i]) 
polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))

for(i in 2:length(components)){
  plot(log10(point_count),log10(alphacomponents[,i]),pch = 19, type = "o", col = colors[i],
       main=bquote(alpha ~ ": " ~ .(i) ~ " components"),
       ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(alphabottom[,i])),0.5+max(c(log10(alphatop[,i]),log10(alphacomponents[,i])))))
  lower <- log10(alphabottom[,i]) 
  upper <- log10(alphatop[,i]) 
  polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))
}
#mtext(expression(paste("90% CI for Error Associated with " ,alpha," parameter")), line=0, side=3, outer=TRUE, cex=2)

i<-1
plot(log10(point_count),log10(betacomponents[,i]),pch = 19, type = "o", col = colors[i],
     main=bquote(beta ~ ": " ~ .(i) ~ " component"),
     ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(betabottom[,i])),0.5+max(c(log10(betatop[,i]),log10(betacomponents[,i])))))
lower <- log10(betabottom[,i]) 
upper <- log10(betatop[,i]) 
polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))

for(i in 2:length(components)){
  plot(log10(point_count),log10(betacomponents[,i]),pch = 19, type = "o", col = colors[i],
       main=bquote(beta ~ ": " ~ .(i) ~ " components"),
       ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(betabottom[,i])),0.5+max(c(log10(betatop[,i]),log10(betacomponents[,i])))))
  lower <- log10(betabottom[,i]) 
  upper <- log10(betatop[,i]) 
  polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))
} 
  
i<-1
plot(log10(point_count),log10(mucomponents[,i]),pch = 19, type = "o", col = colors[i],
     main=bquote(mu ~ ": " ~ .(i) ~ " component"),
     ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(mubottom[,i])),0.5+max(c(log10(mutop[,i]),log10(mucomponents[,i])))))
lower <- log10(mubottom[,i]) 
upper <- log10(mutop[,i]) 
polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))

for(i in 2:length(components)){
  plot(log10(point_count),log10(mucomponents[,i]),pch = 19, type = "o", col = colors[i],
       main=bquote(mu ~ ": " ~ .(i) ~ " components"),
       ylab="log_10 L1 error",xlab="log_10 number points",ylim=c(min(log10(mubottom[,i])),0.5+max(c(log10(mutop[,i]),log10(mucomponents[,i])))))
  lower <- log10(mubottom[,i]) 
  upper <- log10(mutop[,i]) 
  polygon(c(x, rev(x)), c(lower, rev(upper)), col = adjustcolor(colors[i], alpha.f = 0.1),border=adjustcolor("black", alpha.f = 0.25))
}


library(matrixStats)

load("SimulationStudyJune12.RData") 


realiz_list<-vector("list", realizations)
error_indices <- vector("list", 10^5)
listindex <- 1
for (i in seq_along(across_realizations)) {
  for (j in seq_along(across_realizations[[i]])) {
    for (k in seq_along(across_realizations[[i]][[j]])) {
      # Check if the element contains the error message
      if (is.character(across_realizations[[i]][[j]][[k]]) && any(across_realizations[[i]][[j]][[k]] == "Failed to fit")) {
        # Store the indices if the error message is found
        error_indices[[listindex]] <- c(i, j, k)
        listindex <- listindex + 1
      }
    }
  }
}

# Print the indices of elements that contain the error message
print(error_indices[1:listindex - 1]) 

set.seed(0)
realiz <- hsim(mod, size = point_count[2])
i<-error_indices[[1]][2]
j<-error_indices[[1]][3]
guess_mu = matrix(rep(truemu/components[i],times=components[i])+abs(rnorm(components[i],mean=0,sd=10^-1)), nrow = components[i])
guess_alpha = matrix(rep(truealph/components[i],times=components[i]^2)+abs(rnorm(components[i]^2,mean=0,sd=10^-1)), nrow = components[i], byrow = FALSE)
guess_beta = matrix(rep(truebeta,times=components[i]^2)+abs(rnorm(components[i]^2,mean=0,sd=10^-1)), nrow = components[i], byrow = FALSE)
initialG <- new("hspec", mu = guess_mu, alpha = guess_alpha, beta = guess_beta)
fit <- hfit(initialG, inter_arrival = realiz$inter_arrival[1:point_count[j]], type = c(0, sample(1:components[i], point_count[j]-1, replace = TRUE)), reduced = FALSE)
across_realizations[[115]][[6]][[2]]<-summary(fit)$estimate

#Get differences from ansatz parameters 
for(ii in 1:length(realiz_list)){
  realiz_ii<-across_realizations[[ii]]
  component_container<-list()
  for(j in 1:length(components)){
    realiz_ii_compj<-realiz_ii[[j]]
    mu_container<-c()
    alpha_container<-c()
    beta_container<-c()
    for(i in 1:length(point_count)){
      realiz_ii_compj_counti<-realiz_ii_compj[[i]]
      ests<-realiz_ii_compj_counti[,1]
      mu_container[i]<-abs(sum(unname(ests[grep("mu", names(ests))])-truemu/components[j]))
      alpha_container[i]<-abs(sum(unname(ests[grep("alpha", names(ests))])-truealph/(components[j])))
      beta_container[i]<-abs(sum(unname(ests[grep("beta", names(ests))])-truebeta))
    }
    component_container[[j]]<-list(mu=mu_container,alpha=alpha_container,beta=beta_container)
    names(component_container)[j] <- paste("Component", j,sep="")
  }
  realiz_list[[ii]]<-component_container
  names(realiz_list)[ii]<-paste("Realization", ii,sep="")
}

component_list<-vector("list", length(components))
component_CIS<-vector("list", length(components))
component_dfs<-vector("list", length(components))

for(j in 1:length(components)){
  compmu<-list()
  compalpha<-list()
  compbeta<-list()
  for(k in 1:realizations){
    realizname<-paste("Realzation", k,sep="")
    compname<-paste("Component", j,sep="")
    compmu[[k]]<-realiz_list[[k]][[j]]$mu
    compalpha[[k]]<-realiz_list[[k]][[j]]$alpha
    compbeta[[k]]<-realiz_list[[k]][[j]]$beta
  }
  mudf <- data.frame(do.call(cbind, compmu))
  alphadf <- data.frame(do.call(cbind, compalpha))
  betadf <- data.frame(do.call(cbind, compbeta))
  #mumean <- rowMeans(mudf)
  #alphamean <- rowMeans(alphadf)
  #betamean <- rowMeans(betadf)
  mumean <- rowMedians(as.matrix(mudf))
  alphamean <- rowMedians(as.matrix(alphadf))
  betamean <- rowMedians(as.matrix(betadf))
  CIsize<-c(0.05,0.95)
  muCI <- rowQuantiles(as.matrix(mudf),probs=CIsize)
  alphaCI<- rowQuantiles(as.matrix(alphadf),probs=CIsize)
  betaCI <- rowQuantiles(as.matrix(betadf),probs=CIsize)
  component_list[[j]]<-cbind(mu=mumean, alpha=alphamean, beta=betamean)
  names(component_list)[j]<-paste("component",j)
  component_CIS[[j]]<-cbind(mu=muCI, alpha=alphaCI, beta=betaCI)
  names(component_CIS)[j]<-paste("component",j)
  component_dfs[[j]]<-list(mu=mudf, alpha=alphadf, beta=betadf)
  names(component_dfs)[j]<-paste("component",j)
}




mubottom<-cbind(component_CIS$`component 1`[,1],component_CIS$`component 2`[,1],component_CIS$`component 3`[,1],component_CIS$`component 4`[,1],component_CIS$`component 5`[,1],component_CIS$`component 6`[,1])
mutop<-cbind(component_CIS$`component 1`[,2],component_CIS$`component 2`[,2],component_CIS$`component 3`[,2],component_CIS$`component 4`[,2],component_CIS$`component 5`[,2],component_CIS$`component 6`[,2])
alphabottom<-cbind(component_CIS$`component 1`[,3],component_CIS$`component 2`[,3],component_CIS$`component 3`[,3],component_CIS$`component 4`[,3],component_CIS$`component 5`[,3],component_CIS$`component 6`[,3])
alphatop<-cbind(component_CIS$`component 1`[,4],component_CIS$`component 2`[,4],component_CIS$`component 3`[,4],component_CIS$`component 4`[,4],component_CIS$`component 5`[,4],component_CIS$`component 6`[,4])
betabottom<-cbind(component_CIS$`component 1`[,5],component_CIS$`component 2`[,5],component_CIS$`component 3`[,5],component_CIS$`component 4`[,5],component_CIS$`component 5`[,5],component_CIS$`component 6`[,5])
betatop<-cbind(component_CIS$`component 1`[,6],component_CIS$`component 2`[,6],component_CIS$`component 3`[,6],component_CIS$`component 4`[,6],component_CIS$`component 5`[,6],component_CIS$`component 6`[,6])
mucomponents<-cbind(component_list$`component 1`[,1],component_list$`component 2`[,1],component_list$`component 3`[,1],component_list$`component 4`[,1],component_list$`component 5`[,1],component_list$`component 6`[,1])
alphacomponents<-cbind(component_list$`component 1`[,2],component_list$`component 2`[,2],component_list$`component 3`[,2],component_list$`component 4`[,2],component_list$`component 5`[,2],component_list$`component 6`[,2])
betacomponents<-cbind(component_list$`component 1`[,3],component_list$`component 2`[,3],component_list$`component 3`[,3],component_list$`component 4`[,3],component_list$`component 5`[,3],component_list$`component 6`[,3])

# library(Hmisc) 
# colors<-c("#FF0000", "#CCFF00", "#00FF66", "#0066FF", "#CC00FF")
# 
# x <- log10(point_count)  
# 
# png(filename="pointEsts.png")
# par(mfrow=c(1,3))
# matplot(log10(point_count),log10(alphacomponents),pch = 19, type = "o", col = rainbow(length(components)),
#         main=expression(paste(alpha)),
#         ylab="log_10 L1 error",xlab="log_10 number points")
# legend("topright", title="Components", legend = components, col = rainbow(length(components)),fill=rainbow(length(components)))
# 
# matplot(log10(point_count),log10(betacomponents),pch = 19, type = "o", col = rainbow(length(components)),
#         main=expression(paste(beta)),
#         ylab="log_10 L1 error",xlab="log_10 number points")
# legend("topright", title="Components", legend = components, col = rainbow(length(components)),fill=rainbow(length(components)))
# 
# matplot(log10(point_count),log10(mucomponents),pch = 19, type = "o", col = rainbow(length(components)),
#         main=expression(paste(mu)),
#         ylab="log_10 L1 error",xlab="log_10 number points")  
# legend("topright", title="Components", legend = components, col = rainbow(length(components)),fill=rainbow(length(components)))
# 
# dev.off()

library(doParallel)
library(foreach)
library(emhawkes)
library(doSNOW)

setwd("/home/kreco20p/Hawkes with inhibition")

realizations<-128

numCores <- as.numeric(Sys.getenv("SLURM_CPUS_PER_TASK", "1"))
#numCores<-2
cl <- makeCluster(numCores)
registerDoParallel(cl)
registerDoSNOW(cl)
pb <- txtProgressBar(max = realizations, style = 3)
progress <- function(n) setTxtProgressBar(pb, n)
opts <- list(progress = progress)

set.seed(1)

components <- 1:6
point_count <- floor(10^seq(2,4,length.out = 30)) 
truemu<-1
truealph<-1
truebeta<-2
mod <- new("hspec", mu = truemu, alpha = truealph, beta = truebeta)
across_realizations<-vector("list", length(realizations))

across_realizations <- foreach(ii = 1:realizations, .packages = c("emhawkes"), .options.snow = opts) %dopar% {
  meta_list <- vector("list", length(components))
  for (i in seq_along(components)) {
    realiz <- hsim(mod, size = point_count[length(point_count)])
    fittedmodels <- vector("list", length(point_count))
    for (j in 1:length(point_count)) {
      complete <- FALSE
      counter <- 0
      while (!complete && counter < 10) {
        counter <- counter + 1
        
        guess_mu = matrix(rep(truemu/components[i],times=components[i])+abs(rnorm(components[i],mean=0,sd=10^-1)), nrow = components[i])
        guess_alpha = matrix(rep(truealph/components[i],times=components[i]^2)+abs(rnorm(components[i]^2,mean=0,sd=10^-1)), nrow = components[i], byrow = FALSE)
        guess_beta = matrix(rep(truebeta,times=components[i]^2)+abs(rnorm(components[i]^2,mean=0,sd=10^-1)), nrow = components[i], byrow = FALSE)
        
        # Setup initial guesses for the parameters
        #guess_mu = matrix(runif(components[i]), nrow = components[i])
        #guess_alpha = matrix(runif(components[i] ^ 2), nrow = components[i], byrow = FALSE)
        #guess_beta = 10 * matrix(runif(components[i] ^ 2), nrow = components[i], byrow = TRUE)
        initialG <- new("hspec", mu = guess_mu, alpha = guess_alpha, beta = guess_beta)
        
        MLE_fit <- tryCatch({
          fit <- hfit(initialG, inter_arrival = realiz$inter_arrival[1:point_count[j]], type = c(0, sample(1:components[i], point_count[j]-1, replace = TRUE)), reduced = FALSE)
          summary_fit <- summary(fit)$estimate
          summary_fit
        }, error = function(e) {
          message(paste("Error occurred during fitting for time index", j, "and component index", i, ": ", e$message))
          NULL
        })
        
        if (is.null(MLE_fit)) {
          message(paste("Error occurred, retrying... Attempt number:", counter, "for time index", j, "and component index", i, "and realization", ii, "out of", realizations))
        } else {
          fittedmodels[[j]] <- MLE_fit
          message(paste("Successfully fit and summarized model: time index", j, "and component index", i,"and realization", ii, "out of", realizations))
          complete <- TRUE
        }
      }
      if (!complete) {
        fittedmodels[[j]] <- paste("Failed to fit")
      }
    }
    meta_list[[i]] <- fittedmodels
  }
  meta_list
}

close(pb)
save.image(file='SimulationStudyJune12.RData')
stopCluster(cl)


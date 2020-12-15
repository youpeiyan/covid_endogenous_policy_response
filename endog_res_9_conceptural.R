rm(list=ls())
library(ggplot2)

#### 1. Histogram of 5,000,000 draws for Krinsky-Robb confidence interval for the simulated equivalent case between 0 to 100.

means <- c(0.0421, 0.129, -0.0290)
vc <- matrix(0, 3, 3)

# create the variance covariance matrix based on the stata regression results
vc[1,1] <- 0.0000636845521060081
vc[1,2] <- 0.000132175947769322
vc[1,3] <- -0.0000472565887173502
vc[2,1] <- vc[1,2]
vc[2,2] <- 0.000432168396560472
vc[2,3] <- -0.000111148782724961
vc[3,1] <- vc[1,3]
vc[3,2] <- vc[2,3]
vc[3,3] <- 0.0000419928429697697

krCI <- function(mean, vcm, draws){
  vc <- vcm
  c <- chol(vc) #cholesky decomposition of variance-covariance 
  k <- length(mean)
  gamma <- rep(0, draws)
  for(j in 1:draws){
    rand <- rnorm(k, mean = 0, sd = 1)
    draw <- means + c %*% rand
    gamma[j] <- exp(((draw[1]+draw[3])*1.112514+draw[2])/draw[1])-1
  }
  gamma <- sort(gamma)
  lb <- round(0.025*draws)
  ub <- round((1-0.025)*draws)
  ci <- c(gamma[lb], gamma[ub])
  return(list(ci, gamma))
}
result <- krCI(means, vc, 5000000)
result[[1]]
exp(((means[1]+means[3])*1.112514+means[2])/means[1])-1

res2<-result[[2]]
y<-data.frame(res2)
case<-subset(y,res2<=100 & res2>=0)

ggplot(case, aes(x=res2)) + 
  geom_histogram(color="black", fill="white",binwidth=1)  +
  labs(x= "case", y = "1000 counts")  +
  theme_bw() + 
  theme(panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), 
        axis.line = element_line(colour = "black"), 
        axis.text=element_text(size=18),
        axis.title=element_text(size=20)) +
  scale_y_continuous(labels = function(l) {trans = l / 1000})
ggsave("hist.pdf")

#### 2. Illustration of compensating cases under the no-policy scenorio
rm(list=ls())

if (!require("pacman")) install.packages("pacman")
p_load(ggplot2)

coef <- c(0.0421,0.129,-0.0290)
med.case = 2
mean.case = 16.89207
#Simulation function 
sim <- function(cases, case_star, param){
  if(cases < case_star){
    tmp <- param[1]*log(cases+1)
  } else {
    tmp <- param[1]*log(cases+1) + param[2] + param[3]*log(cases+1)
  }
  return(tmp)
}

#SOME SIMUATIONS
sim1.org <- sapply(c(0:60), function(x) sim(x, mean.case, coef))
sim1.no  <- sapply(c(0:60), function(x) sim(x, 200, coef))
sim1 <- as.data.frame(cbind(c(0:60), sim1.org, sim1.no))
colnames(sim1) <- c("cases", "time.org", "time.no")

sim2.org <- sapply(c(0:60), function(x) sim(x, med.case, coef))
sim2.no  <- sapply(c(0:60), function(x) sim(x, 200, coef))
sim2 <- as.data.frame(cbind(c(0:60), sim2.org, sim2.no))
colnames(sim2) <- c("cases", "time.org", "time.no")

ggplot() +
  geom_line(data = sim1, aes(x = cases, y = time.no), color = "blue", size = 1.25)+
  geom_line(data = sim1, aes(x = cases, y = time.org), color = "#85c4b9", size = 1.25,linetype = 'dashed')+
  geom_line(data = sim2, aes(x = cases, y = time.org), color = "red", size = 1.25, linetype = 'dashed')+
  labs(
    x= "county cases",
    y = "additional effects \n to log(home dwell time)")  +
  theme(
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA),
    axis.line = element_line(colour = "black"),
    axis.text=element_text(size=20),
    axis.title=element_text(size=20)
  )
ggsave("fig5.pdf")

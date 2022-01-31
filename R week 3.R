library(dplyr)
library(ggplot2)
library(statsr)
data("kobe_basket")
View(kobe_basket)
dim(kobe_basket)
str(kobe_basket)
summarise(kobe_basket)
kobe_streak<-calc_streak(kobe_basket$shot)
kobe_streak
ggplot(data = kobe_streak,aes(x=length))+ geom_histogram(binwidth = 1)
?calc_streak # it is a pred efined function which storrs the streaks in a data frame kobe_streak under the length var.
ggplot(data = kobe_streak,aes(x=length))+ geom_boxplot()
boxplot(kobe_streak$length, col = "green", horizontal = TRUE)
str(kobe_streak$length)
median(kobe_streak$length)

#Here we will draw a sample using a random process.

coin_outcomes<-c("heads","tails")
sim_fair_coin<-sample(coin_outcomes, size=100,replace = TRUE) # here sim means simulations of the fair coin 100 times.
sim_fair_coin
table(sim_fair_coin)

# Now we will simulate the coin flipping experiment with an unfair coin for 100 times.
sim_unfair_coin<-sample(coin_outcomes,size=100,replace = TRUE, prob = c(0.2,0.8))
sim_unfair_coin
table(sim_unfair_coin) # Note that heads only appears 20 out of 100 as its prob was 20%

if(FALSE){
  According to the question, since kobe bryant had a 45% shooting percentage, hence, in order to make the series of an
  independent shooter we will take a sample where the prob of hitting the basket would be 0.45 and 0.55 of missing it.
  
}
shot_outcomes<-c("H","M")
sim_basket<-sample(shot_outcomes,size=133,replace = TRUE) 

sim_streak<-calc_streak(sim_basket)
sim_streak
typeof(sim_streak)
typeof(kobe_basket)
ggplot(data = sim_streak,aes(x=length))+geom_histogram(binwidth = 1)
boxplot(sim_streak$length,col = "yellow", horizontal = TRUE)
View(sim_streak)

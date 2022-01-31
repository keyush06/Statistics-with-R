library(dplyr)
library(ggplot2)
library(statsr)
data("nycflights")
nycflights
View(nycflights)
names(nycflights) # variables or the columns in the data frame
?nycflights # description about the data.
str(nycflights)
if(FALSE){
  The `dplyr` package offers seven verbs (functions) for basic data 
  manipulation:
    
    - `filter()`
  - `arrange()`
  - `select()` 
  - `distinct()`
  - `mutate()`
  - `summarise()`
  - `sample_n()`
}

#Histogram for analyzing the departure delays


ggplot(data = nycflights,aes(x=dep_delay)) + geom_histogram(binwidth = 200)+stat_bin(bins = 50)
#?geom_histogram
rlang::last_error()# used to check the last error.
?filter
# Now in order to plot the flights which were delayed in terms of departure and headed towards RDU, wew first filter the dataset
#by making a new dataframe and then plot the histogram.

View(filter(nycflights, dest=="RDU")) # we use View as the data is too large to be printed. We can also
# print the whole data by increasing the limit.
rdu_flights<-filter(nycflights, dest=="RDU")
options(max.print = 802)
print(rdu_flights)
ggplot(data = rdu_flights,aes(x=rdu_flights$dep_delay)) + geom_histogram()
if(FALSE){
  "**Logical operators: ** Filtering for certain observations (e.g. flights from a 
                                                              particular airport) is often of interest in data frames where we might want to 
  examine observations with certain characteristics separately from the rest of 
  the data. To do so we use the `filter` function and a series of 
  **logical operators**. The most commonly used logical operators for data 
  analysis are as follows:
    
    - `==` means "equal to"
  - `!=` means "not equal to"
  - `>` or `<` means "greater than" or "less than"
  - `>=` or `<=` means "greater than or equal to" or "less than or equal to"
  </div>"
    
}

if(FALSE){
  "We can also obtain numerical summaries for these flights:

```{r rdu-flights-summ}
rdu_flights %>%
  summarise(mean_dd = mean(dep_delay), sd_dd = sd(dep_delay), n = n())
```

Note that in the `summarise` function we created a list of two elements. The 
names of these elements are user defined, like `mean_dd`, `sd_dd`, `n`, and 
you could customize these names as you like (just don't use spaces in your 
names). Calculating these summary statistics also require that you know the 
function calls. Note that `n()` reports the sample size."
}

# These are the 2 ways !!!!!!!
rdu_flights%>%
   summarise(mean_dd=mean(dep_delay), sd_dd= sd(dep_delay),n=n())
?summarise
summarise(rdu_flights,mean_dd=mean(dep_delay), sd_dd= sd(dep_delay),n=n())



#q.1
sfo_Feb_flights<-filter(nycflights,month==2 & dest=="SFO")
ggplot(sfo_Feb_flights,aes(arr_delay))+geom_histogram(binwidth = 50)
?nycflights
summary(sfo_Feb_flights$arr_delay)
summarise(sfo_Feb_flights,mean_ad=mean(arr_delay), sd=sd(arr_delay))
filter(sfo_Feb_flights,arr_delay>120) # for   Q.2

#q.3
View(sfo_Feb_flights)
group_by(sfo_Feb_flights$carrier)

sfo_Feb_flights %>%
  group_by(carrier)%>%
  summarise(mean_dd = mean(arr_delay), sd_dd = sd(arr_delay),iqr= IQR(arr_delay))

#Q.4 and q.5
nycflights %>%
  group_by(month)%>%
  summarise(mean_m=mean(dep_delay),med=median(dep_delay))%>%
  arrange(desc(mean_m,med))

   

?arrange

#Q.6
if(FALSE){
  
  "We can also visualize the distributions of departure delays across months using 
side-by-side box plots:

```{r delay-month-box}
ggplot(nycflights, aes(x = factor(month), y = dep_delay)) +
  geom_boxplot()
```

There is some new syntax here: We want departure delays on the y-axis and the
months on the x-axis to produce side-by-side box plots. Side-by-side box plots
require a categorical variable on the x-axis, however in the data frame `month` is 
stored as a numerical variable (numbers 1 - 12). Therefore we can force R to treat
this variable as categorical, what R calls a **factor**, variable with 
`factor(month)`."
}
ggplot(nycflights,aes(x=factor(month),y=dep_delay)) + geom_boxplot() # syntax for side by side box plot.

nycflights %>%
  group_by(month)%>%
  ggplot(aes(x=month,y=dep_delay,group=month))+geom_boxplot()

# Q.7
if(FALSE){
  "Let's start with classifying each flight as "on time" or "delayed" by
creating a new variable with the `mutate` function.

```{r dep-type}
nycflights <- nycflights %>%
  mutate(dep_type = ifelse(dep_delay < 5, "on time", "delayed"))
```

The first argument in the `mutate` function is the name of the new variable
we want to create, in this case `dep_type`. Then if `dep_delay < 5` we classify 
the flight as `"on time"` and `"delayed"` if not, i.e. if the flight is delayed 
for 5 or more minutes.

Note that we are also overwriting the `nycflights` data frame with the new 
version of this data frame that includes the new `dep_type` variable.

We can handle all the remaining steps in one code chunk:

```{r}
nycflights %>%
  group_by(origin) %>%
  summarise(ot_dep_rate = sum(dep_type == "on time") / n()) %>%
  arrange(desc(ot_dep_rate))
```

**The summarise step is telling R to count up how many records of the currently found group are on time - sum(dep_type == "on time") - and divide that result by the total number 
#of elements in the currently found group - n() - to get a proportion, then to store the answer in a new variable called ot_dep_rate.**"

}


nycflights<-mutate(nycflights,departure_type=ifelse(dep_delay<5,"On Time","Delayed"))
# because we only consider flights which depart late by more than 5 min as delayed. Flights which may extend their departure 
#timings by 5 min are not counted as delayed but On time.!!!
View(nycflights) # here we see that a new coln is added as we saved in the nycflights only!

nycflights%>%
  group_by(origin)%>%
  summarise(proportion=sum(departure_type=="On Time")/n())%>%
  arrange(desc(proportion))
  
rlang::last_error()
rlang::last_trace()


ggplot(nycflights,aes(x=origin,fill=departure_type))+geom_bar() # this is a segmented bar plot for comparisons of all the 3 
#airports

#Q.8 Calculation of the avg speed

nycflights<-nycflights%>%
  mutate(avg_speed=distance/air_time)%>%
  arrange(desc(avg_speed))
  
View(nycflights)

plot(x=nycflights$avg_speed,nycflights$distance,main = "avgspeed vs dist")

# Q.10

nycflights<-mutate(nycflights,arr_type=ifelse(arr_delay<=0,"On Time","Delayed"))
count=0
#x<-1:length(nycflights$arr_type)
for(row in 1:nrow(nycflights))
{  dep<-nycflights[row,"departure_type"]
   arr<-nycflights[row,"arr_type"]

if(dep=="Delayed" & arr=="On Time"){
  count=count+1
}}
d<-print(count)
nycflights%>%
  summarise(result= d/sum(departure_type=="Delayed"))%>%
  arrange(desc(result))

#nycflights<-mutate(nycflights,yes_no=ifelse(departure_delay=="delayed"))

dbinom(2,size = 10,p=0.56)
pnorm(0.806,lower.tail = FALSE)
?pnorm
pnorm(0.705,lower.tail = FALSE)
qnorm(0.95,55,6)
qnorm(0.90,1500,300)
dbinom(2,size = 3,p=0.51)
pnorm(34,24,4,lower.tail = TRUE)
sum(dbinom(35:3000000,size = 3000000,p=0.00001))
pnorm(0.83,lower.tail = FALSE)

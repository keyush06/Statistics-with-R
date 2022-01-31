install.packages("devtools")

install.packages("dplyr")

install.packages("rmarkdown")

install.packages("ggplot2")

install.packages("broom")

install.packages("gridExtra")

install.packages("shiny")

install.packages("cubature")

install.packages("tidyr")

library(devtools)

install_github("StatsWithR/statsr",force = TRUE)

library(dplyr)
library(ggplot2)
library(statsr)
data("arbuthnot")
arbuthnot
data()
View(arbuthnot)
dim(arbuthnot)
names(arbuthnot)
arbuthnot$boys
 # the code for plotting the no. of girls vs the year in which they were baptized.
ggplot(data = arbuthnot, aes(x=year, y= girls)) +  # if we give aes in ggplot then it uses the same by default in geom_pont but if it is not given in ggplot then each line has to be specified of the aesthetics or axes
  geom_point(colour="red",size=3)

#in order to see the functioning og the any function just type a question mark and the function. Example:-
?ggplot # here aes means aesthetics ie the X and Y axes. Plus the Geom_point means scatter plot.


ggplot(data = arbuthnot, aes(x=year, y= girls)) + geom_boxplot(colour="green")
?geom_boxplot



# we write this if and false to avoid any data from printing in the output. We cannot comment multiple lines out hence this a HACK :D!!!!
if(FALSE) {
### R as a big calculator #############################################

#Now, suppose we want to plot the total number of baptisms. To compute this, we 
could use the fact that R is really just a big calculator. We can type in 
mathematical expressions like

```{r calc-total-bapt-numbers}
5218 + 4683
```

to see the total number of baptisms in 1629. We could repeat this once for each 
year, but there is a faster way. If we add the vector for baptisms for boys to 
that of girls, R will compute all sums simultaneously.

```{r calc-total-bapt-vars}
arbuthnot$boys + arbuthnot$girls
```

What you will see are 82 numbers (in that packed display, because we aren't 
                                  looking at a data frame here), each one representing the sum we're after. Take a
look at a few of them and verify that they are right.

### Adding a new variable to the data frame

We'll be using this new vector to generate some plots, so we'll want to save it 
as a permanent column in our data frame.

```{r calc-total-bapt-vars-save}
arbuthnot <- arbuthnot %>%
  mutate(total = boys + girls)
```

What in the world is going on here? The `%>%` operator is called the **piping** 
  operator. Basically, it takes the output of the current line and pipes it into 
the following line of code.*"Take the `arbuthnot` dataset and **pipe** it into the `mutate` function. 
Using this mutate a new variable called `total` that is the sum of the variables
called `boys` and `girls`. Then assign this new resulting dataset to the object
called `arbuthnot`, i.e. overwrite the old `arbuthnot` dataset with the new one
containing the new variable."*
  
  This is essentially equivalent to going through each row and adding up the boys 
and girls counts for that year and recording that value in a new column called
total.
} 


#### ANOTHER WAY OF ADDING TOTAL COLUMN######
total=arbuthnot$boys + arbuthnot$girls
print(total)

arbuthnot$total<-total # this adds the column total of boys and girls in the data set.
arbuthnot


# to plot the line graph of the total baptisms vs the year

ggplot(data = arbuthnot,aes(x=year,y=total)) + geom_line() # we get a line grapg and nota scatter plot as with the geom_point.

#In order to get both we have :-

ggplot(data = arbuthnot,aes(x=year,y=total)) + geom_line() + geom_point()

#Logical operators
more_boys=arbuthnot$boys > arbuthnot$girls
print(more_boys)

arbuthnot$more_boys= more_boys

#************************************************************************************************************************************************
 #Working with a new data set of the record of present births in the US. This is already compiled with the statsr package which was installed.

data("present")
present
View(present)
range(present$year)

total1=present$boys+present$girls
present$total1<-total1
present

boys_proportion<-present$boys/present$total1
present$boys_prop<-boys_proportion
View(present)

ggplot(data = present,aes(x=year, y=boys_prop)) + geom_line(colour="red",size=2)


more_boys=present$boys > present$girls
present$more_boys=more_boys
View(present)

prop_boy_girl = present$boys / present$girls
present$propBoysGirls = prop_boy_girl
View(present)

ggplot(data = present,aes(x=year,y=propBoysGirls)) + geom_line()

?sort
sort(present$total1, decreasing = TRUE)

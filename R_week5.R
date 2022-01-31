load("selected_nzes2011.Rdata")
View(selected_nzes2011)
library(dplyr)
library(ggplot2)
selected_nzes2011 %>%
  select(jpartyvote,jdiffvoting,_singlefav)%>%
  str()


#If we try to run that line, we will get an error message about unexpected input or missing object.
if(FALSE){
  We know that `select()` is a valid `dplyr` function, so that cannot be the problem. This means the problem might be the variable names. The issue is that R has rules about what variable 
  names are legal (e.g. no spaces, starting with a letter) and when data is loaded, R will often fix variable names to make them legal. This happened to the `_singlefav` at the time of 
  loading the data.
  
  We could check this by looking through every single variable name in the data with the `names()` command.
  
  ```{r}
  names(selected_nzes2011)
  ```
  
  However, when we have hundreds of column names, a useful tip is to just search out only possible names. We can search the names for a fragment of the name by using the 
  `grep("FRAGMENT", variable, value = TRUE)` command, which in this case might be:
    
    ```{r findname}
  grep("singlefav", names(selected_nzes2011), value = TRUE)
  ```
  
  The `value = TRUE` argument, as described in the help for the `grep()` function reports the matching character string, as opposed to the index number for that string.
  
  We can now confirm that the variable is called `X_singlefav`, so that is how we should be referring to it.
  
}
grep("singlefav",names(selected_nzes2011), value = TRUE)
selected_nzes2011 %>%
  select(jpartyvote,jdiffvoting,X_singlefav)%>%
  str()

# In oirder to count the occurrences of each of the levels, we use the groupby and the summarise functionss.

selected_nzes2011%>%
  group_by(jpartyvote)%>%
  summarise(count=n())

#We can see that 23 people answered `"Don't know"`. Since our question is about people who knew which party they voted for, we might want to exclude these observations from our analysis. 
#We can do so by `filter`ing them out.
selected_nzes2011%>%
  filter(jpartyvote != "Don't Know")%>%
  group_by(jpartyvote)%>%
  summarise(count=n())

x<-load("brfss2013.RData")
View(x)











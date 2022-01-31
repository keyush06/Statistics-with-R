# FINAL PRJECT FOR INTRO TO PROBABILITY AND DATA WITH R 
# The project is already done in R markdown but this is another way that could be used to do the prject.
#The graphs are well made and the research questions are well thought.

#Exploring the BRFSS data
#Setup
#Load packages and Tidy Up Analysis Environment

library(ggplot2)
library(dplyr)
#LOAD DATA

load("brfss2013.RData")

#Part 1: Data

Data

# In the BRFSS data set stratified sampling was used to collect uniform, state-specific data on preventive health 
# practices and risk behaviors that are linked to chronic diseases, injuries, and preventable infectious diseases 
# that affect the adult population.
# 
# In this cross sectional observational study as a large representative random sampling was drawn from the population 
# the data for the sample can be considered generalisable to the adult population of the participating states.
# 
# It is important to note however that a major challenge in conducting an observational study such as this is drawing 
# inferences that are free from influences by overt biases, as well as to assess the influence of potential hidden 
# biases. As this is an observational study it won't be possible to make causal inferences from the data.

#The underlying analysis uses data from survey performed in 2013.

## Part 2: Research questions

# Research question 1: For the general population in the US, is there a correlation between the amount of smoking and
# general health? There has been significant research about the link between smoking and disease but I am interested to 
# see if the data supports this.
# 
# Research question 2: For the general population in the US,is there a correlation between the amount of sleep and the
# person's general health? There has been recent research about the link between sleep and general health but I am
# interested to see if the data supports this.
# 
# Research question 3: For the general population in the US, is there a relationship between physical activity and 
# income level. The hypothesis is that higher income or employment status leads to more activity because the 
# participants has more free time. The data will be examined to see if this is the case.
# 
# All questions are analyised to see if there is variance between males and females.



#Part 3: Exploratory data analysis


# **************************************************************************************************************************************
  

#Research quesion 1: Correlation between the amount of smoking and heart disease:
  
q1 <- brfss2013 %>% select(sex  , smokday2, genhlth) %>%
  filter(!is.na(sex), !is.na(smokday2),!is.na(genhlth)) %>% 
  group_by(sex,smokday2,genhlth) %>% 
  summarise(count=n()) %>% 
  mutate(perc=count/sum(count))

ggplot(q1, aes(x = factor(smokday2), y = perc*100, fill = factor(genhlth))) +
  geom_bar(stat="identity", width = 0.7) +
  labs(x = "Smoking Frequency", y = "Percentage", fill = "General Health") +
  theme_minimal(base_size = 10) +
  facet_grid(. ~  sex)

# There appears to be a relationship between smoking and general health across both male and female participants. 
# Of the respondents who responded that they smoke "Not at all" there is a greater percentage that consider their 
# general health to be good or better.

## Research question 2: correlation between the amount of sleep and the person's general health:
  
q2 <- brfss2013 %>% select(sex, sleptim1,genhlth) %>%
  filter(!is.na(sex), !is.na(sleptim1),!is.na(genhlth))

ggplot(q2, aes(x=sex, y=sleptim1)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=1,outlier.size=4) +
  labs(x = "Sex", y = "Hours Slept")

# Examining the summary data in a box plot shows there are a number of outliers in the numbers of hours slept per day. 
# For the purposes of this analysis outliers a removed and hours slept are set at <=12


q2_m <- brfss2013 %>% select(sex, sleptim1,genhlth) %>%
  filter(!is.na(sex), !is.na(sleptim1),!is.na(genhlth), sleptim1 <= 12)

ggplot(q2_m, aes(x=sex, y=sleptim1)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=1,outlier.size=4) +
  labs(x = "Sex", y = "Hours Slept")

# We then want to create and plot mean of sleep time for each general health category.

q2_htlh <- q2_m %>% group_by(sex,genhlth) %>% summarise(mn_sleep = mean(sleptim1))

ggplot(q2_htlh, aes(genhlth, mn_sleep)) +
  geom_point(aes(genhlth, mn_sleep)) +
  labs(title="Average hours of sleep for each general health self-rating",
       x="general health rating", y="average hours of sleep")+
  facet_grid(. ~  sex)


# Reviewing the plot above, there appears to be a relationship between general health and time spent sleeping 
# across both mate and female participants. Participants who reported being in excellent general health slept the 
# longest time on average. However that may be because they feel generally healthly because they are receiving 
# sufficient sleep each night .

## Research quesion 3: The relationship between income and physical activity.


q3 <- brfss2013 %>% select(sex, exerany2, income2) %>%
  filter(!is.na(exerany2), !is.na(income2), !is.na(sex)) %>%
  group_by(sex,income2) %>% summarise(amount_exer = sum(exerany2 == "Yes") / n())

# Plot - first replace spaces with line breaks in income2 names.

levels(q3$income2) <- gsub(" ", "\n", levels(q3$income2))
ggplot(q3, aes(income2, amount_exer)) +
  geom_point(aes(income2, amount_exer)) +
  labs(title="Proportion of participants who exercised in last 30 days vs. income",
       x="Level of Income", y="Amount Who Exercise")+
  theme(text = element_text(size=7.5))+
  facet_grid(. ~  sex)

# The conclusion from this analysis that that for higher levels of income the proportion of participants who exercise
# are higher. Interestingly the porporation of female participants who exercise is lower than male participants for 
# incomes of less that $35,000.
# 
# The higher proportion of exercise for incomes above $50,000 could be because of a number of reasons such has 
# availability of free time, general health or access to exercise equipment and sport.


# Horse racing analysis with R and SQL
# Written by Masato Eguchi 
#######################################################################################################
# This is project aims to analyze Japanse horse racing data to determins the factores that contribute to 
# the result of the race using R and SQL.
########################################################################################################
#Data dictionaly

#name = horse name
#order = winning order (1 means winning)
#wakuwan (group number) = houses are grouped in pairs or sometimes in trios based on horse number. 
#(For example, horse number 1,2 are group1, horse number 3,4 are group 2)
#umaban (horse number) = number of horse. Number 1 horse starts from the most inner starting point.
#popular = 1 means the horse was most popular before the race starts in terms on odds. 
#########################################################################################################

# install packege

#install.packages("sqldf")
#install.packages("readr")
library(sqldf)
library(readr)


race_data <- read_csv("/Users/eguchimasato/horse_racing/KEIBA_WITH_R/race_data_copy.csv", 
                      col_types = cols(weight = col_number()))


# Before analysis: column name 'order' is fanction name in sql and give you error so change it to "win_order".
names(race_data)[3]<- "win_order"


# Some of the column names being used in this project are in Japanese. Change them to English.
names(race_data)[4]<- "group_num"
names(race_data)[5]<- "horse_num"


# Check data quality
summary(race_data)
head(race_data)
tail(race_data)


# Remove columns with NULL in win_order
race_data_nonull <- race_data[!with(race_data,is.na(race_data$win_order)),]

summary(race_data_nonull)


#QUESTION: What is the characteristic of the winnig horse and losing horse?

# Subset data besed on winning order

order1_horses <- subset(race_data_nonull, win_order == 1)
order2_horses <- subset(race_data_nonull, win_order == 2)
order3_horses <- subset(race_data_nonull, win_order == 3)
order4_horses <- subset(race_data_nonull, win_order == 4)
order5_horses <- subset(race_data_nonull, win_order == 5)
order6_horses <- subset(race_data_nonull, win_order == 6)
order7_horses <- subset(race_data_nonull, win_order == 7)
order8_horses <- subset(race_data_nonull, win_order == 8)
order9_horses <- subset(race_data_nonull, win_order == 9)
order10_horses <- subset(race_data_nonull, win_order == 10)

# Examine the effect of popularity before the race

popular_sql <- sqldf("SELECT popular, AVG(win_order)
                  FROM race_data_nonull
                  GROUP BY popular
                  ORDER BY popular
                  ")

####################################
# Result
# The higher the popularity before the race is, the more likely the horse to win.(win_order tends to be small)
# That means there are some factors that people are using to forcast the result that is known before the race.
####################################

# Try to look at the starting positions of the race. 

hist(order1_horses$horse_num)
hist(order2_horses$horse_num)
hist(order3_horses$horse_num)
hist(order4_horses$horse_num)
hist(order5_horses$horse_num)
hist(order6_horses$horse_num)
hist(order7_horses$horse_num)
hist(order8_horses$horse_num)
hist(order9_horses$horse_num)
hist(order10_horses$horse_num)

######################################################
# Result
# huge skweness was observed to the left but looks too unusual.
######################################################

# Made table to see the distribution

table(order1_horses$horse_num)

###########################################
# Result
# The first pilar containts horse_num 1 and 2 (most inner and second most inner starting positions)
# so it's nearly double of the other pollars.
# The reson why the obserbation after number 10 are decreasing is some races don't even have nunbers after 10 or 11.
# Horses with bigger horse number (after 9 or 10) are slitely lose more than the ones with smaller horse numbers
###########################################

# Try to calculate the actual ratio of winning based on the starting position.

hourse_num_sql <- sqldf("SELECT horse_num, AVG(win_order)
                    FROM race_data
                    GROUP BY horse_num;")

#################################################################################
# Result
# some disadvantages are observed after around 10th starting position (= horse_num).
#################################################################################

# Examine if weight matters on win_order

weight_sql <- sqldf("SELECT win_order, AVG(weight)
                    FROM race_data
                    GROUP BY win_order
                    ORDER BY win_order ASC;")

##################################################################################
# Result
# It looks like heavier horses have advantage.
##################################################################################



# Conclusion

# The popularity before the race hugely affect the real race outcome. In addition to that, 
# some factors such as horse weihgt, and horse number (starting point) have some effect on
# race result as well.


# For the future project
# There are some (categorical) factors to examine such as horse gender, stadium condition, jockey.
# I'd like take those variable into considaration to gain more insight.







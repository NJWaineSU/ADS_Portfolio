######################################################### 
# # # # # # # # Air BnB analysis - Team 4 # # # # # # # #
#########################################################

library(dplyr)
library(ggplot2)
library(randomForest)
library(caret)
library(epiDisplay)
library(tidyr)

data_full <- read.csv("airbnb.csv")

# Preliminary EDA
range(data_full$price)
mean(data_full$price)
median(data_full$price)

# Boxplot of prices - some crazy outliers to deal with!
price_plot <- ggplot(data_full, aes(x = room_type, y = price)) +
  geom_boxplot()
price_plot

# Filter by price to reduce the dataset down to realistic prices
f.data_full <- filter(data_full, price < 5000)

# Trying another boxplot on filtered data
price_plot <- ggplot(f.data_full, aes(x = room_type, y = price)) +
  geom_boxplot()
price_plot

# A little bit better, still many outliers. We'll shrink down to < $1000 and do another boxplot
f.data_full <- filter(data_full, price < 1000)
price_plot <- ggplot(f.data_full, aes(x = room_type, y = price)) +
  geom_boxplot()
price_plot

# Create another dataframe that groups the filtered data by room type
roomType <- group_by(f.data_full, room_type)

# Use summarize function to get median price and median reviews per month by room type. Still just exploring the data.
summarize(roomType, price = median(price), reviewsPerMonth = median(reviews_per_month, na.rm = TRUE))

# Filtering to only show New York City listings
nyc <- filter(f.data_full, city == "New York City")

# Group by room type in NYC
roomType <- group_by(nyc, room_type)

# Summarizing median NYC prices and reviews per month by type
summarize(roomType, price = median(price), reviewsPerMonth = median(reviews_per_month, na.rm = TRUE))

# Next step is to place prices into bins to serve as classifiers
b <- c(0, 50, 100, 150, 200, 250, 300, 350, Inf)
price_ranges <- c("0-50", "51-100", "101-150", "151-200", "201-250", "251-300", "301-350", "351+")
nyc$price.cat <- cut(nyc$price, breaks = b, labels = price_ranges)

head(nyc)

# Next we need to remove unimportant columns. Name, host ID, host Name, Minimum nights, Calculated host listing count.
nyc <- select(nyc, -c(name, host_id, host_name, minimum_nights, calculated_host_listings_count, price))
head(nyc)
nyc <- select(nyc, -1)
head(nyc)

# Next we'll get rid of listings with 0 reviews
nyc <- filter(nyc, number_of_reviews > 0)

######################################################### 
## More EDA and Setting up first run of Random Forest ###
######################################################### 

# Calculating the number of rows that is 75% of the data set
smpl <- floor(0.75 * nrow(nyc))
set.seed(3456)
train_ind <- sample(seq_len(nrow(nyc)), size = smpl)

# Dividing into training and testing sets
train <- nyc[train_ind, ]
test <- nyc[-train_ind, ]

# Removing price category from test set
test <- dplyr::select(test, -last_col())

# Modifing the test set and re-including the price.cat variable but with "NONE" in every field
# to allow for combining data sets.
# rbind won't work unless the two data sets we're combining have the same number of columns
# and the same names.

test.price_cat <- data.frame(price.cat = rep("None", nrow(test)), test[,])


rf.train.1 <- nyc.combined[1:26226, c("neighbourhood_group","neighbourhood","latitude","longitude")]
rf.label <- as.factor(train$price.cat)

# Check for NA's in response variable
which(is.na(rf.label))

# Found 3 NA's, recreating rf.label and substituting NA's arbitrarily with $51-100 factor
rf.label$train.price.cat[is.na(rf.label$train.price.cat)] <- "51-100"


# Check again for NA's in response variable
which(is.na(rf.label))


set.seed(3213)
rf.1 <- randomForest(x = rf.train.1, y = rf.label, importance = TRUE, ntree = 1000)

length(rf.label)
dim(rf.train.1)

# Combining the test and train datasets
nyc.combined <- rbind(train, test.price_cat)

# Check structure, make data type changes as needed
str(nyc.combined)
nyc.combined$neighbourhood_group <- as.factor(nyc.combined$neighbourhood_group)
nyc.combined$neighbourhood <- as.factor(nyc.combined$neighbourhood)
nyc.combined$room_type <- as.factor(nyc.combined$room_type)

# Creating table of listings by price category. (Note: We're back to using 'nyc' instead of 'nyc.combined')
table(nyc$price.cat)

# Graphing listings by price category
ggplot(nyc, aes(price.cat)) +
  geom_bar()

# Ceating a table of listings by neighborhood group (borough)
table(nyc$neighbourhood_group)

# Graph view of the listing breakdown by neighborhood group (borough)
tab1(nyc$neighbourhood_group, sort.group="descending",cum.percent=TRUE)

# Converting room type variable to factor
train$room_type <- as.factor(train$room_type)
test$room_type <- as.factor(test$room_type)

# Creating a hypothesis: Manhattan listings are the most expensive
ggplot(nyc, aes(x = price.cat,fill = neighbourhood_group)) +
  geom_histogram(stat = "count", width = 0.5) +
  xlab("price categories") +
  ylab("Total Count") +
  labs(fill = "Neighborhood Group")

# Viewing frequency table of listings in each neighborhood by price category
table(nyc$neighbourhood_group, nyc$price.cat)

rf.price <- randomForest(x = train, y = price_categories, importance = TRUE, ntree = 500)



# Student: Nick Waine
# Professor: Dr. Gregory Block
# Course: IST 707 - Fall 2021
# Assignment: Final Project

library(dplyr)
library(ggplot2)
library(randomForest)
library(caret)
library(doSNOW)

# Load raw wine dataset
rawWine <- read.csv("newWine.csv")

# Split data into 70/30 train/test sets
trainSize <- floor(0.7 * nrow(rawWine))

# Take random sample of raw data to use as train data
set.seed(123)
train_ind <- sample(seq_len(nrow(rawWine)), size = trainSize)

train <- rawWine[train_ind, ]
test <- rawWine[-train_ind, ]

# Removing 'quality' variable from test data
test <- select(test, -quality)
head(test)

# Add a 'quality' variable to test set to allow for combining data sets
test.quality <- data.frame(quality = rep("None", nrow(test)), test[,])

# Combine data sets
data.combined <- rbind(train, test.quality)
tail(data.combined)

# Checking data types of combined data variables
str(data.combined)

# Converting "Quality" and "Type" to factor variables
data.combined$quality <- as.factor(data.combined$quality)
data.combined$ï..type <- as.factor(data.combined$ï..type)

# Taking a look at quality ratings
table(data.combined$quality)

# Distribution of red/white wine in dataset
table(data.combined$ï..type)
head(data.combined)

# Hypothesis 1: Higher levels of sulfur dioxide leads to a higher quality rating
ggplot(train, aes(x = free.sulfur.dioxide, fill = factor(quality))) +
  geom_histogram() +
  xlab("Sulfur Dioxide") +
  ylab("Total Count") +
  labs(fill = "Quality") +
  ggtitle("Sulfur Dioxide Levels")

# Hypothesis 2: Lower pH levels leads to a higher quality rating
ggplot(train, aes(x = pH, fill = factor(quality))) +
  geom_histogram() +
  xlab("pH") +
  ylab("Total Count") +
  labs(fill = "Quality") +
  ggtitle("pH Levels")

# Hypothesis 3: Higher sulfate levels leads to higher quality rating
ggplot(train, aes(x = sulphates, fill = factor(quality))) +
  geom_histogram() +
  xlab("Sulphates") +
  ylab("Total Count") +
  labs(fill = "Quality") +
  ggtitle("Sulphate levels")

# Hypothesis 4: Higher residual sugar level leads to higher quality rating
ggplot(train, aes(x = residual.sugar, fill = factor(quality))) +
  geom_histogram() +
  xlab("Residual Sugar") +
  ylab("Total Count") +
  labs(fill = "Quality") +
  ggtitle("Residual Sugar Levels")

# Hypothesis 5: High Citric Acid levels in Red Wine leads to higher quality rating than white wine
ggplot(data.combined[data.combined$quality != "None",], aes(x = citric.acid, fill = factor(quality))) +
  facet_wrap(~ï..type) +
  geom_bar() +
  xlab("Residual Sugar") +
  ylab("Total Count") +
  labs(fill = "Quality") +
  ggtitle("Citric Acid Levels compared between Red and White wine")

# Training first random forest using default parameters, to predict quality using 
# only residual sugar, pH and citric acid:

rf.train.1 <- data.combined[1:4524, c("residual.sugar", "pH", "citric.acid")]
rf.label <- as.factor(train$quality)

set.seed(1234)
rf.1 <- randomForest(x = rf.train.1, y = rf.label, importance = TRUE)
rf.1

# Training second random forest model, this time with 1000 trees
set.seed(1212)
rf.2 <- randomForest(x = rf.train.1, y = rf.label, importance = TRUE, ntree = 1000)
rf.2

# Training third random forest model, this time with 1000 trees and 3 variables at each split
rf.train.3 <- data.combined[1:4524, c("fixed.acidity",	"volatile.acidity",	"citric.acid",	"residual.sugar",	"chlorides",	"free.sulfur.dioxide",	
                                      "total.sulfur.dioxide",	"density",	"pH",	"sulphates",	"alcohol")]
set.seed(3221)
rf.3 <- randomForest(x = rf.train.3, y = rf.label, importance = TRUE, ntree = 1000, mtry = 3)
rf.3
varImpPlot(rf.3)

# Training a fourth random forest model with the 5 most important variables from the varImpPlot from rf.3
rf.train.4 <- data.combined[1:4524, c("alcohol", "volatile.acidity", 
                                      "free.sulfur.dioxide", "sulphates", "residual.sugar")]
rf.4 <- randomForest(x = rf.train.4, y = rf.label, importance = TRUE, ntree = 1000, mtry = 3)
rf.4

# Before feature engineering, we establish a methodology for estimating error rate on the test set.
# This is how we avoid overfitting. 

# Subset test records and features
test.submit.df <- data.combined[4525:6463, c("fixed.acidity",	"volatile.acidity",	"citric.acid",	"residual.sugar",	"chlorides",	"free.sulfur.dioxide",	
                                             "total.sulfur.dioxide",	"density",	"pH",	"sulphates",	"alcohol")]
# Make predictions
rf.3.preds <- predict(rf.3, test.submit.df)
table(rf.3.preds) 

# Writing out a .csv file to see predictions in tabular format
preds.df <- data.frame(WineID = rep(4525:6463), Quality = rf.3.preds)

write.csv(preds.df, file = "rf_3_predictions.csv", row.names = FALSE)

# Cross Validation
set.seed(444)
cv.10.folds <- createMultiFolds(rf.label, k = 10, times = 10)

# Check stratification
table(rf.label)

# Checking random fold, the 33rd fold
table(rf.label[cv.10.folds[[33]]])

# Set up caret's trainControl object
ctrl.1 <- trainControl(method = "repeatedcv", number = 10, repeats = 10,
                       index = cv.10.folds)

#Set up doSNOW package for multi-core training
cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)

# Set seed for reproducibility and train
set.seed(32223)
rf.3.cv.1 <- train(x = rf.train.3, y = rf.label, method = "rf", tuneLength = 3,
                   ntree = 1000, trControl = ctrl.1)
rf.3.cv.1
stopCluster(cl)

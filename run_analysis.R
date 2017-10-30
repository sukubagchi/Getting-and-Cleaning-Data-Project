# File URL to download
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# Local data file
dataFileZIP <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"

# Directory
dirFile <- "./UCIHAR"

# Download the dataset (. ZIP), which does not exist
if (file.exists(dataFileZIP) == FALSE) {
  download.file(fileURL, destfile = dataFileZIP)
}

# Uncompress data file
if (file.exists(dirFile) == FALSE) {
  unzip(dataFileZIP)
}

## 1. Merges the training and the test sets to create one data set:
## Load Data
subtest <- read.table("./UCIHAR/test/subject_test.txt")
xtest <- read.table("./UCIHAR/test/X_test.txt")
ytest <- read.table("./UCIHAR/test/Y_test.txt")
subtrain <- read.table("./UCIHAR/train/subject_train.txt")
xtrain <- read.table("./UCIHAR/train/X_train.txt")
ytrain <- read.table("./UCIHAR/train/Y_train.txt")
## Bind Data

x<- rbind(xtest,xtrain)
y <- rbind(ytest, ytrain)
sub <- rbind(subtest, subtrain)



## 2. Extracts only the measurements on the mean and standard deviation for each measurement:
# Read features labels and provides friendly name
features <- read.table("./UCIHAR/features.txt")
names(features) <- c('feat_id', 'feat_name')
# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
# Replaces all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

## 3. Uses descriptive activity names to name the activities in the data set:
activities <- read.table("./UCIHAR/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')

## 4. Appropriately labels the data set with descriptive activity names:
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(sub) <- "Subject"

# Combines data table by columns
tidyDataSet <- cbind(sub, y, x)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject:
xtidy <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(xtidy,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

# Activity and Subject name of columns 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"

tidy_datatxt <- "./UCIHAR/tidy_data.txt"
write.table(tidyDataAVGSet, tidy_datatxt)

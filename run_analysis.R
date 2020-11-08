## First make sure to set your working directory to where you will store your files
setwd("C://Users/ethan/Desktop/coursera/getting_and_cleaning_project")

# I chose to use the dplyr package to help with the commands so make sure to load that as well
library(dplyr)

## we need to assign the data to a value in order to download it.
dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

##download the file to the working directory.

download.file(dataurl, destfile = "C://Users/ethan/Desktop/coursera/getting_and_cleaning_project/data.zip")

## since it is a zip file we need to unzip the file first.

unzip("data.zip")

## Define the path for which the unzip file is to save time

datapath <- file.path("C:/Users/ethan/Desktop/coursera/getting_and_cleaning_project", "UCI HAR Dataset")

## Define the files in the unzipped folderTidyData

files <- list.files(datapath, recursive = TRUE)

## We need to begin creating data frames and assigning their values

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")



# Now the fun part, merging the data!

# Merging the train and test data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

# combining the merged data into one set
Merged_Data <- cbind(Subject, Y, X)

# Extracting only the mean and the std for each measurement
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# Making the descriptive names for the data set.
TidyData$code <- activities[TidyData$code, 2]
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## Now that we have replaced the variable names to be more descriptive, the last thing we need to do is create a second, independent tidy
# data set with the average of each variable for each activity and each subject.

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarize_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
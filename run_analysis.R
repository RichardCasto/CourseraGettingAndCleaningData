# run_analysis.R
#
# Richard Casto
# 2015-10-17

#setwd("D:/Coursera/Data Science Specalization/Getting and Cleaning Data/Programming Assignment 1")

# packages
install.packages("dplyr")
library(dplyr)

################################################################################
# Source (download) the data
################################################################################

# download file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./getdata-projectfiles-UCI HAR Dataset.zip", method="auto", mode = "wb")

# Background: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Data + Codebook: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

################################################################################
# Open the files we need
################################################################################

# Note, we don't use the raw "Inertial Signal" data because ultimately we only 
# need the Mean and Std values which by definition are not in the Inertial 
# Signal data.  See Codebook.md for more information.

# feature labels (we use these labels for column names directly below)
features.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/features.txt"), col.names = c("FeatureID","Name"), stringsAsFactors = FALSE)
activity_labels.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/activity_labels.txt"), col.names = c("Activity","Name"), stringsAsFactors = FALSE)

# test
x_test.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/X_test.txt"), col.names = features.raw$Name)
y_test.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/y_test.txt"), col.names = "Activity")
subject_test.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/subject_test.txt"), col.names = "Subject")

# training
x_train.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/X_train.txt"), col.names = features.raw$Name)
y_train.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/y_train.txt"), col.names = "Activity")
subject_train.raw <- read.table(unz("./getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/subject_train.txt"), col.names = "Subject")

################################################################################
# Merge the data (including test and train)
################################################################################

# column bind to combine subject, activity and data
test <- bind_cols(subject_test.raw, y_test.raw, x_test.raw)
train <- bind_cols(subject_train.raw, y_train.raw, x_train.raw)

# row bind to combine test and train
data.full <- bind_rows(test, train)

# Convert Activity from numeric ID to the label (for output)
data.full <- mutate(data.full, Activity = activity_labels.raw$Name[Activity])

# remove objects we don't need anymore to reduce clutter
rm(x_test.raw, y_test.raw, subject_test.raw, x_train.raw, y_train.raw, subject_train.raw, test, train, activity_labels.raw, features.raw)

################################################################################
# Subset to extract just the Mean and Standard Deviation
################################################################################

# Note, we only extract variables that initially used the -mean(), -std() and 
# X,Y and Z variants. Oother variables include the name "mean" in them, but 
# they (such as -meanFreq()) are calculating a weighted average and not a true 
# mean so we are not including them.  The same applies to the "angle" variables 
# as they use an average within a window and not a full mean, so those are not 
# included either.  See the Codebook.md file for more details.

data.sub <- data.full[, grep("(Subject)|(Activity)|(\\.std\\.)|(\\.mean\\.)", names(data.full))]

################################################################################
# Create readable and easier to understand (descriptive) labels
################################################################################

names(data.sub)<-gsub("^t", "Time", names(data.sub)) # t prefix = ime (time domain)
names(data.sub)<-gsub("^f", "Frequency", names(data.sub)) # f prefix = Frequency (frequency domain)
names(data.sub)<-gsub("Acc", "Accelerometer", names(data.sub)) # Acc = Accelerometer
names(data.sub)<-gsub("Gyro", "Gyroscope", names(data.sub)) # Gyro = Gyroscope
names(data.sub)<-gsub("Mag", "Magnitude", names(data.sub)) # Mag = Magnitude
names(data.sub)<-gsub("BodyBody", "Body", names(data.sub)) # Clean up odd Body name
names(data.sub)<-gsub("\\.mean\\.", "Mean", names(data.sub)) # mean = Mean
names(data.sub)<-gsub("\\.std\\.", "StandardDeviation", names(data.sub)) # Mag = StandardDeviation
names(data.sub)<-gsub("\\.X$", "XAxis", names(data.sub)) # .X suffix = XAxis
names(data.sub)<-gsub("\\.Y$", "YAxis", names(data.sub)) # .Y suffix = YAxis
names(data.sub)<-gsub("\\.Z$", "ZAxis", names(data.sub)) # .Z suffix = ZAxis
names(data.sub)<-gsub("[.]", "", names(data.sub), perl = TRUE) # remove periods

################################################################################
# Create the required tidy dataset.
################################################################################

# Group by (aggreate) Subject and Activity
# Calculate the mean
# Order by Subject and Activity
data.tidy <- aggregate(. ~Subject + Activity, data.sub, mean)
data.tidy <- data.tidy[order(data.tidy$Subject, data.tidy$Activity), ]

################################################################################
# Write out the file
################################################################################

# Note, you can read this via...
# data <- read.table(file_path, header = TRUE)

write.table(data.tidy, file = "TidyData.txt", row.name=FALSE)

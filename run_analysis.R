# loads necessary libraries for data manipulation
library(dplyr)
library(tidyr)

# first, checks that folder to download and unzip to exists
if (!dir.exists("data")) {
    dir.create("data")
}

# downloads file from website and unzips it
filename <- "data.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, filename)

unzip(filename, exdir = "./data")

# imports files by type (test / train, and feature labels)
# imports test files and renames columns for y and sub
x_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/X_test.txt"))
y_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/y_test.txt")) %>% 
    rename(activityno = V1)
sub_test <- tbl_df(read.table("./data/UCI HAR Dataset/test/subject_test.txt")) %>% 
    rename(subject = V1)

# imports train files and renames columns for y and sub
x_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
y_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/y_train.txt")) %>% 
    rename(activityno = V1)
sub_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/subject_train.txt")) %>% 
    rename(subject = V1)

# imports features (column labels for x files), and highlights which labels indicate
# a mean or std deviation, along with matching column labels to the x_test and 
# x_train files
features <- tbl_df(read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE))
features <- mutate(features, include = grepl("mean|std", features$V2), columnlabel = paste0("V", features$V1))

# imports activity labels table and renames columns
activity <- tbl_df(read.table("./data/UCI HAR Dataset/activity_labels.txt"))
names(activity) <- c("activityno", "activity")

# adds a column in x_train and x_test prior to merging to indicate whether
# data came from the train or test samples
x_test <- mutate(x_test, sample = "test")
x_train <- mutate(x_train, sample = "train")

# merges all the datasets into a single combined dataset
# starts by merging together the test / train datasets separately
test <- cbind(sub_test, y_test, x_test)
train <- cbind(sub_train, y_train, x_train)

# merges together the test and train datasets (Step 1)
combined <- rbind(test, train)

# selects columns in x_train and x_test that are relevant (mean / std deviation)
# and removes the rest (Step 2)
combined <- select(combined, c(c("subject", "activityno", "sample"), features$columnlabel[features$include == TRUE]))

# merges activity table with combined table (Step 3), and removes activityno column
combined <- merge(activity, combined, by.x = "activityno", by.y = "activityno")
combined <- select(combined, -activityno)

# renames columns in combined to match variables (Step 4)
names(combined) <- c(c("activity", "subject", "sample"), features$V2[features$include == TRUE])

# combined values (Step 4)
combined <- gather(combined, observationtype, value, -(activity:sample))

# groups values by activity, subject and observation type
combined <- group_by(combined, activity, subject, observationtype)

# summarises results by taking the average of the groups, grouped by activity,
# subject and observation type
results <- combined %>%
    group_by(activity, subject, observationtype) %>%
    summarise(average = mean(value))

# writes out results into a file
write.table(results, "results.txt")
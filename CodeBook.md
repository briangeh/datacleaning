## Introduction
This code book provides a description of the 'results.txt' file

## Layout of the file
The file contains 4 columns:
* activity - this describes what activity the volunteer was doing during the observation. There are 6 different activities, which are:
    * WALKING
    * WALKING_UPSTAIRS
    * WALKING_DOWNSTAIRS
    * SITTING
    * STANDING
    * LAYING
* subject - this tells you which volunteer was being observed, which are numbered between 1 - 30
* observationtype - this column describes the type of observation that was being extracted at the time [1]
* average - this column reports the averaged figures for observations of the same type for the same activity and subject. This is measured in seconds for the time components and in Hertz (Hz) for the frequency components

This file has been put into a 'narrow and long' tidy data format, i.e. we've collapsed the 79 distinct data points per subject / activity combination into a single column

## How the results.txt file was generated
The 'run_analysis.R' script does the following steps
1. Downloads the data file from the website <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and unzips it
2. Imports the datasets from the test / train folders. In particular, each folder contains 3 data files (replace ^ with either test / train):
    * x_^ - this contains the raw data results from the observations
    * y_^ - this contains the activity code indicating which activity was being done when the measurement was done
    * subject_^ - this indicates which volunteer was being measured
3. Imports the following files
    * features - indicates what measurement was being done
    * activity - maps the activity code to the activity
4. (Pre-Filter step) For the features table, indicate which columns to retain (only the ones with the mean or standard deviation)
5. Adds a new column to the x_^ table, to help indicate which dataset it came from (either the test or train ones)
6. Merges the x_^, y_^ and subject_^ tables together for both the train and test datasets, and then merges the train and test datasets to create a combined dataset
7. (Column filtering step) Renames columns appropriately using the labels from the feature table, and then selecting only the pre-selected columns
8. Merges the combined table with the activity table, dropping the activityno column
9. Tidies the data by changing the table from a 'short-wide' format into a 'long-narrow' format by collapsing all the different observations into the 'observationtype' column and the values into the 'value' column
10. Groups the data by the activity and subject columns, and then obtains the means of these columns, which is then saved in the 'results.txt' file

## Data Source
The data was obtained from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. For additional information on the raw data, please refer to the README.txt file in this zip file.

## Additional Notes
[1] The descriptions under observationtype are somewhat difficult to decipher, here's a guide:
* t / f in the first letter indicates a time / frequency measurement
* Body represents the component of the acceleration / angular velocity due to the body
* Gravity represents the component of acceleration due to gravity
* Acc represents linear acceleration as measured by the phone's accelerometer
* Gyro represents the angular velocity as measured by the phone's gyroscope
* Jerk is a signal calculated from the acceleration and angular velocity
* Mag represents the magnitude of the acceleration / angular velocity / jerk as measured by the sensors
* mean() / std() represents the summary method of the measurement used, be it the mean or the standard deviation
* meanFreq() indicates that it is the mean of the frequency that's being meausred
* X / Y / Z as the final letter indicates the axes on which the measurement is being made (i.e. acceleration along the X / Y / Z axes)
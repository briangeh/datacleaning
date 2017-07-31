# Data Cleaning Assignment
Submission for the final assignment in the Getting and Cleaning Data Course
## Files contained in this repository
This repository contains 4 files:
* run_analysis.R - the script that downloads and merges the datasets together, performing transformations before producing the final result
* CodeBook.md - this file explains all the variables, data and transformations that was done to the data leading to the result and provides an overview of the 'results.txt' file
* README.md - this file describes the purpose of every file in this repository
* results.txt - this file contains the results of the script "run_analysis.R"
## How to load the results.txt file
In loading the results.txt file in R, I recommend using the following code:

```
results <- read.table("results.txt", header = TRUE)
View(results)
```
## Acknowledgements
Thanks to David Hood for providing hints on how to present the results of the script

Link: <https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/>
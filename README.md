# Course Project - Getting and Cleaning Data

This repo contains the follwing 3 files:

- README.md
- Codebook.md - the codebook for this project
- run_analysis.R - the R script that does the tidying

#Requirements

run_analysis.R requires the following packages:

- reshape2

Furthermore, run_analysis.R expect the working directory to have the Samsung data sets residing in the "UCI HAR Dataset/" directory.

The output of the script is a tidy data set called tinydata.txt

#Methodology

The script performs the following procedures

- read in the results, subject and activity data sets for the test and training groups
- read in the variable names from features.txt
- assign variables as columnn names on the test and training results
- use cbind() to put together complete data frames for test and training data
- use rbind() to merge the 2 datasets into one
- subset the merged dataset by only keeping columns containing mean or std
- convert activity codes to actual activity names
- use melt() to create narrow dataset keeping Subject and Activity columns
- use dcast() to create wide tidy data, aggregating and finding the mean of each subject-activity-variable occurance
- perform substitutions to make variable names more descriptive
- place tidy data in tinydata.txt


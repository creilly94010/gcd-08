---
title: "Codebook for tidy.txt"
author: "creilly94010"
date: "Monday, October 13, 2014"
output: html_document
---

This this codebook decribes the data produced by run_analysis.r script, part of the Getting and Cleaning Data - Programming Assignment

The raw Data set used to create tidy.txt can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

To understand the structure of the raw data used to produce tidy.txt, you can download the above dataset, unzip the files, and open the readme.txt file in the UCI HAR Dataset directory.


### Tidy.txt Dataset produced by the run_analysis.r script

Tidy.txt contains the variables listed in Appendix A.  There are 66 measturement variables and 2 grouping objects each with 180 objects.

1. Group.1 - is a list of the following "Activity" values measured in the original dataset
 - 1=WALKING
 - 2=WALKING_UPSTAIRS
 - 3=WALKING_DOWNSTAIRS
 - 4=SITTING
 - 5=STANDING
 - 6=LAYING

2. Group.2 - is a list of 30 different subjects [1:30] for which Group.1 activies were measured in the original dataset.

Tidy.txt variables listed in Appendix A have 180 readings, providing the average (mean reading) across all samples taken for each subject, grouped by Activity.

### Transformations
The original dataset (UCI HAR Dataset), included 561 measurements variables (columns).  See features.txt in the original data source file for the complete listing.  Each variable included 10299 observations normalized in the range of -1 to 1.  From this original dataset, only the mean() and std() measurements were subsetted, resulting in 66 measurements (10299 x 66) objects.  For these 66 objects, the mean() was derived and used to create the final dataset.  These were then grouped by Activity and Subject which was used to create tidy.txt. (180 obs of 68 variables.)


### Appendix A - List of Objects in Tidy.txt
Group.1

Group.2

tBodyAcc-mean()-X

tBodyAcc-mean()-Y

tBodyAcc-mean()-Z

tBodyAcc-std()-X

tBodyAcc-std()-Y

tBodyAcc-std()-Z

tGravityAcc-mean()-X

tGravityAcc-mean()-Y

tGravityAcc-mean()-Z

tGravityAcc-std()-X

tGravityAcc-std()-Y

tGravityAcc-std()-Z

tBodyAccJerk-mean()-X

tBodyAccJerk-mean()-Y

tBodyAccJerk-mean()-Z

tBodyAccJerk-std()-X

tBodyAccJerk-std()-Y

tBodyAccJerk-std()-Z

tBodyGyro-mean()-X

tBodyGyro-mean()-Y

tBodyGyro-mean()-Z

tBodyGyro-std()-X

tBodyGyro-std()-Y

tBodyGyro-std()-Z
tBodyGyroJerk-mean()-X

tBodyGyroJerk-mean()-Y

tBodyGyroJerk-mean()-Z

tBodyGyroJerk-std()-X

tBodyGyroJerk-std()-Y

tBodyGyroJerk-std()-Z

tBodyAccMag-mean()

tBodyAccMag-std()

tGravityAccMag-mean()

tGravityAccMag-std()

tBodyAccJerkMag-mean()

tBodyAccJerkMag-std()

tBodyGyroMag-mean()

tBodyGyroMag-std()

tBodyGyroJerkMag-mean()

tBodyGyroJerkMag-std()

fBodyAcc-mean()-X

fBodyAcc-mean()-Y

fBodyAcc-mean()-Z

fBodyAcc-std()-X

fBodyAcc-std()-Y

fBodyAcc-std()-Z

fBodyAccJerk-mean()-X

fBodyAccJerk-mean()-Y

fBodyAccJerk-mean()-Z

fBodyAccJerk-std()-X

fBodyAccJerk-std()-Y

fBodyAccJerk-std()-Z

fBodyGyro-mean()-X

fBodyGyro-mean()-Y

fBodyGyro-mean()-Z

fBodyGyro-std()-X

fBodyGyro-std()-Y

fBodyGyro-std()-Z

fBodyAccMag-mean()

fBodyAccMag-std()

fBodyBodyAccJerkMag-mean()

fBodyBodyAccJerkMag-std()

fBodyBodyGyroMag-mean()

fBodyBodyGyroMag-std()

fBodyBodyGyroJerkMag-mean()

fBodyBodyGyroJerkMag-std()
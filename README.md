---
title: "README.md for run_Analysis.r"
author: "creilly94010"
date: "Monday, October 13, 2014"
output: html_document
---

This this codebook decribes the script, "run_analysis.r", part of the Getting and Cleaning Data - Programming Assignment

The raw Data set for this assignment can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

**Note**: this script requires the dplyr package to run, be sure to install dplyr before executing. If you are having a problem installing dplyr on RStudio, you can see a workaround that I have posted [here](https://class.coursera.org/getdata-008/forum/thread?thread_id=47#post-279)

### run_analysis.R does the following:
 1. Downloads the raw data files and initialize enviroment varialbles
 2. Merges the training and the test sets to create one data set
 3. Extracts only the measurements on the mean and standard deviation for each measurement
 4. Uses descriptive activity names to name the activities in the data set
 5. Appropriately labels the data set with descriptive variable names
 6. From the data set in step 5, creates a second, independent tidy data set with the average of each variable for each activity and each subject

### 1-Downloads the raw data files and initialize enviroment varialbles
First we set the working directory and install required package (dplyr).  Next we initinalize the varialbes for URL, Destination directory where we want to download the data to in our current working directory, then set file name and extension variables for use later.


```
setwd("C:/git.creilly94010/GCDCP1")
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destdir <- "data"
myfilename <- "data"
fileExtType <- "zip"
```

Next, we want to ensure that our current working Directory has the direcctory which we want to download our data to, if not we create it.

```
chkdir <- destdir
if (!file.exists(chkdir)){
        dir.create(chkdir)
        writeLines(paste("Directory missing. Creating Directory> ", chkdir))
}
```
After handling directory conditions, we download the data if it does not already exist in our target directory, or skip download if it's already been downloaded.

```
destfilename <- paste("./", destdir,"/", myfilename, ".", fileExtType, sep="")
if (!file.exists(destfilename)){
        download.file(fileUrl, destfile=destfilename)
        list.files (destdir)
        datedownloaded <- date()
        unzip(destfilename, overwrite = TRUE,junkpaths = FALSE, exdir = destdir, unzip = "internal", setTimes = FALSE)
        }else{
        writeLines("File Exists. Download Skipped")
}
```

Lastly for this we initialize some directory variables to use later. 
```
dl <- list.files(path = destdir, full.names = T, recursive = T, include.dirs=T)
topdir <- dl[2]
testdir <- dl[7]
traindir <- dl[21]
```

### 2-Merge Training and Test Sets into one dataset
Before reading the raw data files, first initialize X,y, subject, activity, and feature variables for import of the data

- x data files
```
xtestfile <- "X_test.txt"
xtrainfile <- "X_train.txt"
testdatapath <- paste(testdir,"/",xtestfile, sep="")
traindatapath <- paste(traindir,"/",xtrainfile, sep="")
```
 - y label files
```
ytestlabelfile <- "y_test.txt"
ytrainlabelfile <- "y_train.txt"
testlabelpath <- paste(testdir,"/",ytestlabelfile, sep="")
trainlabelpath <- paste(traindir,"/",ytrainlabelfile, sep="")
```
- subject label files
```
sbjtestfile <- "subject_test.txt"
sbjtrainfile <- "subject_train.txt"
sbjtestdatapath <- paste(testdir,"/",sbjtestfile, sep="")
sbjtraindatapath <- paste(traindir,"/",sbjtrainfile, sep="")
```
- activity and feature files
```
activitylabelfile <- "activity_labels.txt"
activitydatapath <- paste(topdir, "/", activitylabelfile, sep="")
featureslabelfile <- "features.txt"
featuresdatapath <- paste(topdir, "/", featureslabelfile, sep="")
```

Next, read the files, defined as a dplyr table dataframe, assigning each to a unique object

```
xtestdt <- tbl_df(read.csv(testdatapath, sep="", header=F))
xtraindt <- tbl_df(read.csv(traindatapath, sep="",header=F))
ytestlabels <- tbl_df(read.csv(testlabelpath, sep="", header=F)) 
ytrainlabels <- tbl_df(read.csv(trainlabelpath, sep="", header=F))
stestlabels <- tbl_df(read.csv(sbjtestdatapath, sep="", header=F))
strainlabels <- tbl_df(read.csv(sbjtraindatapath, sep="", header=F))
activitydt <- tbl_df(read.csv(activitydatapath, sep="",header=F))
featuresdt <- tbl_df(read.csv(featuresdatapath, sep="",header=F))
```

Next append the y and subject values to our test and training objects.

```
xtestdt["y"] <- ytestlabels
xtestdt["s"] <- stestlabels
xtraindt["y"] <- ytrainlabels
xtraindt["s"] <- strainlabels
```
Lastly, create a single complete dataset by combining test and train data into one table
```
alldt = rbind(xtraindt, xtestdt)
```

### 3-Extract mean and standard deviation for each measurement

We need to get the mean and std calculations (subset of rows that have mean() or std() values) from our full set of features.  Dplyr does not like NULL values for colnames so we set those first.  Also we need to remove the meanFreq() rows that are pick up from grepl command, as this is not desired. Lastly, we extract the first column that has the row numbers we want, and add the row numbers 562 and 563 which are our Activity and Subject columns.

```
colnames(featuresdt) <- c("m", "desc")
fms <- filter(featuresdt, grepl("mean()|std()",desc))
fms2 <- filter(fms, !grepl("meanFreq()",desc))
fms2 <- droplevels(fms2)
fms3 <- select(fms2, m)
colsToGet <- c(fms3, 562,563)
```

Now all we need to do is remove the unwanted columns from our complete dataset (alldt) and assign it to a new dataframe.

```
colnames(alldt) <- c(1:563)
alldt <- droplevels(alldt)
alldtfinal <- select(alldt, colsToGet)
alldtfinal <- as.data.frame(alldtfinal, copy=T)
alldtfinal <- droplevels(alldtfinal)
```

### 4-Add descriptive colnames to final dataset
At this point, our final data set has only numbers for column names.  Descriptive columnames need to be added for each measurement.  Using dplyr prior to this requires us convert the data tables to regular data frames and to drop factors for easier manipulation of the column names.

```
x <- as.data.frame(fms2[,2], copy=T)
x <- data.frame(lapply(x, as.character), stringsAsFactors=FALSE)
x <- c(x, "Activity", "Subject")
x <- unlist(x)
names(x) <- NULL
colnames(alldtfinal) <- x
````

### 5-Create tidy dataset 
Now that we have a good subset of data with just the right activities, we create tidy data set taking mean of each variable and grouping by Activity and Subject and write the tidy dataset as a file.  Our output will have groupings appended to the dataset, so we remove the Activity and Subject columns which are no longer needed.

```
tidy <- aggregate(alldtfinal, by=list(alldtfinal$Activity, alldtfinal$Subject),
                  FUN="mean")
tidy <- select(tidy, -Activity, -Subject)
write.table(tidy, "tidy.txt", sep=",")
```

Lastly, we additionally write out a file of our subset of feature names for cut and paste in our Codebook file

```
l <- as.character(names(tidy))
write.table(l, "mycolnames.txt", eol="\n", row.names=F, col.names=F, quote=F )
```
Be sure to take a look at the Codebook.md file in the git repository for descriptions of each variable in the tidy.txt data set.
## Getting and Cleaning Data - Programming Assignment
## Created by creilly94010

## Data set: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## this script requires the dplyr package to run, be sure to install dplyr
## before executing. 

## run_analysis.R does the following. 
## 1) Merges the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 
## 3) Uses descriptive activity names to name the activities in the data set
## 4) Appropriately label the data set with descriptive variable names. 
## 5) From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

######### i) DOWNLOADING FILES#########
setwd("C:/git.creilly94010/GCDCP1")
library(dplyr)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destdir <- "data"
myfilename <- "data"
fileExtType <- "zip"

#############Directory test#########
## check to see if a directory exists, relative to current working director,
## if not, create it
chkdir <- destdir
if (!file.exists(chkdir)){
        dir.create(chkdir)
        writeLines(paste("Directory missing. Creating Directory> ", chkdir))
}

#############Download File#########
##  Download files from the internet
destfilename <- paste("./", destdir,"/", myfilename, ".", fileExtType, sep="")
if (!file.exists(destfilename)){
        download.file(fileUrl, destfile=destfilename)
        list.files (destdir)
        datedownloaded <- date()
        unzip(destfilename, overwrite = TRUE,junkpaths = FALSE, exdir = destdir, unzip = "internal", setTimes = FALSE)
        }else{
        writeLines("File Exists. Download Skipped")
}
## need to add a date check on the above file check code

######### ii) CREATE LIST OF ALL DOWNLOADED FILES FOR PROCESSING#########
dl <- list.files(path = destdir, full.names = T, recursive = T, include.dirs=T)
topdir <- dl[2]
testdir <- dl[7]
traindir <- dl[21]

########### 1) Merge Training and Test Sets into one dataset#############
## set up variables for import
## x data files
xtestfile <- "X_test.txt"
xtrainfile <- "X_train.txt"
testdatapath <- paste(testdir,"/",xtestfile, sep="")
traindatapath <- paste(traindir,"/",xtrainfile, sep="")
## y lable files
ytestlabelfile <- "y_test.txt"
ytrainlabelfile <- "y_train.txt"
testlabelpath <- paste(testdir,"/",ytestlabelfile, sep="")
trainlabelpath <- paste(traindir,"/",ytrainlabelfile, sep="")
## subject label files
sbjtestfile <- "subject_test.txt"
sbjtrainfile <- "subject_train.txt"
sbjtestdatapath <- paste(testdir,"/",sbjtestfile, sep="")
sbjtraindatapath <- paste(traindir,"/",sbjtrainfile, sep="")
## activity and feature files
activitylabelfile <- "activity_labels.txt"
activitydatapath <- paste(topdir, "/", activitylabelfile, sep="")
featureslabelfile <- "features.txt"
featuresdatapath <- paste(topdir, "/", featureslabelfile, sep="")


## read geospacial data and features
xtestdt <- tbl_df(read.csv(testdatapath, sep="", header=F))
xtraindt <- tbl_df(read.csv(traindatapath, sep="",header=F))
ytestlabels <- tbl_df(read.csv(testlabelpath, sep="", header=F)) 
ytrainlabels <- tbl_df(read.csv(trainlabelpath, sep="", header=F))
stestlabels <- tbl_df(read.csv(sbjtestdatapath, sep="", header=F))
strainlabels <- tbl_df(read.csv(sbjtraindatapath, sep="", header=F))
activitydt <- tbl_df(read.csv(activitydatapath, sep="",header=F))
featuresdt <- tbl_df(read.csv(featuresdatapath, sep="",header=F))

## Add the y_test.txt and subject_test.txt values to testdt and traindt
xtestdt["y"] <- ytestlabels
xtestdt["s"] <- stestlabels
xtraindt["y"] <- ytrainlabels
xtraindt["s"] <- strainlabels

## combine test and train data into one table
alldt = rbind(xtraindt, xtestdt)

######## 2) Extract mean and standard deviation for each measurement. #########

## Get mean and std rows only from features list
colnames(featuresdt) <- c("m", "desc")
fms <- filter(featuresdt, grepl("mean()|std()",desc))
fms2 <- filter(fms, !grepl("meanFreq()",desc))
fms2 <- droplevels(fms2)
fms3 <- select(fms2, m)
colsToGet <- c(fms3, 562,563)

## Remove the unwanted columns from alldt and create new df 
colnames(alldt) <- c(1:563)
alldt <- droplevels(alldt)
alldtfinal <- select(alldt, colsToGet)
alldtfinal <- as.data.frame(alldtfinal, copy=T)
alldtfinal <- droplevels(alldtfinal)

################ 3) & 4)Add descriptive colnames to final dataset########
## set df column names to be descriptive
x <- as.data.frame(fms2[,2], copy=T)
x <- data.frame(lapply(x, as.character), stringsAsFactors=FALSE)
x <- c(x, "Activity", "Subject")
x <- unlist(x)
names(x) <- NULL
colnames(alldtfinal) <- x


######### 5) Create tidy dataset ############
## create tidy data set taking mean of each variable and grouping
## by Activity and Subject
tidy <- aggregate(alldtfinal, by=list(alldtfinal$Activity, alldtfinal$Subject),
                  FUN="mean")
tidy <- select(tidy, -Activity, -Subject)

## ouput the tidy dataset as a file
write.table(tidy, "tidy.txt", sep=",")

######### Misc - write out some additional data to help make codebook###########
l <- as.character(names(tidy))
write.table(l, "mycolnames.txt", eol="\n", row.names=F, col.names=F, quote=F )
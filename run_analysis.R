#downloads and unzips file if not already present
if(!file.exists("./data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles
                  %2FUCI%20HAR%20Dataset.zip", destfile = "./data.zip")
}
if(!file.exists("./UCI HAR Dataset")){
    unzip("./data.zip")
}

#merges data sets to create one dataset
xTrainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
xTestData <- read.table("./UCI HAR Dataset/test/X_test.txt")
xMergedData <- rbind(xTrainData, xTestData)

yTrainData <- read.table("./UCI HAR Dataset/train/y_train.txt")
yTestData <- read.table("./UCI HAR Dataset/test/y_test.txt")
yMergedData <- rbind(yTrainData, yTestData)

subTrainData <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subTestData <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subMergedData <- rbind(subTrainData, subTestData)

#mean and standard deviation extractions for each measurement
features <- read.table("./UCI HAR Dataset/features.txt")
extractions <- grep("mean\\(\\)|std\\(\\)", features[, 2])
xExtractions <- xMergedData[, extractions]

#names activites in data set
names(xExtractions) <-  gsub("\\(|\\)", "", tolower(features[extractions, 2]))
names(xExtractions) <- gsub("tbody", "timebody", names(xExtractions))
names(xExtractions) <- gsub("fbody", "frequencybody", names(xExtractions))
names(xExtractions) <- gsub("tgrav", "timegrav", names(xExtractions))
names(xExtractions) <- gsub("fgrav", "frequencygrav", names(xExtractions))

act <- read.table("./UCI HAR Dataset/activity_labels.txt")
act[, 2] <- gsub("_", "", tolower(as.character(act[, 2])))


yMergedData[, 1] <- act[yMergedData[, 1], 2]
colnames(yMergedData) <- "activity"
colnames(subMergedData) <- "subject"

#labels data set variables
dataSet <- cbind(subMergedData, xExtractions, yMergedData)
names(dataSet)

#creation of tidy data set with averages of each variable
avg <- aggregate(dataSet, list(activities = dataSet$activity, subjects = 
        dataSet$subject), mean)
avg <- avg[, !(colnames(avg) %in% c("subject, activity"))]
str(avg)
write.table(avg, "tidyData.txt", row.names = FALSE)
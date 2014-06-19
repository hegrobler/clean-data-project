##
# 1. Set up all the paths
#    I work in [Documents]\R or [home]\R
## 
dir <- "clean-data-project"

if (!grepl(dir, getwd())) {
  path <- paste(getwd(),"/R/", dir, sep="")
}

#Master data
labelsFile <- paste(path,"/UCI HAR Dataset/activity_labels.txt", sep="")
featuresFile <- paste(path,"/UCI HAR Dataset/features.txt", sep="")

#Test / Training data
trainDataFile <- paste(path,"/UCI HAR Dataset/train/X_train.txt", sep="")
trainSubjectFile <- paste(path, "/UCI HAR Dataset/train/subject_train.txt", sep="")
trainLabelFile <- paste(path, "/UCI HAR Dataset/train/y_train.txt", sep="") 

testDataFile <- paste(path,"/UCI HAR Dataset/test/X_test.txt", sep="")
testSubjectFile <- paste(path, "/UCI HAR Dataset/test/subject_test.txt", sep="")
testLabelFile <- paste(path, "/UCI HAR Dataset/test/y_test.txt", sep="") 

#2. Download the data into folder clean-data-project
#temp <- tempfile()
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
#unzip(temp, exdir=path)
#unlink(temp)

#Declare the helper functions
checkFileExists <- function (file, description) {
  print(paste("Checking if file exists: ",file))
  
  if (!file.exists(file)) {
    stop(paste(description, "file does not exist. Path: ", file))
  }
}

##
# 2. Load all data
#
##

#Load activity labels
activities <- read.csv(labelsFile, header=FALSE, sep=" ")
names(activities) <- c("ActivityId", "ActivityName")

#Load features
features <- read.csv(featuresFile, header=FALSE, sep=" ")
names(features) <- c("FeatureId", "FeatureName")

loadDataset <- function(subjectFile, labelFile, dataFile) {
  
  #Do validation
  checkFileExists(subjectFile, "Subject")
  checkFileExists(labelFile, "Labels")
  checkFileExists(dataFile, "Dataset")

  #Load subject data
  subject <- read.csv(subjectFile, header=FALSE, sep=" ", col.names=c("subjectId"))
  
  #Load ActivityLables data
  activityLabels <- read.csv(labelFile, header=FALSE, sep=" ", col.names=c("activityLabelId"))
  
  #load data
  dataset <- read.csv(dataFile, header=FALSE, sep="", col.names=features$FeatureName)
  
  if (nrow(activityLabels) != nrow(dataset) || nrow(dataset) != nrow(subject)) {
    print("The amount of rows in the dataset, subject and activity label files are not equal")
    print(paste("Dataset:", nrow(dataset),"Subject:",nrow(subject), "Activity Labels:", nrow(activityLabels)))
    stop()
  }
  
  dataset$subjectId <- subject$subjectId
  dataset$activityLabelId <- activityLabels$activityLabelId
  
  return(dataset)
}

train <- loadDataset(trainSubjectFile, trainLabelFile, trainDataFile)
test <- loadDataset(testSubjectFile, testLabelFile, testDataFile)

if (ncol(train) != ncol(test)) {
  stop('The datasets do not have the same number of columns and can therefore not be combined')
}

if (!identical(train, test)) {
  stop('The column names or column order of the datasets do not match and can therefore not be combined')
}

fullDataset <- rbind(train, test)

getColumnsContaining <- function(x, patterns) {
  
  columnIndexes <- c();
  
  for(i in 1:length(patterns)){
    indexes <- grep(patterns[i], names(x), fixed = TRUE)
    columnIndexes <- c(columnIndexes, indexes)
  }
  
  columnIndexes <- sort(columnIndexes)
  
  x[columnIndexes]
  
} 

ds <- getColumnsContaining(fullDataset, c("mean...", "std...", "subjectId", "activityLabelId"))

#Add the ActivityName factor
ds$ActivityName <- activities$ActivityName[match(ds$activityLabelId, activities$ActivityId)]

colMeans(ds[1:48],)
res <- aggregate(. ~ ActivityName + subjectId, data=ds, FUN=mean)

str(re)


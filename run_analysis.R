##################################################################################
# 1. Set up all the paths
##################################################################################
#Where is the script
path = getwd()
if (grep("clean-data-project", getwd()) == FALSE) {
  path <- paste(getwd(), "clean-data-project", sep="/")  
}

message(paste("Path:",path))

if (!file.exists(path)) {
  stop("Could not find the specified folder. Please upadte the path above")
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

##################################################################################
#2. Download the data into folder clean-data-project
##################################################################################
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp, exdir=path)
unlink(temp)

##################################################################################
#3. Declare checkFileExists function
##################################################################################
checkFileExists <- function (file, description) {
  
  if (!file.exists(file)) {
    stop(paste(description, "file does not exist. Path: ", file))
  }
}

##################################################################################
#4. Declare loadDataset function
##################################################################################
loadDataset <- function(subjectFile, labelFile, dataFile) {
  #Check that the files exist
  checkFileExists(subjectFile, "Subject")
  checkFileExists(labelFile, "Labels")
  checkFileExists(dataFile, "Dataset")
  
  #Load subject data
  subject <- read.csv(subjectFile, header=FALSE, sep=" ", col.names=c("subjectId"))
  
  #Load activityLables data
  activityLabels <- read.csv(labelFile, header=FALSE, sep=" ", col.names=c("activityLabelId"))
  
  #load data
  dataset <- read.csv(dataFile, header=FALSE, sep="", col.names=features$featureName)
  
  #Ensure that the lines from the three files correspond to ensure that there is no missing data
  if (nrow(activityLabels) != nrow(dataset) || nrow(dataset) != nrow(subject)) {
    print("The amount of rows in the dataset, subject and activity label files are not equal")
    print(paste("Dataset:", nrow(dataset),"Subject:",nrow(subject), "Activity Labels:", nrow(activityLabels)))
    stop()
  }
  
  #Add a subjectId column to the dataset based on the subject file
  dataset$subjectId <- subject$subjectId
  
  #Add a activityLabelId column to the dataset based on the activityLables file
  dataset$activityLabelId <- activityLabels$activityLabelId
  
  return(dataset)
}

##################################################################################
#5. Declare the getColumnsContaining function
##################################################################################
getColumnsContaining <- function(x, patterns) {
  
  columnIndexes <- c();
  
  for(i in 1:length(patterns)){
    #Extract the column indexes of the columns that must be included
    indexes <- grep(patterns[i], names(x), fixed = TRUE)
    columnIndexes <- c(columnIndexes, indexes)
  }
  
  #Sort the columns by index so that they are in the same order as before
  columnIndexes <- sort(columnIndexes)
  
  x[columnIndexes]
}

##################################################################################
#6. Load activity labels
##################################################################################
activities <- read.csv(labelsFile, header=FALSE, sep=" ")
names(activities) <- c("activityId", "activityName")

##################################################################################
#7. Load features and remove all non-alphanumeric characters from the names
##################################################################################
features <- read.csv(featuresFile, header=FALSE, sep=" ")
names(features) <- c("featureId", "featureName")
features$featureName <- gsub("[^[:alnum:] ]", "", features$featureName)
features$featureName <- make.names(features$featureName, unique=TRUE)

##################################################################################
#8. Load the training and test data set and validate that the columns correspond 
##################################################################################
train <- loadDataset(trainSubjectFile, trainLabelFile, trainDataFile)
test <- loadDataset(testSubjectFile, testLabelFile, testDataFile)

if (ncol(train) != ncol(test)) {
  stop('The datasets do not have the same number of columns and can therefore not be combined')
}

if (!identical(names(train), names(test))) {
  stop('The column names or column order of the datasets do not match and can therefore not be combined')
}

##################################################################################
#9. Combine the two datasets and remove columns not containing mean or std
##################################################################################
fullDataset <- rbind(train, test)
ds <- getColumnsContaining(fullDataset, c("mean", "Mean", "std", "Std", "subjectId", "activityLabelId"))

##################################################################################
#10. Add the activityName factor and remove the acrivityLabelId
##################################################################################
ds$activityName <- activities$activityName[match(ds$activityLabelId, activities$activityId)]
ds <- ds[,!(names(ds) %in% "activityLabelId")]

##################################################################################
#11. Write the first dataset
##################################################################################
write.csv(ds, paste(path, "full_dataset.txt", sep="/"), row.names = FALSE, quote=FALSE)

##################################################################################
#12. Summarise the dataset
##################################################################################
result <- aggregate(. ~ subjectId + activityName, data=ds, FUN=mean)

##################################################################################
#13. Write the second dataset
##################################################################################
write.csv(result, paste(path, "avg_by_subject_dataset.txt", sep="/"), row.names = FALSE, quote=FALSE)

Coursera Cleaning Data Project
========================================================

This file documents the **run_analysis.R** script. It describes each of the steps completed in the **run_analysis.R** script in detail.

The following summarizes the environment that the tests were run in. Please ensure that all the packages listed are loaded before running the script to ensure that the script will run without error:

```r
sessionInfo()
```

```
## R version 3.1.0 (2014-04-10)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.6
## 
## loaded via a namespace (and not attached):
## [1] evaluate_0.5.5 formatR_0.10   stringr_0.6.2  tools_3.1.0
```

```r
Sys.time()
```

```
## [1] "2014-06-21 01:21:09 SAST"
```


Step 1: Configure directory and file paths 
--------------------------------
The first line indicates the directory where **run_analysis.R** is located.
**Please adjust this value to suit the environment that it is run on**


```r
#path <- paste(getwd(), "clean-data-project", sep="/")
path <- "C:/Users/Lambert/Documents/R/week3/clean-data-project"

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
```

Step 2: Download the data into folder clean-data-project
--------------------------------
This step may take some time to complete. In order to run the script more than once you should:
* Manually download the (zip file)[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]
* Extract the contents to **UCI HAR Dataset** folder. NOTE: This folder must be in the same location as the **run_analysis.R** file
* Comment out the following 4 lines by placing a # in front of each line 

```
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp, exdir=path)
unlink(temp)
```

Step 3: Declare checkFileExists function
--------------------------------
This function is used to determine is a specific file exists. If it does not then it will print a message and stop the script execution

**Parameters:**
* **file**: Path to the file
* **file**: Description of the file. This is used to make the error message more helpful


```r
checkFileExists <- function (file, description) {
    
  if (!file.exists(file)) {
    stop(paste(description, "file does not exist. Path: ", file))
  }
}
```

Step 4: Declare loadDataset function
--------------------------------
This function loads a data set from the different files and merges the data together into one dataset. It can be reused to load the training set as well as the test set

**Parameters:**
* **subjectFile**: The subjects file eg. subject_test.txt
* **labelFile**: The activity labels file eg. y_test.txt
* **dataFile**: The main data file eg. X_test.txt

See **run_analysis.md** for more information on these files and the their contents


```r
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
```

Step 5: Declare getColumnsContaining function
--------------------------------
This function is used to extract specific columns from a data frame based on a naming pattern.

**Parameters:**
* **x**: Data frame to filter
* **patterns**: A character vector containing the naming patterns of columns to extract. Matching consist of a simple contains. Eg pattern "mean" will extract all columns that have mean anywhere in the column name. 


```r
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
```
Step 6: Load activity labels
--------------------------------
The activity labels are loaded from the specified file and appropriate column names assigned


```r
activities <- read.csv(labelsFile, header=FALSE, sep=" ")
names(activities) <- c("activityId", "activityName")
```
This is some sample content from the file

```
##   activityId       activityName
## 1          1            WALKING
## 2          2   WALKING_UPSTAIRS
## 3          3 WALKING_DOWNSTAIRS
## 4          4            SITTING
## 5          5           STANDING
## 6          6             LAYING
```

Step 7: Load features and remove all non-alphanumeric characters from the names
--------------------------------

As indicated in the CodeBook.md file, there are some characters that are not allowed in column names. These characters include (), and -. R normally replace these characters automatically with full stops. Eg tBodyAcc-mean()-X becomes tBodyAcc.mean...X. These characters were removed in order to ensure consistency and compatibility with other programming languages. For example tBodyAcc-mean()-X is changed to become tBodyAccmeanX. Keeping the name consistent with the original feature name ensures that studies are comparable irrespective of the original dataset being used or the output of this exercise.



```r
features <- read.csv(featuresFile, header=FALSE, sep=" ")
names(features) <- c("featureId", "featureName")
```

This is some sample content bedore the names are cleansed

```
##   featureId       featureName
## 1         1 tBodyAcc-mean()-X
## 2         2 tBodyAcc-mean()-Y
## 3         3 tBodyAcc-mean()-Z
## 4         4  tBodyAcc-std()-X
## 5         5  tBodyAcc-std()-Y
## 6         6  tBodyAcc-std()-Z
```

Remove all characters that are not numbers or letters

```r
features$featureName <- gsub("[^[:alnum:] ]", "", features$featureName)
features$featureName <- make.names(features$featureName, unique=TRUE)
```
This is some sample content after the names have been cleansed

```
##   featureId   featureName
## 1         1 tBodyAccmeanX
## 2         2 tBodyAccmeanY
## 3         3 tBodyAccmeanZ
## 4         4  tBodyAccstdX
## 5         5  tBodyAccstdY
## 6         6  tBodyAccstdZ
```

Step 8: Load the training and test data set and validate that the columns correspond 
--------------------------------

```r
train <- loadDataset(trainSubjectFile, trainLabelFile, trainDataFile)
test <- loadDataset(testSubjectFile, testLabelFile, testDataFile)

if (ncol(train) != ncol(test)) {
  stop('The datasets do not have the same number of columns and can therefore not be combined')
}

if (!identical(names(train), names(test))) {
  stop('The column names or column order of the datasets do not match and can therefore not be combined')
}
```
The following shows a sample of what the datasets look like. Note that only some of the colums were included.

```r
head(train[c(1:6, 562,563)])
```

```
##   tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ tBodyAccstdX tBodyAccstdY
## 1        0.2886      -0.02029       -0.1329      -0.9953      -0.9831
## 2        0.2784      -0.01641       -0.1235      -0.9982      -0.9753
## 3        0.2797      -0.01947       -0.1135      -0.9954      -0.9672
## 4        0.2792      -0.02620       -0.1233      -0.9961      -0.9834
## 5        0.2766      -0.01657       -0.1154      -0.9981      -0.9808
## 6        0.2772      -0.01010       -0.1051      -0.9973      -0.9905
##   tBodyAccstdZ subjectId activityLabelId
## 1      -0.9135         1               5
## 2      -0.9603         1               5
## 3      -0.9789         1               5
## 4      -0.9907         1               5
## 5      -0.9905         1               5
## 6      -0.9954         1               5
```

We can also see that the training set has 7352 observations and 563 variables where the test set has 2947 and 563 respectively.

```r
dim(train)
```

```
## [1] 7352  563
```

```r
dim(test)
```

```
## [1] 2947  563
```

Step 9: Combine the two datasets and remove columns not containing mean or std
--------------------------------


```r
fullDataset <- rbind(train, test)
ds <- getColumnsContaining(fullDataset, c("mean", "Mean", "std", "Std", "subjectId", "activityLabelId"))
```

Step 10: Add the activityName factor and remove the activityLabelId
--------------------------------


```r
ds$activityName <- activities$activityName[match(ds$activityLabelId, activities$activityId)]
ds <- ds[,!(names(ds) %in% "activityLabelId")]
```

The following shows a sample of what the dataset look like. Note that only some of the colums were included.

```r
head(ds[c(1:6, 87,88)])
```

```
##   tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ tBodyAccstdX tBodyAccstdY
## 1        0.2886      -0.02029       -0.1329      -0.9953      -0.9831
## 2        0.2784      -0.01641       -0.1235      -0.9982      -0.9753
## 3        0.2797      -0.01947       -0.1135      -0.9954      -0.9672
## 4        0.2792      -0.02620       -0.1233      -0.9961      -0.9834
## 5        0.2766      -0.01657       -0.1154      -0.9981      -0.9808
## 6        0.2772      -0.01010       -0.1051      -0.9973      -0.9905
##   tBodyAccstdZ subjectId activityName
## 1      -0.9135         1     STANDING
## 2      -0.9603         1     STANDING
## 3      -0.9789         1     STANDING
## 4      -0.9907         1     STANDING
## 5      -0.9905         1     STANDING
## 6      -0.9954         1     STANDING
```

We can also see that the training set has 10299 observations and 88 variables.

```r
dim(ds)
```

```
## [1] 10299    88
```

Step 11: Write the first dataset
--------------------------------


```r
write.csv(ds, paste(path, "full_dataset.txt", sep="/"), row.names = FALSE, quote=FALSE)
```

Step 12: Summarise the dataset
--------------------------------
The summary dataset includes the mean of all the variables (columns) broken down by subjectId and activityName.


```r
result <- aggregate(. ~ subjectId + activityName, data=ds, FUN=mean)
```

The following shows a sample of what the summary dataset look like. Note that only some of the colums were included.

```r
head(result[c(1:6, 87,88)])
```

```
##   subjectId activityName tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ
## 1         1       LAYING        0.2216      -0.04051       -0.1132
## 2         2       LAYING        0.2814      -0.01816       -0.1072
## 3         3       LAYING        0.2755      -0.01896       -0.1013
## 4         4       LAYING        0.2636      -0.01500       -0.1107
## 5         5       LAYING        0.2783      -0.01830       -0.1079
## 6         6       LAYING        0.2487      -0.01025       -0.1331
##   tBodyAccstdX angleYgravityMean angleZgravityMean
## 1      -0.9281           -0.5203           -0.3524
## 2      -0.9741           -0.5197           -0.4789
## 3      -0.9828           -0.6301           -0.3462
## 4      -0.9542           -0.7632           -0.2298
## 5      -0.9659           -0.8253           -0.1681
## 6      -0.9340           -0.8746           -0.1066
```

We can also see that the training set has 180 observations and 88 variables.

```r
dim(result)
```

```
## [1] 180  88
```

Step 13: Write the second dataset
--------------------------------


```r
write.csv(result, paste(path, "avg_by_subject_dataset.txt", sep="/"), row.names = FALSE, quote=FALSE)
```

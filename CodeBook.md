#Overview
The following document provides and overview of the data analysis completed as part of the Coursera Getting and Cleaning Data course. It describes the data used in the analysis, the steps completed to explore and prepare the data so that it is ready for analysis.

The references section at the end of the document contains a list of resources that an be used to get more information about topics discussed in this document.

##Exercise
The exercise calls for the following tasks to be completed:

1. Retrieve the sample data
1. Merge the training and the test sets found in the sample data into one data set
1. Extract only the measurements that contain the mean and standard deviation for each measurement
1. Add descriptive activity names to each measurement
1. Rename variables (columns) in the dataset to be descriptive
1. Apply any other necessary transformations on the data to make it ready for analysis 
1. Save above dataset to a file
1. Create a second, independent tidy data set with the average of each variable for each activity and each subject
1. Save the second dataset to a second file

##Tidy Data Principles:
The following principles were considered during the exercise:

* One observation per row
* One variable per column where each variable measures the same attribute
* Each data set should contain information related to one observational unit of analysis 
* Each column is appropriately labeled
* Missing values or incomplete observations should be removed (where applicable to the study

#Original Dataset
The dataset used during this exercise was compiled during a [study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the University of Genoa and contains information relating to 30 subjects each wearing a smartphone embedded with inertial sensors on their waist. The gathered information was preprocessed by the researchers and packaged as described on the [study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) web page.

The data can be downloaded as a [compressed zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) file from the  [study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) website. As per the [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the data comprises of 10299 observations each consisting of 561 attributes (or variables) and is made up of a training dataset as well as a test dataset.

The following provides and overview of the files relevant to the Coursera Getting and Cleaning Data course. This is a summarised version taken from the README.txt file that can be found in the [compressed zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) file:

1. **README.txt**: Contains more information about the files from the study
1. **features_info.txt**: Information about the variables used on the feature vector
1. **features.txt**: List of all attributes / variables that was tracked
1. **activity_labels.txt**: List of activities that was tracked 
1. **train/X_train.txt** and **test/X_test.txt**: Training and test dataset
1. **train/y_train.txt** and **y_test.txt**: Training and test dataset activity labels
1. **train/subject_train.txt** and **test/subject_test.txt**: Subject information

#Data Analysis
##Initial Observations
###Activity Labels
On inspection of the **activity_labels.txt** file it was found that it contains six activities relating to the study namely:

| Activity Id | Activity Name |
| ------------- |:-------------:|
|1 | WALKING |
|2 | WALKING_UPSTAIRS |
|3 | WALKING_DOWNSTAIRS |
|4 | SITTING |
|5 | STANDING |
| 6 | LAYING |

###Features
On inspection of the **features.txt** file it was found that it contains 561 lines each relating to the 561 attributes mentioned on the study [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Some examples of these are:

| Feature Id | Feature Name |
| ------------- |:-------------:|
| 294 | fBodyAcc-meanFreq()-X |
| 516 | fBodyBodyAccJerkMag-mean() |
| 517 | fBodyBodyAccJerkMag-std() |
| 518 | fBodyBodyAccJerkMag-mad() |

The full list of features can be found in the **features.txt** file.

###Train and Test Data
The full set of training data is broken up into 3 separate files **train/X_train.txt**,  **train/y_train.txt** and **train/subject_train.txt**, each containing some information about the specific observation. These 3 files have to be combined line by line in order to get all the relevant data in one comprehensive dataset.

The same applies to the **test/X_test.txt**, **y_test.txt** and **test/subject_test.txt** files. The amount of lines in the training set (7352) added to amount of lines in the test set (2947) equates to 10299 which corresponds to the amount of observations indicated on the study [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).



#Glossary:
1. Wearable Computing: Find more infomation on this topic in this [article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/)

 
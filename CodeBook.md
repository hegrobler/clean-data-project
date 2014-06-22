#Overview
The following document provides and overview of the data analysis completed as part of the Coursera Getting and Cleaning Data course. It describes the data used in the analysis and the steps completed to explore and prepare the data so that it is ready for analysis. 

##Tools
The following tools were used to complete the exercise:

* [Notepad++](http://notepad-plus-plus.org/): Used in initial exploration of the data. The tool is able to work with relatively large datasets with a small memory footprint. 
* [R](http://www.r-project.org/) and [RStudio](http://www.rstudio.com/): Used to analyse and clean the data

##Requirements
The scripts were designed to be reproducible so any person will be able to reproduce the exercise on their own pc. The following notes the environment that the scripts were developed and run in. Running the scripts in a different environment may have varied performance but the results should still be the same.

* Pentium I7 Processor with 16Gb memory
* Windows 8 64-bit
* RStudio version 0.98.507
* R version 3.1.0

##Tidy Data Principles:
The following principles were considered during the exercise:

* One observation per row
* One variable per column where each variable measures the same attribute
* Each data set should contain information related to one observational unit of analysis 
* Each column is appropriately labeled
* Missing values or incomplete observations should be removed (where applicable to the study)

##List of Result Files
The following lists the files that can be found in this repository and the purpose of each:

* **CodeBook.md**: Provides more information on the data and its origin as well detailed information about the data cleaning exercise
* **run_analysis.R**: The R script used to download and process the data
* **run_analysis.Rmd**: The R markdown script used to create the  **run_analysis_walkthough.html** file
* **run_analysis_walkthough.html**: Detailed step by step explanation of the code written in the **run_analysis.R** script
* **full_dataset.txt**: The first "tidy" dataset mentioned in the Exercise Tasks above 
* **avg_by_subject_dataset.txt**: The second "tidy" dataset mentioned in the Exercise Tasks above 

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

##Variables
The following is the contents of **features_info.txt** which describes the variables. This information is summarised in this file for convenience. **Please use the original file as the main point of reference.**

The data was retrieved from an accelerometer and gyroscope with 3-axial raw signals tAcc-XYZ and tGyro-XYZ. The time domain signals are prefixed with t were captured at a constant rate of 50 Hz. These signals were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

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

The Activity Ids in this file relates to the values in the **train/y_train.txt** and **y_test.txt** files as indicated in the **README.txt**.

###Features
On inspection of the **features.txt** file it was found that it contains 561 lines each relating to the 561 attributes mentioned on the study [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Some examples of these are:

| Feature Id | Feature Name |
| ------------- |:-------------:|
| 294 | fBodyAcc-meanFreq()-X |
| 516 | fBodyBodyAccJerkMag-mean() |
| 517 | fBodyBodyAccJerkMag-std() |
| 518 | fBodyBodyAccJerkMag-mad() |
*The full list of features can be found in the **features.txt** file.*

From the data in the above data extract we can see that the variable names contain dashes and brackets which are not allowed in column [names](http://cran.r-project.org/doc/FAQ/R-FAQ.html#What-are-valid-names_003f) in the R language. In order to keep the resulting dataset from this exercise compatible with the original it was decided to strip off syntactically [incorrect characters](http://cran.r-project.org/doc/FAQ/R-FAQ.html#What-are-valid-names_003f) in the variable names. For example: **fBodyAcc-meanFreq()-X** would become **fBodyAccmeanFreqX**. The adjusted names would also be useful when data must be accessed and processed programatically in R as well as other languages.

###Train and Test Data
The full set of training data is broken up into 3 separate files **train/X_train.txt**,  **train/y_train.txt** and **train/subject_train.txt**, each containing some information about the specific observation. These 3 files have to be combined line by line in order to get all the relevant data in one comprehensive dataset.

The same applies to the **test/X_test.txt**, **y_test.txt** and **test/subject_test.txt** files. The amount of lines in the training set (7352) added to amount of lines in the test set (2947) equates to 10299 which corresponds to the amount of observations indicated on the study [website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#Data Retrieval and Processing
The data retrieval and processing was completed with the R programming language using R studio. Each step is documented in detail in the **run_analysis_walkthough.html** file. Please refer to the html file for any questions about the code written in the **run_analysis.R** file.

##First Dataset Result
The first dataset includes all the observations from the training and test dataset. All columns that do not contain the words mean or std anywhere in the name was removed.

The dataset contains **10299** observations and **88** variables. The number of observations correspond to the original [study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#). **86** columns consist of variables contain either mean or std in the variable name. The last **2** columns contain the id of the subject that was observed and the name of the activity that the subject performed. 

A sample from the resulting dataset as well as a **comprehensive list of column names** can be found in the **run_analysis_walkthough.html** file under the **Step 10: Add the activityName factor and remove the activityLabelId** heading.

The variables are described under the Variables heading in the previous section.

##Second Dataset Result
The second result set contains a summarized version of the dataset described in the previous step. It contains the average of each column broken down by subject and activity. The sample from this dataset can be seen in the  **run_analysis_walkthough.html** file under the **Step 12: Summarise the dataset** heading.

Review of assignment result
---------------------------------

The assignment asked that the following be done. Note the values in bold at the end of each line which corresponds to the step above that fulfils that assignment task.

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set (**Step 9**)
1. Extracts only the measurements on the mean and standard deviation for each measurement (**Step 9**)
1. Uses descriptive activity names to name the activities in the data set (**Step 10**)
1. Appropriately labels the data set with descriptive variable names (**Step 7 & Step 4**)
1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. (**Step 12**)




  
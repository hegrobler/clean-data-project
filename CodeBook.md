#Overview
The following document provides and overview of the data analysis completed as part of the Coursera Getting and Cleaning Data course. It describes the data used in the analysis and the steps completed to explore and prepare the data so that it is ready for analysis. 

##Exercise Tasks
The exercise calls for the following tasks to be completed:

1. Retrieve the sample data
1. Merge the training and the test sets found in the sample dataset into one dataset
1. Extract only the measurements that contain the word mean and std (standard deviation) for each measurement
1. Add descriptive activity names to each measurement
1. Rename variables (columns) in the dataset to be descriptive
1. Apply any other necessary transformations on the data to make it ready for analysis 
1. Save above dataset to a file (**full_dataset.txt**)
1. Create a second, independent tidy data set with the average of each variable for each activity and each subject
1. Save the second dataset to a second file (**avg_by_subject_dataset.txt**)

##Tools
The following tools were used to complete the exercise:

* [Notepad++](http://notepad-plus-plus.org/): Used in initial exploration of the data. The tool is able to work with relatively large datasets with a small memory footprint. 
* [R](http://www.r-project.org/) and [RStudio](http://www.rstudio.com/): Used to analyse and clean the data

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

The scripts were designed to be reproducible so any person will be able to reproduce the exercise on their own pc. The following notes the environment that the scripts were developed and run in. Running the scripts in a different environment may have varied performance but the results should still be the same.

* Pentium I7 Processor with 16Gb memory
* Windows 8 64-bit
* RStudio version 0.98.507
* R version 3.1.0



 
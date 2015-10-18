# Readme.md
Richard Casto

2015-10-17

## Overview
This project is part of the Coursera “Getting and Cleaning Data” course.  The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The artifacts in this GitHub repository include…

* Readme.md (this file)
* Codebook.md (describes the source data, how the data was manipulated and describes the output data set)
* run_analysis.R (The R code that source the original data set and creates the output data set)

The assignment is to…

1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## A few points to hopefully help with grading

* The tidy data set output file is in the “Wide” format.  It has 180 observations/rows and 68 variables/columns.  The 180 observations are based upon 30 subjects with 6 activities (30x6=180).  **Both the Wide and Narrow formats are acceptable for this assignment.**
* I have only included measurements that use –mean(), -mean()-X, -mean()-Y, -mean()-Z, -std(), -std()-X, -std()-Y and -std()-Z.  I have excluded other values that include “mean” in the name (such as meanFreq() and the angle means) because they are “weighted average” or a “windowed average” and not a true classic “mean”.  Others may have included some or all of those in their work, but I have not and **hopefully my explanation (here, in the Codebook and in the code) will suffice to explain “why” I have chosen the variables based upon the assignments requirements**.  I did not just accidently not include them, or not know how to include them.  I could have modified my subset regular expression to include those if I had wanted.
* I have tried to provide both descriptive labels for the variable measurements as well as convert the activities from numeric ids to the provided friendly labels.
* I have tried to create a codebook that includes a base description of the source data (without copying the original text verbatim) as well as defining the goals of the resulting dataset, how the original source data was used and the definition of the resulting new tidy data set.
* I struggled with how to split the details between the Codebook.md and the Readme.md files.  So I have tried to avoid a large amount of duplication.  So while I explain key parts of how the original data was transformed in the Codebook, I am doing the larger walkthrough of the R logic here.  Hopefully both documents combined provide a complete picture.

## Reproducing my output
Not that the grading rubric asks you to execute my code, but if you wanted, to it should work by placing run_analysis.R in your working directory within R (or R Studio) and executing the script.  It will download the data and write out the tidy data set. 

## Walkthrough of the logic within run_analysis.R
1.	First I install and load the “dplyr” package.  I use a few dplyr features later on such as the aggregation and sorting.
2.	Next I download the source data into the current working directory.  Note, during development of the script I had examined the content of the ZIP file to understand the contents and used that knowledge for the next step.  Also I use some of the data to apply column names to the test and train measurements during the load.
3.	Next I load various files into R.  I use a technique that allows me to load files from within the source .ZIP file.
4.	Next I column bind the subject identifier, activity identifier and measurements into a full “test” and “train” dataset and then row bind the “test” and “train” into a full dataset.  Lastly I convert the activity identifier into descriptive character values.
5.	Next I subset out the “mean” and “standard deviation” measurements (I also keep my subject and activity variables).  See comments above, in the code and in the codebook about why I select specific variables.
6.	Next I adjust the variable names to make them more descriptive and human readable.  That includes fixing some changes that R makes when creating unique column names.
7.	Next I create the final tidy data set which is an aggregate based upon subject and activity.  The measurements are now a “mean” of the previous values.  I also order the data to make it nicer to look at.
8.	Lastly, I write out the data using the specified assignment parameters.


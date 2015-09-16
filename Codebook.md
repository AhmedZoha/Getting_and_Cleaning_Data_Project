---
title: "Codebook"
author: "Ahmed Zoha"
date: "September 16, 2015"
output: html_document
---
This ***Code Book*** is generated on 2015-09-16 18:59:23, for the Coursera "Getting and Cleaning Data" course project. The description of the variables found in the tidy dataset is as follows:

Variable Description
---------------------


Variable name    | Description
-----------------|------------
subject          | It specifies the subject ID who has performed the activity. The value ranges from 1 to 30.
activity         | Name of the Activity 
featcategories   | Feature: It shows the categorization whether it is Time domain signal or frequency domain signal (i.e., Time or Freq)
featint          | Feature: Specifies the Measuring instrument (i.e., Accelerometer or Gyroscope)
featAcc          | Feature: Acceleration signal (Body or Gravity)
featstat         | Feature: Statistics (i.e., Mean or Standard Deviation (SD))
fJerk            | Feature: Jerk signal
fMagnitude       | Feature: Magnitude of the signals 
fAxis            | Feature: It specifies the axis of the 3-axial signals (i.e., X, Y, or Z direction)
count            | Feature: Count of data points used to compute `average`
average          | Feature: Average of each variable for each activity and each subject

Structure of the Dataset
-----------------


```r
str(dftidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject       : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity      : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ featcategories: Factor w/ 2 levels "Time","Frequency": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featAcc       : Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featint       : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ fJerk         : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ fMagnitude    : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ featstat      : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ fAxis         : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count         : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average       : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "featcategories" "featAcc" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```
Key variables in the data table
----------------------------------------


```r
key(dftidy)
```

```
## [1] "subject"        "activity"       "featcategories" "featAcc"       
## [5] "featint"        "fJerk"          "fMagnitude"     "featstat"      
## [9] "fAxis"
```

Displaying First 10 rows of the Dataset
---------------------------------------


```r
head(dftidy,n=10)
```

```
##     subject activity featcategories featAcc   featint fJerk fMagnitude
##  1:       1   LAYING           Time      NA Gyroscope    NA         NA
##  2:       1   LAYING           Time      NA Gyroscope    NA         NA
##  3:       1   LAYING           Time      NA Gyroscope    NA         NA
##  4:       1   LAYING           Time      NA Gyroscope    NA         NA
##  5:       1   LAYING           Time      NA Gyroscope    NA         NA
##  6:       1   LAYING           Time      NA Gyroscope    NA         NA
##  7:       1   LAYING           Time      NA Gyroscope    NA  Magnitude
##  8:       1   LAYING           Time      NA Gyroscope    NA  Magnitude
##  9:       1   LAYING           Time      NA Gyroscope  Jerk         NA
## 10:       1   LAYING           Time      NA Gyroscope  Jerk         NA
##     featstat fAxis count     average
##  1:     Mean     X    50 -0.01655309
##  2:     Mean     Y    50 -0.06448612
##  3:     Mean     Z    50  0.14868944
##  4:       SD     X    50 -0.87354387
##  5:       SD     Y    50 -0.95109044
##  6:       SD     Z    50 -0.90828466
##  7:     Mean    NA    50 -0.87475955
##  8:       SD    NA    50 -0.81901017
##  9:     Mean     X    50 -0.10727095
## 10:     Mean     Y    50 -0.04151729
```

Summary
-------


```r
summary(dftidy)
```

```
##     subject                   activity      featcategories    featAcc    
##  Min.   : 1.0   LAYING            :1980   Time     :7200   NA     :4680  
##  1st Qu.: 8.0   SITTING           :1980   Frequency:4680   Body   :5760  
##  Median :15.5   STANDING          :1980                    Gravity:1440  
##  Mean   :15.5   WALKING           :1980                                  
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                                  
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                                  
##           featint      fJerk          fMagnitude   featstat    fAxis    
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940   NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940   X :2880  
##                                                                Y :2880  
##                                                                Z :2880  
##                                                                         
##                                                                         
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```
Save to file
------------

Save the dataframe `dftidy` to  `tidydataset.txt`.


```r
f = file.path(pathdata, "tidaydataset.txt")
write.table(dftidy, f, quote=FALSE, sep="\t", row.names=FALSE)
```

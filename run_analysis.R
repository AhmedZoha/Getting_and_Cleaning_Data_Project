
#Load Required Packages
library(data.table)
library(reshape)
#This script assumes that dataset is unzipped in the working directory
path = getwd()
pathdata = file.path(path, "UCI HAR Dataset")
#Read the files for train and test files for subjects
dfSubTrain = fread(file.path(pathdata, "train", "subject_train.txt"))
dfSubTest  = fread(file.path(pathdata, "test" , "subject_test.txt" ))

#Read the train and test files for activity
dfActTrainY = fread(file.path(pathdata, "train", "Y_train.txt"))
dfActTestY  = fread(file.path(pathdata, "test" , "Y_test.txt" ))

#The X files have some issue and here is the workaround

convdatatable = function (f) {
  dt = read.table(f)
  df = data.table(dt)
}
dfActTrainX = convdatatable(file.path(pathdata, "train", "X_train.txt"))
dfActTestX  = convdatatable(file.path(pathdata, "test" , "X_test.txt" ))

#Task 1: Merging the training and test datasets
dfSub = rbind(dfSubTrain, dfSubTest)
setnames(dfSub, "V1", "subject")
dfAct = rbind(dfActTrainY, dfActTestY)
setnames(dfAct, "V1", "activityNum")
df = rbind(dfActTrainX, dfActTestX)

#Now merging the columns
dfSub = cbind(dfSub, dfAct)
df = cbind(dfSub, df)

#Setting the key
setkey(df, subject, activityNum)

#TASK2: Extracting the mean and standard deviation
Features = fread(file.path(pathdata, "features.txt"))
setnames(Features, names(Features), c("featureNum", "featureName")) #This contains 561 features
#Using regular expression to find out the mean and std features index
Features = Features[grepl("mean\\(\\)|std\\(\\)", featureName)] # This contains list of features containing just mean and std

# To match the column names in df
Features$fCode = Features[, paste0("V", featureNum)] #paste0 minimizes any spaces
head(Features)

# subsetting the variables
select = c(key(df), Features$fCode)
df = df[, select, with=FALSE]

#Task3: Use descriptive activity names
dfActNames = fread(file.path(pathdata, "activity_labels.txt"))
setnames(dfActNames, names(dfActNames), c("activityNum", "activityName"))
unique(dfActNames) # You can dispaly the unique activity names. 

#TASK4: Appropriately labels the data set with descriptive activity names.

df = merge(df, dfActNames, by="activityNum", all.x=TRUE)
setkey(df, subject, activityNum, activityName)
df = data.table(melt(df, key(df)))
df = rename(df,c("variable"="fCode"))
df = merge(df, Features[, list(featureNum, fCode, featureName)], by="fCode", all.x=TRUE)

#Now factoring Activity and Feature Names
df$activity = factor(df$activityName)
df$feature = factor(df$featureName)

#Now the task is to seperate the features from featurename
# For that we define a function called fnsep
fnsep = function (regex) {
  grepl(regex, df$feature)
}

#Now the problem is that there are 2 categories of Feature names
# One has two category of strings, while the other has only one
# To address this we deal it one by one.
## Features with 2 categories
c = 2
y = matrix(seq(1, c), nrow=c)
x = matrix(c(fnsep("^t"), fnsep("^f")), ncol=nrow(y))
df$featcategories = factor(x %*% y, labels=c("Time", "Frequency"))

x = matrix(c(fnsep("Acc"), fnsep("Gyro")), ncol=nrow(y))
df$featint = factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

x = matrix(c(fnsep("BodyAcc"), fnsep("GravityAcc")), ncol=nrow(y))
df$featAcc = factor(x %*% y, labels=c(NA, "Body", "Gravity"))

x = matrix(c(fnsep("mean()"), fnsep("std()")), ncol=nrow(y))
df$featstat = factor(x %*% y, labels=c("Mean", "SD"))


## Features with 1 category

df$fJerk = factor(fnsep("Jerk"), labels=c(NA, "Jerk"))
df$fMagnitude = factor(fnsep("Mag"), labels=c(NA, "Magnitude"))

## Features with 3 categories
c = 3
y = matrix(seq(1, c), nrow=c)

x = matrix(c(fnsep("-X"), fnsep("-Y"), fnsep("-Z")), ncol=nrow(y))
df$fAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

#The last step is to now make a tidy Dataset 
setkey(df, subject, activity, featcategories, featAcc,featint, fJerk, fMagnitude, featstat, fAxis)
dftidy = df[, list(count = .N, average = mean(value)), by=key(df)]
print(dftidy)

library(knitr); knit2html("Codebook.Rmd")


#Course Project

#this file contains the code for the course project.  It takes multiple
#files and combines them into a single data frame. 

#read activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)

#read test measurements
testResults <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)

#read test subjects
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"), header=FALSE)

#read test activity labels
testActivity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("Activity"), header=FALSE)

#read training measurements
trainResults <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)

#read training activity labels
trainActivity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"),header=FALSE)

#read train subjects
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"), header=FALSE)

#read variable names
variables <- read.table("UCI HAR Dataset/features.txt", header=FALSE)



#make column names = variables in features.txt
colnames(trainResults) = variables$V2
colnames(testResults) = variables$V2

#create complete test data frame
test <- cbind(testSubjects,testActivity,testResults)

#create complete train data frame
train <- cbind(trainSubjects,trainActivity,trainResults)

#create merge test and train
fullDataset <- rbind(test,train)

#subset to only columns with MEAN and STD
filtered <- fullDataset[,c("Subject","Activity", colnames(fullDataset)[grep("mean",colnames(fullDataset))], colnames(fullDataset)[grep("std",colnames(fullDataset))])]

#replace activity ID with label
activityList <- as.vector(activityLabels$V2)
labels <- activityList[filtered$Activity]
filtered$Activity <- labels

#call reshape library
library(reshape)

#melt into narrow format (subject,activity, variable, value)
narrow <- melt(filtered, id=c("Subject","Activity"))

#now aggregate and get avg for each subject-activity-variable combo
wide <- dcast(narrow, Subject + Activity ~ variable, fun.aggregate = mean)

#use gsub to make variable names more descriptive

colnames(wide) <- gsub("\\(\\)","", colnames(wide))
colnames(wide) <- gsub("tBody","TimeBody",colnames(wide))
colnames(wide) <- gsub("tGravity","TimeGravity",colnames(wide))
colnames(wide) <- gsub("fBody","FrequencyBody",colnames(wide))
colnames(wide) <- gsub("fGravity","FrequencyGravity",colnames(wide))
colnames(wide) <- gsub("-mean-","Mean",colnames(wide))
colnames(wide) <- gsub("-std-","StdDev",colnames(wide))
colnames(wide) <- gsub("Acc", "Acceleration", colnames(wide))
colnames(wide) <- gsub("-mean","Mean",colnames(wide))
colnames(wide) <- gsub("-std","StdDev",colnames(wide))
colnames(wide) <- gsub("Freq-X","FreqX",colnames(wide))
colnames(wide) <- gsub("Freq-Y","FreqY",colnames(wide))
colnames(wide) <- gsub("Freq-Z","FreqZ",colnames(wide))

#write tidy data set
write.table(wide, file="tidydata.txt", row.names = FALSE)


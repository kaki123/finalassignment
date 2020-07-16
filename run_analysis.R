setwd("/Users/kakifung/Documents/finalassignment")

# reading in files 
activity <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
feature <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE)[2]
testX<- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
testY<- read.csv("UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE)
trainX<- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
trainY<- read.csv("UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE)

testSubject <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
trainSubject <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)

# changing the colnumn names to put in perspective
colnames(trainX)<-feature[,1]
colnames(testX)<-feature[,1]

# creating data sets: trainSet and testSet
trainSet <- data.frame(trainSubject, trainY, trainX) 
testSet <- data.frame(testSubject, testY, testX)  

# Step 1: merging the two set into one
mergeSet <- rbind(trainSet, testSet)
# changing column names to reflect infomation (Appropriately labels the data set with descriptive variable names.)
colnames(mergeSet)[1]<-"Subject"
colnames(mergeSet)[2]<-"Activity"

# Step 2:Extracting only mean and std measurements
fmergeSet <- mergeSet[ grepl("Subject", names(mergeSet), ignore.case = TRUE)| grepl("Activity", names(mergeSet), ignore.case = TRUE)|
                       grepl("mean", names(mergeSet), ignore.case = TRUE)|grepl("std", names(mergeSet), ignore.case = TRUE)] 

# Step 3:Assigning descriptive activity names
newActivityLabelSet <- merge(fmergeSet, activity, by.x = "Activity", by.y = "V1")
newActivityLabelSet = subset(newActivityLabelSet, select = -c(Activity) )

# Step 4: Appropriately labels the data set with descriptive variable names.
colnames(newActivityLabelSet)[88]<-"Activity"
newActivityLabelSet

# Step 5: creates an independent tidy data set with the average of each variable for each activity and each subject
grouping<-group_by(newActivityLabelSet,Subject,Activity)
avgData<-summarise_each(grouping,funs(mean))

write.table(avgData,"analysis.txt",row.name=FALSE)

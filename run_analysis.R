
library(dplyr)

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

XData <- rbind(xtrain, xtest)
YData <- rbind(ytrain, ytest)
Subject <- rbind(subjecttrain, subjecttest)
BindData <- cbind(Subject, YData, XData)

TidyData <- BindData %>% select(subject, code, contains("mean"), contains("std"))
View(TidyData)

TidyData$code <- activities[TidyData$code, 2]

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

FinalData <- TidyData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(FinalData, "TidyData.txt", row.name=FALSE)

View(FinalData)
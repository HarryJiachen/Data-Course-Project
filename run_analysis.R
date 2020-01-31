library(dplyr)
#Load and merge X,Y and subject's two data sets respectively (training and test) 
#X
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
xmerge <- rbind(xtrain, xtest)
#Y
xtrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
ymerge <- rbind(ytrain, ytest)
#Subject
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjectmerge <- rbind(subjecttrain, subjecttest)

#Extract mean and sd for measurements
variable<- read.table("./UCI HAR Dataset/features.txt")
meansd<- variable[grep("mean\\(\\)|std\\(\\)",variable[,2]),]
xmerge<- xmerge[,meansd[,1]]

#replace names
label<- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(ymerge) <- "activity"
ymerge$activitylabel <- factor(ymerge$activity, labels = as.character(label[,2]))
activitylabel <- ymerge[,-1]

# label the data set with variable names.
colnames(xmerge) <- variable[meansd[,1],2]

# tidy data set creation
colnames(subjectmerge) <- "subject"
total <- cbind(xmerge, activitylabel, subjectmerge)
totalmean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(totalmean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

#set the wd as the project folder. Should work at my PC
setwd("D:/Dropbox/Currículum Vitae/Data Scientist/Getting-and-Cleaning-Data-W4Project")

#delete the data folder, and of course, all its content
#in case the last delete is ignored
unlink("./w4project_data", recursive = TRUE, force = TRUE)

#load the dplyr package
library(dplyr)

#create the data folder
##WHOEVER the user is, that person can choose which lines to run.
### Which means the folder might not be deleted, hence the 'IFs'
if(!file.exists("./w4project_data")){
  
  dir.create("./w4project_data")
  
}

#set the data folder as the wd, before downloading
setwd("./w4project_data")

#downloaded zip file name
data_zip_file <- "w4project_data.zip"

#download the data set
if (!file.exists(data_zip_file)){
  
  download_link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  download.file(download_link, data_zip_file, method="curl")
  
}

#unzip the file
unzip(data_zip_file)


#data frames creation
feats <- read.table("UCI HAR Dataset/features.txt", col.names = c("i","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feats$functions)
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
training_set <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feats$functions)
training_labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

################################################################################
################################################################################
#Now comes the real work

#merging the data
set_merged <- rbind(training_set, test_set)
labels_merged <- rbind(training_labels, test_labels)
guinea_pigs <- rbind(subject_train, subject_test)
Merged_Data <- cbind(guinea_pigs, labels_merged, set_merged)

#cleaning the data, sticking only to MEAN and SD of each observation
clean_data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#naming the activities
clean_data$code <- activity_labels[clean_data$code, 2]

#labeling clean_data, using the same identifiers as in the .txt files
names(clean_data)[2] = "activity"
names(clean_data)<-gsub("Acc", "Accelerometer", names(clean_data))
names(clean_data)<-gsub("Gyro", "Gyroscope", names(clean_data))
names(clean_data)<-gsub("BodyBody", "Body", names(clean_data))
names(clean_data)<-gsub("Mag", "Magnitude", names(clean_data))
names(clean_data)<-gsub("^t", "Time", names(clean_data))
names(clean_data)<-gsub("^f", "Frequency", names(clean_data))
names(clean_data)<-gsub("tBody", "TimeBody", names(clean_data))
names(clean_data)<-gsub("-mean()", "Mean", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-std()", "STD", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-freq()", "Frequency", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("angle", "Angle", names(clean_data))
names(clean_data)<-gsub("gravity", "Gravity", names(clean_data))

#create the independent data set requested for STEP 5
Step_5 <- clean_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Step_5, "Independent_clean_data.txt", row.name=FALSE)

#the clean data is moved to the main folder
library(filesstrings)
file.move("D:/Dropbox/Currículum Vitae/Data Scientist/Getting-and-Cleaning-Data-W4Project/w4project_data/Independent_clean_data.txt", "D:/Dropbox/Currículum Vitae/Data Scientist/Getting-and-Cleaning-Data-W4Project")
setwd("D:/Dropbox/Currículum Vitae/Data Scientist/Getting-and-Cleaning-Data-W4Project")

#delete the data folder, and of course, all its content, to save space
unlink("./w4project_data", recursive = TRUE, force = TRUE)

#Checking the final result
str(Step_5)

Step_5

#this last line saves the workspace on the project folder
save.image("w4project_workspace.RData")
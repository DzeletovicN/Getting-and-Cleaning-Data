
library(plyr)
library(tidyr)
library(base)

## prepare dataset for subjects in test group:

##read file features to find columns which needed to result dataset (only the measurements on the mean and standard deviation)
features <- read.table("features.txt")
Colno<-grep("mean[^Freq]|std",features$V2)
activity_labels <- read.table("activity_labels.txt")


for (j in 1:2) {
       ##set working folder       
       if (j == 1) {
             setwd("./test")
             subject_file <- "subject_test.txt"
             activity_file <- "y_test.txt"
             measurement_file <-"x_test.txt"
             test_type <- "test"
       } else {
             setwd("..")
             setwd("./train")
             subject_file <- "subject_train.txt"
             activity_file <- "y_train.txt"
             measurement_file <-"x_train.txt"
             test_type <- "train"
       }
       
       ## read files of subjects and activities 
       ## renaming columns
       ## generate sequence for each dataset to join them

       subject <- read.table(subject_file)
       names(subject)[1] <- "subjectno"
       subject$id <- 0
       for (i in 1:nrow(subject)){subject$id[i] = i}


       activity <- read.table(activity_file)
       names(activity)[1] <- "activityid"
       activity$id <- 0
       for (i in 1:nrow(activity)){activity$id[i] = i}

       ## read file of measurements, 
       ## rename all columns,
       ## extract measurements on the mean and standard deviation  
       measurement <- read.table(measurement_file)
       for (i in 1:nrow(features)) {names(measurement)[i] <- as.character(features$V2[i])}
       measurement <- measurement[,Colno]
       ## generate sequence to join datasets
       measurement$id <- 0
       for (i in 1:nrow(measurement)){measurement$id[i] = i}
       measurement$testtype <- test_type

       ##merge datasets to one
       dflist<-list(subject,activity,measurement)
       if (j==1) {
           testds <- join_all(dflist)
       }  else trainds <- join_all(dflist)
	 
}
##join 2 datasets to one
unionds <-rbind.fill(testds,trainds)
##change activityid to activityname
unionds_l <-merge(unionds, activity_labels,by.x = "activityid", by.y = "V1")
names(unionds_l)[names(unionds_l)=="V2"] <- "activity"
unionds_l$activityid <-NULL
unionds_l$id <- NULL



##create independent tidy data set with the average of each variable for each activity and each subject
aggrds<- aggregate(unionds_l[, 4:ncol(unionds_l)-2], list(unionds_l$subjectno,unionds_l$activity,unionds_l$testtype), mean)
names(aggrds)[1] <-"subjectno"
names(aggrds)[2] <-"activity"
names(aggrds)[3] <-"testtype"
res <- gather(aggrds, measuremenvariable, mean,-subjectno,-activity,-testtype)
##create file
setwd("..")
write.table(res,file="res.txt",row.name = FALSE)

       
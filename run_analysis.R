require("data.table")
require("reshape2")

# Read raw data in from data files

features <- read.table("./UCI_HAR_Dataset/features.txt")[,2]
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")[,2]
X_train_set <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train_set <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
subject_train_set <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
X_test_set <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test_set <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test_set <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

# Extract column names from features to use in X_train_set and X_test_set  
# and subset only on the rows that contain the standard deviation and mean. We 
# will achieve this by using the grepl() function mentioned in the videos.

names(X_train_set) <- features
names(X_test_set) <- features

# Append to the data frame for the y_train and y_test sets by pairing the activity
# number with the activity. Add a name for the subjects data frames and y sets

y_train_set[,2] <- activity_labels[y_train_set[,1]]
y_test_set[,2] <- activity_labels[y_test_set[,1]]
names(subject_train_set) <- c("Subject_ID")
names(subject_test_set) <- c("Subject_ID")
names(y_train_set) <- c("Activity_Number", "Activity")
names(y_test_set) <- c("Activity_Number", "Activity")

# Now, merge the train and test sets using cbind and rbind

train_set <- cbind(subject_train_set, X_train_set, y_train_set)
test_set <- cbind(subject_test_set, X_test_set, y_test_set)
merged_data <- rbind(train_set,test_set)

# Now, take a subset of only the rows that contain the standard deviation and 
# mean. We will achieve this by using the grepl() function mentioned in the videos.

merged_data <- merged_data[grepl("mean|std",features)]

# Finally, for the last step (step 5) we will make use of the melt() and dcast()
# functions in the reshape2 package to extract the average value of each variable
# for each subject participant and each activity.

melted_data <- melt(merged_data, id=c("Subject_ID","Activity_Number","Activity"), measure.vars=as.vector(colnames(merged_data)[2:80]))
variable_averages <- dcast(melted_data, Subject_ID + Activity ~ variable, mean)

write.table(variable_averages, file="./variable_averages.txt")
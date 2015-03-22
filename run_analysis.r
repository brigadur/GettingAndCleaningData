
# read features data
features <- read.delim("features.txt", header = FALSE, sep = "")

# read activity data train/y_train.txt and test/y_test.txt
y_train <- read.delim("train/y_train.txt", header = FALSE, sep = "")
y_test <- read.delim("test/y_test.txt", header = FALSE, sep = "")

# read subject data train/subject_train.txt and test/subject_test.txt
subject_train <- read.delim("train/subject_train.txt", header = FALSE, sep = "")
subject_test <- read.delim("test/subject_test.txt", header = FALSE, sep = "")

# read mapping table for activities, activity_labels.txt
activity_labels <- read.delim("activity_labels.txt", header = FALSE, sep = "")

# create vector with column names for training/test sets
X_train.col.names <- features[,2]
X_test.col.names <- features[,2]

# create vector with row names for training/test sets
row_names <- merge(y_train,activity_labels,by.y = "V1")
X_train.row.names <- row_names[,2]
row_names <- merge(y_test,activity_labels,by.y = "V1")
X_test.row.names <- row_names[,2]

# read training/test sets train/X_train.txt and test/X_test.txt
X_train <- read.delim("train/X_train.txt", col.names = X_train.col.names, header = FALSE, sep = "", dec = ".")
X_test <- read.delim("test/X_test.txt", col.names = X_test.col.names, header = FALSE, sep = "", dec = ".")

# add Activity column to X_train and X_test data sets
X_train <- cbind(Activity = X_train.row.names, X_train)
X_test <- cbind(Activity = X_test.row.names, X_test)

# add Subject column to X_train and X_test data sets
X_train <- cbind(Subject = subject_train[,1], X_train)
X_test <- cbind(Subject = subject_test[,1], X_test)

# add Set column to X_train and X_test data sets
X_train <- cbind(Set = "Training", X_train)
X_test <- cbind(Set = "Testing", X_test)

# combine X_test and X_train data sets
X_total <- rbind(X_test,X_train)

# extract mean and standard deviation data
X_total_sub <- X_total[,c("Set", "Subject", "Activity", colnames(X_total)[grep("mean",colnames(X_total))], colnames(X_total)[grep("std",colnames(X_total))])]

# Create data set with averages by Activity and Subject
X_total.tidy <- aggregate(X_total_sub[, 4:82], list(Activity = X_total_sub$Activity,Subject = X_total_sub$Subject), mean)

# write X_total.tidy to file X_total_tidy.txt
write.table(X_total.tidy, file = "X_total_tidy.txt", row.names = FALSE)
## file dowloaded and unzipped
## only train and test folders are extracted to working directory. contain three files each - X, y and subject
## assign fodlders names

trainf<-  dir("./coursera/Samsung/Train")
testf<-  dir("./coursera/Samsung/Test")

train <- lapply(as.list(trainf), function(x) read.table(paste0(getwd(),"./coursera/Samsung/Train/",x)))
test <- lapply(as.list(testf), function(x) read.table(paste0(getwd(),"./coursera/Samsung/Test/",x)))

## assign the lable names from feature_info

features<-read.table("./coursera/Samsung/features.txt")
features_cols<-t(features[[,2]])


## add feature lables in all the files and bind the train files together

colnames(train[[1]])<-c("subject")
colnames(train[[2]])<-features_cols
colnames(train[[3]])<-c("activity")

trainbind<-cbind(train[[1]],train[[2]])
trainbind<-cbind(trainbind,train[[3]])

## dd feature lables in all the files and bind the test files together

colnames(test[[1]])<-c("subject")
colnames(test[[2]])<-features_cols
colnames(test[[3]])<-c("activity")

testbind<-cbind(test[[1]],test[[2]])
testbind<-cbind(testbind,test[[3]])

## bind test and train data set together, this data set has lable names also assigned
## step 1 as per project instructions

data_bind<- rbind(trainbind, testbind)

## next step it to clean the lable names as per standards, remove uppoer cases, periods, spaces etc.
## step 3 as per project instructions

names(data_bind)<-sub("-", "", names(data_bind),)
names(data_bind)<-tolower(names(data_bind))

## identify the columns with mean and std measurements and subset on these columns
## step 2 as per project instructions

pattern<-"subject|mean|std|activity"
data_bind_ms<-data_bind[,(which (grepl(pattern,names(data_bind))))]
names(data_bind_ms)<-sub("-", "", names(data_bind_ms),)

## read the activity lables from activity table and change the lables

activity<-read.table("./coursera/Samsung/activity_labels.txt")
names(activity)<-c("id", "activityname")

## merge data set form above with acitivy lables on activity id (1,2,3,4,5,6) and change the lable for activity
## step 4 as per project instructions

mergedata<-merge(data_bind_ms, activity, by.x="activity", by.y="id", all = TRUE)

## create a data set with average of each variable and for each activity and subject
## remove duplicate acitivity id from the data set for simplicity

mergedataact<-mergedata[2:89]

## melt the data set with subject and activity name as id and rest of the colun as variables
## step 5as per project instructions

datamelt<-melt(mergedataact, id.vars= c("subject", "activityname"))

##calculate the mean for each variable 

summarydata<-dcast(datamelt, subject +activityname ~ variable,mean)

## write a dataset for this summary data

write.csv(summarydata, "./coursera/Samsung/outputsum.txt")

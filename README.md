# Getting-and-Cleaning-Data
## pre-conditions
For the successful execution of the script run_analysys.r you need to unpack the data to a separate folder 
with preservation of the original structure of the ZIP file 
and setting a working folder in the root directory of the unpacked archive.
In this was the working directory will be contained files
 - activity_labels.txt with subjects' activity dictionary
 - features.txt - File describing the structure of the vector A-561


##the script does the following:
- Reads the file with the activities catalogue (activity_labels.txt)
- Reads the description file of the vector A-561 (features.txt) 
and selects coluumns with measurements on the mean and standard deviation (list Colno)
- Goes into the folder "test"
- Reads files
  subject_test.txt to get numbers of subject
  y_test.txt to gen Activity data
  x_test.txt to get all measurements (data.frame measurement)
- renames the columns into measurement in accordance with the variables description in features.txt
- Extracts only the measurements on the mean and standard deviation for each measurement (uses selected columns in Colno)
- joins these files by the rowid (first row on each file will be first row in union dataset)
- marks data as "test" test_type
- does similar actions with files in folder "train" with mark "train"
- Merges the training and the test sets to create one data set
- change activity id to activity name (uses activity_labels.txt)
- calculates means of each variable for each activity and each subject
- pivot dataset from wertical to horisontal structure (move colunms of variables to the rows)
- create file res.txt in the root directory

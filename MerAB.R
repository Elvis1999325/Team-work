install.packages('openxlsx')
library(openxlsx)


A<-read.xlsx('SouthEast.xlsx')
A
unique(A$Phusical)
unique(A$Belief)
unique(A$Region)
unique(A$ID)
unique(A$SES5)
unique(A$Gender)

B<-read.xlsx('Practical B R.xlsx') # Renaming

names(B)[names(B)=="Name"]<-"ID"   # renaming Name to ID 

B$ID

AB<-merge(A,B,by='ID',all=TRUE)  # merging based on ID 

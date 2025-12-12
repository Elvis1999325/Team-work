library(openxlsx)
Data1<-read.xlsx("A.xlsx")
Data2<-read.xlsx("B.xlsx")
Data3<-read.xlsx("P.xlsx")

str(Data1)
str(Data2)
str(Data3)


MergedRegion<-merge(Data1,Data2,by="Region",all=TRUE)
str(MergedRegion)
unique(MergedRegion$Region)
MergedRegion2<-merge(MergedRegion,Data3,by="Region",all=TRUE)
str(MergedRegion2)
unique(MergedRegion2$Region)

Data4<-read.xlsx("SouthEast.xlsx")
str(Data4)

Data5<-read.xlsx("Practical B R.xlsx")
str(Data5)
Data5$ID<-Data5$Name

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
str(AB)
str(MergedRegion2)
IDmerged<-merge(AB,MergedRegion2,by="ID",all=TRUE)
str(IDmerged)
unique(IDmerged$ID)

xtabs(~Belief+)



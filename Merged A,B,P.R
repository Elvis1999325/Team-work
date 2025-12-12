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


library("openxlsx")
library(dplyr)
A<-read.xlsx("A.xlsx")
B<-read.xlsx("B.xlsx")
C<-read.xlsx("P.xlsx")
D<-read.xlsx("SouthEast.xlsx")
E<-read.xlsx("Practical B R.xlsx")

##Structure of the data
A
B
C
D
E
str(D)
unique(D$Smoking)
D %>% summarise(across(
  c(Phusical,Mental,Smoker,Belief,Region,Age,Gender,ID,SES5),~sum(is.na(.))))
D<- D %>% 
  mutate(Smoking= case_when(
    tolower(Smoker)%in% c("current","y")~ "Yes",
    tolower(Smoker)=="n"~ "No",TRUE~NA_character_))
D$Smokings<-ifelse(tolower(D$Smoker)%in% c("current","yes"),"Yes",
                  ifelse(tolower(D$Smoker)=="n","No",NA))

D<- D %>% rename(Physical= Phusical)
DSub<- D %>%
  select(Physical,Mental,Belief,Region,Age,ID)##Subsetting to columns with no missing data
str(DSub)

##cleaning A
str(A)
A %>%
  summarise(across(
    c(PH,MH,Belief,Region,Age,Smoker,Gender),~sum(is.na(.))
  ))##checking for missing data 9 in smokers, 27 in gender
unique(A$Region)
unique(A$PH)
A<- A %>%
  mutate(Physical= case_when(
    tolower(trimws(PH))=="n" ~"No",
    tolower(trimws(PH))=="y"~"Yes",TRUE~NA_character_))##cleaning Physical
A<-A %>% mutate(Mental= case_when(
  tolower(trimws(MH))=="n"~"No",
          tolower(trimws(MH))=="y"~"Yes",TRUE~NA_character_))##cleaning Mental
A<-A %>%
  mutate(Belief=case_when(
    tolower(trimws(Belief))=="n"~"No",
            tolower(trimws(Belief))=="y"~"Yes",TRUE~NA_character_))
A<- A %>% mutate(Smoking=case_when(
  tolower(Smoker) %in% c("current","y")~"Yes",
  tolower(Smoker)=="n"~"No",TRUE~NA_character_))
ASub<- A %>% select(Region,Physical,Belief,Smoking,Mental,Age)
##Cleaning B
str(B)
B %>% summarise(across(
  c(Age,PH,MH,Smoker,Belief),~sum(is.na(.))
))
B<- B %>% mutate(Physical= case_when(
  tolower(trimws(PH))=="n"~"No",
          tolower(trimws(PH))=="y"~"Yes",TRUE~NA_character_))

B<- B %>% mutate(Mental= case_when(
  tolower(trimws(MH))=="n"~"No",
  tolower(trimws(MH))=="y"~"Yes",TRUE~NA_character_))

B<- B%>% mutate(Smoking= case_when(
  tolower(trimws(Smoker))=="n"~"No",
          tolower(trimws(Smoker)) %in% c("current","y")~"Yes",TRUE~NA_character_))

B<-B %>% mutate()
BSub<- B %>% select(Region,Physical,Mental,Smoking,Belief,Age)

##Cleaning C
str(C)
C %>% summarize(across(
  c(PH,MH,Smoker,Belief),~sum(is.na(.))
))
C<- C %>% mutate(Mental=case_when(
  tolower(trimws(MH))=="n"~"No",
          tolower(trimws(MH))=="y"~"Yes",TRUE~NA_character_))

C<- C %>% mutate(Physical= PH)

C<- C%>% mutate(Smoking=case_when(
  tolower(trimws(Smoker))%in% c("current","y")~"Yes",
          tolower(trimws(Smoker))=="n"~"No",TRUE~NA_character_))

CSub<-C %>% select(Region,Smoking,Mental,Physical,Age,Belief)##Subsetting C

##Cleaning E
str(E)
E %>% summarise(across(
  c(Belief,Physical,Mental,Smoking,Name),~sum(is.na(.))
))
E %>% mutate(across(
  c(Physical,Belief,Mental,Smoking),~(trimws(.))
))
E<-E %>% rename(ID=Name)
ESub<-E %>% select(ID,Belief,Physical,Mental,Smoking)

##Subsets
M1<-bind_rows(ASub,BSub,CSub)
str(M1)
M2<-bind_rows(E,D)
str(M2)

##Combine Data

unique(M3$Belief)
M3<-M3 %>% mutate(Belief= case_when(
  tolower(Belief) %in% c("no","n")~"No",
  tolower(Belief) %in% c("yes","y")~"Yes",TRUE~NA_character_))

unique(M2$Physical)
M3<- M3 %>% mutate(Physical= tolower(Physical))

unique(M3$Mental)

M3<-M3 %>% mutate(Mental=case_when(
  tolower(Mental) %in% c("y","yes")~"Yes",
  tolower(Mental) %in% c("n","no")~"No",TRUE~NA_character_
))

M2$Physical<-as.factor(M2$Physical)
M2$Mental<-as.factor(M2$Mental)
M2<-M2 %>% mutate(Sex=case_when(
  tolower(trimws(Gender)) %in% c("f","female")~"Female",
          tolower(trimws(Gender)) %in% c("m","male")~"Male",
          tolower(trimws(Gender)) %in% c("gd","pnts")~NA_character_,TRUE~NA_character_))

M2sub<-M2 %>%select(Age,Mental,Smoking,Belief,Physical,Region)
unique(M2$Region)

M3<-bind_rows(M1,M2)
str(M3)

M3$Belief<-as.factor(M3$Belief)

Z<-glm(Belief~Physical+Mental+Age,M3,family=binomial("logit"))
summary(Z)

M2 %>% summarise(
  Agemean= mean(Age,na.rm=TRUE),
  Agemissing= mean(is.na(Age)),
  Physical_prev_yes = mean(Physical == "Yes", na.rm = TRUE),
  Physical_missing  = mean(is.na(Physical)),
  
  Mental_prev_yes = mean(Mental == "Yes", na.rm = TRUE),
  Mental_missing  = mean(is.na(Mental)),
  
  Belief_prev_yes = mean(Belief == "Yes", na.rm = TRUE),
  Belief_missing  = mean(is.na(Belief))
)

xtabs(~Physical,M2)
xtabs(~Mental,M2)
xtabs(~Belief,M2)
summary(M2$Age,na.rm=TRUE)


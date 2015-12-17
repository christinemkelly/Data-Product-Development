setwd("~/Documents/Coursera/1. DataScience/9. Data Products Development/Project")
library(caret)
library(rattle)
library(randomForest)

# Read in the data:
Data <- read.table("Exam_Data.csv", header=TRUE, sep=",") 

str(Data)   #244 obs. of  6 numeric variables: Exams I - III scores, FinalExam score, Final Grade and year
# All exam scores and final grades are as percents since the exams were worth different point values
#in different years.

Data  <- Data[, -c(5:6)]  # Remove the final grade and the year columns as they are not used in this analysis

# Over years of teaching I "had the feeling" that students tended to score lower on the final
# exam as compared to the average of their 3 semester exams. So part of the initial exploration of the data
# explored this gut feel by looking at the difference between the final exam score and the 
# average of the three exams:

MeanDiff <- mean(Data$FinalExam) - (mean(Data$ExamI) + mean(Data$ExamII) + mean(Data$ExamIII))/3

#Find the average drop in the final exam for students who do worse on the final than their
# 3 exam averages and who do better:
NegDiff <- data.frame()
PosDiff <- data.frame()
for (i in 1: nrow(Data)) {
        diff[i] <- Data$FinalExam[i] - (Data$ExamI[i] + Data$ExamII[i] + Data$ExamIII[i])/3
        if (diff[i] < 0)  {
                NegDiff <- rbind(NegDiff , diff[i])
        } else if (diff[i] > 0) {
                PosDiff <- rbind(PosDiff , diff[i])
        }
}

meanNegDiff <- sum(NegDiff)/nrow(NegDiff)
meanPosDiff <- sum(PosDiff)/nrow(PosDiff)

# Find the percentage of students who score lower on the final than the average of their
# 3 exams. Do the same for students scoring higher on the final.

PercentLower <- (nrow(NegDiff)/nrow(Data))*100
PercentHigher <- (nrow(PosDiff)/nrow(Data))*100

# My "feeling" place the percent scoring lower on the final at about 80% so these results
# are in line with my teacher's intuition.

# Now see if there's a relationship between the 3 individual exams and the final exam.
# First partition the data and then explore linear, CART and random forest models. 

# Partition data into a training set (60%) and a test set (40%):
set.seed(334455)
TrainIndex <- createDataPartition(y=Data$FinalExam, p = .60, list=FALSE)
TrainingSet  <- Data[ TrainIndex,]
TestSet  <- Data[-TrainIndex,]

# Create a data frame to hold the R2 and coefficent results:
Results <- data.frame()

# Develop several models, first with simple linear regression and then with CART and Random Forest:
# Force all linear models to go through zero. Not doing so results in a negative intercept
# and a negative grade doesn't make sense. Additionally if a student hadn't taken the
# the semester exams they wouldn't be taking the final! T
# Model 1 (simple linear with Exam I)

Model1Fit  <- lm(FinalExam ~ 0 + ExamI, data = TrainingSet)
print(Model1Fit, digits = 5)
r.squared  <-  summary(Model1Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 2 (simple linear with Exam II)

Model2Fit  <- lm(FinalExam ~ 0 + ExamII, data = TrainingSet)
print(Model2Fit, digits = 5)
r.squared  <-  summary(Model2Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 3 (simple linear with Exam III)

Model3Fit  <- lm(FinalExam ~ 0 + ExamIII, data = TrainingSet)
print(Model3Fit, digits = 5)
r.squared  <-  summary(Model3Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 4 (simple linear with Exams I and II)

Model4Fit  <- lm(FinalExam ~ 0 + ExamI + ExamII, data = TrainingSet)
print(Model4Fit, digits = 5)
r.squared  <-  summary(Model4Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 5 (simple linear with Exams I and III)

Model5Fit  <- lm(FinalExam ~ 0 + ExamI + ExamIII, data = TrainingSet)
print(Model5Fit, digits = 5)
r.squared  <-  summary(Model5Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 6 (simple linear with Exams II and III)

Model6Fit  <- lm(FinalExam ~ 0 + ExamII + ExamIII, data = TrainingSet)
print(Model6Fit, digits = 5)
r.squared  <-  summary(Model6Fit)$r.squared
Results  <- rbind(Results, r.squared)

# Model 7 (simple linear with All 3 Exams)

Model7Fit  <- lm(FinalExam  ~ 0 + .,   data = TrainingSet)  
print(Model7Fit, digits = 5)
r.squared  <-  summary(Model7Fit)$r.squared
Results  <- rbind(Results, r.squared)

colnames(Results)  <- 'R Squared'
rownames(Results)  <- c('Model 1','Model 2','Model 3','Model 4','Model 5','Model 6','Model 7')

Results

#Model 8: Classification tree method (CART, rpart)
Model8Fit  <- train(FinalExam ~ ., data = TrainingSet, method = "rpart")
print(Model8Fit, digits = 5)

# Model 9 (pre-processing only)
set.seed(334455)
Model9Fit  <- train(FinalExam ~ ., preProcess=c('center', 'scale'), data = TrainingSet, method = "rpart")
print(Model9Fit, digits = 5)

# Model 10 (cross-validation only)
set.seed(334455)
Model10Fit  <- train(FinalExam ~ ., trControl = trainControl(method = 'cv', number = 4, allowParallel = TRUE), data = TrainingSet, method = "rpart")
print(Model10Fit, digits = 5)

# Model 11 (both pre-processing and cross-validation)
set.seed(334455)
Model11Fit  <- train(FinalExam ~ ., preProcess=c('center', 'scale'), trControl = trainControl(method = 'cv', number = 4, allowParallel = TRUE), data = TrainingSet, method = "rpart")
print(Model11Fit, digits = 5)


fancyRpartPlot(Model1Fit$finalModel) 

# Now do random forest:

#Model 12 (no additional features)
set.seed(334455)
Model12Fit  <- train(FinalExam ~ ., data = TrainingSet, method = "rf", prox = TRUE)
print(Model12Fit, digits = 5)

# Model 13 (pre-processing only)
set.seed(334455)
Model13Fit  <- train(FinalExam ~ ., data = TrainingSet, preProcess=c('center', 'scale'),  method = "rf", prox = TRUE, allowParellel = TRUE)
print(Model13Fit, digits = 5)

# Model 14 (cross-validation only)
set.seed(334455)
Model14Fit  <- train(FinalExam ~ ., data = TrainingSet, method = "rf", prox = TRUE, trControl = trainControl(method = 'cv', number = 3, allowParallel = TRUE))
print(Model14Fit, digits = 5)

# Model 15 (both pre-processing and cross-validation)
set.seed(334455)
Model15Fit  <- train(FinalExam ~ ., data = TrainingSet, method = "rf", prox = TRUE, preProcess=c('center', 'scale'), trControl = trainControl(method = 'cv', number = 3, allowParallel = TRUE))
print(Model15Fit, digits = 5)

#******************Now work with Model 7 since it had the highest R^2 value***********
#Final exam scores were predicted on the test set
predicted  <- as.numeric((predict(Model7Fit, newdata = TestSet)))
print(confusionMatrix(predicted, TestSet$FinalExam), digits = 3) #Can't get this to work
# Get the following error: Error in confusionMatrix.default(predicted, TestSet$FinalExam) : 
# the data cannot have more levels than the reference.
# I've looked at everything I can think of.
# Here's how I'll look at how well the model is predicting:

ActualPredictedDifference <- data.frame()
for (i in 1: nrow(TestSet)) {
        diff[i] <- Data$FinalExam[i] - (predicted[i])
        ActualPredictedDifference <- rbind(ActualPredictedDifference, diff[i])
}
AveragePredictedDifference <- sum(ActualPredictedDifference)/nrow(ActualPredictedDifference)

# Calculate a confidence internval

summary(Model7Fit)
yhat <- (Model7Fit$coef[1]*mean(Data$ExamI) + Model7Fit$coef[2]*mean(Data$ExamII) + Model7Fit$coef[3]*mean(Data$ExamIII))
CI  <- yhat + c(-1,1) * qt(0.975, df = Model7Fit$df) * summary(Model7Fit)$sigma / sqrt(nrow(Data))
(CI[2] - CI[1])/2   #  Exam +/- 1.156173


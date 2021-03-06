library(readr)
dsbchurn <- read.csv("DSBchurn.csv")
dsbchurn <- data.frame(dsbchurn)
str(dsbchurn)

dsbchurn$rep_sat <- factor(dsbchurn$rep_sat,order = TRUE, levels = c("very_unsat","unsat","avg","sat","very_sat"))
dsbchurn$usage <- factor(dsbchurn$rep_usage,order = TRUE, levels = c("very_little","little","avg","high","very_high"))
dsbchurn$rep_change <- factor(dsbchurn$rep_change,order = TRUE, levels = c("never_thought","no","considering","perhaps","actively_looking_into_it"))
   
set.seed(3478)
train = sample(1:nrow(dsbchurn),0.667*nrow(dsbchurn))
churn.train = dsbchurn[train,]
churn.test = dsbchurn[-train,]

library(rpart)
library(caret)
#for the train data set
fit = rpart(stay ~ ., 
            data=churn.train,
            method="class",
            control=rpart.control(xval=0, minsplit=100))
fit

#plot the tree
plot(fit, 
     uniform=T, 
     branch=0.5, 
     compress=T, 
     main="The Stay Tree", 
     margin=0.3)

#label
text(fit,  use.n=TRUE, 
     all=TRUE, 
     fancy=F, 
     pretty=T,
     cex=1.0)

churn.pred = predict(fit, churn.train, type="class")
churn.actual = churn.train$stay

#performance
confusion.matrix = table(churn.pred, churn.actual)  
confusionMatrix(confusion.matrix, positive = 'leave')

#for the test data set
confusionMatrix(table(pred=predict(fit, churn.test,type="class"),actual = churn.test$stay), positive = 'leave')






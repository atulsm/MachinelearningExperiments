-- svm classifier

select * from mtcars_train;

SELECT SVM_CLASSIFIER('svm_class', 'mtcars_train', 'am', 'cyl, mpg, wt, hp, gear'
                          USING PARAMETERS exclude_columns='gear');
                          
SELECT SUMMARIZE_MODEL('svm_class');                          

--create new table for prediction from test data
CREATE TABLE svm_mtcars_predict AS
   (SELECT car_model, am, PREDICT_SVM_CLASSIFIER(cyl, mpg, wt, hp
                                            USING PARAMETERS model_name='svm_class')
                                            AS Prediction FROM mtcars_test);
select * from svm_mtcars_predict;

--evaluate accuracy from confusion matrix
SELECT CONFUSION_MATRIX(obs::int, pred::int USING PARAMETERS num_classes=2) OVER()
        FROM (SELECT am AS obs, Prediction AS pred FROM svm_mtcars_predict) AS prediction_output;                                            
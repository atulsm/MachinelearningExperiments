-- logistical regression

-- create model from taining data
select * from mtcars_train;
SELECT LOGISTIC_REG('logistic_reg_mtcars', 'mtcars_train', 'am', 'cyl, hp, wt' 
                         USING PARAMETERS exclude_columns='hp');
SELECT SUMMARIZE_MODEL('logistic_reg_mtcars');

--predict with test data
CREATE TABLE mtcars_predict_results AS
   (SELECT car_model, am, PREDICT_LOGISTIC_REG(cyl, wt
                                            USING PARAMETERS model_name='logistic_reg_mtcars') 
                                            AS Prediction FROM mtcars_test);                         
SELECT * FROM mtcars_predict_results;

--check accuracy using confusion matrix
SELECT CONFUSION_MATRIX(obs::int, pred::int USING PARAMETERS num_classes=2) OVER()
        FROM (SELECT am AS obs, Prediction AS pred FROM mtcars_predict_results) AS prediction_output;                                            
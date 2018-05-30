-- regression models

select * from faithful_training;
SELECT LINEAR_REG('linear_reg_faithful', 'faithful_training', 'eruptions', 'waiting'
                      USING PARAMETERS optimizer='BFGS');
SELECT SUMMARIZE_MODEL('linear_reg_faithful');
CREATE TABLE pred_faithful_results AS
       (SELECT id, waiting, eruptions AS actual_eruptions,  PREDICT_LINEAR_REG(waiting USING PARAMETERS model_name='linear_reg_faithful') 
        AS pred_erruptions FROM faithful_testing);
select * from pred_faithful_results;
-- Calculating the Mean Squared Error (MSE)
SELECT MSE (actual_eruptions::float, pred_erruptions::float) OVER() FROM 
(SELECT actual_eruptions, pred_erruptions FROM pred_faithful_results) AS prediction_output;

--svm regression
SELECT SVM_REGRESSOR('svm_faithful', 'faithful_training', 'eruptions', 'waiting'
                      USING PARAMETERS error_tolerance=0.1, max_iterations=100);
SELECT SUMMARIZE_MODEL('svm_faithful');
CREATE TABLE pred_faithful AS
       (SELECT id, waiting, eruptions AS actual_eruptions, PREDICT_SVM_REGRESSOR(waiting USING PARAMETERS model_name='svm_faithful') 
        AS pred_erruptions FROM faithful_testing);
SELECT * FROM pred_faithful ORDER BY waiting;        
--Error
SELECT MSE(obs::float, prediction::float) OVER()
   FROM (SELECT actual_eruptions AS obs, pred_erruptions AS prediction
         FROM pred_faithful) AS prediction_output;                      
                      
                      

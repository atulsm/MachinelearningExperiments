-- random forest => ensemble of decision trees

select * from iris;

SELECT RF_CLASSIFIER ('rf_iris', 'iris', 'Species', 'Sepal_Length, Sepal_Width, Petal_Length, Petal_Width' 
USING PARAMETERS ntree=100, sampling_size=0.5);

SELECT SUMMARIZE_MODEL('rf_iris');

--apply the classifier model to test data
SELECT PREDICT_RF_CLASSIFIER (Sepal_Length, Sepal_Width, Petal_Length, Petal_Width
                                  USING PARAMETERS model_name='rf_iris') FROM iris1;
                                  
-- view probability of classes
SELECT PREDICT_RF_CLASSIFIER_CLASSES(Sepal_Length, Sepal_Width, Petal_Length, Petal_Width
                               USING PARAMETERS model_name='rf_iris') OVER () FROM iris1;
                               
                                                                 
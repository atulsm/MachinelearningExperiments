--naive bayes

--cleanup for repeted runs
drop table house84_train;
drop table house84_test;
drop model naive_house84_model;
drop table predicted_party_naive;

--create taining/test data
create table house84_train AS select * from house84_clean TABLESAMPLE(75);
create table house84_test AS select * from house84_clean TABLESAMPLE(25);


select * from house84_train;
--create naive bayes model
SELECT NAIVE_BAYES('naive_house84_model', 'house84_train', 'party',
                      '*' USING PARAMETERS exclude_columns='party, id');
select SUMMARIZE_MODEL('naive_house84_model');                      
                  
--store prediction from test data
CREATE TABLE predicted_party_naive
     AS SELECT party,
          PREDICT_NAIVE_BAYES (vote1, vote2, vote3, vote4, vote5,
                               vote6, vote7, vote8, vote9, vote10,
                               vote11, vote12, vote13, vote14,
                               vote15, vote16
                                 USING PARAMETERS model_name = 'naive_house84_model',
                                                  type = 'response') AS Predicted_Party
       FROM house84_test;                  
select * from predicted_party_naive;

--test accuracy
SELECT  (Predictions.Num_Correct_Predictions / Count.Total_Count) AS Percent_Accuracy
	FROM (  SELECT COUNT(Predicted_Party) AS Num_Correct_Predictions
		FROM predicted_party_naive
		WHERE party = Predicted_Party
	     ) AS Predictions,
	     (  SELECT COUNT(party) AS Total_Count
               FROM predicted_party_naive
            ) AS Count;
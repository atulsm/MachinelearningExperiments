--Balancing Imbalanced Data
SELECT fraud, COUNT(fraud) FROM transaction_data GROUP BY fraud;
SELECT BALANCE('balance_fin_data', 'transaction_data', 'fraud', 'under_sampling'
                  USING PARAMETERS sampling_ratio = 0.2);
SELECT fraud, COUNT(fraud) FROM balance_fin_data GROUP BY fraud;
SELECT * FROM balance_fin_data;

--Detect outliers
SELECT DETECT_OUTLIERS('baseball_hr_hits_salary_outliers', 'baseball', 'hr, hits, salary', 'robust_zscore'
                         USING PARAMETERS outlier_threshold=3.0, key_columns='id, team');
select * from baseball_hr_hits_salary_outliers;
CREATE VIEW clean_baseball AS
   SELECT * FROM baseball WHERE id NOT IN (SELECT id FROM baseball_hr_hits_salary_outliers);
select * from clean_baseball;

--impute missing values
SELECT * FROM small_input_impute; 
SELECT IMPUTE('output_view','small_input_impute', 'pid, x1,x2,x3,x4','mean' 
                  USING PARAMETERS exclude_columns='pid');
select * from output_view;
SELECT impute('output_view_group','small_input_impute', 'pid, x1,x2,x3,x4','mean' 
USING PARAMETERS exclude_columns='pid', partition_columns='pclass,gender');
SELECT * FROM output_view_group; 
SELECT impute('output_view_mode','small_input_impute', 'pid, x5,x6','mode' 
                  USING PARAMETERS exclude_columns='pid');
SELECT * FROM output_view_mode;                   

-- normalization
select * from salary_data;
SELECT NORMALIZE('normalized_salary_data', 'salary_data', 'current_salary, years_worked', 'minmax');
SELECT * FROM normalized_salary_data;

--sampling
SELECT * FROM baseball TABLESAMPLE(25);

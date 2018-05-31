--kmeans clustering

--cluster using agar_dish_1 and apply the cluster on agar_dish_2

select * from  agar_dish_1 ;

select * from agar_1_view;

SELECT KMEANS('agar_dish_kmeans', 'agar_dish_1', '*', 5
                  USING PARAMETERS exclude_columns ='id', max_iterations=20, output_view='agar_1_view', 
                  key_columns='id');
                  
SELECT * FROM agar_1_view;

SELECT cluster_id, COUNT(cluster_id) FROM agar_1_view group by cluster_id;

SELECT SUMMARIZE_MODEL('agar_dish_kmeans');

CREATE TABLE kmeans_results AS
        (SELECT id,
                APPLY_KMEANS(x, y
                             USING PARAMETERS 
                                              model_name='agar_dish_kmeans') AS cluster_id
         FROM agar_dish_2);
         
select * from kmeans_results;         
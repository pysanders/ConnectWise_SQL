SELECT   TOP (1000) Opportunity_RecID, SUM(Revenue) AS RevSum, SUM(Cost) AS CostSum, Opp_Status_Name
FROM         dbo.v_api_collection_sales_opportunity_forecast
GROUP BY Opportunity_RecID, SO_Forecast_Type_ID, Opp_Status_Name
HAVING   (SO_Forecast_Type_ID = 'S')
ORDER BY Opportunity_RecID DESC
GO

# Surveys need to be setup to use one question with a scale of 0 - 10
SELECT     dbo.v_rpt_Surveys.SurveyYr, dbo.v_rpt_Surveys.SurveyQtr, MONTH(dbo.v_rpt_Surveys.Last_Update) AS SurveyMonth, dbo.v_rpt_Surveys.SurveyName, 
                      dbo.SR_Board.Board_Name AS Board, dbo.v_rpt_Surveys.Ticket AS TicketNbr, dbo.v_rpt_Surveys.CompanyName AS Company, dbo.SR_Service.Summary, 
                      dbo.v_rpt_Surveys.resources, dbo.v_rpt_Service.Hours_Actual, dbo.SR_Source.Description AS Source, dbo.SR_Urgency.Description AS Urgency, 
                      dbo.v_rpt_Service.Resolved_By, dbo.SR_Service.Date_Entered, dbo.v_rpt_Service.Date_Resplan_UTC, dbo.v_rpt_Service.Date_Resolved_UTC, 
                      dbo.SR_Service.Date_Closed, dbo.v_rpt_Surveys.Last_Update AS Survey_Completed, dbo.v_rpt_Surveys.Possible_Points AS Total_Possible_Points, 
                      dbo.v_rpt_Surveys.Points AS Total_Points, CASE WHEN Possible_Points = 5 THEN (100 * (SUM(CASE WHEN CAST([Points] AS INT) >= 5 THEN 1 ELSE 0 END) 
                      - SUM(CASE WHEN CAST([Points] AS INT) <= 3 THEN 1 ELSE 0 END)) / COUNT(*)) 
                      ELSE CASE WHEN Possible_Points = 10 THEN (100 * (SUM(CASE WHEN CAST([Points] AS INT) >= 9 THEN 1 ELSE 0 END) - SUM(CASE WHEN CAST([Points] AS INT) 
                      <= 5 THEN 1 ELSE 0 END)) / COUNT(*)) END END AS nps, dbo.v_rpt_Surveys.Comments, dbo.v_rpt_Surveys.ContactMe, MIN(NEWID()) AS id
FROM         dbo.SR_Board INNER JOIN
                      dbo.SR_Service ON dbo.SR_Board.SR_Board_RecID = dbo.SR_Service.SR_Board_RecID INNER JOIN
                      dbo.SR_Urgency ON dbo.SR_Service.SR_Urgency_RecID = dbo.SR_Urgency.SR_Urgency_RecID INNER JOIN
                      dbo.SR_Source ON dbo.SR_Service.SR_Source_RecID = dbo.SR_Source.SR_Source_RecID LEFT OUTER JOIN
                      dbo.v_rpt_Service ON dbo.SR_Service.SR_Service_RecID = dbo.v_rpt_Service.TicketNbr RIGHT OUTER JOIN
                      dbo.v_rpt_Surveys ON dbo.SR_Service.SR_Service_RecID = dbo.v_rpt_Surveys.Ticket
GROUP BY dbo.v_rpt_Surveys.SurveyYr, dbo.v_rpt_Surveys.SurveyQtr, dbo.v_rpt_Surveys.SurveyName, dbo.v_rpt_Surveys.CompanyName, dbo.v_rpt_Surveys.Ticket, 
                      dbo.v_rpt_Surveys.Last_Update, dbo.v_rpt_Surveys.Points, dbo.v_rpt_Surveys.Comments, dbo.v_rpt_Surveys.ContactMe, dbo.v_rpt_Surveys.resources, 
                      dbo.v_rpt_Surveys.Possible_Points, dbo.SR_Board.Board_Name, dbo.SR_Urgency.Description, dbo.SR_Service.Date_Entered, dbo.SR_Service.Summary, 
                      dbo.SR_Service.Date_Closed, dbo.SR_Source.Description, dbo.v_rpt_Service.Date_Resolved_UTC, dbo.v_rpt_Service.Date_Resplan_UTC, 
                      dbo.v_rpt_Service.Hours_Actual, dbo.v_rpt_Service.Resolved_By, MONTH(dbo.v_rpt_Surveys.Last_Update)
GO

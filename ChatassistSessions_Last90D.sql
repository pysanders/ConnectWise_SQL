SELECT     dbo.v_TE_TimeRecords.SR_Service_RecID AS ID, dbo.v_TE_TimeRecords.SR_Service_RecID, COUNT(*) AS Entries, dbo.v_rpt_Service.Last_Update, 
                      dbo.v_rpt_Service.date_entered, dbo.v_rpt_Service.date_closed, dbo.v_rpt_Service.status_description, dbo.v_rpt_Service.Summary, 
                      dbo.v_rpt_Service.company_name, dbo.v_rpt_Service.Updated_By, dbo.v_rpt_Service.Hours_Actual, dbo.v_rpt_Service.Responded_By, 
                      dbo.v_rpt_Service.Resolved_By, dbo.v_rpt_Service.Source, dbo.v_rpt_Service.Resplan_Minutes, dbo.v_rpt_Service.Resolved_Minutes, 
                      dbo.v_NPS.nps
FROM         dbo.v_TimeRecords INNER JOIN
                      dbo.v_TE_TimeRecords ON dbo.v_TimeRecords.Time_RecID = dbo.v_TE_TimeRecords.Time_RecID INNER JOIN
                      dbo.v_rpt_Service ON dbo.v_TE_TimeRecords.SR_Service_RecID = dbo.v_rpt_Service.SR_Service_RecID LEFT OUTER JOIN
                      dbo.v_NPS ON dbo.v_rpt_Service.SR_Service_RecID = NPS.TicketNbr
WHERE     (dbo.v_TimeRecords.Notes LIKE '%[0-9][0-9]:[0-9][0-9] [AP][M] - %')
GROUP BY dbo.v_TE_TimeRecords.SR_Service_RecID, dbo.v_rpt_Service.Last_Update, dbo.v_rpt_Service.date_entered, dbo.v_rpt_Service.date_closed, 
                      dbo.v_rpt_Service.status_description, dbo.v_rpt_Service.Summary, dbo.v_rpt_Service.company_name, dbo.v_rpt_Service.Updated_By, 
                      dbo.v_rpt_Service.Hours_Actual, dbo.v_rpt_Service.Responded_By, dbo.v_rpt_Service.Resolved_By, dbo.v_rpt_Service.Source, dbo.v_rpt_Service.Resplan_Minutes, 
                      dbo.v_rpt_Service.Resolved_Minutes, dbo.v_NPS.nps
HAVING      (dbo.v_rpt_Service.date_entered >= DATEADD(day, - 90, GETDATE()))

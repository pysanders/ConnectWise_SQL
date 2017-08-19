SELECT     s.TicketNbr AS id, s.TicketNbr AS Ticket_Number, s.company_name, co.Company_ID, co.Company_RecID, s.contact_name AS Contact, s.Source, s.team_name, 
                      s.Territory, s.Location, s.Board_Name AS Board, s.Summary, s.status_description AS Status, DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), 
                      CAST(s.date_entered AS DATETIME)) AS date_opened, DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), CAST(s.Last_Update AS DATETIME)) 
                      AS date_last_updated, DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE()), CAST(s.Date_Required AS DATETIME)) AS Date_Required, 
                      COALESCE (slaw.Responded_Minutes + slaw.Responded_Skipped_Minutes, 0) AS [Time_to_Acknowledgement(Minutes)], CAST(s.Date_Responded_UTC AS DATETIME)
                       AS acknowledgement_date, CASE WHEN slaw.Date_Responded_UTC IS NOT NULL 
                      THEN (CASE WHEN slaw.Responded_Minutes + slaw.Responded_skipped_minutes <= (CASE WHEN slap.Responded_Hours IS NOT NULL 
                      THEN slap.Responded_Hours ELSE sla.Responded_Hours END * 60) THEN 'Met' ELSE 'Unmet' END) ELSE NULL END AS MetResponseSLA, 
                      CAST(CAST(slaw.Resplan_Minutes + slaw.Resplan_Skipped_Minutes + slaw.Responded_Minutes AS DECIMAL(9, 2)) / 60.0 AS DECIMAL(10, 2)) 
                      AS [Time_to_Resolution_Plan(Hours)], CAST(s.Date_Resplan_UTC AS DATETIME) AS resolution_plan_date, CASE WHEN slaw.Date_Resplan_UTC IS NOT NULL 
                      THEN (CASE WHEN slaw.Resplan_Minutes + slaw.Resplan_Skipped_Minutes + slaw.Responded_Minutes <= (CASE WHEN slap.Resplan_Hours IS NOT NULL 
                      THEN slap.Resplan_Hours ELSE sla.Resplan_Hours END * 60) THEN 'Met' ELSE 'Unmet' END) ELSE NULL END AS MetResPlanSLA, 
                      CAST(CAST(slaw.Resolved_Minutes + slaw.Resplan_Minutes + slaw.Responded_Minutes AS DECIMAL(9, 2)) / 60.0 AS DECIMAL(10, 2)) 
                      AS [Time_to_Resolution(Hours)], CAST(s.Date_Resolved_UTC AS DATETIME) AS resolution_date, CASE WHEN slaw.Date_Resolved_UTC IS NOT NULL 
                      THEN (CASE WHEN slaw.Resolved_Minutes + slaw.resplan_minutes + slaw.responded_minutes <= (CASE WHEN slap.Resolution_Hours IS NOT NULL 
                      THEN slap.Resolution_Hours ELSE sla.Resolution_Hours END * 60) THEN 'Met' ELSE 'Unmet' END) ELSE NULL END AS MetResolutionSLA, DATEADD(hh, 
                      DATEDIFF(hh, GETDATE(), GETUTCDATE()), CAST(s.date_closed AS DATETIME)) AS date_closed, LOWER(s.Resolved_By) AS Resolved_By, LOWER(s.closed_by) 
                      AS Closed_By, CASE WHEN DATEDIFF(DD, s.date_entered, s.date_closed) = 0 THEN 'Y' ELSE 'N' END AS Same_day_close, CASE WHEN DATEDIFF(DD, 
                      s.Date_Responded_UTC, s.Date_Resolved_UTC) = 0 THEN 'Y' ELSE 'N' END AS Same_day_resolved, s.ServiceType AS Type, s.ServiceSubType AS SubType, 
                      s.ServiceSubTypeItem AS Service_Item, s.Urgency AS Priority, s.Severity, s.Impact, s.Hours_Actual, s.Hours_Budget, s.Hours_Scheduled, s.Hours_Billable, 
                      s.Hours_NonBillable, s.Hours_Invoiced, s.Hours_Agreement, s.agreement_name, CASE WHEN slaw.Date_Resolved_UTC IS NOT NULL 
                      THEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, slaw.Date_Resolved_UTC) / 24.0, 0) AS NUMERIC) ELSE CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, 
                      CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) END AS [Age (Days)], CASE WHEN slaw.Date_Resolved_UTC IS NULL 
                      THEN CASE WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) 
                      < 8 THEN '1. Current' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 7 AND CAST(ROUND(DATEDIFF(Hour, 
                      s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) < 15 THEN '2. 1 Week' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, 
                      CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 14 AND CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) 
                      < 22 THEN '3. 2 Weeks' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 21 AND 
                      CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) < 30 THEN '4. 3 Weeks' WHEN CAST(ROUND(DATEDIFF(Hour, 
                      s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 29 THEN '5. 1+ Month' END ELSE 'Resolved' END AS [Unresolved Age (Weeks)], 
                      CASE WHEN s.date_closed IS NULL THEN CASE WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) 
                      < 8 THEN '1. Current' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 7 AND CAST(ROUND(DATEDIFF(Hour, 
                      s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) < 15 THEN '2. 1 Week' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, 
                      CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 14 AND CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) 
                      < 22 THEN '3. 2 Weeks' WHEN CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 21 AND 
                      CAST(ROUND(DATEDIFF(Hour, s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) < 30 THEN '4. 3 Weeks' WHEN CAST(ROUND(DATEDIFF(Hour, 
                      s.Date_Entered, CURRENT_TIMESTAMP) / 24.0, 0) AS NUMERIC) > 29 THEN '5. 1+ Month' END ELSE 'Resolved' END AS [Unsolved Age (Weeks)], 
                      CASE WHEN (s.date_resolved_utc IS NOT NULL) THEN 'Resolved' ELSE 'Open' END AS Resolved_Flag, CASE WHEN (s.Date_Closed IS NOT NULL) 
                      THEN 'Closed' ELSE 'Open' END AS Closed_Flag, CASE WHEN (sch.RecID IS NOT NULL) THEN 'Y' ELSE 'N' END AS Is_Assigned, 
                      sr.CustUpdate_Flag AS Customer_Responded, CONVERT(CHAR(8), s.date_entered, 112) AS Date_Entered_NT, CASE WHEN
                          (SELECT     TOP 1 c.sr_service_recid
                            FROM          SR_Config c
                            WHERE      ticketnbr = c.sr_service_recid) IS NULL THEN 'False' ELSE 'True' END AS Config_Attached, m.Member_ID AS SA, YEAR(s.date_entered) AS YearOpen, 
                      MONTH(s.date_entered) AS MonthOpen, { fn WEEK(s.date_entered) } AS WeekOpen
FROM         dbo.Company AS co RIGHT OUTER JOIN
                      dbo.v_rpt_Service AS s ON co.Company_RecID = s.company_recid LEFT OUTER JOIN
                          (SELECT     RecID
                            FROM          dbo.Schedule
                            GROUP BY RecID) AS sch ON s.TicketNbr = sch.RecID LEFT OUTER JOIN
                      dbo.SR_Service_SLA_Workflow AS slaw ON s.TicketNbr = slaw.SR_Service_RecID LEFT OUTER JOIN
                      dbo.SR_Service AS sr ON s.TicketNbr = sr.SR_Service_RecID LEFT OUTER JOIN
                      dbo.SR_Urgency AS sru ON sr.SR_Urgency_RecID = sru.SR_Urgency_RecID LEFT OUTER JOIN
                      dbo.SR_SLA AS sla ON sr.SR_SLA_RecID = sla.SR_SLA_RecID LEFT OUTER JOIN
                      dbo.SR_SLAPriority AS slap ON sr.SR_SLA_RecID = slap.SR_SLA_RecID AND sru.SR_Urgency_RecID = slap.SR_Urgency_RecID LEFT OUTER JOIN
                      dbo.Company_Team AS ct ON co.Company_RecID = ct.Company_RecID AND ct.Tech_Flag = 1 LEFT OUTER JOIN
                      dbo.Member AS m ON m.Member_RecID = ct.Member_RecID
WHERE     (DATEDIFF(DAY, s.date_entered, CURRENT_TIMESTAMP) <= 180) AND (s.Parent IS NULL)
GO

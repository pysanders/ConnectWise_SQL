# Requires the member record to have a daily capacity set and certian charge codes setup, may need to change to match your data
SELECT        cal.Office_Calendar_Date AS [Date], cal.Office_Calendar_Name, cal.Office_Calendar_RecID, cal.NW_Flag, CASE WHEN cal.NW_Flag = 1 THEN 'N' ELSE 'Y' END AS Working_Day, m.Member_RecID, 
                         m.Member_ID, m.First_Name + ' ' + m.Last_Name AS Member_Name, m.Inactive_Flag, bu.Description AS BusGroup, ol.Description AS Location, CASE WHEN cal.NW_Flag = 0 THEN ISNULL(m.Daily_Capacity, 0) ELSE 0 END AS Schedule_Capacity, 
                         CASE WHEN cal.NW_Flag = 0 THEN ISNULL(m.Daily_Capacity, 0) ELSE 0 END AS Working_Capacity, ISNULL(m.Billable_Forecast, 0) AS Billable_Forecast, m.Utilization_Flag AS Member_Utilization_Flag, 
                         ISNULL(te2.Hours_Actual, 0) AS Hours_Actual, ISNULL(te2.Hours_Bill, 0) AS Hours_Bill, ISNULL(te2.Hours_Invoiced, 0) AS Hours_Invoiced, ISNULL(te2.Hours_Actual_Billable, 0) AS Hours_Actual_Billable, 
                         ISNULL(te2.Hours_Bill_Billable, 0) AS Hours_Bill_Billable, ISNULL(te2.Hours_Invoiced_Billable, 0) AS Hours_Invoiced_Billable, ISNULL(te2.Hours_Actual_Non_Billable, 0) AS Hours_Actual_Non_Billable, 
                         ISNULL(te2.Hours_Bill_Non_Billable, 0) AS Hours_Bill_Non_Billable, ISNULL(te2.Hours_Invoiced_Non_Billable, 0) AS Hours_Invoiced_Non_Billable, ISNULL(te2.Hours_Actual_Utilized, 0) 
                         AS Hours_Actual_Utilized, ISNULL(te2.Hours_Bill_Utilized, 0) AS Hours_Bill_Utilized, ISNULL(te2.Hours_Actual_Billable_Utilized, 0) AS Hours_Actual_Billable_Utilized, ISNULL(te2.Hours_Bill_Billable_Utilized, 
                         0) AS Hours_Bill_Billable_Utilized, ISNULL(te2.Hours_Invoiced_Billable_Utilized, 0) AS Hours_Invoiced_Billable_Utilized, ISNULL(te2.Hours_Actual_Non_Billable_Utilized, 0) 
                         AS Hours_Actual_Non_Billable_Utilized, ISNULL(te2.Hours_Bill_Non_Billable_Utilized, 0) AS Hours_Bill_Non_Billable_Utilized, ISNULL(te2.Hours_Invoiced_Non_Billable_Utilized, 0) 
                         AS Hours_Invoiced_Non_Billable_Utilized, ISNULL(te2.Hours_Actual_PTO, 0) AS Hours_Actual_PTO, ISNULL(te2.Hours_Actual_Admin, 0) AS Hours_Actual_Admin, ISNULL(te2.Hours_Actual_Holiday, 0) 
                         AS Hours_Actual_Holiday, ISNULL(te2.Hours_Actual_TeamLead, 0) AS Hours_Actual_TeamLead, ISNULL(te2.Hours_Actual_TicketClean, 0) AS Hours_Actual_TicketClean, ISNULL(te2.Hours_Actual_PartnerEngage, 
                         0) AS Hours_Actual_PartnerEngage, [Reports_To], Member_Type_RecID, NEWID() AS id
FROM            dbo.Member AS m INNER JOIN
                         dbo.Billing_Unit AS bu ON bu.Billing_Unit_RecID = m.Billing_Unit_RecID INNER JOIN
                         dbo.Owner_Level AS ol ON ol.Owner_Level_RecID = m.Owner_Level_RecID CROSS APPLY
                             (SELECT        ocwd.Office_Calendar_Date, ocwd.NW_Flag, oc.Description AS Office_Calendar_Name, ocwd.Office_Calendar_RecID
                               FROM            dbo.Office_Calendar_Working_Days AS ocwd INNER JOIN
                                                         dbo.Office_Calendar AS oc ON oc.Office_Calendar_RecID = ocwd.Office_Calendar_RecID
                               WHERE        ocwd.Office_Calendar_RecID = dbo.udf_getMemberCalendar(m.Member_RecID) AND ocwd.Office_Calendar_Date >= DATEADD(YEAR, - 2, GETDATE()) AND 
                                                         ocwd.Office_Calendar_Date <= dateadd(DAY, 30, GETDATE())) cal OUTER APPLY
                             (SELECT        /*Summarize Hours withOUT respect to if it billable or not  and without respect if it is a utilized work type*/ SUM(te.Hours_Actual) AS Hours_Actual, SUM(te.Hours_Bill) AS Hours_Bill, 
                                                         SUM(te.Hours_Invoiced) AS Hours_Invoiced, /*Summarize Hours WITH respect to if it billable or not and without respect if it is a utilized work type*/ SUM(te.Hours_Actual * te.Billable_Flag) 
                                                         AS Hours_Actual_Billable, SUM(te.Hours_Bill * te.Billable_Flag) AS Hours_Bill_Billable, SUM(te.Hours_Invoiced * te.Billable_Flag) AS Hours_Invoiced_Billable, 
                                                         /*Summarize non-billable hours and without respect if it is a utilized work type*/ SUM(CASE WHEN te.Billable_Flag = 0 THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_Non_Billable, 
                                                         SUM(CASE WHEN te.Billable_Flag = 0 THEN te.Hours_Bill ELSE 0 END) AS Hours_Bill_Non_Billable, SUM(CASE WHEN te.Billable_Flag = 0 THEN te.Hours_Invoiced ELSE 0 END) 
                                                         AS Hours_Invoiced_Non_Billable, /*Summarize hours with work type of "Utilized" without repect to billable flag*/ SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Actual ELSE 0 END) 
                                                         AS Hours_Actual_Utilized, SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Bill ELSE 0 END) AS Hours_Bill_Utilized, 
                                                         SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Invoiced ELSE 0 END) AS Hours_Invoiced_Utilized, 
                                                         /*Summarize hours with work type of "Utilized" with respect to billable*/ SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Actual * te.billable_flag ELSE 0 END) 
                                                         AS Hours_Actual_Billable_Utilized, SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Bill * te.billable_flag ELSE 0 END) AS Hours_Bill_Billable_Utilized, 
                                                         SUM(CASE WHEN a.Utilization_Flag = 1 THEN te.Hours_Invoiced * te.billable_flag ELSE 0 END) AS Hours_Invoiced_Billable_Utilized, 
                                                         /*Summarize hours with work type of "Utilized" non-billable*/ SUM(CASE WHEN a.Utilization_Flag = 1 AND te.Billable_Flag = 0 THEN te.Hours_Actual ELSE 0 END) 
                                                         AS Hours_Actual_Non_Billable_Utilized, SUM(CASE WHEN a.Utilization_Flag = 1 AND te.Billable_Flag = 0 THEN te.Hours_Bill ELSE 0 END) AS Hours_Bill_Non_Billable_Utilized, 
                                                         SUM(CASE WHEN a.Utilization_Flag = 1 AND te.Billable_Flag = 0 THEN te.Hours_Invoiced ELSE 0 END) AS Hours_Invoiced_Non_Billable_Utilized, 
                                                         /*Summarize Admin, PTO,  Holiday, Team Lead, and Ticket Cleanup*/ SUM(CASE WHEN te.Activity_Type_RecID IN (10, 35, 4, 53, 9, 3, 11, 7, 37, 38, 39, 19, 13, 57, 54, 52, 61, 62, 49) 
                                                         THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_Admin, SUM(CASE WHEN te.te_charge_code_recid = '2' THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_PTO, 
                                                         SUM(CASE WHEN te.te_charge_code_recid = '74' THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_Holiday, 
                                                         SUM(CASE WHEN te.te_charge_code_recid = '75' THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_TicketClean, 
                                                         SUM(CASE WHEN te.te_charge_code_recid = '76' THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_TeamLead, 
                                                         SUM(CASE WHEN te.te_charge_code_recid = '92' THEN te.Hours_Actual ELSE 0 END) AS Hours_Actual_PartnerEngage
                               FROM            dbo.Time_Entry AS te INNER JOIN
                                                         dbo.Activity_Type a ON a.Activity_Type_RecID = te.Activity_Type_RecID
                               WHERE        CONVERT(DATE, te.Date_Start) = CONVERT(DATE, cal.Office_Calendar_Date) AND m.Member_RecID = te.Member_RecID 
                               GROUP BY CONVERT(DATE, te.Date_Start), te.Member_RecID) te2
WHERE        m.System_Flag = 0
GO

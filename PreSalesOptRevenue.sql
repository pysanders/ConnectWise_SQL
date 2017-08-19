SELECT DISTINCT 
                         dbo.v_rpt_Opportunity.Sales_Rep1_FullName AS [Sales Rep], dbo.v_rpt_Opportunity.Company_Name AS Company, dbo.v_rpt_Opportunity.Opportunity_RecID, 
                         dbo.v_rpt_Opportunity.Opportunity_Name AS Opportunity, dbo.v_rpt_Opportunity.Status AS Opt_Status, dbo.v_rpt_Opportunity.Expected_Close_Date AS Opt_Close_Date, 
                         dbo.v_rpt_Service.TicketNbr AS Ticket#, dbo.v_rpt_Service.status_description AS [Pre-Sales_Status], dbo.v_rpt_Service.Last_Update AS Svc_Last_Update, 
                         dbo.v_CompanyTeam_List.member_id AS SA, dbo.v_rpt_Opportunity.Service_Revenue AS Opt_Service_Rev, dbo.v_rpt_Service.date_closed, 
                         dbo.v_rpt_Opportunity.Product_Revenue AS Opt_Product_Rev, dbo.v_rpt_Opportunity.Agreement_Revenue AS Opt_Agreement_Rev, 
                         dbo.v_rpt_Opportunity.Other1_Revenue AS Opt_Other1_Rev, dbo.v_rpt_Opportunity.Other2_Revenue AS Opt_Other2_Rev, 
                         dbo.v_rpt_Opportunity.Total_Revenue AS Opt_Total_Rev, dbo.v_rpt_Service.TicketNbr, dbo.PM_Project.PM_Project_RecID, dbo.v_rpt_ProjectHeader.Project_Name, 
                         dbo.v_rpt_ProjectHeader.Project_Manager, dbo.v_rpt_ProjectHeader.Estimated_Start_Date AS Project_EstStartDate, 
                         dbo.v_rpt_ProjectHeader.Estimated_End_Date AS Project_EstEndDate, dbo.v_rpt_ProjectHeader.Project_Status, 
                         dbo.v_rpt_ProjectHeader.Closed_Flag AS Project_ClosedFlag, dbo.v_rpt_ProjectHeader.Hours_Budget AS Project_HrsBudget, 
                         dbo.v_rpt_ProjectHeader.Hours_Actual AS Project_HrsActual, dbo.v_PreSalesOptRevenueSums.CostSum AS Service_CostSum, 
                         CASE WHEN dbo.v_PreSalesOptRevenueSums.RevSum IS NULL 
                         THEN dbo.v_rpt_Opportunity.Service_Revenue ELSE dbo.v_PreSalesOptRevenueSums.RevSum END AS Service_RevSum
FROM         dbo.v_rpt_Service WITH (NOLOCK) INNER JOIN
                         dbo.v_rpt_Opportunity WITH (NOLOCK) ON dbo.v_rpt_Opportunity.Opportunity_RecID = dbo.v_rpt_Service.Opportunity_RecID LEFT OUTER JOIN
                         dbo.v_PreSalesOptRevenueSums ON 
                         dbo.v_rpt_Opportunity.Opportunity_RecID = dbo.v_PreSalesOptRevenueSums.Opportunity_RecID LEFT OUTER JOIN
                         dbo.PM_Project INNER JOIN
                         dbo.v_rpt_ProjectHeader ON dbo.PM_Project.PM_Project_RecID = dbo.v_rpt_ProjectHeader.PM_Project_RecID ON 
                         dbo.v_rpt_Opportunity.Opportunity_RecID = dbo.PM_Project.Opportunity_RecID RIGHT OUTER JOIN
                         dbo.v_CompanyTeam_List WITH (NOLOCK) ON dbo.v_CompanyTeam_List.company_recid = dbo.v_rpt_Service.company_recid
WHERE     (dbo.v_rpt_Service.Board_Name = N'Pre-Sales') AND (dbo.v_CompanyTeam_List.role_desc = 'Solutions Architect')
GO

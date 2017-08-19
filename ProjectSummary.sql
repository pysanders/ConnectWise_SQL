WITH proj AS (SELECT     dbo.PM_Team.Member_ID AS manager, dbo.PM_Project.PM_Project_RecID, dbo.PM_Project.Project_ID, dbo.PM_Project.Company_RecID, 
                                                      dbo.Company.Company_Name, dbo.PM_Project.PM_Status_RecID, dbo.PM_Status.Description AS status, dbo.PM_Status.Closed_Flag, 
                                                      dbo.PM_Project.Invoice_Flag, dbo.PM_Project.PM_Billing_Method_ID AS billing_method, dbo.PM_Project.SR_Board_RecID, 
                                                      dbo.SR_Board.Board_Name, dbo.PM_Project.Budget_Flag, dbo.PM_Project.Est_Hours,
                                                          (SELECT     SUM(dbo.SR_Service.Hours_Budget) AS Expr1
                                                            FROM          dbo.SR_Service WITH (nolock) INNER JOIN
                                                                                   dbo.PM_Phase WITH (nolock) ON dbo.SR_Service.PM_Phase_RecID = dbo.PM_Phase.PM_Phase_RecID AND 
                                                                                   dbo.PM_Phase.PM_Project_RecID = dbo.PM_Project.PM_Project_RecID) AS hours_budget,
                                                          (SELECT     SUM(Hours_Actual) AS Expr1
                                                            FROM          dbo.Time_Entry WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID)) AS hours_actual,
                                                          (SELECT     SUM(Hours_Bill) AS Expr1
                                                            FROM          dbo.Time_Entry AS Time_Entry_4 WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID)) AS hours_bill,
                                                          (SELECT     SUM(Hours_Bill) AS Expr1
                                                            FROM          dbo.Time_Entry AS Time_Entry_3 WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID) AND (Billable_Flag = 1)) AS hours_bill_billable,
                                                          (SELECT     SUM(Hours_Actual * dbo.udf_EncrDecr(Hourly_Cost, 'D')) AS Expr1
                                                            FROM          dbo.Time_Entry AS Time_Entry_2 WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID)) AS hours_cost,
                                                          (SELECT     SUM(Hours_Bill * Hourly_Rate) AS Expr1
                                                            FROM          dbo.Time_Entry AS Time_Entry_1 WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID) AND (Billable_Flag = 1)) AS hours_fee, 
                                                      dbo.PM_Project.Billing_Amount AS flat_fee,
                                                          (SELECT     SUM(Billing_Amount) AS Expr1
                                                            FROM          dbo.PM_Phase AS PM_Phase_1 WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID) AND (Add_On_Flag = 'true') AND (SR_Billing_Method_ID = 'F')) 
                                                      AS add_on_phases,
                                                          (SELECT     SUM(Invoice_Amount) AS Expr1
                                                            FROM          dbo.Billing_Log WITH (nolock)
                                                            WHERE      (PM_Project_RecID = dbo.PM_Project.PM_Project_RecID)) AS invoice_amount
                               FROM         dbo.PM_Project WITH (nolock) INNER JOIN
                                                      dbo.PM_Team WITH (nolock) ON dbo.PM_Project.PM_Project_RecID = dbo.PM_Team.PM_Project_RecID INNER JOIN
                                                      dbo.PM_Role WITH (nolock) ON dbo.PM_Team.PM_Role_RecID = dbo.PM_Role.PM_Role_RecID AND dbo.PM_Role.Manager_Flag = 1 INNER JOIN
                                                      dbo.PM_Status WITH (nolock) ON dbo.PM_Project.PM_Status_RecID = dbo.PM_Status.PM_Status_RecID INNER JOIN
                                                      dbo.Company WITH (nolock) ON dbo.PM_Project.Company_RecID = dbo.Company.Company_RecID LEFT OUTER JOIN
                                                      dbo.SR_Board WITH (nolock) ON dbo.PM_Project.SR_Board_RecID = dbo.SR_Board.SR_Board_RecID)
    SELECT     manager, PM_Project_RecID, Project_ID, Company_RecID, Company_Name, PM_Status_RecID, status, Closed_Flag, Invoice_Flag, billing_method, 
                            SR_Board_RecID, Board_Name, Budget_Flag, Est_Hours, hours_budget, hours_actual, hours_bill, hours_bill_billable, hours_cost, hours_fee, flat_fee
     FROM         proj AS proj_1
GO

SELECT     dbo.v_rpt_Invoices.Company_Name, dbo.v_rpt_Invoices.Invoice_Number, dbo.v_rpt_Invoices.Date_Invoice, dbo.v_rpt_InvoiceProduct.Item_ID, 
                      dbo.v_rpt_InvoiceProduct.Item_Desc, dbo.v_rpt_InvoiceProduct.Quantity, dbo.v_rpt_InvoiceProduct.Unit_Price, dbo.v_rpt_InvoiceProduct.Extended_Amt, 
                      dbo.v_rpt_InvoiceProduct.Last_Update, dbo.v_rpt_Invoices.CompanyRecId
FROM         dbo.v_rpt_InvoiceProduct INNER JOIN
                      dbo.v_rpt_Invoices ON dbo.v_rpt_InvoiceProduct.Billing_Log_RecID = dbo.v_rpt_Invoices.Billing_Log_RecID
WHERE     (dbo.v_rpt_InvoiceProduct.Extended_Amt < - 1) AND (dbo.v_rpt_Invoices.Invoice_Number LIKE 'MSP%')
GO

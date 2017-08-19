SELECT     TOP (100) PERCENT Parent AS id, COUNT(*) AS TotalCount
FROM         dbo.v_rpt_Service
WHERE     (date_entered >= DATEADD(day, - 90, GETDATE())) AND (Board_Name LIKE 'NOC%') AND (Parent IS NOT NULL)
GROUP BY Parent
HAVING      (COUNT(*) > 1)
ORDER BY TotalCount DESC
GO

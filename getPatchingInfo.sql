USE CM_SITE;
GO
DECLARE @SystemName nvarchar(15) = '';

WITH PatchCompliance(ResourceID,CI_ID,Compliant)
AS
(
SELECT DISTINCT
	RSYS.ResourceID,
	UCS.CI_ID,
	UCS.Status AS Compliant
FROM v_R_System RSYS
JOIN v_Update_ComplianceStatusAll UCS
	ON UCS.ResourceID = RSYS.ResourceID
JOIN v_UpdateInfo UI
	ON UI.CI_ID = UCS.CI_ID
JOIN v_CICategoryInfo_All CICIA 
	ON UCS.CI_ID = CICIA.CI_ID
	AND CICIA.CategoryTypeName = 'UpdateClassification'
WHERE
	RSYS.Name0 = @SystemName
	AND CICIA.CategoryInstanceName = 'Security Updates'
	AND UI.ArticleID like '[1-9]%'
	AND UI.IsSuperseded = 0
	AND UI.IsExpired = 0
)

SELECT DISTINCT
	UI.BulletinID,
	UI.ArticleID,
	UI.Title,
	CASE PC.Compliant
		WHEN 3 THEN 'Installed'
		WHEN 2 THEN 'Required'
		WHEN 1 THEN 'NotApplicable'
		WHEN 0 THEN 'Unknown'
	ELSE 'Error'
	END AS Status
FROM PatchCompliance PC
JOIN v_R_System RSYS
	ON RSYS.ResourceID = PC.ResourceID
JOIN v_UpdateInfo UI
	ON UI.CI_ID = PC.CI_ID
WHERE PC.Compliant IN (0, 1, 2, 3)
ORDER by Status

use CM_SITE

select sys.name0 [Computername]
  from v_updateinfo ui
 inner join v_UpdateComplianceStatus ucs on ucs.ci_id=ui.ci_id
 join v_CICategories_All catall2 on catall2.CI_ID=UCS.CI_ID
 join v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID and catinfo2.CategoryTypeName='UpdateClassification'
 join v_R_System sys on sys.resourceid=ucs.resourceid
 and ucs.status='2' -- required
 AND (ui.bulletinid='MS15-058' OR ui.articleid='3045321')
 GROUP BY sys.name0
 order by sys.name0
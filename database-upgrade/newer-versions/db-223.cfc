<cfcomponent implements="zcorerootmapping.interface.databaseVersion">
<cfoutput>
<cffunction name="getChangedTableArray" localmode="modern" access="public" returntype="array">
	<cfscript>
	arr1=[];
	return arr1;
	</cfscript>
</cffunction>

<cffunction name="executeUpgrade" localmode="modern" access="public" returntype="boolean">
	<cfargument name="dbUpgradeCom" type="component" required="yes">
	<cfscript>   
 	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `site`   
  ADD COLUMN `site_exclude_lead_type_list` VARCHAR(255) NOT NULL AFTER `site_report_company_name`,
  ADD COLUMN `site_report_start_date` DATE NOT NULL AFTER `site_exclude_lead_type_list`")){
		return false;
	}   

	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
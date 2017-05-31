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
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `inquiries`   
  CHANGE `inquiries_external_id` `inquiries_external_id` VARCHAR(64) CHARSET utf8 COLLATE utf8_general_ci NOT NULL")){		return false;	}
	 
	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
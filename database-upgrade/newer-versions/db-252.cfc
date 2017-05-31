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
 	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `listing_data`   
  ADD COLUMN `listing_data_json` LONGTEXT NOT NULL AFTER `listing_data_deleted`")){
		return false;
	}         

	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
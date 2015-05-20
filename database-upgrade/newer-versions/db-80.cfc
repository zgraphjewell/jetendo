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
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `event_config`   
  ADD COLUMN `event_config_enable_suggest_event` CHAR(1) DEFAULT '0'  NOT NULL AFTER `event_config_event_next_recur_url_id`")){
		return false;
	}  

	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
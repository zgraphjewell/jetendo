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
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `authorize_net_relay_log`   
  ADD COLUMN `authorize_net_relay_log_key` CHAR(64) NOT NULL AFTER `authorize_net_relay_log_deleted`")){
		return false;
	}  
	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
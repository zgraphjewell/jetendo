<cfcomponent>
<cfoutput>
<cffunction name="getConfig" localmode="modern" returntype="struct">
	<cfargument name="tempCGI" type="struct" required="yes">
	<cfscript>
	
	var ts=structnew();
	// install path of this Application.cfc - It must end with a forward slash.
	ts.zOS = StructNew();
	// domain to append to ALL of your test domains.
	ts.zos.testDomain="dev.com";
	ts.zos.testManagerDomain="devsecure.com"; 
	if(findnocase("."&ts.zos.testDomain, arguments.tempCgi.http_host) NEQ 0 or findnocase("."&ts.zos.testManagerDomain, arguments.tempCgi.http_host) NEQ 0){
		ts.zos.installPath="/opt/jetendo/";
		ts.zOS.istestserver=true;
	}else{
		ts.zos.installPath="/opt/jetendo/";
		ts.zOS.istestserver=false;
	}
	if(structkeyexists(server, "jetendo_"&ts.zos.installPath&"_globalscache") and structkeyexists(form,'zreset') EQ false){
		return duplicate(server["jetendo_"&ts.zos.installPath&"_globalscache"]); 
	}
	
	// sign up for grammarly's affiliate program and replace this url with a tracking url provided by their system to earn commission.
	ts.zos.grammarlyTrackingURL="http://tr.grammarly.com/aff_c?offer_id=37&aff_id=3187";
	
	if(ts.zos.istestserver){
		ts.zos.defaultSSLManagerDomain="";
		ts.zos.defaultPasswordVersion=2; // Valid values are 0 - no hash,1 - hash with many iterations or 2 scrypt java.
		ts.zos.passwordExpirationTimeSpan=createtimespan(180, 0, 0, 0); // 180 days is the default
		ts.zos.isJavaEnabled=false;
		ts.zos.isImplicitScopeCheckEnabled=true;
		ts.zos.isExecuteEnabled=false;
		ts.zOS.thisistestserver=true;
		ts.zos.directoryMode=777;
		ts.zos.fileMode=777;
		ts.zos.sambaInstallPath="C:/serverData/jetendo/";
		ts.zos.scriptsPath="/opt/jetendo/scripts/";
		ts.zos.sharedPath="/opt/jetendo/share/";
		ts.zos.sharedPathForDatabase="/opt/jetendo/share/";
		ts.zos.backupDirectory="/zbackup/backup/";
		ts.zos.mysqlBackupDirectory="/zbackup/backup/";
		ts.zos.sitesWritablePath="/opt/jetendo/sites-writable/";
		ts.zos.sitesPath="/opt/jetendo/sites/";
		
		// The database name MUST match the datasource name.
		ts.zos.zcoreDatasource="zcore"; 
		ts.zos.zcoreTempDatasource="ztemp"; 
		ts.zOS.insertIDColumnForSiteIDTable="id2";
		ts.zOS.railoUser="nginx";
		ts.zos.allowRequestCFC=true;
		ts.zOS.railoAdminReadEnabled=true;
	}else{ 
		ts.zos.defaultSSLManagerDomain=""; // leave blank until you install a wildcard ssl certificate on this domain's ip.
		ts.zos.defaultPasswordVersion=2; // Valid values are 0 - no hash,1 - hash with many iterations or 2 scrypt java.
		ts.zos.passwordExpirationTimeSpan=createtimespan(180, 0, 0, 0); // 180 days is the default
		ts.zos.allowRequestCFC=true;
		ts.zos.isImplicitScopeCheckEnabled=false;
		ts.zos.isJavaEnabled=false;
		ts.zos.isExecuteEnabled=false;
		ts.zOS.thisistestserver=false;
		ts.zos.directoryMode=770;
		ts.zos.fileMode=660;
		ts.zos.sambaInstallPath="/opt/jetendo/";
		ts.zos.scriptsPath="/opt/jetendo/scripts/";
		ts.zos.sharedPath="/opt/jetendo/share/";
		ts.zos.sharedPathForDatabase="/opt/jetendo/share/";
		ts.zos.installPath="/opt/jetendo/";
		ts.zos.sitesPath="/opt/jetendo/sites/";
		ts.zos.sitesWritablePath="/opt/jetendo/sites-writable/";
		ts.zos.backupDirectory="/opt/jetendo/mysqlbackup/";
		ts.zos.mysqlBackupDirectory="/opt/jetendo/mysqlbackup/";
		// The database name MUST match the datasource name.
		ts.zos.zcoreDatasource="zcore"; 
		ts.zos.zcoreTempDatasource="ztemp";
		ts.zOS.insertIDColumnForSiteIDTable="id2";
		ts.zOS.railoUser="nginx";
		ts.zOS.railoAdminReadEnabled=false;
	};
	ts.zOS.railoAdminWriteEnabled=false; // must be enabled to allow deploying railo archives.
	ts.zos.errorEmailAlertsPerMinute=5;
	
	ts.zos.zcoreTestHost="test.your-company.com.dev.com";
		
	ts.zos.scriptDirectory="/opt/jetendo/scripts/";
	ts.zos.backupStructureOnlyTables={
		ts.zos.zcoreDatasource&".site":true, // the site table shouldn't be able to be imported at all since this could cause sites to be lost.  That kind of migration should replace entire database manually.
		ts.zos.zcoreDatasource&".listing_x_site":true, // this table is too large to backup all the time.
		// these tables contain data that is temporary in nature and shouldn't need to be migrated between servers
		ts.zos.zcoreDatasource&".login_log":true,
		ts.zos.zcoreDatasource&".user_token":true, 
		ts.zos.zcoreDatasource&".log":true,
		ts.zos.zcoreDatasource&".ip_block":true
	};
        
		
    ts.zos.adminIpStruct=structnew();
    // developer ips - always set to false;  define one key for each developer
    ts.zos.adminIpStruct["10.0.3.2"]=false;
    ts.zos.adminIpStruct["192.168.56.1"]=false;


    // localhost is always a server ip - always set to true
    ts.zOS.adminIpStruct["127.0.0.1"]=true;
        
		
	// new server ips - define one key for each ip
    ts.zos.adminIpStruct["your.production.server.ip"]=true;
    
    // test server ips - always set to true | note this also allows the test server to auto-login to the production server
    ts.zOS.adminIpStruct["192.168.56.104"] = true;
    ts.zOS.adminIpStruct["192.168.56.105"] = true;
    
    // dev email info - all error alerts, notifications will be from and to these addresses.
    ts.zOS.developerEmailFrom="server@your-company.com";
    ts.zOS.developerEmailTo="developer@your-company.com";
    
    // global site administration live domain - It must NOT end with a forward slash.
    ts.zOS.zcoreAdminDomain="https://jetendo.your-company.com";
    
    // global site administration test domain - It must NOT end with a forward slash.
    ts.zOS.zcoreTestAdminDomain="http://jetendo.your-company.com.dev.com";
	ts.zOS.zcoreTestAdminRailoPassword="your_railo_password";
    
    
    
    ts.zos.serverSessionVariable="zsessionid";
    
    // port defined for the java server connector when using SSL - used to detect a secure connection instead of port 443.
    ts.zos.alternatesecureport="8889";
    
    // google recaptcha key - http://www.google.com/recaptcha/ - domain name: global-key.farbeyondcode.com
    ts.zos.recaptchaPrivateKey="";
    
    
    // administration site - It must end with a forward slash.
    ts.zos.zcoreRootPath=ts.zos.installPath&"core/";
    
    // non-public path for administration site - It must end with a forward slash.
    ts.zos.zcoreRootPrivatePath=ts.zos.sitesWritablePath&"jetendo_your-company_com/";
    
    // cache folder for the administration site - It must end with a forward slash.
    ts.zos.zcoreRootCachePath=ts.zos.sitesWritablePath&"jetendo_your-company_com/_cache/";
     
    // cfml mapping which should point to the same path as ts.zos.zcoreRootPath
    ts.zos.zcoremapping="zcorerootmapping";
    
    // cfml mapping which should point to the same path as ts.zos.zcoreRootCachePath
    ts.zos.zcorecachemapping="zcorecachemapping";
    
    // cgi variable name that contains the url for routing engine.
    ts.zos.urlRoutingParameter="_zsa3_path";
    
    
	
	ts.zos.testDnsServer="192.168.56.1";
	ts.zos.dnsServer="8.8.8.8";
	
    ts.zos.excludeDatasourcesFromBackup={
		"information_schema":true,
		"mysql":true,
		"performance_schema":true
	};
	
    ts.zos.zcoreDatasourcePrefix="";
    
    // prepend a string that identifies mysql memory engine tables
    ts.zos.ramtableprefix="zram##";
    
    // prepend a string to the beginning of all system table names - currently not implemented.
    ts.zos.zcoreDBPrefix="";
    
    // A third datasource can be defined in the global settings for each site in the admin portal.

	server["jetendo_"&ts.zos.installPath&"_globalscache"]=ts;

    return ts;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
<cfcomponent>
<cfoutput>
	<cfscript>
    variables.idxExclude=structnew();
	variables.allfields=structnew();
    </cfscript>
	<cffunction name="findFieldsInDatabaseNotBeingOutput" localmode="modern" access="remote" roles="member" output="yes" returntype="any">
    	<cfscript>
	application.zcore.listingCom.makeListingImportDataReady();
	idxExclude={};
	tf=application.zcore.listingStruct.mlsStruct["25"].sharedStruct.metaStruct["property"].tableFields;
	n=0;
	for(curField in tf){  
		f2=tf[curField].longname; 
		n++;
		variables.allfields[n]={field:"rets25_"&curField, label:f2};
	}
		idxExclude["rets25_virtualtoururl2"]="Virtual Tour Url 2";
idxExclude["rets25_agentfax"]="Agent Fax";
idxExclude["rets25_agenthomepage"]="Agent Home Page";
idxExclude["rets25_agentofficeext"]="Agent Office Ext";
idxExclude["rets25_agentpagercell"]="Agent Pager Cell";
idxExclude["rets25_colistagentdirectworkphone"]="Co List Agent Direct Work Phone";
idxExclude["rets25_colistagentfullname"]="Co List Agent Full Name";
idxExclude["rets25_colistagentmlsid"]="Co List Agent Mlsid";
idxExclude["rets25_colistofficemlsid"]="Co List Office Mlsid";
idxExclude["rets25_colistofficename"]="Co List Office Name";
idxExclude["rets25_cosellingagentfullname"]="Co Selling Agent Full Name";
idxExclude["rets25_cosellingagentmlsid"]="Co Selling Agent Mlsid";
idxExclude["rets25_cosellingofficemlsid"]="Co Selling Office Mlsid";
idxExclude["rets25_cosellingofficename"]="Co Selling Office Name";
idxExclude["rets25_listagentdirectworkphone"]="List Agent Direct Work Phone";
idxExclude["rets25_listagentemail"]="List Agent Email";
idxExclude["rets25_listagentfullname"]="List Agent Full Name";
idxExclude["rets25_listagentmlsid"]="List Agent Mlsid";
idxExclude["rets25_listofficemlsid"]="List Office Mlsid";
idxExclude["rets25_listofficename"]="List Office Name";
idxExclude["rets25_listofficephone"]="List Office Phone";
idxExclude["rets25_realtorinfo"]="Realtor Info";
idxExclude["rets25_realtoronlyremarks"]="Realtor Only Remarks";
idxExclude["rets25_recipsellagentname"]="Recip Sell Agent Name";
idxExclude["rets25_recipsellofficename"]="Recip Sell Office Name";
idxExclude["rets25_sellingagentfullname"]="Selling Agent Full Name";
idxExclude["rets25_sellingagentmlsid"]="Selling Agent Mlsid";
idxExclude["rets25_sellingofficemlsid"]="Selling Office Mlsid";
idxExclude["rets25_sellingofficename"]="Selling Office Name";
idxExclude["rets25_singleagentcomp"]="Single Agent Comp";
idxExclude["rets25_officefax"]="Office Fax";
idxExclude["rets25_idxoptinyn"]="Idx Opt In Yn";
idxExclude["rets25_idxvowdisplaycommentsyn"]="Idxvow Display Comments Yn";
idxExclude["rets25_dprurl"]="Dprurl";
idxExclude["rets25_dprurl2"]="Dprurl 2";
idxExclude["rets25_dpryn"]="Dpryn";
idxExclude["rets25_tempoffmarketdate"]="Temp Off Market Date";
idxExclude["rets25_activestatusdate"]="Active Status Date";
idxExclude["rets25_bathsfull"]="Baths Full";
idxExclude["rets25_bathshalf"]="Baths Half";
idxExclude["rets25_bathstotal"]="Baths Total";
idxExclude["rets25_bedstotal"]="Beds Total";
idxExclude["rets25_lsclistside"]="Lsc List Side";
idxExclude["rets25_lscsellside"]="Lsc Sell Side";
idxExclude["rets25_listingwphotoapprovedyn"]="Listing w Photo Approved Yn";
idxExclude["rets25_matrixmodifieddt"]="Matrix Modified Dt";
idxExclude["rets25_matrix_unique_id"]="Matrix Unique Id";
idxExclude["rets25_officeprimaryboardid"]="Office Primary Board Id";
idxExclude["rets25_photocount"]="Photo Count";
idxExclude["rets25_photomodificationtimestamp"]="Photo Modification Timestamp";
idxExclude["rets25_property_id"]="Property_id";
idxExclude["rets25_providermodificationtimestamp"]="Provider Modification Timestamp";
idxExclude["rets25_showpropaddroninternetyn"]="Show Prop Addr On Internet Yn";
idxExclude["rets25_nonrepcomp"]="Non Rep Comp";
idxExclude["rets25_transbrokercomp"]="Trans Broker Comp";
idxExclude["rets25_cddyn"]="Cddyn";
idxExclude["rets25_cdom"]="Cdom";
idxExclude["rets25_dom"]="Dom";
idxExclude["rets25_publicremarksnew"]="Public Remarks";
		application.zcore.listingCom=createobject("component", "zcorerootmapping.mvc.z.listing.controller.listing");
		// force allfields to not have the fields that already used
		this.getDetailCache1(structnew());
		this.getDetailCache2(structnew());
		this.getDetailCache3(structnew());
		
		if(structcount(variables.allfields) NEQ 0){
			writeoutput('<h2>All Fields:</h2>');
			uniqueStruct={};
			for(i in variables.allfields){
				if(structkeyexists(idxExclude, i) EQ false){
					uniqueStruct[i]={
						field:variables.allfields[i].field,
						label:replace(application.zcore.functions.zfirstlettercaps(variables.allfields[i].label),"##","####")
					}
				}
			}
			arr1=structsort(uniqueStruct, "text", "asc", "label");
			for(i=1;i LTE arraylen(arr1);i++){
				c=uniqueStruct[arr1[i]];
				writeoutput('idxTemp2["'&c.field&'"]="'&c.label&'";<br />');
			}
		}
		application.zcore.functions.zabort();</cfscript>
	</cffunction>

	<!--- <table class="ztablepropertyinfo"> --->
    <cffunction name="getDetailCache1" localmode="modern" output="yes" returntype="string">
      <cfargument name="idx" type="struct" required="yes">
      <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
		

 


idxTemp2["rets25_utilities"]="Utilities";
idxTemp2["rets25_warehousespaceheated"]="Warehouse Space Heated";
idxTemp2["rets25_warehousespacetotal"]="Warehouse Space Total";
idxTemp2["rets25_additionalrooms"]="Additional Rooms";
idxTemp2["rets25_airconditioning"]="Air Conditioning";
idxTemp2["rets25_appliancesincluded"]="Appliances Included";
idxTemp2["rets25_ceilingheight"]="Ceiling Height";
idxTemp2["rets25_ceilingtype"]="Ceiling Type";
idxTemp2["rets25_doorheight"]="Door Height";
idxTemp2["rets25_doorwidth"]="Door Width";
idxTemp2["rets25_fireplacedescription"]="Fireplace Description";
idxTemp2["rets25_fireplaceyn"]="Fireplace Yn";
idxTemp2["rets25_flexspacesqft"]="Flex Space Sq Ft";
idxTemp2["rets25_floorcovering"]="Floor Covering";
idxTemp2["rets25_floornum"]="Floor Num";
idxTemp2["rets25_floorsinunit"]="Floors in Unit";
idxTemp2["rets25_freezerspaceyn"]="Freezer Space Yn";
idxTemp2["rets25_furnishings"]="Furnishings";
idxTemp2["rets25_heatingandfuel"]="Heating and Fuel";
idxTemp2["rets25_indoorairquality"]="Indoor Air Quality";
idxTemp2["rets25_interiorfeatures"]="Interior Features";
idxTemp2["rets25_interiorlayout"]="Interior Layout";
idxTemp2["rets25_kitchenfeatures"]="Kitchen Features";
idxTemp2["rets25_masterbathfeatures"]="Master Bath Features";
idxTemp2["rets25_masterbedsize"]="Master Bed Size";
idxTemp2["rets25_maxpetweight"]="Max Pet Weight";
idxTemp2["rets25_num1bed1bath"]="Num 1 Bed 1 Bath";
idxTemp2["rets25_num2bed1bath"]="Num 2 Bed 1 Bath";
idxTemp2["rets25_num2bed2bath"]="Num 2 Bed 2 Bath";
idxTemp2["rets25_num3bed1bath"]="Num 3 Bed 1 Bath";
idxTemp2["rets25_num3bed2bath"]="Num 3 Bed 2 Bath";
idxTemp2["rets25_numofbays"]="Num of Bays";
idxTemp2["rets25_numofbaysdockhigh"]="Num of Bays Dock High";
idxTemp2["rets25_numofbaysgradelevel"]="Num of Bays Grade Level";
idxTemp2["rets25_numofconferencemeetingrooms"]="Num of Conference Meeting Rooms";
idxTemp2["rets25_numofhotelmotelrms"]="Num of Hotel Motel Rms";
idxTemp2["rets25_numofoffices"]="Num of Offices";
idxTemp2["rets25_numofpets"]="Num of Pets";
idxTemp2["rets25_numofrestrooms"]="Num of Restrooms";
idxTemp2["rets25_petdeposit"]="Pet Deposit";
idxTemp2["rets25_petfeenonrefundable"]="Pet Fee Non Refundable";
idxTemp2["rets25_petrestrictions"]="Pet Restrictions";
idxTemp2["rets25_petrestrictionsyn"]="Pet Restrictions Yn";
idxTemp2["rets25_petsize"]="Pet Size";
idxTemp2["rets25_petsallowedyn"]="Pets Allowed Yn";
idxTemp2["rets25_range"]="Range";
idxTemp2["rets25_roomcount"]="Room Count";
idxTemp2["rets25_studiodimensions"]="Studio Dimensions";
idxTemp2["rets25_windowcoverings"]="Window Coverings";
		arrayappend(arrR, application.zcore.listingCom.getListingDetailRowOutput("Interior Information", arguments.idx, variables.idxExclude, idxTemp2, variables.allFields));
		
		return arraytolist(arrR,'');
		
		</cfscript>
	</cffunction>
    
    
	<cffunction name="getDetailCache2" localmode="modern" output="yes" returntype="string">
        <cfargument name="idx" type="struct" required="yes">
        <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
		// exterior features
idxTemp2["rets25_architecturalstyle"]="Architectural Style";
idxTemp2["rets25_buildingnamenumber"]="Building Name Number";
idxTemp2["rets25_buildingnumfloors"]="Building Num Floors";
idxTemp2["rets25_classofspace"]="Class of Space";
idxTemp2["rets25_exteriorconstruction"]="Exterior Construction";
idxTemp2["rets25_exteriorfeatures"]="Exterior Features";
idxTemp2["rets25_fences"]="Fences";
idxTemp2["rets25_foundation"]="Foundation";
idxTemp2["rets25_frontexposure"]="Front Exposure";
idxTemp2["rets25_frontfootage"]="Front Footage";
idxTemp2["rets25_frontagedescription"]="Frontage Description";
idxTemp2["rets25_garagecarport"]="Garage Carport";
idxTemp2["rets25_garagedimensions"]="Garage Dimensions";
idxTemp2["rets25_garagedoorheight"]="Garage Door Height";
idxTemp2["rets25_garagefeatures"]="Garage Features";
idxTemp2["rets25_greencertifications"]="Green Certifications";
idxTemp2["rets25_greenenergyfeatures"]="Green Energy Features";
idxTemp2["rets25_greenlandscaping"]="Green Landscaping";
idxTemp2["rets25_greensiteimprovements"]="Green Site Improvements";
idxTemp2["rets25_greenwaterfeatures"]="Green Water Features";
idxTemp2["rets25_location"]="Location";
idxTemp2["rets25_lotdimensions"]="Lot Dimensions";
idxTemp2["rets25_lotnum"]="Lot Num";
idxTemp2["rets25_lotsizeacres"]="Lot Size Acres";
idxTemp2["rets25_lotsizesqft"]="Lot Size Sq Ft";
idxTemp2["rets25_lpsqft"]="Lp Sq Ft";
idxTemp2["rets25_modelmake"]="Model Make";
idxTemp2["rets25_modelname"]="Model Name";
idxTemp2["rets25_newconstructionyn"]="New Construction Yn";
idxTemp2["rets25_officeretailspacesqft"]="Office Retail Space Sq Ft";
idxTemp2["rets25_parking"]="Parking";
idxTemp2["rets25_pool"]="Pool";
idxTemp2["rets25_pooldimensions"]="Pool Dimensions";
idxTemp2["rets25_pooltype"]="Pool Type";
idxTemp2["rets25_porches"]="Porches";
idxTemp2["rets25_propertystyle"]="Property Style";
idxTemp2["rets25_propertystylecom"]="Property Style Com";
idxTemp2["rets25_propertystyleland"]="Property Style Land";
idxTemp2["rets25_propertytype"]="Property Type";
idxTemp2["rets25_propertyuse"]="Property Use";
idxTemp2["rets25_roadfrontage"]="Road Frontage";
idxTemp2["rets25_roadfrontageft"]="Road Frontage Ft";
idxTemp2["rets25_roof"]="Roof";
idxTemp2["rets25_sidewalkyn"]="Sidewalk Yn";
idxTemp2["rets25_siteimprovements"]="Site Improvements";
idxTemp2["rets25_spsqft"]="Sp Sq Ft";
idxTemp2["rets25_spacetype"]="Space Type";
idxTemp2["rets25_splpratio"]="Splp Ratio";
idxTemp2["rets25_sqftgross"]="Sq Ft Gross";
idxTemp2["rets25_sqftheated"]="Sq Ft Heated";
idxTemp2["rets25_sqfttotal"]="Sq Ft Total";
idxTemp2["rets25_squarefootsource"]="Square Foot Source";
idxTemp2["rets25_wateraccess"]="Water Access";
idxTemp2["rets25_wateraccessyn"]="Water Access Yn";
idxTemp2["rets25_waterextras"]="Water Extras";
idxTemp2["rets25_waterextrasyn"]="Water Extras Yn";
idxTemp2["rets25_waterfrontage"]="Water Frontage";
idxTemp2["rets25_waterfrontageyn"]="Water Frontage Yn";
idxTemp2["rets25_watername"]="Water Name";
idxTemp2["rets25_waterview"]="Water View";
idxTemp2["rets25_waterviewyn"]="Water View Yn";
idxTemp2["rets25_waterfrontfeet"]="Waterfront Feet";
		arrayappend(arrR, application.zcore.listingCom.getListingDetailRowOutput("Exterior Information", arguments.idx, variables.idxExclude, idxTemp2, variables.allFields));
		return arraytolist(arrR,'');
		
		
		
		</cfscript>
    </cffunction>
    <cffunction name="getDetailCache3" localmode="modern" output="yes" returntype="string">
        <cfargument name="idx" type="struct" required="yes">
        <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
idxTemp2["rets25_address"]="Address";
idxTemp2["rets25_altaddress"]="Alt Address";
idxTemp2["rets25_availability"]="Availability";
idxTemp2["rets25_availabilitycom"]="Availability Com";
idxTemp2["rets25_awcremarks"]="Awc Remarks";
idxTemp2["rets25_blockparcel"]="Block Parcel";
idxTemp2["rets25_communityfeatures"]="Community Features";
idxTemp2["rets25_complexcommunitynamenccb"]="Complex Community Name Nccb";
idxTemp2["rets25_complexdevelopmentname"]="Complex Development Name";
idxTemp2["rets25_condoenvironmentyn"]="Condo Environment Yn";
idxTemp2["rets25_constructionstatus"]="Construction Status";
idxTemp2["rets25_contractstatus"]="Contract Status";
idxTemp2["rets25_convertedresidenceyn"]="Converted Residence Yn";
idxTemp2["rets25_country"]="Country";
idxTemp2["rets25_countyorparish"]="County Or Parish";
idxTemp2["rets25_disastermitigation"]="Disaster Mitigation";
idxTemp2["rets25_drivingdirections"]="Driving Directions";
idxTemp2["rets25_efficienciesnumberof"]="Efficiencies Number Of";
idxTemp2["rets25_electricalservice"]="Electrical Service";
idxTemp2["rets25_elementaryschool"]="Elementary School";
idxTemp2["rets25_highschool"]="High School";
idxTemp2["rets25_hoacommonassn"]="Hoa Common Assn";
idxTemp2["rets25_housingforolderpersons"]="Housing For Older Persons";
idxTemp2["rets25_internetyn"]="Internet Yn";
idxTemp2["rets25_listingtype"]="Listing Type";
idxTemp2["rets25_longtermyn"]="Long Term Yn";
idxTemp2["rets25_mhwidth"]="Mh Width";
idxTemp2["rets25_middleorjuniorschool"]="Middle or Junior School";
idxTemp2["rets25_miscellaneous"]="Miscellaneous";
idxTemp2["rets25_miscellaneous2"]="Miscellaneous 2";
idxTemp2["rets25_mlsareamajor"]="Mls Area Major";
idxTemp2["rets25_mlsnumber"]="Mls Number";
idxTemp2["rets25_postalcode"]="Postal Code";
idxTemp2["rets25_postalcodeplus4"]="Postal Code Plus 4";
idxTemp2["rets25_pricechangetimestamp"]="Price Change Timestamp";
idxTemp2["rets25_priceperacre"]="Price Per Acre";
idxTemp2["rets25_projectedcompletiondate"]="Projected Completion Date";
idxTemp2["rets25_propertydescription"]="Property Description";
idxTemp2["rets25_propertystatus"]="Property Status";
idxTemp2["rets25_section"]="Section";
idxTemp2["rets25_soldremarks"]="Sold Remarks";
idxTemp2["rets25_stateorprovince"]="State";
idxTemp2["rets25_status"]="Status";
idxTemp2["rets25_statuschangetimestamp"]="Status Change Timestamp";
idxTemp2["rets25_streetcity"]="Street City";
idxTemp2["rets25_streetdirprefix"]="Street Dir Prefix";
idxTemp2["rets25_streetdirsuffix"]="Street Dir Suffix";
idxTemp2["rets25_streetname"]="Street Name";
idxTemp2["rets25_streetnumber"]="Street Number";
idxTemp2["rets25_streetsuffix"]="Street Suffix";
idxTemp2["rets25_subdivisionnum"]="Subdivision Num";
idxTemp2["rets25_subdivisionsectionnumber"]="Subdivision Section Number";
idxTemp2["rets25_swsubdivcommunityname"]="Sw Subdiv Community Name";
idxTemp2["rets25_swsubdivcondonum"]="Sw Subdiv Condo Num";
idxTemp2["rets25_taxyear"]="Tax Year";
idxTemp2["rets25_teamname"]="Team Name";
idxTemp2["rets25_totalacreage"]="Total Acreage";
idxTemp2["rets25_totalnumbuildings"]="Total Num Buildings";
idxTemp2["rets25_totalunits"]="Total Units";
idxTemp2["rets25_township"]="Township";
idxTemp2["rets25_transportationaccess"]="Transportation Access";
idxTemp2["rets25_unitcount"]="Unit Count";
idxTemp2["rets25_unitnumber"]="Unit Number";
idxTemp2["rets25_units"]="Units";

idxTemp2["rets25_yearbuilt"]="Year Built";
if(application.zcore.functions.zso(arguments.idx, 'rets25_virtualtoururl2') NEQ ""){
	arrayAppend(arrR, '<a href="#arguments.idx.rets25_virtualtoururl2#" target="_blank">View Virtual Tour Link 2</a>');
}
		arrayappend(arrR, application.zcore.listingCom.getListingDetailRowOutput("Additional Information", arguments.idx, variables.idxExclude, idxTemp2, variables.allFields));
		
		

		idxTemp2=structnew();
idxTemp2["rets25_campersqft"]="Cam Per Sq Ft";
idxTemp2["rets25_totalmonthlyexpenses"]="Total Monthly Expenses";
idxTemp2["rets25_totalmonthlyrent"]="Total Monthly Rent";
idxTemp2["rets25_weeklyrent"]="Weekly Rent";
idxTemp2["rets25_weeksavailable2011"]="Weeks Available 2011";
idxTemp2["rets25_weeksavailable2012"]="Weeks Available 2012";
idxTemp2["rets25_weeksavailable2013"]="Weeks Available 2013";
idxTemp2["rets25_weeksavailable2014"]="Weeks Available 2014";
idxTemp2["rets25_efficiencyavgrent"]="Efficiency Avg Rent";
idxTemp2["rets25_maintenanceincludes"]="Maintenance Includes";
idxTemp2["rets25_management"]="Management";
idxTemp2["rets25_mandatoryfees"]="Mandatory Fees";
idxTemp2["rets25_originalentrytimestamp"]="Original Entry Timestamp";
idxTemp2["rets25_plannedunitdevelopmentyn"]="Planned Unit Development Yn";
idxTemp2["rets25_additionalpetfees"]="Additional Pet Fees";
idxTemp2["rets25_additionalapplicantfee"]="Additional Applicant Fee";
idxTemp2["rets25_additionalmembershipavailableyn"]="Additional Membership Available";
idxTemp2["rets25_additionalparcelyn"]="Additional Parcel Yn";
idxTemp2["rets25_additionaltaxids"]="Additional Tax IDs";
idxTemp2["rets25_adjoiningproperty"]="Adjoining Property";
idxTemp2["rets25_alternatekeyfolionum"]="Alternate Key Folio Num";
idxTemp2["rets25_annualcddfee"]="Annual Cdd Fee";
idxTemp2["rets25_annualexpenses"]="Annual Expenses";
idxTemp2["rets25_annualgrossincome"]="Annual Gross Income";
idxTemp2["rets25_annualnetincome"]="Annual Net Income";
idxTemp2["rets25_annualrent"]="Annual Rent";
idxTemp2["rets25_annualtotalscheduledincome"]="Annual Total Scheduled Income";
idxTemp2["rets25_applicationfee"]="Application Fee";
idxTemp2["rets25_assocapprreqyn"]="Assoc Appr Req Yn";
idxTemp2["rets25_associationapplicationfee"]="Association Application Fee";
idxTemp2["rets25_associationapprovalfee"]="Association Approval Fee";
idxTemp2["rets25_associationfeeincludes"]="Association Fee Includes";
idxTemp2["rets25_auctionyn"]="Auction Yn";
idxTemp2["rets25_avgrent1bed1bath"]="Avg Rent 1 Bed 1 Bath";
idxTemp2["rets25_avgrent2bed1bath"]="Avg Rent 2 Bed 1 Bath";
idxTemp2["rets25_avgrent2bed2bath"]="Avg Rent 2 Bed 2 Bath";
idxTemp2["rets25_avgrent3bed1bath"]="Avg Rent 3 Bed 1 Bath";
idxTemp2["rets25_avgrent3bed2bath"]="Avg Rent 3 Bed 2 Bath";
idxTemp2["rets25_condofees"]="Condo Fees";
idxTemp2["rets25_condofeesterm"]="Condo Fees Term";
idxTemp2["rets25_countylandusecode"]="County Land Use Code";
idxTemp2["rets25_countypropertyusecode"]="County Property Use Code";
idxTemp2["rets25_currentadjacentuse"]="Current Adjacent Use";
idxTemp2["rets25_disclosures"]="Disclosures";
idxTemp2["rets25_dateavailable"]="Date Available";
idxTemp2["rets25_estannualmarketincome"]="Est Annual Market Income";
idxTemp2["rets25_existingleasebuyoutallow"]="Existing Lease Buyout Allow";
idxTemp2["rets25_expectedclosingdate"]="Expected Closing Date";
idxTemp2["rets25_currentprice"]="Current Price";
//idxTemp2["rets25_dayslease"]="Days Lease";
idxTemp2["rets25_closedate"]="Close Date";
idxTemp2["rets25_closeprice"]="Close Price";
idxTemp2["rets25_financialsource"]="Financial Source";
idxTemp2["rets25_financingavailable"]="Financing Available";
idxTemp2["rets25_financingterms"]="Financing Terms";
idxTemp2["rets25_landleasefee"]="Land Lease Fee";
idxTemp2["rets25_floodzonecode"]="Flood Zone Code";
idxTemp2["rets25_forleaseyn"]="For Lease Yn";
idxTemp2["rets25_futurelanduse"]="Future Land Use";
idxTemp2["rets25_hersindex"]="Hers Index";
idxTemp2["rets25_hoafee"]="Hoa Fee";
idxTemp2["rets25_hoapaymentschedule"]="Hoa Payment Schedule";
idxTemp2["rets25_homesteadyn"]="Homestead Yn";
idxTemp2["rets25_lastchangetimestamp"]="Last Change Timestamp";
idxTemp2["rets25_lastdateavailable"]="Last Date Available";
idxTemp2["rets25_lastmonthsrent"]="Last Months Rent";
idxTemp2["rets25_leasefee"]="Lease Fee";
idxTemp2["rets25_leaseprice"]="Lease Price";
idxTemp2["rets25_leasepriceperacre"]="Lease Price Per Acre";
idxTemp2["rets25_leasepriceperyr"]="Lease Price Per Yr";
idxTemp2["rets25_leasepricepersf"]="Lease Priceper Sf";
idxTemp2["rets25_leaseremarks"]="Lease Remarks";
idxTemp2["rets25_leaseterms"]="Lease Terms";
idxTemp2["rets25_legaldescription"]="Legal Description";
idxTemp2["rets25_legalsubdivisionname"]="Legal Subdivision Name";
idxTemp2["rets25_lengthoflease"]="Length of Lease";
idxTemp2["rets25_listprice"]="List Price";
idxTemp2["rets25_listingcontractdate"]="Listing Contract Date";
idxTemp2["rets25_easements"]="Easements";
idxTemp2["rets25_eavesheight"]="Eaves Height";
idxTemp2["rets25_mfrconsumeryn"]="Mfr Consumer Yn";
idxTemp2["rets25_millagerate"]="Millage Rate";
idxTemp2["rets25_minimumdaysleased"]="Minimum Days Leased";
idxTemp2["rets25_minimumlease"]="Minimum Lease";
idxTemp2["rets25_momaintamtadditiontohoa"]="Mo Maint Amtadditionto Hoa";
idxTemp2["rets25_monthlycondofeeamount"]="Monthly Condo Fee Amount";
idxTemp2["rets25_monthlyhoaamount"]="Monthly Hoa Amount";
idxTemp2["rets25_netleasablesqft"]="Net Leasable Sq Ft";
idxTemp2["rets25_netoperatingincome"]="Net Operating Income";
idxTemp2["rets25_netoperatingincometype"]="Net Operating Income Type";
idxTemp2["rets25_numtimesperyear"]="Num Times per Year";
idxTemp2["rets25_numofaddparcels"]="Num of Add Parcels";
idxTemp2["rets25_offmarketdate"]="Off Market Date";
idxTemp2["rets25_offseasonrent"]="Off Season Rent";
idxTemp2["rets25_originallistprice"]="Original List Price";
idxTemp2["rets25_otherexemptionsyn"]="Other Exemptions Yn";
idxTemp2["rets25_otherfees"]="Other Fees";
idxTemp2["rets25_otherfeesamount"]="Other Fees Amount";
idxTemp2["rets25_otherfeesterm"]="Other Fees Term";
idxTemp2["rets25_otherfeesyn"]="Other Fees Yn";
idxTemp2["rets25_parcelnumber"]="Parcel Number";
idxTemp2["rets25_platbookpage"]="Plat Book Page";
idxTemp2["rets25_rentconcession"]="Rent Concession";
idxTemp2["rets25_rentincludes"]="Rent Includes";
idxTemp2["rets25_rentalratetype"]="Rental Rate Type";
idxTemp2["rets25_seasonalrent"]="Seasonal Rent";
idxTemp2["rets25_securitydeposit"]="Security Deposit";
idxTemp2["rets25_speciallistingtype"]="Special Listing Type";
idxTemp2["rets25_specialsaleprovision"]="Special Sale Provision";
idxTemp2["rets25_specialtaxdisttampayn"]="Special Tax Dist Tampa Yn";
idxTemp2["rets25_statelandusecode"]="State Land Use Code";
idxTemp2["rets25_statepropertyusecode"]="State Property Use Code";
idxTemp2["rets25_taxes"]="Taxes";
idxTemp2["rets25_usecode"]="Use Code";
idxTemp2["rets25_zoning"]="Zoning";
idxTemp2["rets25_zoningcompatibleyn"]="Zoning Compatible Yn";
		
		arrayappend(arrR, application.zcore.listingCom.getListingDetailRowOutput("Financial &amp; Legal Information", arguments.idx, variables.idxExclude, idxTemp2, variables.allFields));
		
		return arraytolist(arrR,'');
		</cfscript>
	</cffunction>
</cfoutput>
</cfcomponent>
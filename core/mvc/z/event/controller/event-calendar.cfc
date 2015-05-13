<cfcomponent>
<cfoutput>
	
<cffunction name="viewCalendar" access="remote" localmode="modern">
    <cfscript>
    db=request.zos.queryObject;
	var ts=structnew();
	ts.content_unique_name="/calendar/index";
	application.zcore.app.getAppCFC("content").includePageContentByName(ts);

	application.zcore.template.setTag("title", "Upcoming Events");
	application.zcore.functions.zRequireJqueryUI();

	form.event_calendar_id=application.zcore.functions.zso(form, 'event_calendar_id');

	calendarIdList="";
	arrCalendar=listToArray(form.event_calendar_id, ",");
	if(arraylen(arrCalendar)){
		arrCalendar2=[];
		for(i=1;i LTE arraylen(arrCalendar);i++){
			if(isnumeric(trim(arrCalendar[i]))){
				arrayAppend(arrCalendar2, arrCalendar[i]);
			}
		}
		calendarIdList=arrayToList(arrCalendar2, ",");
	}
	if(calendarIdList EQ ""){
		application.zcore.functions.z404("form.event_calendar_id is required");
	}


	db.sql="select * from #db.table("event_calendar", request.zos.zcoreDatasource)# 
	WHERE site_id = #db.param(request.zos.globals.id)# and 
	event_calendar_deleted=#db.param(0)# and 
	event_calendar_id IN (#db.trustedSQL(calendarIdList)#) ";
	qCalendar=db.execute("qCalendar");
	application.zcore.functions.zQueryToStruct(qCalendar, form);
	if(qCalendar.recordcount EQ 0){
		application.zcore.functions.z404("form.event_calendar_id doesn't exist.");
	}
	if(qCalendar.recordcount GT 1){
		application.zcore.template.setTag("title", "Event Calendar");
		application.zcore.template.setTag("pagetitle", "Event Calendar");
	}else{
		application.zcore.template.setTag("title", qCalendar.event_calendar_name);
		application.zcore.template.setTag("pagetitle", qCalendar.event_calendar_name);
		echo(qCalendar.event_calendar_description);
	}
	
	for(row in qCalendar){
		if(row.event_calendar_user_group_idlist NEQ ""){
			arrUserGroup=listToArray(row.event_calendar_user_group_idlist, ",");
			if(not application.zcore.user.checkGroupAccess(arrUserGroup)){
				application.zcore.status.setStatus(request.zsid, "You must login to view the calendar");
				application.zcore.functions.zRedirect("/z/user/preference/index?returnURL=#urlencodedformat(request.zos.originalURL)#");
			}
		}
	}

	form.zview=application.zcore.functions.zso(form, 'zview');
	arrView=listToArray(qCalendar.event_calendar_list_views, ",");
	viewStruct={};
	for(i=1;i<=arrayLen(arrView);i++){
		viewStruct[arrView[i]]=true;
	}
	if(form.zview NEQ ""){
		form.event_calendar_list_default_view=form.zview;
	}
	arrEvent=[];
	</cfscript> 
	<div id="zCalendarResultsDiv" style="width:100%; float:left;">

		<cfif structkeyexists(viewStruct, 'list')>
		<div id="zCalendarHomeTabs">
			<ul>
				<cfif structkeyexists(viewStruct, 'list')>
					<li><a href="##zCalendarTab_List">List View</a></li>
				</cfif>
	
				<cfif structkeyexists(viewStruct, 'Month') or structkeyexists(viewStruct, '2 Months') or structkeyexists(viewStruct, 'Week') or structkeyexists(viewStruct, 'Day')>
					<li><a href="##zCalendarTab_Calendar">Calendar View</a></li>
				</cfif>
	
			</ul>
		</cfif>
	
			<div style="width:100%; float:left;">
				<div id="zCalendarTab_List">
					
				</div>
				<div id="zCalendarTab_Calendar" style="display:none;">
					<div id="zCalendarFullPageDiv"></div>
				</div>
			</div>
		<cfif structkeyexists(viewStruct, 'list')>
		</div>
		</cfif>
	
	</div>
	<cfscript>
	application.zcore.functions.zRequireFullCalendar();
	</cfscript>
	<script>

	function setupFullCalendar(){

		$('##zCalendarFullPageDiv').fullCalendar({
		    eventClick: function(calEvent, jsEvent, view) {
				if(typeof calEvent.link != "undefined"){
					window.location.href=calEvent.link;
				}
				return;
		    },
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			defaultDate: '#dateformat(now(), "yyyy-mm-dd")#',
			editable: false,
			events: "/z/event/event-calendar/getFullCalendarJson?calendarids=#calendarIdList#"
		});
		if(navigator.userAgent.indexOf("MSIE 7.0") != -1){
			$(".fc-icon-left-single-arrow").html("&lt;");
			$(".fc-icon-right-single-arrow").html("&gt;");
		}
	}
	function listViewCallback(r){
		var rs=eval("("+r+")");
		if(rs.success){
			$("##zCalendarTab_List").html(rs.html);
		}
	}
	function setupListView(){

		var tempObj={};
		tempObj.id="zListCalendar";
		tempObj.url="/z/event/event-calendar/getListViewCalendarJson?calendarids=#calendarIdList#";
		tempObj.callback=listViewCallback;
		tempObj.cache=false;
		zAjax(tempObj);
	}
	zArrDeferredFunctions.push(function() {
		<cfif structkeyexists(viewStruct, 'list')>
			<cfif form.event_calendar_list_default_view EQ "List" or (not structkeyexists(viewStruct, 'Month') and not structkeyexists(viewStruct, '2 Months') and not structkeyexists(viewStruct, 'Week') and not structkeyexists(viewStruct, 'Day'))>
				var activeTab=0;
				setupListView();
			<cfelse>
				var activeTab=1;
				setupFullCalendar();
			</cfif>
			$("##zCalendarHomeTabs").tabs({
				active:activeTab,
				activate:function(e, e2){ 
					if(e2.newPanel[0].id == "zCalendarTab_Calendar"){
						setupFullCalendar();
					}else if(e2.newPanel[0].id == "zCalendarTab_List"){
						setupListView();
					}
				}
			});
		<cfelse>
			setupFullCalendar();
		</cfif>
		
	});
	</script>  
</cffunction>

	

<cffunction name="getListViewCalendarJson" access="remote" localmode="modern">
	<cfscript>
	ss={};
	ss.thumbnailSize="200x150";
	ss.calendarids=application.zcore.functions.zso(form, 'calendarids');
 	ss.startDate=application.zcore.functions.zso(form, 'start', false, request.zos.mysqlnow);
 	ss.endDate=application.zcore.functions.zso(form, 'end', false, dateadd("d", application.zcore.app.getAppData("event").optionstruct.event_config_project_recurrence_days, request.zos.mysqlnow)); 
 	ss.perpage=min(application.zcore.functions.zso(form, 'perpage', true, 15),15);

 	eventCom=application.zcore.app.getAppCFC("event");
 	rs=eventCom.searchEvents(ss);

 	js={};
 	js.success=true;
 	</cfscript>
	<cfsavecontent variable="js.html">
	
	<cfloop from="1" to="#arrayLen(rs.arrData)#" index="i1">
		<cfscript>row=rs.arrData[i1];
		dateRangeStruct=eventCom.getDateRangeStruct(row);

		if(row.event_summary EQ ""){
			summary=application.zcore.functions.zLimitStringLength(application.zcore.functions.zRemoveHTMLForSearchIndexer(row.event_description), 200);
		}else{
			summary=row.event_summary;
		}
		</cfscript>

		<div class="zEventListContainer" style="">
			<cfif rs.hasPhotos>
				<div class="zEventListPhoto" style="">
					<cfif true>
						Photo
					<cfelse>
						&nbsp;
					</cfif>
					&nbsp;
				</div>
				<div class="zEventListText" style="width:#request.zos.globals.maximagewidth-220#px;">
			<cfelse>
				<div class="zEventListText" style="">
			</cfif>
			
					<div class="zEventListHeading" style=""><h2><a href="#htmleditformat(row.__url)#" class="event-link">#htmleditformat(row.event_name)#</a></h2></div>
					<div class="zEventListSummary" style="">#summary#<br />
					Time: #dateRangeStruct.dateRange# at #dateRangeStruct.timeRange#
					<a href="#htmleditformat(row.__url)#" class="zEventInfoButton">More Info</a>
					</div>
				</div>
		</div>
		<hr /> 

	</cfloop>
	</cfsavecontent>
	<cfscript>
	application.zcore.functions.zReturnJson(js);
	</cfscript>
</cffunction>
	

<cffunction name="getFullCalendarJson" access="remote" localmode="modern">
	<cfscript>
	ss={};
	ss.calendarids=application.zcore.functions.zso(form, 'calendarids');
 	ss.startDate=application.zcore.functions.zso(form, 'start', false, request.zos.mysqlnow);
 	ss.endDate=application.zcore.functions.zso(form, 'end', false, dateadd("d", application.zcore.app.getAppData("event").optionstruct.event_config_project_recurrence_days, request.zos.mysqlnow)); 
 	ss.perpage=1000;
 	rs=application.zcore.app.getAppCFC("event").searchEvents(ss);
 	arrData=[];

 	for(i=1;i LTE arraylen(rs.arrData);i++){
 		row=rs.arrData[i];
		ts={
			title:row.event_name,
			start:'$.fullCalendar.moment.parseZone("'&dateformat(row.event_recur_start_datetime,"yyyy-mm-dd")&"T"&timeformat(row.event_recur_start_datetime, "HH:mm:ss")&'")',
			link:row.__url
		}

		if(row.event_recur_start_datetime NEQ row.event_recur_end_datetime){
			ts.end='$.fullCalendar.moment.parseZone("'&dateformat(row.event_recur_end_datetime,"yyyy-mm-dd")&"T"&timeformat(row.event_recur_end_datetime, "HH:mm:ss")&'")'
		}
		arrayAppend(arrData, ts);
	}
 	application.zcore.functions.zReturnJson(arrData);

	</cfscript>
</cffunction>



<cffunction name="displayCalendarResults" access="private" localmode="modern">
	<cfscript>
	var ts=0;
	</cfscript> 
	<cfsavecontent variable="output">
		<cfscript>
		ts={};
		form.zIndex=application.zcore.functions.zso(form, 'zIndex', true, 1);
		if(form.zIndex LTE 0){
			application.zcore.functions.z301redirect("/events/index");
		}

		if(structkeyexists(form, 'startDate')){
			if(structkeyexists(form, 'startDate') and isdate(form.startDate)){
				ts.startDate=form.startDate;
			}else{
				ts.startDate=now();
			}
			if(structkeyexists(form, 'endDate') and isdate(form.endDate)){
				ts.endDate=form.endDate;
			}else{
				ts.endDate=dateAdd("m", 3, now());
			}
			ts.arrGroupName=["event"];
			ts.limit=15;
			ts.offset=(form.zIndex-1)*ts.limit;
			ts.orderBy="startDateASC"; // startDateASC | startDateDESC
			arr1=application.zcore.siteOptionCom.optionGroupSetFromDatabaseBySearch(ts, request.zos.globals.id);  
			countTotal=application.zcore.siteOptionCom.optionGroupSetCountFromDatabaseBySearch(ts, request.zos.globals.id);
		}else{

			ts=[];
			arrayAppend(ts, {
				type:">=",
				field: "Start Date",
				arrValue:[request.zos.mysqlnow]	
			});
			arrayAppend(ts, {
				type:">",
				field: "End Date",
				arrValue:[request.zos.mysqlnow]	
			});
			
			form.limit=15;
			form.offset=(form.zIndex-1)*form.limit;
			rs2=application.zcore.siteOptionCom.searchOptionGroup("Event", ts, 0, false, form.offset, form.limit, "Start Date", "text", "asc", true);
			arr1=rs2.arrResult;
			countTotal=rs2.count;
		}
		ts=[];
		arrayAppend(ts, {
			type:"<",
			field: "Start Date",
			arrValue:[request.zos.mysqlnow]	
		});
		arrayAppend(ts, {
			type:">",
			field: "End Date",
			arrValue:[request.zos.mysqlnow]	
		});
		
		form.limit=25;
		form.offset=0;
		rs=application.zcore.siteOptionCom.searchOptionGroup("Event", ts, 0, false, form.offset, form.limit, "Start Date", "text", "asc", true);

		ongoing={};
		for(i=1;i LTE arraylen(rs.arrResult);i++){
			eventStruct=rs.arrResult[i];
			savecontent variable="event"{
				echo('	<div class="sn-36">
							<div class="sn-37">
								<div class="sn-38"><a href="#htmleditformat(eventStruct.__url)#" class="event-link">#htmleditformat(eventStruct.title)#</a></div>
								<div class="sn-39">#request.zos.functions.zParagraphFormat(htmleditformat(eventStruct.summary))#</div>
							</div>
							<a href="#htmleditformat(eventStruct.__url)#" class="event-button">View Details</a>
						</div>
						<hr />');
			}
			ongoing[eventStruct.__setId]={
				html:event,
				date:eventStruct["start date"],
				dateAsNumber:dateformat(eventStruct["start date"], "yyyymdd")&timeformat(eventStruct["start date"],"HHmmss")
			};
		} 
		//arr1=request.zos.functions.zSiteOptionGroupStruct("Event");
		dateStruct={};
		signatureDisplayed=false;   

		</cfscript>
		<cfloop from="1" to="#arraylen(arr1)#" index="i">
			<cfscript>
			eventStruct=arr1[i]; 
			</cfscript>
			<cfif arr1[i]["Signature Event"] EQ "1">
			<!--- <cfif (variables.isDateWithinRange(eventStruct["start date"], form.startdate, form.enddate) or variables.isDateWithinRange(dateformat(eventStruct["end date"], 'yyyy-mm-dd'), form.startdate, form.enddate)) and (form.rootCategoryList EQ "" or variables.isInSearchCategory(arr1[i]["category"], form.rootCategoryList))  and eventStruct["Signature Event"] EQ "1">  --->
				<cfscript>
				signatureDisplayed=true; 
				eventStruct=arr1[i];
				curDate=dateformat(arr1[i]["start date"], "yyyymmdd");
				if(not structkeyexists(dateStruct, curDate)){
					dateStruct[curDate]={};
				}
				</cfscript>  
				<div style="width:618px; padding:25px; float:left;  background-color:##e5fde5; border:1px solid ##769373; margin-bottom:20px;">
					<div class="sn-32">
						<div class="sn-33">#dateformat(arr1[i]["start date"], 'mmm')#</div>
						<div class="sn-34">#dateformat(arr1[i]["start date"], 'd')#</div>
					</div>
					<div class="sn-35">
						<div class="sn-36">
							<div class="sn-37">
								<div class="sn-38"><a href="#htmleditformat(eventStruct.__url)#" class="event-link">#htmleditformat(eventStruct.title)#</a></div>
								<div class="sn-39">#request.zos.functions.zParagraphFormat(htmleditformat(eventStruct.summary))#</div>
							</div>
							<a href="#htmleditformat(eventStruct.__url)#" class="event-button">View Details</a>
						</div> 
					</div> 
				</div> 
			</cfif>
		</cfloop> 
	<!--- Disabled<cfabort> --->
		<cfscript>
		//arr1=request.zos.functions.zSiteOptionGroupStruct("Event");
		dateStruct={};
		if(form.method EQ "viewAll"){
			countLimit=0; // show everything, but the date range must always be no more then 30 days.
		}else{
			countLimit=15;
		}
		count=0;
		resultsLimited=false;  
		</cfscript>
		<cfloop from="1" to="#arraylen(arr1)#" index="i"> 
			<!--- <cfif (variables.isDateWithinRange(arr1[i]["start date"], form.startdate, form.enddate) or variables.isDateWithinRange(dateformat(arr1[i]["end date"], 'yyyy-mm-dd'), form.startdate, form.enddate)) and (form.rootCategoryList EQ "" or variables.isInSearchCategory(arr1[i]["category"], form.rootCategoryList)) and arr1[i]["Signature Event"] NEQ "1"> --->
			<cfif arr1[i]["Signature Event"] NEQ "1">
				<cfscript>
				/*if(countLimit NEQ 0 and count GTE countLimit){
					resultsLimited=true;
					break;
				}*/
				count++;
				eventStruct=arr1[i];
				curDate=dateformat(arr1[i]["start date"], "yyyymmdd");
				if(not structkeyexists(dateStruct, curDate)){
					dateStruct[curDate]={};
				}
				</cfscript>
				<cfsavecontent variable="event">
					<div class="sn-36">
						<div class="sn-37">
							<div class="sn-38"><a href="#htmleditformat(eventStruct.__url)#" class="event-link">#htmleditformat(eventStruct.title)#</a></div>
							<div class="sn-39">#request.zos.functions.zParagraphFormat(htmleditformat(eventStruct.summary))#</div>
						</div>
						<a href="#htmleditformat(eventStruct.__url)#" class="event-button">View Details</a>
					</div>
					<hr />
				</cfsavecontent>
				<cfscript> 
				dateStruct[curDate][eventStruct.__setId]={
					html:event,
					date:eventStruct["start date"],
					dateAsNumber:dateformat(eventStruct["start date"], "yyyymdd")&timeformat(eventStruct["start date"],"HHmmss")
				}; 
				</cfscript>
			</cfif>
		</cfloop> 
		<cfscript>
		arrKey2=structsort(ongoing, "numeric", "asc", "dateAsNumber");
		savecontent variable="sidebarContent"{
			if(arraylen(arrKey2)){
				echo('<div style="width:100%;clear:both; float:left;font-size:18px;  font-weight:bold; line-height:24px; padding-bottom:10px; padding-top:20px;">Ongoing Events</div>');
				for(i=1;i LTE arraylen(arrKey2);i++){
					echo(ongoing[arrKey2[i]].html);
				}
			}
		}
		if(not structkeyexists(request, 'eventsSidebarHTML')){
			request.eventsSidebarHTML="";
		}
		request.eventsSidebarHTML&=sidebarContent;
		arrKey=structkeyarray(dateStruct);
		arraysort(arrKey, "numeric", "asc");
		var totalOutput=0;
		var totalOffset=0;
		var curOffset=(form.zIndex-1)*countLimit;
		for(i=1;i LTE arraylen(arrKey);i++){
			arrCurrent=[];
			arrKey2=structsort(dateStruct[arrKey[i]], "numeric", "asc", "dateAsNumber");
			//writeoutput('<br /><br >'&arrKey[i]&' | '&dateformat(arrKey[i], 'm/d/yy')&'<br />');
			var outputThisDate=false;
			for(n=1;n LTE arraylen(arrKey2);n++){
				//writeoutput(dateStruct[arrKey[i]][arrKey2[n]].date);
				curDate=dateStruct[arrKey[i]][arrKey2[n]].date;
				curHTML=dateStruct[arrKey[i]][arrKey2[n]].html;
				if(n EQ arraylen(arrKey2)){
					curHTML=replace(curHTML, ' class="sn-36"', ' class="sn-36" style="border-bottom:none;"');
				}
				//if(totalOffset GTE curOffset and totalOffset LT curOffset+countLimit){
					totalOutput++;
					outputThisDate=true;
					arrayAppend(arrCurrent, curHTML);
				//}
				/*totalOffset++;
				if(totalOutput EQ countLimit){
					break;
				}*/
			}
			if(outputThisDate){
				writeoutput('
				<div class="sn-31">
					<div class="sn-32">
						<div class="sn-33">#dateformat(curDate, 'mmm')#</div>
						<div class="sn-34">#dateformat(curDate, 'd')#</div>
					</div>
					<div class="sn-35">'&arrayToList(arrCurrent, " ")&'
					</div>
				</div>');
			}
			if(totalOutput EQ countLimit){ 
				resultsLimited=true;
				break;
			}
		} 
		//writeoutput(countTotal&" | "&((form.zIndex-1)*15)+countLimit);
		if(form.zIndex NEQ 1 or countTotal GTE ((form.zIndex-1)*15)+countLimit){
			// required
			searchStruct = StructNew();
			searchStruct.count = countTotal;
			searchStruct.index = form.zIndex;
			searchStruct.url = "/events/index?startDate=#urlencodedformat(dateformat(form.startDate, "m/d/yyyy"))#&endDate=#urlencodedformat(dateformat(form.endDate, "m/d/yyyy"))#";
			searchStruct.indexName = "zIndex";
			searchStruct.buttons = 5;
			searchStruct.perpage = countLimit;
			var searchNav = application.zcore.functions.zSearchResultsNav(searchStruct);
			writeoutput(searchNav);
		}
		//writeoutput(totalOutput &":"&countLimit&":"&count);
		</cfscript>
		<!--- <cfif resultsLimited and form.method NEQ "viewAll" and count NEQ 0>
			<div class="sn-41"> <a href="/events/viewAll" class="big-button">VIEW ALL</a></div>
		</cfif> --->
		<cfif not signatureDisplayed and count EQ 0>
			<div style="padding:40px;">
			<h2>Please adjust your search</h2>
			<p>No events match your search.</p></div>
			<cfelse> 
		</cfif>
	</cfsavecontent>
	<cfscript>
	return output;
	</cfscript>
</cffunction>


<cffunction name="view" localmode="modern" access="remote">
	<cfscript>
	db=request.zos.queryObject;

	writedump(form);
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
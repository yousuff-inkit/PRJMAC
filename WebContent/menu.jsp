<%@ taglib prefix="s" uri="/struts-tags"%>
<% String contextPath=request.getContextPath();%>
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<%-- <meta http-equiv="refresh" content="${pageContext.session.maxInactiveInterval};url=<%=contextPath%>/sessionout.jsp" /> --%>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="HandheldFriendly" content="true">
<link rel="shortcut icon" href="<%=contextPath+"/"%>gatelogo.ico" >
<title>Gateway ERP(Integrated) Copyright &#169; 2017 GW INNOVATIONS PVT. LTD.</title>
<jsp:include page="includes.jsp"></jsp:include>
<link href='http://fonts.googleapis.com/css?family=Mr+Dafoe' rel='stylesheet' type='text/css'> 

<script type = "text/javascript">
		$(document).ready(function () {
			 $("body").prepend('<div id="overlay2" class="ui-widget-overlay" style="z-index: 1; display: none;"></div>');
             $("body").prepend("<div id='PleaseWait2' style='display: none;position:absolute; z-index: 1;top:200px;right:750px;'><img src='<%=contextPath%>/icons/31load.gif'/></div>");
	
			getDecimal();
			getBackDate();
			getPdcAsCdcDate();
			getMsgCount();
			funChkMenu();
			funChkExport();
			getEmployeeBranchChk();
			
		$('#windowcp').jqxWindow({width: '45%', height: '36%',  maxHeight: '36%' ,maxWidth: '45%' , title: 'Change Password',position: { x: 130, y: 55 } , theme: 'energyblue', showCloseButton: true});
		    $('#windowcp').jqxWindow('close');
			 $("#menuBody").keydown(function (evt) {
			 if (evt.keyCode == 8) {
				  var d = event.srcElement || event.target;
			        if ((d.tagName.toUpperCase() === 'INPUT' && 
			             (
			                 d.type.toUpperCase() === 'TEXT' ||
			                 d.type.toUpperCase() === 'PASSWORD' || 
			                 d.type.toUpperCase() === 'FILE' || 
			                 d.type.toUpperCase() === 'EMAIL' || 
			                 d.type.toUpperCase() === 'SEARCH' || 
			                 d.type.toUpperCase() === 'DATE' )
			             ) || 
			             d.tagName.toUpperCase() === 'TEXTAREA') {
			            doPrevent = d.readOnly || d.disabled;
			        }
			        else {
			            doPrevent = true;
			        }
			    }
				if(doPrevent) {
			        event.preventDefault();
				}
		}); 
		});
		
		function addTab(title, url){
			if ($('#tt').tabs('exists', title)){
				$.messager.alert('Message','Form Already Exists in Tab.','warning');
				$('#tt').tabs('select', title);
				return 0;
			} else {
			 
			 var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
				$('#tt').tabs('add', {
					title:title,
					content:content,
					closable:true
					/* showCloseButtons: true */
				 });
				 return 1;
			} 
		}
		
	function geturl(aa){
		var x=new XMLHttpRequest();
		x.onreadystatechange=function(){
			if (x.readyState==4 && x.status==200)
				{
		 			document.getElementById("formData").value = x.responseText; 
					var Data = document.getElementById("formData").value;
					//document.getElementById('content2').src = Data.split("$$$$$",1);
					document.getElementById('formName').value = aa;
					document.getElementById('formCode').value = Data.split("$$$$$",2)[1];
					//document.getElementById('Name').innerHTML = aa;
					//makeWindow(Data.split("$$$$$",1),aa,Data.split("$$$$$",2)[1]);
					var url=document.URL;
					var reurl=url.split("login");
					if(Data.split("$$$$$",1)!=""){
						  var val=addTab(aa,reurl[0]+Data.split("$$$$$",1));     
						  //alert(aa+"=="+val);         
						  if(val=="1" && aa!="HR Related Master" && aa!="Veh. Related Master" && aa!="Maintenance Master" && aa!="Product Related Master" && aa!="Asset Related Master" && aa!="Client Area" && aa!="Company Settings" && aa!="Service Settings" && aa!="Staff Master"  && aa!="Tax Master "  && aa!="Transport Masters"  && aa!="Property Related Master" && aa!="Dump Related Master"  && aa!="Floor Master"){
							  $("#overlay2, #PleaseWait2").show();         
							  $("#jqxMenu").addClass("disabledbutton");            
							  $("#tt").addClass("disabledbutton"); 
						  }
					}
				}
			else
				{
				}
		}
		x.open("GET","getPageDetails.jsp?name="+aa,true);
		x.send();
	//document.write(document.getElementById("authname").value);
     }

	function getDecimal(){
	 var x=new XMLHttpRequest();
	 x.onreadystatechange=function(){
	  if (x.readyState==4 && x.status==200)
	   {
	    var res = x.responseText;
	    res=res.split('####');
	    $('#amtdec').val(res[0]);
	    $('#curdec').val(res[1]);
	   }
	  else
	   {}
	 }
	 x.open("GET","getDecimal.jsp",true);
	 x.send();
	}
	
	function getBackDate(){
  		var x = new XMLHttpRequest();
  		x.onreadystatechange = function() {
  			if (x.readyState == 4 && x.status == 200) {
  				var items = x.responseText;
  			    $('#backdateallowed').val(items);
  		}
  		}
  		x.open("GET", "getBackDateAllowed.jsp", true);
  		x.send();
      }
	  function getEmployeeBranchChk(){
  		var x = new XMLHttpRequest();
  		x.onreadystatechange = function() {
  			if (x.readyState == 4 && x.status == 200) {
  				var items = x.responseText;
  			    $('#employeebranchchk').val(items);  
  		}
  		}
  		x.open("GET", "getEmployeeBranchChk.jsp", true);
  		x.send();
      }
	function funChkExport(){
  		var x = new XMLHttpRequest();
  		x.onreadystatechange = function() {
  			if (x.readyState == 4 && x.status == 200) {
  				var items = x.responseText;
  			    $('#chkexportdata').val(items);
  		}
  		}
  		x.open("GET", "chkexportdata.jsp", true);
  		x.send();
      }
	
	
	
	
	  
	  function getPdcAsCdcDate(){
  		var x = new XMLHttpRequest();
  		x.onreadystatechange = function() {
  			if (x.readyState == 4 && x.status == 200) {
  				var items = x.responseText;
  			    $('#pdcascdcdateallowed').val(items);
  		}
  		}
  		x.open("GET", "getPdcAsCdcDateAllowed.jsp", true);
  		x.send();
      }

	 function funexit(){
		$.messager.confirm('Confirm', 'Do you Want To Quit Application?', function(result){
			if (result){
				window.close();
			 }
		   });
	 }
	 
	  /* window.setInterval(function(){
		   funSession();
		   }, 5000); */ 
		   
   function funSession(){
     var x = new XMLHttpRequest();
     x.onreadystatechange = function() {
      if (x.readyState == 4 && x.status == 200) {
       var item=x.responseText.trim();
      if(item=="1"){
      window.location.href="<%=contextPath+"/"%>sessionout.jsp";
      
      }
     }
    }
     x.open("GET", "<%=contextPath+"/"%>getSessionDetails.jsp", true);
     x.send();   
   }


function funSendEmail(){
				
				
				<%-- emailSearchContent("<%=contextPath%>/com/email/EmailFrom.jsp"); --%>
				window.open("<%=contextPath%>/com/email/Email.jsp","E-Mail","menubar=0,resizable=1,width=900,height=525 ");
			
		}
		
function funSendSms(){
			
			window.open("<%=contextPath%>/com/sms/Sms.jsp","SMS","menubar=0,resizable=1,width=500,height=325 ");
		
	}
		
		
function funMsngr(){
			
			window.open("<%=contextPath%>/com/messenger/chatForm.jsp","Messenger","menubar=0,resizable=1,width=800,height=525 ,top=100, left=260");
		
	}


function funSupport(){
	
	var userid='<%=session.getAttribute("USERID").toString().trim()%>';
	var compid='<%=session.getAttribute("COMPANYID").toString().trim()%>';
	$.get('getSupportDetails.jsp',{userid:userid,compid:compid},function(data){
		data=JSON.parse(data);
		if(parseInt(data.comprefid)>0){
			var username=data.username;
			var usermobile=data.usermobile;
			var usermail=data.usermobile;
			var compname=data.compname;
			var comprefid=data.comprefid;
			
			if(username!='' && username!='undefined' && username!=null && typeof(username)!='undefined'){
				window.open("http://185.217.125.145:8877/ServiceDB/gwqueryapp/index.jsp?userid="+userid+"&username="+encodeURIComponent(username)+"&usermobile="+encodeURIComponent(usermobile)+"&usermail="+encodeURIComponent(usermail)+"&compname="+encodeURIComponent(compname)+"&comprefid="+comprefid,"Gateway Support","menubar=0,resizable=1,width=1000,height=580 ,top=100, left=260");
			}
		}
		else{
		/*	var username='<%=session.getAttribute("USERNAME").toString().trim()%>';
			var compname='<%=session.getAttribute("COMPANYREFID").toString().trim()%>';
			//window.open("http://185.217.125.145:8877/ServiceDB/com/support/supportCenterForm.jsp?userfrmid="+userid+"&username="+username+"&compname="+compname+"","Support","menubar=0,resizable=1,width=1000,height=580 ,top=100, left=260");
		*/}
	});
}
		
function getMsgCount()
			{

/* 
			var x=new XMLHttpRequest();
			var msgcnt;
			var user;
			x.onreadystatechange=function(){
				
				if (x.readyState==4 && x.status==200)
					{
					
						items= x.responseText;
					
						items=items.split('####');
						user=items[0];
						msgcnt=items[1];
							if(msgcnt>0){
								$('#iconnm').hide();
								$('#iconym').show();
							}
							else{
								$('#iconym').hide();
								$('#iconnm').show();
							}
						
					    
					}
				else
					{
					}
			}
			x.open("GET","getMsgCount.jsp",true);
			x.send(); */
			}
	
		function funChkMenu(){
			
			
			var x = new XMLHttpRequest();
			x.onreadystatechange = function() {
				if (x.readyState == 4 && x.status == 200) {
					var items = x.responseText.trim();
					items = items.split('##');
					var email  = items[0].split(",");
					var sms = items[1].split(",");
					var support  = items[2].split(",");
					var approve = items[3].split(",");
					var msngr = items[4].split(",");
					var passchnge = items[5].split(",");
					var user = items[6].split(",");
				
					//alert("==email==="+email+"===sms==="+sms+"==approve==="+approve+"==support="+support);
					
			if(parseInt(email)==0)
				{		
					$("#email").attr('disabled', true ); 
			    }
			if(parseInt(sms)==0)
			   {
			        $("#sms").attr('disabled', true );
			   }
			if(parseInt(approve)==0)
			   {
				    $("#approve").attr('disabled', true );
			   } 
			if(parseInt(support)==0)
			   {
				    $("#support").attr('disabled', true );
				  
			   }
			
			if(parseInt(msngr)==0)
			   {
				    $("#iconym").attr('disabled', true );
				    $("#iconnm ").attr('disabled', true );
				  
			   } 
			
			if(parseInt(passchnge)==0)
			   {
				    $("#passchange ").attr('disabled', true );
				  
			   } 
			
			if(parseInt(user)==0)
			   {
				    $("#user").attr('disabled', true );
				  
			   } 
			
			 			
			}else {}
			}
			
			x.open("GET",<%=contextPath+"/"%>+"chkmainmenu.jsp",true);
			x.send();
		
		
		}


		   

		function funApprove(){
	
	var userid='<%=session.getAttribute("USERID").toString().trim()%>';
	var username='<%=session.getAttribute("USERNAME").toString().trim()%>';
	var compname='<%=session.getAttribute("COMPANYREFID").toString().trim()%>';
	
	 top.addTab( 'Executive Folio',"<%=contextPath%>/com/common/executiveFolioNew.jsp");
	
	<%--  window.open("<%=contextPath%>/com/common/approvalForm.jsp","Approval Form","menubar=0,resizable=1,width=350,height=380 ,top=100, left=260"); --%>
}


function funchgpass(){
				 $("#windowcp").jqxWindow('setTitle','<%=session.getAttribute("USERNAME")%>'+" - "+'<%=session.getAttribute("BRANCHID")%>');
				var brch='<%=session.getAttribute("BRANCHID")%>';
				var userid='<%=session.getAttribute("USERID")%>';
				
				changePassword("<%=contextPath%>/com/common/changePassword.jsp?userid="+userid+"&branchid="+brch);	
			
		}

function changePassword(url) {
			$.get(url).done(function (data) {
				    $('#windowcp').jqxWindow('open');
					$('#windowcp').jqxWindow('setContent',data);
					$('#windowcp').jqxWindow('bringToFront');
		}); 
		}
   
</script>

<style>

/*Messenger Image*/

.animated {
  animation-duration: 2.5s;
  animation-fill-mode: both;
  animation-iteration-count: infinite;
}

@keyframes wobble {
  0% {transform: translateX(0%);}
  15% {transform: translateX(-25%) rotate(-5deg);}
  30% {transform: translateX(20%) rotate(3deg);}
  45% {transform: translateX(-15%) rotate(-3deg);}
  60% {transform: translateX(10%) rotate(2deg);}
  75% {transform: translateX(-5%) rotate(-1deg);}
  100% {transform: translateX(0%);}
}
.wobble {
  animation-name: wobble;
}
/*Messenger Image Ends*/

@font-face {
	font-family: myriad pro;
    src: local('Myriad Pro'), url('../fonts/Myriad-Pro-Black-Italic_31618.ttf)') format('truetype'); 
}

  #menuBody {
    font-family: Tahoma;
    font-size: 10px;
	width: 100%;
	height: 100%;
	/* background: url("icons/gatewaybg-1.png"); */
	background-size: 100% 100%;
	background-repeat: no-repeat;
}
 
 #HeadIcons {
   /*  font: 12px Tahoma;
    margin-top: 0px;
	line-height: 30px; */
	background-color: #f0f0f0;
	height: 27px;
	width: 100%;
	/* position:inherit; */
}

select{
   font-size: 10px;
   background-color: #FFFFFF;
   border: 1px solid #ccc;
   height: 15px;
   padding: 0px; 
   -webkit-border-radius: 5px;
   -moz-border-radius: 5px;
   border-radius: 5px;
   
}
option{
    height:12px;
    font-size:9px;
}

#icon {
    background-color: #f0f0f0;
	width: 3em;
	height: 2em;
	border: none;
}

#iconym {
    background-color: #f0f0f0;
	width: 3em;
	height: 2em;
	border: none;
}

#iconnm {
    background-color: #f0f0f0;
	width: 3em;
	height: 2em;
	border: none;
}

#icon1 {
    background-color: #f0f0f0;
	width: 3em;
	height: 2em;
	border: none;
    float: right; 
}
label{
   cursor: default;
}

.company{
   /*font-size: 13px;
   font-family: myriad pro;
   font-style: bold;
   color: red;
   width:auto;*/
   
   font-size: 13px;
   font-family: myriad pro;
   font-style: bold;
   -webkit-box-sizing: content-box;
   -moz-box-sizing: content-box;
   box-sizing: content-box;
   margin: 0 auto;
   border: none;
   color: red;
   text-align: center;
   text-transform: uppercase;
   -o-text-overflow: clip;
   text-overflow: clip;
   letter-spacing: 3px;
   text-shadow: 0px 0px 0 rgba(249,162,162,1) , 1px 1px 0 red;
   -webkit-transform: rotateX(1.7188733853924696deg) rotateY(1.7188733853924696deg);
   transform: rotateX(1.7188733853924696deg) rotateY(1.7188733853924696deg);
  
}

label.space{
    width:auto;
    padding-right: 8%;
}

label.user1{
    /*font-size: 12px;
    font-family: Tahoma;
    font-style: italic;
    color: blue;
    width:auto;
    padding-right: 4%;*/
	
   font-family: Mr Dafoe, sans-serif;
   font-size: 14px;
   color: blue;
   text-align: center;
   text-transform: capitalize;
   width:auto;
   padding-right: 4%;
   letter-spacing: 1px; 
   text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.9), 0 1px 0 #E5E8E8, 0 2px 0 #E5E8E8, 0 3px 0 #E5E8E8, 0 4px 0 #E5E8E8, 0 5px 0 #E5E8E8, 0 6px 0 #E5E8E8, 0 7px 0 #E5E8E8, 0 8px 0 #E5E8E8, 0 9px 0 #E5E8E8, 0 10px 0 #E5E8E8, 0 11px 0 #E5E8E8, 0 12px 0 #E5E8E8, 0 13px 0 #E5E8E8, 0 14px 0 #E5E8E8, 0 15px 0 #E5E8E8, 0 22px 30px rgba(0, 0, 0, 0.9);
}
label.user{
    font-size: 12px;
    font-family: Tahoma;
    font-style: normal;
    width:auto;
    padding-right: 1%;
}

label.logTime{
   font-size: 12px;
   font-family: Tahoma;
   font-style: normal;
   width: auto; 
   padding-right: 6%;
}

label.period{
   font-size: 12px;
   font-family: Tahoma;
   font-style: normal;
   width: auto;
   padding-right: 1%;
}

label.period1{
   font-size: 12px;
   font-family: Tahoma;
   font-style: normal;
   width: auto;
   padding-right: 1%;
}

.bicon {
    background-color: #f0f0f0;
	width: 3em;
	height: 2em;
	border: none;
}

a:link {
    text-decoration: none;
 color: #000000;
}

a:visited {
    text-decoration: none;
 color: #000000;
}


button.bicon:disabled { opacity: 0.5; };
button.iconym:disabled { opacity: 0.5; };
button.iconnm:disabled { opacity: 0.5; };

label.licenceExpiry{
	text-align:center;
	font-size:13px;
	 font-style: bold;
	-webkit-transition-property: background;
	-webkit-transition-duration: 3s;
	-webkit-transition-timing-function: ease-out;
	background: -webkit-linear-gradient(left,  rgba(255,0,0,1) 0%,rgba(255,0,0,1) 99%); 
	-webkit-background-clip: text;
	color:transparent;
}
	
label.licenceExpiry:hover{
	-webkit-transition-property: background;
	-webkit-transition-duration: 2s;
	-webkit-transition-timing-function: ease-out;
	-webkit-text-stroke: 1px rgba(255,255,255,1);
	background: -webkit-linear-gradient(left,  rgba(255,0,0,1) 0%,rgba(255,255,0,1) 19%,rgba(0,255,0,1) 38%,rgba(0,255,255,1) 51%,rgba(0,0,255,1) 67%,rgba(255,0,255,1) 83%,rgba(255,0,0,1) 99%); /* Chrome10+,Safari5.1+ */
	-webkit-background-clip: text;
	color:transparent;
	background-position:-500px;
}
.disabledbutton {
    pointer-events: none;
    opacity: 0.4;
}               
</style>
</head>
<!-- style="overflow:;  onload="getBrchCurr();" -->
<body id="menuBody" >
<div id="mainBG" class="homeContent" data-type="background" style='margin-top:0px; width: 100%;'>
<!-- <div id='content'> -->
        <script type="text/javascript">
            $(document).ready(function () {
                // Create a jqxMenu
                $("#jqxMenu").jqxMenu({ width: '100%', height: '20', mode: 'horizontal', showTopLevelArrows: true});
                // Set up the open directions.
                $("#jqxMenu").css('visibility', 'visible');
                
            });
        </script>
        <div>
        
         <div id='jqxMenu' style="visibility: hidden;margin-top:-9px;margin-left:-8px;">
			<ul >
				<s:iterator var="first" status="status" value="%{#request.MenuMap}">
					<li><s:property value="key"></s:property>
						<ul>
							<s:iterator var="second" status="status1" value="%{#first.getValue()}">
								<a href="#" onClick="geturl('<s:property value='key'/>')">
								<li>
									 
									<s:property value='key'></s:property>
									<ul>
										<s:iterator var="al" status="status1" value="%{#second.getValue()}">
											<a href="#" onClick="geturl('<s:property value='key'/>')">
											<li>
												<label> <s:property value='key'></s:property>	</label>
														<ul>
															<s:iterator var="al1" status="status1" value="%{#al.getValue()}">
																<a href="#"	onClick="geturl('<s:property value='al1'/>')"><label><li>
																	<s:property value='al1' />
																</li></label></a>
															</s:iterator>
														</ul> 
														<%-- <a href="#" onClick="geturl('<s:property value='al'/>')"> <s:property value='al'/></a> --%>
											</li> </a>
										</s:iterator>
									</ul>
								</li></a>
							</s:iterator>
						</ul></li>
				</s:iterator>

					<b><font class="company"><%=session.getAttribute("COMPANYNAME") %></font></b>
			</ul>
			
			</div>
		
        
    
		<div id="HeadIcons" style='margin-top:0px;margin-left:-8px; width: 100%;'>
				<!-- <button id="icon" title="Quit Application" onClick="funexit();">
			<img alt="exit" src="icons/exit_new.png">
		</button> -->
		
		<button type="button" class="bicon" id="qa" title="Quit Application" onClick="funexit();"> 
							<img alt="qa" src="<%=contextPath%>/icons/exit_new.png">
						</button>
		
		
		<!-- <button id="icon" title="User">
			<img alt="user" src="icons/user__new.png">
		</button> -->
		
		<!--<button type="button" class="bicon" id="user" title="User" > 
							<img alt="User" src="<%=contextPath%>/icons/user__new.png">
						</button> -->
		
		<!-- <button id="icon" title="Change Password">
			<img alt="chgPass" src="icons/PasswordChange_new.png">
		</button> -->
		
		<button type="button" class="bicon" id="passchange" title="Change Password" onClick="funchgpass();"> 
							<img alt="passchange" src="<%=contextPath%>/icons/PasswordChange_new.png">
						</button>

		<!-- <button id="icon" title="Attachment">
			<img alt="addAttachment" src="icons/attachment_new.png">
		</button> -->
         
        <!--  <button id="icon" name="email" title="Mail" onclick="funSendEmail()">
			<img alt="mail" src="icons/mail_new.png">
		</button> -->
		
		<button type="button" class="bicon" id="email" title="E-Mail" onclick="funSendEmail()"> 
							<img alt="email" src="<%=contextPath%>/icons/mail_new.png">
						</button>

		<!-- <button id="icon" name="sms" title="SMS">
			<img alt="SMS" src="icons/SMS_new.png">
		</button> -->
		
		<button type="button" class="bicon" id="sms" title="SMS" onclick="funSendSms()">   
							<img alt="SMS" src="<%=contextPath%>/icons/SMS_new.png">
						</button>

		<button id="iconym" class="animated wobble"  hidden="true" title="Messenger" onclick="funMsngr();">
			<img alt="Messenger" src="icons/chat3.png">
		</button>
		<button id="iconnm"  title="Messenger" onclick="funMsngr();">
			<img alt="Messenger" src="icons/chat1.png">
		</button>

		<!-- <button id="icon"  name="support" title="Need Help,Contact Support Center" onclick="funSupport()">
			<img alt="Messenger" src="icons/support.png">
		</button> -->
		
		<button type="button" class="bicon" id="support" title="Need Help,Contact Support Center" onclick="funSupport()">  
							<img alt="Approval" src="<%=contextPath%>/icons/support.png">
						</button>

<!-- 		<button id="icon" name="approve"  title="Executive Folio" onclick="funApprove()">
			<img alt="Approval" src="icons/app16.png">
		</button> -->
		
		<button type="button" class="bicon" id="approve" title="Executive Folio" onclick="funApprove()">  
							<img alt="Approval" src="<%=contextPath%>/icons/app16.png">
						</button>
		

		<!-- <button id="icon" title="Move to First Form">
			<img alt="moveFirstForm" src="icons/left_new.png">
		</button>
	    <button id="icon" title="Move to Last Form">
			<img alt="moveLaststForm" src="icons/right_new.png">
		</button>
		 <button id="icon" title="Running Forms">
			<img alt="runningForms" src="icons/refresh_new.png">
		</button> -->
		
		<label class="space">&nbsp;</label>
		<label class="user"> Welcome</label><label class="user1">&nbsp;&nbsp;<%=session.getAttribute("USERNAME")%></label>
		<label class="logTime"> <%=session.getAttribute("LOGGEDIN").toString().substring(0,19)%> </label>
		<label class="period">Period&nbsp;&nbsp;<input type="text" id="txtaccountperiodfrom" name="txtaccountperiodfrom" readonly style="width:7%;height:15px;border:none;text-align: center;" value='<%=session.getAttribute("STYEAR")%>'></label>&nbsp;
		<label class="period1">To&nbsp;&nbsp;<input type="text" id="txtaccountperiodto" name="txtaccountperiodto" readonly style="width:7%;height:15px;border:none;text-align: center;" value='<%=session.getAttribute("EDYEAR")%>'></label>
		<label class="licenceExpiry"><b><%=session.getAttribute("ERA") %></b></label>
		
	    <button id="icon1" title="Logout" onclick="location.href='logout';" >
			<img alt="Logout" src="icons/Log-Out_new.png" >
		   </button> 
    	
	   </div>
	</div>
			
</div>
<input type="hidden" id="formData" />
<input type="hidden" id="formName" />
<input type="hidden" id="formCode" />
<input type="hidden" id="branchid" />
<input type="hidden" id="mode" />
<input type="hidden" id="employeebranchchk" name="employeebranchchk"/>   
<input type="hidden" id="backdateallowed" name="backdateallowed" value='<s:property value="backdateallowed"/>' />
<input type="hidden" id="pdcascdcdateallowed" name="pdcascdcdateallowed" value='<s:property value="pdcascdcdateallowed"/>' />
<input type="hidden" id="monthclosed" name="monthclosed" value='<s:property value="monthclosed"/>' />
<input type="hidden" id="taxdateval" name="taxdateval" value='<s:property value="taxdateval"/>' />
<input type="hidden" name="formcurrencytype" id="formcurrencytype" value='<s:property value="formcurrencytype"/>' />
<input type="hidden" id="curdec" name="curdec" value='<s:property value="curdec"/>' />
<input type="hidden" id="amtdec" name="amtdec" value='<s:property value="amtdec"/>' />
<input type="hidden" id="chkexportdata" name="chkexportdata" value='<s:property value="chkexportdata"/>' />

 
 <div id="tt" class="easyui-tabs" style="width:100%;height:100%;margin-left:-8px;" >
  <div title="New Home">
         <iframe scrolling="auto" frameborder="0" id="frame" src="com/dashboard/dashBoardTiles.jsp" style="width:100%;height:100%;"></iframe>
     </div>

<div title="New Home 1">
         <iframe scrolling="auto" frameborder="0" id="frame2" src="com/dashboard/dashboardtiels2.jsp" style="width:100%;height:100%;"></iframe>
     </div>
     
 <div title="Home">
		<iframe scrolling="auto" frameborder="0"  src="com/dashboard/dashBoard.jsp" style="width:100%;height:100%;"></iframe>
		</div> 
 	</div>
<div id="windowcp">
	<div></div>
</div>
 
</body>
</html> 

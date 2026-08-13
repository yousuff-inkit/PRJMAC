<%@ taglib prefix="s" uri="/struts-tags"%>
<% String contextPath=request.getContextPath();%>
<%@page import="com.dashboard.ClsDashBoardDAO"%>
<%ClsDashBoardDAO DAO= new ClsDashBoardDAO(); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GatewayERP(i)</title>
<jsp:include page="../../includes.jsp"></jsp:include>
<link href='http://fonts.googleapis.com/css?family=Mr+Dafoe' rel='stylesheet' type='text/css'> 
<link rel="stylesheet" type="text/css" href="../../../../vendors/bootstrap-v3/css/bootstrap.min.css">
<%-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> --%>
<%-- <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script> --%>
<script src="../../../../vendors/bootstrap-v3/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="../../../../vendors/select2/select2.min.css">
<script src="../../../../vendors/select2/select2.min.js"></script>
<link rel="stylesheet" href="../../../../vendors/font-awesome-v5/all.css">
<!-- <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet"> -->
<link rel="stylesheet" type="text/css" href="../../../../js/animate/animate.css">
<link rel="stylesheet" type="text/css" href="../../../../vendors/font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="../../css/util.css">
<style type="text/css">
	/* @import url(https://fonts.googleapis.com/css?family=Source+Sans+Pro);
	@import url(https://fonts.googleapis.com/css?family=Teko:700); */
	@font-face {
		font-family: Poppins-Regular;
	  	src: url('fonts/poppins/Poppins-Regular.ttf'); 
	}
	
	@font-face {
	  	font-family: Poppins-Medium;
	  	src: url('fonts/poppins/Poppins-Medium.ttf'); 
	}
	
	@font-face {
	  	font-family: Montserrat-Medium;
	  	src: url('fonts/montserrat/Montserrat-Medium.ttf'); 
	}
	
	@font-face {
	  	font-family: Montserrat-SemiBold;
	  	src: url('fonts/montserrat/Montserrat-SemiBold.ttf'); 
	}
	* {
		margin: 0px; 
		padding: 0px; 
		box-sizing: border-box;
	}
	html,body{
		width:100%;
		height:100%;
		background-color:#E9E9E9;
		font-family: Poppins-Regular, sans-serif;
	}
	html {
	    font-family: sans-serif;
	    line-height: 1.15;
	    -webkit-text-size-adjust: 100%;
	    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
	}
	body {
	    margin: 0;
	    font-family: "Poppins";
	    font-size: 1.3rem;
	    font-weight: 400;
	    line-height: 1.5;
	    color: #212529;
	    text-align: left;
	    background-color: #F7F7F7;
	    width:100%;
	    overflow:auto;
		height:100%;
		background-color: #f9f9fa;
	}
	.sidebar{
		position:absolute;
		z-index:999999;
		width:100px;
		min-height:100%;
		background-color:#fff;
	}
	
	.admin-cover .panel-body,.chart-panel .panel-body{
		border:none;
	}
		
	.page-loader{
		position:fixed;
		top:50%;
		left:50%;
		transform:translate(-50%,-50%);
		z-index:9999999;
		width:100vw;
		height:100vh;
		background-color:rgba(255,255,255,0.9);
	}
	.page-loader button,.page-loader button:hover,.page-loader button:active,.page-loader button:focus{
		background-color: #5867dd;
    	border-color: #5867dd;
		color:#fff;
		margin:0 auto;
		position:absolute;
		top:50%;
		left:50%;
		transform:translate(-50%,-50%);
	}
	.btn-chartfleetsales.active{
		background-color:#5867dd;
		border-color:#5867dd;
		color:#fff;
	}
</style>
<script type="text/javascript">
	
	
	
</script>
</head>
<body>
	<div class="page-loader">
		<button type="button" class="btn btn-brand"><i class="fa fa-circle-o-notch fa-spin fa-fw"></i> Loading</button>
	</div>
	<!-- <div class="sidebar animated slideOutLeft">
		
	</div> -->
	<div class="container-fluid">
		<div class="panel panel-default admin-cover animated fadeInDown m-t-10">
	  		<div class="panel-body">
	  			<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
	  				<p style="margin-bottom:0;" class="fs-12"><strong>Hi <span style="text-transform:capitalize;">Admin</span></strong>, Your Analytics are all set</p>	
	  			</div>
	    		<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
	    			<p style="margin-bottom:0;" class="fs-12 pull-right last-updated">Last Updated on 29-08-2019 14:03</p>	
	    		</div>
	  		</div>
		</div>
		<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-5">
				<div class="panel-group" id="chartfleetsalesparent" role="tablist" aria-multiselectable="true">
					<div class="panel panel-default chart-panel">
						<div class="panel-heading">
							<strong>Fleet Induction & Sales 2019</strong>
						</div>
		  				<div class="panel-body">
		  					<canvas id="chartfleetsales"></canvas>
		  					<div class="text-center">
		  						<a href="#fleetsalesbrandwise" class="btn btn-default btn-chartfleetsales" style="width:45%;" data-toggle="collapse" data-parent="#chartfleetsalesparent">View Brandwise Details</a>
		  						<a href="#fleetsalesmodelwise" class="btn btn-default btn-chartfleetsales" style="width:45%;" data-toggle="collapse" data-parent="#chartfleetsalesparent">View Modelwise Details</a>
		  					</div>
		  					<div id="fleetsalesbrandwise" class="panel-collapse collapse p-t-5" role="tabpanel">
		  						<select class="cmbfleetsalesbrand form-control" name="cmbfleetsalesbrand" id="cmbfleetsalesbrand" style="width:100%;"></select>
		  						<div class="table-responsive" style="max-height:200px;overflow:auto;">
		  							<table class="table table-brandwise">
		  								<thead>
		  									<tr>
		  										<th>Sr.No</th>
		  										<th>Brand</th>
		  										<th>Induction</th>
		  										<th>Sales</th>
		  									</tr>
		  								</thead>
		  								<tbody>
		  									<tr>
		  										<td>1</td>
		  										<td>Toyota</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  									<tr>
		  										<td>1</td>
		  										<td>Mercedes</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  									<tr>
		  										<td>1</td>
		  										<td>Audi</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  								</tbody>
		  							</table>
		  						</div>
		  						
		  					</div>
		  					<div id="fleetsalesmodelwise" class="panel-collapse collapse p-t-5" role="tabpanel" >
								<select class="cmbfleetsalesmodel form-control" name="cmbfleetsalesmodel" id="cmbfleetsalesmodel" style="width:100%;"></select>
								<div class="table-responsive"  style="max-height:200px;overflow:auto;">
		  							<table class="table table-modelwise">
		  								<thead>
		  									<tr>
		  										<th>Sr.No</th>
		  										<th>Model</th>
		  										<th>Induction</th>
		  										<th>Sales</th>
		  									</tr>
		  								</thead>
		  								<tbody>
		  									<tr>
		  										<td>1</td>
		  										<td>Toyota Supra</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  									<tr>
		  										<td>1</td>
		  										<td>Mercedes E</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  									<tr>
		  										<td>1</td>
		  										<td>Audi A4</td>
		  										<td>12</td>
		  										<td>15</td>
		  									</tr>
		  								</tbody>
		  							</table>
		  						</div>
							</div>
		  				</div>
					</div>
				</div>		
			</div>
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-5">
				<div class="panel panel-default chart-panel p-b-30">
					<div class="panel-heading"><strong>Fleet Distribution</strong></div>
					<div class="panel-body">
						<canvas id="chartfleetdist"></canvas>
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-2">
				<div class="panel panel-default chart-panel">
	  				<div class="panel-heading"><strong>Live Fleets</strong></div>
	  				<div class="panel-body" style="height:310px;overflow:auto;border:none;">
	  					<div class="widget fleetlist">
	  						<ul class="list-group">
  								<li class="list-group-item">Mercedes <span class="badge">12</span></li>
  								<li class="list-group-item">BMW <span class="badge">5</span></li> 
  								<li class="list-group-item">Audi <span class="badge">3</span></li> 
							</ul>
	  					</div>
	  				</div>
				</div>		
			</div>
		</div>
		
	</div>
	<script src="../../js/Chart.min.js"></script>
	<%-- <script src="../../js/chartutils.js"></script> --%>
	<script type="text/javascript">
		var dt = new Date();

		// ensure date comes as 01, 09 etc
		var DD = ("0" + dt.getDate()).slice(-2);
		
		// getMonth returns month from 0
		var MM = ("0" + (dt.getMonth() + 1)).slice(-2);
		
		var YYYY = dt.getFullYear();
		
		var hh = ("0" + dt.getHours()).slice(-2);
		
		var mm = ("0" + dt.getMinutes()).slice(-2);
		
		var ss = ("0" + dt.getSeconds()).slice(-2);
		
		var date_string = DD + "-" + MM + "-" + YYYY + " " + hh + ":" + mm;
		$('.last-updated').text('Last Updated On '+date_string);
		window.chartColors = {
			red: 'rgb(255, 99, 132)',
			orange: 'rgb(255, 159, 64)',
			yellow: 'rgb(255, 205, 86)',
			green: 'rgb(75, 192, 192)',
			blue: 'rgb(54, 162, 235)',
			purple: 'rgb(153, 102, 255)',
			grey: 'rgb(201, 203, 207)',
			color1:'rgb(255, 15, 0)',
			color2:'rgb(255, 102, 0)',
			color3:'rgb(255, 158, 1)',
			color4:'rgb(252, 210, 2)',
			color5:'rgb(248, 255, 1)',
			color6:'rgb(176, 222, 9)',
			color7:'rgb(4, 210, 21)',
			color8:'rgb(13, 142, 207)',
			color9:'rgb(13, 82, 209)',
			color10:'rgb(42, 12, 208)',
			color11:'rgb(138, 12, 207)',
			color12:'rgb(205, 13, 116)',
			color13:'rgb(117, 77, 235)',
			color14:'rgb(221, 221, 221)',
			color15:'rgb(153, 153, 153)',
			color16:'rgb(51, 51, 51)'
		};
		var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		var fleetdistconfig = {
			type: 'pie',
			data: {
				datasets: [{
					data: [
						5,
						10,
						15,
						20,
						30,
					],
					backgroundColor: [
						window.chartColors.red,
						window.chartColors.orange,
						window.chartColors.yellow,
						window.chartColors.green,
						window.chartColors.blue,
					],
					label: 'Fleet Distribution'
				}],
				labels: [
					'Red',
					'Orange',
					'Yellow',
					'Green',
					'Blue'
				]
			},
			options: {
				responsive: true,
				legend:{
					position:'right'
				}
			}
		};
		var fleetsalesconfig = {
			type: 'line',
			data: {
				labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July','August'],
				datasets: [{
					label: 'Addition',
					backgroundColor: window.chartColors.blue,
					borderColor: window.chartColors.blue,
					data: [
						5,
						10,
						15,
						6,
						25,
						10,
						2
					],
					fill: false,
				}, {
					label: 'Sales',
					fill: false,
					backgroundColor: window.chartColors.red,
					borderColor: window.chartColors.red,
					data: [
						5,
						20,
						35,
						6,
						25,
						10,
						50
					],
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio:true,
				title: {
					display: false,
					text: 'Fleet Induction & Sales 2019'
				},
				tooltips: {
					mode: 'index',
					intersect: false,
				},
				hover: {
					mode: 'nearest',
					intersect: true
				},
				scales: {
					xAxes: [{
						display: true,
						scaleLabel: {
							display: true,
							labelString: 'Month'
						}
					}],
					yAxes: [{
						display: true,
						scaleLabel: {
							display: true,
							labelString: 'Value'
						}
					}]
				}
			}
		};
		
		$(document).ready(function(){
		    $('.cmbfleetsalesbrand,.cmbfleetsalesmodel').select2();
			$('.cmbfleetsalesbrand').change(function(){
				getBrandwiseFleetSales($(this).val(),"Brand");
			});
			$('.cmbfleetsalesmodel').change(function(){
				getBrandwiseFleetSales($(this).val(),"Model");
			});
			
			$('#chartfleetsalesparent .panel-collapse').on('shown.bs.collapse', function () {
	   			var collapseid=$(this).attr('id');
	   			$('a[href="#'+collapseid+'"]').addClass('active');
			});
			
			$('#chartfleetsalesparent .panel-collapse').on('hidden.bs.collapse', function () {
	   			var collapseid=$(this).attr('id');
	   			$('a[href="#'+collapseid+'"]').removeClass('active');
			});
		});
		function getInitChartData(chart,config,fleetdistchart,fleetdistconfig){
		var x=new XMLHttpRequest();
		x.onreadystatechange=function(){
			if (x.readyState==4 && x.status==200){
				var items=x.responseText.trim();
				var chartdistdata=JSON.parse(items.split("***")[1]);
				items=JSON.parse(items.split("***")[0]);
				
				var fleetlisthtml='';
				fleetlisthtml+='<ul class="list-group">';
				$.each(items.livefleets, function( index, value ) {
  					fleetlisthtml+='<li class="list-group-item">'+value.split("::")[0]+'<span class="badge">'+value.split("::")[1]+'</span></li>';
				});
				fleetlisthtml+='</ul>';
				
				fleetdistchart.data.labels=chartdistdata.names;
				fleetdistchart.data.datasets[0].data=chartdistdata.values;
				fleetdistchart.data.datasets[0].backgroundColor=chartdistdata.colors;
				fleetdistchart.update();
				chart.data.labels=items.labels;
				chart.data.datasets[0].data=items.purchasemonthcount;
				chart.data.datasets[1].data=items.salesmonthcount;
				chart.options.title.text=items.fleetstatustitle;
				chart.update();
				$('.widget.fleetlist').html($.parseHTML(fleetlisthtml));
				var fleetsalescombohtml='';
				$.each(items.labelsvalues,function(key,value){
					if(key==items.labels.length-1){
						fleetsalescombohtml+='<option value='+items.labelsvalues[key]+' selected>'+items.labels[key]+'</option>';	
					}
					else{
						fleetsalescombohtml+='<option value='+items.labelsvalues[key]+'>'+items.labels[key]+'</option>';
					}
					
				});
				$('.cmbfleetsalesbrand,.cmbfleetsalesmodel').html(fleetsalescombohtml);
				getBrandwiseFleetSales($('.cmbfleetsalesbrand').val(),"Brand");
				getBrandwiseFleetSales($('.cmbfleetsalesmodel').val(),"Model");
				
				$('.page-loader').hide();
				
				
			}
			else{
			}
		}
		x.open("GET","getInitChartData.jsp",true);
		x.send();
	}
	
	function getBrandwiseFleetSales(basedate,detailtype){
		var x=new XMLHttpRequest();
		x.onreadystatechange=function(){
			if (x.readyState==4 && x.status==200){
				var items=x.responseText.trim();
				items=JSON.parse(items);
				
				if(detailtype=="Brand"){
					var brandwisetabledata='';
					$.each(items.brandwisedata,function(key,value){
						brandwisetabledata+='<tr>';
						brandwisetabledata+='<td>'+value.split("::")[0]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[1]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[2]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[3]+'</td>';
						brandwisetabledata+='</tr>';
					});
					$('.table-brandwise tbody').html($.parseHTML(brandwisetabledata));	
				}
				else if(detailtype=="Model"){
					var brandwisetabledata='';
					$.each(items.modelwisedata,function(key,value){
						brandwisetabledata+='<tr>';
						brandwisetabledata+='<td>'+value.split("::")[0]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[1]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[2]+'</td>';
						brandwisetabledata+='<td>'+value.split("::")[3]+'</td>';
						brandwisetabledata+='</tr>';
					});
					$('.table-modelwise tbody').html($.parseHTML(brandwisetabledata));	
				}
				
			}
			else{
			}
		}
		x.open("GET","getBrandwiseFleetSales.jsp?basedate="+basedate+"&detailtype="+detailtype,true);
		x.send();
	}
		window.onload = function() {
			var ctxchartfleetsales = document.getElementById('chartfleetsales').getContext('2d');
			window.chartfleetsales = new Chart(ctxchartfleetsales, fleetsalesconfig);
			var ctxchartfleetdist = document.getElementById('chartfleetdist').getContext('2d');
			window.chartfleetdist = new Chart(ctxchartfleetdist, fleetdistconfig);
			getInitChartData(window.chartfleetsales,fleetsalesconfig,window.chartfleetdist,fleetdistconfig);
			
		};
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- ���� -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- ���� -->

<title>�ּҰ˻�</title>

<style type="text/css">
 body {font-size:12px}
#addrForm {
 	height:500px;
 	overflow:auto;
 }
#listContainerJibun {
 	height:250px;
 	overflow:auto;
 	font-size:12px
 }
#listContainerRoad {
 	height:250px;
 	overflow:auto;
 	font-size:12px
 }
#addrComplete{
	height:120px;
 	overflow:auto;
 	font-size:12px;
}
#addrCompleteRoad{
	height:120px;
 	overflow:auto;
 	font-size:12px;
}
</style>
<script>
var sido;
var sidoname;
var sigunguname;
$(document).ready(function() {
		$("#searchJibun").button();
		$("#searchJibun").click(function() {
			searchJibun();
		});
		$("#searchRoad").button();
		$("#searchRoad").click(function() {
			searchRoad();
		});
		
		$("#addrForm").tabs();
		$("#dong").focus();
		
		setSido();
});
	function keyDownHandler(e){
	  	if(window.event.keyCode==13) {
	  		searchRoad();
	  	}
	}
	function searchJibun() {
		var dong = $("#dong").val();
		$.ajax({
			url : '${pageContext.request.contextPath}/base/post.do?oper=searchJibun',
			data : {
				'dong' : dong
			},
			type : 'post',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			cache : false,
			dataType : 'json',
			success : function(data) {
				if (data.errorCode < 0) {
					alert(data.errorMsg);
				}
				if (data.postList) {
					dataSet = data.postList;
					printAddrList(dataSet);
				}
			},
			error :  function() { alert("�����߻�"); }
		});
	}
	function printAddrList(dataSet) {
		$("#listContainerJibun").html("");
		var array = [];
		array.push("<tr><td><b>�ּҸ� �����ϼ���.</b></td></tr>");
		$.each(dataSet,function(index, postBean){
				array.push("<tr><td style='cursor : pointer' onclick='insertAddr(this)'><font color='blue'>"+postBean.zipno+ "/"+postBean.sido);
				array.push(" " + postBean.sigungu);
				array.push(" " + postBean.dong);
				array.push(" " + postBean.ri + "</font></td></tr>");
		});
		$('<table/>', {
			html : array.join(''),
			'class' : 'listTable',
			'width' : '400px'
		}).appendTo("#listContainerJibun");
	}
	function insertAddr(addr) {
		var str = "";
		$("#addrComplete").html("");
		var addr=$(addr).text();
		var zip=addr.split("/");
		str += "<b>���ּҸ� �Է��ϼ���.</b><br>";
		str += "�����ȣ : <input type='text' size='10' id='zipcode' value='"
			+ zip[0] + "' disabled><br> ";
		str += "�⺻�ּ� : <input type='text' size='50' id='baseAddr' value='"
				+ zip[1] + "' disabled><br>";
		str += "���ּ� : <input type='text' size='50' id='detailAddr'><br>";
		str += "<input type='button' id='done' onclick='completeAddr()' value='�Է¿Ϸ�'>";
		$("#addrComplete").html(str);
		$("#detailAddr").focus();
		$('#done').button();
	}
	function completeAddr(){
		opener.document.getElementById("empAddr").value = $("#baseAddr").val()+" "+$("#detailAddr").val(); 
		opener.document.getElementById("empZip").value = $("#zipcode").val();
		self.close();		
	}
	
	function setSido(){
		$.ajax({
			url : '${pageContext.request.contextPath}/base/post.do?oper=searchSido',
			data : {
			},
			type : 'post',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			cache : false,
			dataType : 'json',
			success : function(data) {
				if (data.errorCode < 0) {
					alert(data.errMsg);
				}
				if (data.postSidoList) {
					dataSet = data.postSidoList;
					printSidoList(dataSet);
				}
			},
			error :  function() { alert("�����߻�"); }
		});
	}
	function printSidoList(dataSet) {
		$("#listContainerSido").html("");
		var array = [];		
		array.push("<select id=selSido onchange='setSigungu(this.value)'>");
		array.push("<option> ======== </option>");
		$.each(dataSet,function(index, postBean){
			array.push("<option value='" + postBean.sido+"/"+postBean.sidoname + "'>" + postBean.sidoname+"</option>");
		});
		array.push("</select>");
		$("#listContainerSido").append(array.join(""));
	}
	
	function setSigungu(sidocode){
		sido=sidocode.split("/")[0];
		sidoname=sidocode.split("/")[1];
		$.ajax({
			url : '${pageContext.request.contextPath}/base/post.do?oper=searchSigungu',
			data : {
				
				"sido":sido
			},
			type : 'post',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			cache : false,
			dataType : 'json',
			success : function(data) {
				if (data.errorCode < 0) {
					alert(data.errMsg);
				}
				if (data.postSigunguList) {
					dataSet = data.postSigunguList;
					printSigunguList(dataSet);
				}
			},
			error :  function() { alert("�����߻�"); }
		});
	}
	
	function printSigunguList(dataSet) {
		$("#listContainerSigungu").html("");
		var array = [];		
		array.push("<select id=selSigungu onchange='setSigunguname(this.value)'>");
		array.push("<option> ======== </option>");
		$.each(dataSet,function(index, postBean){
			array.push("<option value='"+ postBean.sidoname+"'>" + postBean.sidoname+"</option>");
		});
		array.push("</select>");
		$("#listContainerSigungu").append(array.join(""));
	}
	
	function setSigunguname(sigungu){
		sigunguname = sigungu;
	}

	function searchRoad() {
		var roadname = $("#roadname").val();
		var selsido = $("#selSido").val();
		var selsigungu = $("#selSigungu").val();
		
		if($.trim(selsido)=="========") {alert('�õ��� �����ϼ���.'); return;}
		if($.trim(selsigungu)=="========") {alert('�ñ����� �����ϼ���.'); return;}
		if(!$.trim(roadname)) {alert('���ּҸ� �Է��ϼ���.'); return;}
		
		alert(sido+','+sigunguname+','+roadname);
		$.ajax({
			url : '${pageContext.request.contextPath}/base/post.do?oper=searchRoadname',
			data : {
				'sido' : sido,
				'sigunguname' : sigunguname, 
				'roadname' : roadname
			},
			type : 'post',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			cache : false,
			dataType : 'json',
			success : function(data) {
				if (data.errorCode < 0) {
					alert(data.errorMsg);
				}else{
					if (data.datanull) {
						alert(data.datanull);
					}else if(data.postRoadList) {
						dataSet = data.postRoadList;
						printRoadList(dataSet);
					}
				}
			},
			error :  function() { alert("�����߻�"); }
		});
	}
	function printRoadList(dataSet) {
		$("#listContainerRoad").html("");
		var array = [];
		array.push("<tr><td><b>�ּҸ� �����ϼ���.</b></td></tr>");
		$.each(dataSet,function(index, postBean){
				array.push("<tr><td style='cursor : pointer' onclick='insertRoadAddr(this)'><font color='blue'>"+postBean.zipno+ "/"+sidoname);
				array.push(" " + sigunguname);
				array.push(" " + postBean.roadname);
				array.push(" " + postBean.buildingcode1 +"-"+postBean.buildingcode2 + "</font></td></tr>");
		});
		$('<table/>', {
			html : array.join(''),
			'class' : 'listTable',
			'width' : '400px'
		}).appendTo("#listContainerRoad");
	}
	function insertRoadAddr(addr) {
		var str = "";
		$("#addrCompleteRoad").html('');
		var addr=$(addr).text();
		var zip=addr.split("/");
		str += "<b>���ּҸ� �Է��ϼ���.</b><br>";
		str += "�����ȣ : <input type='text' size='10' id='zipcodeRoad' value='"
			+ zip[0] + "' disabled><br> ";
		str += "�⺻�ּ� : <input type='text' size='50' id='baseAddrRoad' value='"
				+ zip[1] + "' disabled><br>";
		str += "���ּ� : <input type='text' size='50' id='detailAddrRoad'><br>";
		str += "<input type='button' id='done' onclick='completeAddrRoad()' value='�Է¿Ϸ�'>";
		$("#addrCompleteRoad").html(str);
		$("#detailAddrRoad").focus();
		$('#done').button();
	}
	function completeAddrRoad(){
		
		opener.document.getElementById("basicAddr").value = $('#baseAddrRoad').val();
		opener.document.getElementById("DetailAddr").value = $('#detailAddrRoad').val();
		opener.document.getElementById("empZip").value = $('#zipcodeRoad').val();
		self.close();
	}

</script>
</head>
<body>
	<div id="addrForm">
		<ul>
			<li><a href="#roadName">���θ��ּ�</a></li>
			<li><a href="#jibun">�����ּ�</a></li>
		</ul>
		<div id="roadName" align="center">
				<b>�ּҰ˻� &nbsp;&nbsp;&nbsp; �õ�: </b>
				<span id="listContainerSido"></span>&nbsp;&nbsp;&nbsp;
				<b>�ñ���: </b>
				<span id="listContainerSigungu"></span>
				<br>
				<b>���θ��� �Է��ϼ���. </b>&nbsp;&nbsp;
					<input type="text" id="roadname" style="ime-mode:active" onKeyDown="keyDownHandler(event);"/>&nbsp;
					<input type="button" id="searchRoad" value="�˻�"><br>
				<div id="listContainerRoad"></div>
				<br>
				<div id="addrCompleteRoad"></div>
		</div>
		<div id="jibun" align="center">			
				<b>�ּҰ˻� : </b>
				<b>��/��/���� �Է��ϼ���.</b>&nbsp;&nbsp;
					<input type="text" id="dong" style="ime-mode:active">&nbsp;
					<input type="button" id="searchJibun" value="�˻�"> <br>
				<div id="listContainerJibun"></div>
				<br>
				<div id="addrComplete"></div>			
		</div>

	</div>
</body>
</html>
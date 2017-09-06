<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	String oper=null; // 코드테이블인지 , 계정과목테이블인지 구분
	String code=null; // 코드테이블에서 어떤 카테고리코드를 찾을지 구분
	String accCode=null; // 적요는 선택한 계정과목에 따라 달라져야하기 때문에
	oper=request.getParameter("oper");
	if(request.getParameter("code")!=null){
		code=request.getParameter("code");
	}
	if(request.getParameter("accCode")!=null){
		accCode=request.getParameter("accCode");
	}
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>코드도우미</title>
</head>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- 맞음 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- 맞음 -->

<script type="text/javascript">
var url; 
var firstColName;
var secondColName;
$(document).ready(function(){
		$('#grid').tabs();
		switch("${param.oper}"){
			case "getInfocode" : url = "base/code.do"; 
			firstColName = "detailCode"
			secondColName = "detailCodeName"
			break; 
			
			case "getCodeList" : url = "accounting/accountbase/account.do"; 
			firstColName = "accountCode";
			secondColName = "accountName";
			break;
		}
		showCodeList(url,firstColName,secondColName);
		
});
function selectCode(id,first,second){
	var rowid= $("#grid").jqGrid('getGridParam','selrow');
	var selectCode=$("#grid").getRowData(rowid)[first]
	var selectCodeName=$("#grid").getRowData(rowid)[second]
	var openerJourRowid= $("#jourTable", opener.document).jqGrid('getGridParam','selrow');
	window.opener.<%=request.getParameter("callBack")%>(openerJourRowid,selectCode,selectCodeName);
	window.close();
}


function showCodeList(thisurl,first,second){
	
	$('#grid').jqGrid({
	      url:'${pageContext.request.contextPath}/'+thisurl+'?oper=<%=oper%>&code=<%=code%>&accCode=<%=accCode%>',
	      datatype:'json',
	        jsonReader:{
	           root:'codeinfo'
	        },beforeProcessing:function(data){
	        	if(data.errorCode<0){
					alert(data.errorMsg+"리스트에러");
				}else{
					dataSet=data.list;
					
	 			}
		},
	      colNames:['상세코드','코드명'],
	      colModel:[
	      {name:first,width:20, editable:false},
	      {name:second,width:20, editable:false},
	    ],
	      ondblClickRow : function (id) {
	          selectCode(id,first,second)
	      },
	      width:450,
	      height:350,
	      viewrecords: true,
	      cellsubmit : 'clientArray',
	      rownumbers: true,
	      sortname: 'categoryCode',
	      sortorder: 'desc',
	      sortable: true,
	      rowNum:15,
	      rowList:[5,10,20],
	      pager:'#pager',
	      caption:'코드도우미',	      
	   });
}
</script>
<body>
	<table id="grid">
	</table>
	
</body>
</html>
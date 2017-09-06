<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	String oper=null; // �ڵ����̺����� , �����������̺����� ����
	String code=null; // �ڵ����̺��� � ī�װ��ڵ带 ã���� ����
	String accCode=null; // ����� ������ �������� ���� �޶������ϱ� ������
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
<title>�ڵ嵵���</title>
</head>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- ���� -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- ���� -->

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
					alert(data.errorMsg+"����Ʈ����");
				}else{
					dataSet=data.list;
					
	 			}
		},
	      colNames:['���ڵ�','�ڵ��'],
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
	      caption:'�ڵ嵵���',	      
	   });
}
</script>
<body>
	<table id="grid">
	</table>
	
</body>
</html>
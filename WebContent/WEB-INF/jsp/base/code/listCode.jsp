<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>


<head>
<title>�ڵ� ����Ʈ ���Ӵϴ�</title>
</head>


<script type="text/javascript">
var empBean;
var dataSet;
var dataSet2;
var index;
var sel;
$(document).ready(function(){
	showCodeGrid();
	$('#detailcode').css({'display':'none'});
	$("#changeinfo").css({'display':'none'});
	$('#codeinfotabs').tabs();
	$('#addBtn').click(addMemberFunc);
	$('#addBtn').button();
	$('#checkBtn').button();
	$("#checkBtn").click(process);
});



function showCodeGrid(){
	$('#codegrid').jqGrid({
	      url:'${pageContext.request.contextPath}/base/code.do?oper=getCodelist',
	      datatype:'json',
	        jsonReader:{
	           page :'page',   
	           total:'total',
	           root:'list'
	        
	      },beforeProcessing:function(data){
				if(data.errorCode<0){
					alert(data.errorMsg+"����Ʈ����");
				}else{
					dataSet=data.list;
					alert($.toJSON(dataSet))
					
	 			}
		},
	      colNames:['�ڵ��ȣ','�ڵ��̸�','��������'],
	      colModel:[
	      {name:'categoryCode',width:20, editable:false},
	      {name:'categoryName',width:20, editable:false},
	      {name:'modiWhether',width:10, editable:false},
	    ],
	      ondblClickRow : function (id) {
	          detailcode(id)
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
	      caption:'�ڵ屸�и���Ʈ',
	      
	   });
	   $("#codegrid").jqGrid('navGrid',"#pager",{
				add : false,
				del : false,
				edit : false,
				search : false,
				refresh : false
	   });
	
}
function detailcode(i){      //�ڵ��
	var code=$('#codegrid').getCell(i, 'categoryCode');
	sel=code;
	$("#codeinfotabs").jqGrid("GridUnload") //�Ȱ��������� ������ȣ�� ���Ϸ��� ��
	if(dataSet[i].modiWhether=="N"){
		$("#changeinfo").css({'display':'none'});// ������ n �̸� �߰�+�ϰ�ó�� ��ư �Ⱥ��̰�
	}
	else{
		$("#changeinfo").css({'display':'block'});
	}

	$('#codeinfotabs').jqGrid({
	      url:'${pageContext.request.contextPath}/base/code.do?oper=getInfocode&code='+code,
	      datatype:'json',
	        jsonReader:{
	           page :'page',   
	           total:'total',
	           root:'codeinfo'	        
	      },beforeProcessing:function(data){
				if(data.errorCode<0){
					alert(data.errorMsg+"�����Ͽ���");
				}else{
					dataSet2=data.list;
				}
	      },
	      colNames:['�ڵ��ȣ','���ڵ�','���̸�','�������','status'],
	      colModel:[
	      {name:'categoryCode',width:20, editable:false},
	      {name:'detailCode',width:10, editable:true},
	      {name:'detailCodeName',width:20, editable:true},
	      {name:'useWhether',width:10, editable:true,edittype:"select",
				editoptions:{value:"Y:Y;N:N"}},
	      {name:'status',width:10, editable:true,hidden:false},
	      
	    ],
		  width:500, 
	      viewrecords:true,
	      caption:'�ڵ�󼼸���Ʈ',
	  	  rownumbers: true,
	 	  rownumWidth: 40,
		  width:670,
		  rowNum:10,
	      viewrecords: true,
	      rowList:[10,15,20],
	      pager :'#pager2',
	      multiboxonly : true,
	      multiselect : true,
	      cellEdit : true,
	      editurl :'clientArray',
	      cellsubmit : 'clientArray'
	   });
	   $("#codeinfotabs").jqGrid('navGrid',"#pager2",{
			add : false,
			del : false,
			edit : false,
			search : false,
			refresh : false
   });
	  
	   $('#detailcode').css({'display':'block'});
	
}
function addMemberFunc(){           //�߰��ϸ� status�� �⺻������ insert                                  
    var newObject={"status":"insert","categoryCode":sel,"detailCode":"","detailCodeName":"","useWhether":""};
	var nextRowId=$("#codeinfotabs").getGridParam("records");
	$("#codeinfotabs").addRowData(Number(nextRowId)+1,newObject);
}

function ObjectCopy(obj){           //ī�� , �迭�ּ� ����
	 	return JSON.parse(JSON.stringify(obj));
	 	//JSON.parse -> json���ڿ� -> �迭
	 	//JSON.stringify -> �迭 -> json���ڿ�
}   
function process(){
	var empBean = {"status":"update","categoryCode":"","detailCode":"","detailCodeName":"","useWhether":""};
	var addempBean = {"status":"insert","categoryCode":"","detailCode":"","detailCodeName":"","useWhether":""};
	var updateEmpArray=[];      // �����ϰų� �߰��� �ֵ��� ���� �迭
   	var deleteList = $("#codeinfotabs").jqGrid('getGridParam','selarrrow'); //<-- üũ�� �� �ҷ���
   	var updateList = $("#codeinfotabs").getChangedCells('all'); //<--�������� ���� �� �ҷ���
  	for(var index=0; index<updateList.length; index++){
  		if(updateList[index].status!="insert"){        //status
			var copyCodeBean=ObjectCopy(empBean);
   		}
		else{
			var copyCodeBean=ObjectCopy(addempBean);
		}
		copyCodeBean.categoryCode=updateList[index].categoryCode;  
		copyCodeBean.detailCode=updateList[index].detailCode;
		copyCodeBean.detailCodeName=updateList[index].detailCodeName;
		copyCodeBean.useWhether=updateList[index].useWhether;
   		updateEmpArray.push(copyCodeBean);
   	}
   	if(deleteList.length!=0){
	     for(var index=0; index<deleteList.length; index++){
		 var copyCodeBean=ObjectCopy(empBean);
		copyCodeBean.categoryCode=$("#codeinfotabs").getRowData(deleteList[index]).categoryCode; //<--
		copyCodeBean.detailCode=$("#codeinfotabs").getRowData(deleteList[index]).detailCode; //<--
		copyCodeBean.status='delete';
		updateEmpArray.push(copyCodeBean);
 		}
   	}
   	
	var list ='{"updatelist":'+$.toJSON(updateEmpArray)+'}';
	//if(!confirm("������ �߰�/����/���� �˴ϴ�")) return;
	alert(list+"��������Ʈ");
	$.ajax({
		    url : '${pageContext.request.contextPath}/base/code.do?oper=batchProcess',
		    data:{'list':encodeURIComponent(list)},
		    success : function() {
			   		alert("�� ���� �Ǿ����ϴ�?");
		    		$("#codeinfotabs").trigger("reloadGrid"); // �׸��常 �ٽ� �ҷ���
		    },error : function(a,b,c){
		    	alert(a+"//"+b+"//"+c)
		    	$("#codeinfotabs").trigger("reloadGrid"); 
		    }
   	});
}
</script>

<table id="codegrid" style="float: left; font-size:2em;"></table>
<div id="pager"></div>

<div id="detailcode">
<table id=codeinfotabs></table>
<div id="pager2"></div>
</div>

<div id="changeinfo">
<Button id="addBtn">�߰�</Button>
<Button id="checkBtn">���� �ϰ� ó��</Button>
</div>

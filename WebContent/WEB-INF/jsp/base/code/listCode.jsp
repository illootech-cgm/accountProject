<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>


<head>
<title>코드 리스트 폼임니다</title>
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
					alert(data.errorMsg+"리스트에러");
				}else{
					dataSet=data.list;
					alert($.toJSON(dataSet))
					
	 			}
		},
	      colNames:['코드번호','코드이름','변경유무'],
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
	      caption:'코드구분리스트',
	      
	   });
	   $("#codegrid").jqGrid('navGrid',"#pager",{
				add : false,
				del : false,
				edit : false,
				search : false,
				refresh : false
	   });
	
}
function detailcode(i){      //코드상세
	var code=$('#codegrid').getCell(i, 'categoryCode');
	sel=code;
	$("#codeinfotabs").jqGrid("GridUnload") //똑같은값으로 데이터호출 안하려고 씀
	if(dataSet[i].modiWhether=="N"){
		$("#changeinfo").css({'display':'none'});// 수정이 n 이면 추가+일괄처리 버튼 안보이게
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
					alert(data.errorMsg+"디테일에러");
				}else{
					dataSet2=data.list;
				}
	      },
	      colNames:['코드번호','상세코드','상세이름','사용유무','status'],
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
	      caption:'코드상세리스트',
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
function addMemberFunc(){           //추가하면 status는 기본적으로 insert                                  
    var newObject={"status":"insert","categoryCode":sel,"detailCode":"","detailCodeName":"","useWhether":""};
	var nextRowId=$("#codeinfotabs").getGridParam("records");
	$("#codeinfotabs").addRowData(Number(nextRowId)+1,newObject);
}

function ObjectCopy(obj){           //카피 , 배열주소 섞기
	 	return JSON.parse(JSON.stringify(obj));
	 	//JSON.parse -> json문자열 -> 배열
	 	//JSON.stringify -> 배열 -> json문자열
}   
function process(){
	var empBean = {"status":"update","categoryCode":"","detailCode":"","detailCodeName":"","useWhether":""};
	var addempBean = {"status":"insert","categoryCode":"","detailCode":"","detailCodeName":"","useWhether":""};
	var updateEmpArray=[];      // 수정하거나 추가할 애들을 담을 배열
   	var deleteList = $("#codeinfotabs").jqGrid('getGridParam','selarrrow'); //<-- 체크한 줄 불러옴
   	var updateList = $("#codeinfotabs").getChangedCells('all'); //<--셀에값이 변한 줄 불러옴
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
	//if(!confirm("정보가 추가/수정/삭제 됩니다")) return;
	alert(list+"보낼리스트");
	$.ajax({
		    url : '${pageContext.request.contextPath}/base/code.do?oper=batchProcess',
		    data:{'list':encodeURIComponent(list)},
		    success : function() {
			   		alert("잘 적용 되었습니다?");
		    		$("#codeinfotabs").trigger("reloadGrid"); // 그리드만 다시 불러옴
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
<Button id="addBtn">추가</Button>
<Button id="checkBtn">정보 일괄 처리</Button>
</div>

<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<head>
<title>전표 작성 기입</title>
</head>

<script type="text/javascript">
var detailJourBean={"slipCode" : "" , "journalItemCode" : "" , "accountDetailItemCode" : "" , "item" : "" , "value" : "" ,"status" : ""};
var slipBean={"slipCode" : "" , "writeDate":"","request":"","resolveDeptName":"","resolveDeptCode":"","slipType":"","kipyoNo":"",'balanceDiff':"","writeEmpCode":"","writeEmpName":"","okState":"","empCode":"x","status" : "","jourBeanList":""};
var jourBean={"slipCode":"","journalItemCode" : "" ,"balanceCode":"","balanceName":"","accountCode":"","accountName":"","businessCode":"","businessName":"","amount":"","keywordCode":"","keywordName":"","evidenceCode":"","evidenceName":"", "status" : ""};
var slipBeanList = []; // 모든 전표가 저장되어있음
var jourBeanList = []; // 모든 분개가 저장되어있음
var detailJourList = []; // 모든 분개상세가 저장되어있음
var lastSlipCode=0;
var showJourSplit; // 대차변표에 넣기 위해서 '현재보여지는 분개표' 를 여기에 저장함
var firstSlipCode = "SL2015";
var getToday; // 오늘 날짜
var dataSet; // 모든 데이터를 담아서 db에 보낼예정
var allDae=[]; // 현재 전표에 해당되는 대변을 담음
var allCha=[]; // 현재 전표에 해당되는 차변을 담음
var currSelslip; // 현재 선택된 전표
var currSelJour; // 현재 선택된 분개
var selAccountCode; // 내가 선택한 계정과목 -> 분개상세랑 , 적요가 달라져야함
var dataSet=[];
var searchData=[];
var searchDate;
var dateType={
      dateFormat: "yy/mm/dd",
      changeMonth: true,
      changeYear: true,
      monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
      monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
      dayNames : ['일', '월', '화', '수', '목', '금', '토'],
      dayNamesShort : ['일', '월', '화', '수', '목', '금', '토'],
      dayNamesMin : ['일', '월', '화', '수', '목', '금', '토'],
      showMonthAfterYear: true
 };

$(document).ready(function(){
	$('#checkData').click(function(){
		var updateList = $("#jourTable").getChangedCells('all'); //<--셀에값이 변한 줄 불러옴
		alert("전개빈 체크 ----------->"+$.toJSON(slipBeanList))
		alert("분개빈 체크 ----------->"+$.toJSON(jourBeanList))
		alert("분개상세빈 체크 ----------->"+$.toJSON(detailJourList))
	})
	$('#excelDown').button()
	$('#excelDown').click(downExcel)
	$('#pdfDown').button()
	$('#pdfDown').click(downPDF)
	$('#searchSlip').button(); //전표를 검색
	$('#searchSlip').click(searchDate);
	$("#addSlip").button(); // 전표에 한행 추가
	$('#addSlip').click(addSlip); 
	$("#addJour").button(); // 분개에 한행 추가
	$('#addJour').click(addJour);
	$("#batchProcess").button(); // 일괄처리
	$('#batchProcess').click(processBatchData);
	$('#balance_detail_tabs').css({'display':'none'});
	$('#requestDate').datepicker(dateType); //요청일
	$('#expiryDate').datepicker(dateType);  //만기일
	$('#startDate').datepicker(dateType);   //검색 시작날짜	
	showSlipFunc();// 전표 그리드
	showJourFunc();// 분개 그리드
	getToday(); // 현재 날짜 가져오는 펑션	
	getLastSlipCode(); //마지막 번호 갖고옴
	$('#jourDetailTabs').css({'display':'none'});
	//showDetailJour(); // 빈 분개상세 그리드 뿌림
});
function downExcel(){
	location.href="<%=request.getContextPath()%>/accounting/slip/slip.do?oper=toSlipFile&kind=excel&date="+searchDate;
}
function downPDF(){
	location.href="<%=request.getContextPath()%>/accounting/slip/slip.do?oper=toSlipFile&kind=pdf&date="+searchDate;
}
function searchDate(){
	getToday=$('#startDate').val();
	searchDate=$('#startDate').val();
	if(searchDate!="")
	 $.ajax({
			url 		: '${pageContext.request.contextPath}/accounting/slip/slip.do?oper=searchDate&searchDate='+searchDate,
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : 'post',
			success : function(data, textStatus, jqXHR) {
			if(data.errorCode<0){
					alert(data.errorMsg+"디테일에러");
				}
				else{
				if(searchData.length!=0){
					searchData=[];
				}	
				searchData=data.searchList;				
				setSeachdate()
				}
			},
			error : function(jqXHR, textStatus, error) {
				alert(jqXHR+"//"+textStatus+"//"+error);
			},complete : function(a,b){
				
			}
		});
	else
	alert("날짜를 먼저 선탠하시오");	
		
}
function setSeachdate(){
	dataconcat=true;
	for(var t=0; t<slipBeanList.length; t++){
		for(var k=0; k<searchData.length; k++){
			if(slipBeanList[t].slipCode == searchData[k].slipCode){
				dataconcat=false;
			}
		}
	}
	if(dataconcat){
	slipBeanList = []; 
	jourBeanList = []; 
	detailJourList = []; 
	for(var i=0; i<searchData.length; i++){
		slipBeanList=slipBeanList.concat(searchData[i]); // 전표
		jourBeanList=jourBeanList.concat(searchData[i].jourBeanList) // 전표.분개
		if(searchData[i].jourBeanList)
		for(var j=0; j<searchData[i].jourBeanList.length; j++){ //전표.분개.분개상세
			detailJourList=detailJourList.concat(searchData[i].jourBeanList[j].jourDetailBeanList)
		}			
	}
	
	}
	alert("가져온 전표--"+$.toJSON(slipBeanList))	
	alert("가져온 분개--"+$.toJSON(jourBeanList))	
	alert("가져온 분개상세--"+$.toJSON(detailJourList))	
	showSlipFunc()
}
function checkDelList(){
	
	var deleteList = $("#slipTable").jqGrid('getGridParam', 'selarrrow');	
	for(var i=0; i<deleteList.length; i++){
		var index=deleteList[i];
		var slipCode=$('#slipTable').getCell(index, 'slipCode');
		for(var j=0; j<slipBeanList.length; j++){
			if((slipBeanList[j].status=="normal"||slipBeanList[j].status=="update") && slipCode && slipCode==slipBeanList[j].slipCode){				
				slipBeanList[j].status="delete";
				for(var k=0; k<jourBeanList.length; k++){
					if(jourBeanList[k].slipCode==slipCode&&(jourBeanList[k].status=="normal"||jourBeanList[k].status=="update")){
						jourBeanList[k].status="delete";//딜리트로
							for(var t=0; t<detailJourList.length; t++){
							if((detailJourList[k].status=="normal"||detailJourList[k].status=="update") && detailJourList[t].slipCode==slipCode && jourBeanList[k].journalItemCode==detailJourList[t].journalItemCode){
								detailJourList[t].status="delete";
							}
						}
					}
				}
			}	
		}
	}
	var deleteJourList = $("#jourTable").jqGrid('getGridParam', 'selarrrow');
	if(deleteJourList!=null)
	for(var i=0; i<deleteJourList.length; i++){
		var index=deleteJourList[i];
		var jourCode=$('#jourTable').getCell(index, 'journalItemCode');
		var slipCode=$('#slipTable').getCell(currSelslip, 'slipCode');
		for(var j=0; j<jourBeanList.length; j++){
			if((jourBeanList[j].status=="normal" || jourBeanList[j].status=="update") && jourCode==jourBeanList[j].journalItemCode&&slipCode==jourBeanList[j].slipCode){
				jourBeanList[j].status="delete";//전표를 삭제하려면 전표에 딸리 분개,분개상세도 싸그리 지워야함
					for(var t=0; t<detailJourList.length; t++){
						if(jourBeanList[j].status=="normal" && detailJourList[t].slipCode==slipCode && jourBeanList[j].journalItemCode==detailJourList[t].journalItemCode){
							detailJourList[t].status=="delete";
						}
					}
			}	
		}
	}
	
	var deleteDetailJourList = $("#jourDetailTable").jqGrid('getGridParam', 'selarrrow');
	if(deleteDetailJourList!=null)
	for(var i=0; i<deleteDetailJourList.length; i++){
		var index=deleteDetailJourList[i];
		var jourCode=$('#jourTable').getCell(index, 'jourCode');
		var slipCode=$('#slipTable').getCell(currSelslip, 'slipCode');
		var slipCode=$('#jourTable').getCell(currSelJour, 'journalItemCode');
		for(var j=0; j<jourBeanList.length; j++){
			if((jourBeanList[j].status=="normal" || jourBeanList[j].status=="update")&&jourCode==jourBeanList[j].jourCode&&slipCode==jourBeanList[j].slipCode){
				jourBeanList[j].status="delete";
			}	
		}
	}
	
	
}
function processBatchData(){
	checkDelList();
	if (!confirm("모든 데이터가 dataSet에 저장되고 DB로 전송됩니다."))
	return;	
	for(var i=0; i<slipBeanList.length; i++){ // 전표 배열
		var jourList=[];
		slipBeanList[i].jourBeanList=jourList; // 각 전표의 분개리스트를 생성
		for(var j=0; j<jourBeanList.length; j++){
			var jourDetailList=[];
			jourBeanList[j].jourDetailBeanList=jourDetailList; // 각 분개에 분개상세리스트를 생성
			if(slipBeanList[i].slipCode==jourBeanList[j].slipCode){ // 위에 전표랑 같은 분개를 만나면
				for(var k=0; k<detailJourList.length; k++){ // 일단 분개랑 분개상세를 찾아서
					if(jourBeanList[j].journalItemCode==detailJourList[k].journalItemCode){ //
						jourBeanList[j].jourDetailBeanList.push(detailJourList[k]); // 분개의 분개상세리스트에 넣음
					}
				}
				slipBeanList[i].jourBeanList.push(jourBeanList[j]);
			}	
		}
	}		
	//dataSet=[];
	dataSet=slipBeanList;
	var processData = '{"dataSet":'+ $.toJSON(dataSet) +'}'
	alert("보낼거//-----"+$.toJSON(dataSet))
		$.ajax({
			url : '${pageContext.request.contextPath}/accounting/slip/slip.do?oper=batchProcess',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : 'post',
			data : {
			
				'batchList' : processData
			},
			success : function(data, textStatus, jqXHR){				
					if(data.errorCode<0){
					alert(data.errorMsg+"디테일에러");
				}else{
					alert("처리되었습니다");	
					}				
			},
			error : function(jqXHR, textStatus, error) {
				alert(jqXHR+"//"+textStatus+"//"+error);
			},
			complete : function(){
				location.href="${pageContext.request.contextPath}/accounting/slip/slipForm.do";
			}
		});		
}

function copyObject(obj){           //카피 , 배열주소 섞기
	 	return JSON.parse(JSON.stringify(obj));
	 	//JSON.parse -> json문자열 -> 배열
	 	//JSON.stringify -> 배열 -> json문자열
} 
function getLastSlipCode(){
	$.ajax({
		url :"${pageContext.request.contextPath}/accounting/slip/slip.do?oper=getLastSlipCode",
		dataType:'json',
		success: function(data){
		if(data.errorCode<0){
					alert(data.errorMsg+"디테일에러");
				}else{
			lastSlipCode=Number(data.lastSlipCode);   
			}
	 	},error : function(a,b,c){
	 		alert("마지막번호 갖고오기 에러"+$.toJSON(a)+b+c)
	 	}
	});
}

function getToday(){ // 작성일자 얻어오기 위해
var date = new Date(); 
var year = date.getFullYear(); 
var month = new String(date.getMonth()+1); 
var day = new String(date.getDate()); 
getToday = year+"/"+month+"/"+day;
}
function showSlipFunc(){ // 전표 리스트 
  $("#slipTable").jqGrid("GridUnload") 
	    $('#slipTable').jqGrid({
	   	    datatype:"local",
  			data : slipBeanList,
	      colNames:['전표코드','작성일자','품의내역명','결의부서코드','결의부서명','유형','승인상태','기표번호','대차차액','작성자코드','작성자명','승인자','status'],
	      colModel:[
	      {name:'slipCode',width:15, editable:false,align:"center"},
	      {name:'writeDate',width:20, editable:false,align:"center"},
	      {name:'request',width:30, editable:true,align:"center"},
	      {name:'resolveDeptCode',width:20, editable:false,align:"center"},
	      {name:'resolveDeptName',width:20, editable:false,align:"center"},
	      {name:'slipType',width:10, editable:true,edittype:"select",
				editoptions:{value:"일반:일반"}},
	      {name:'okState',width:10, editable:false,align:"center"},
	      {name:'kipyoNo',width:20, editable:false,align:"center"},
	      {name:'balanceDiff',width:20, editable:false,align:"center"},
	      {name:'writeEmpCode',width:20, editable:false,align:"center"},
	      {name:'writeEmpName',width:20, editable:false,align:"center"},
	      {name:'empCode',width:20, editable:false,align:"center"},
	      {name:'status',width:10, editable:false,align:"center"},
	 	      
	    ],
	      viewrecords:true,
	      caption:'전표리스트',
	  	  rownumbers: false,
	 	  rownumWidth: 40,
		  width:1000,
		  rowNum:10,
	      viewrecords: true,
	      rowList:[10,15,20],
	      multiboxonly : true,
	      multiselect : true,
	      cellEdit : true,
	      editurl :'clientArray',
	      cellsubmit : 'clientArray',
	      cellEdit : true,
	      cellsubmit : 'clientArray',
          afterSaveCell : function(rowid,name,val,iRow,iCol) {  //분개작성으로.
	    	 //var dataIds = $("#slipTable").getDataIDs(); // 123
   			 //var lastRowId = dataIds.length; 			 // 3   
   			 if(iCol==6){
    			addJour(currSelslip)       				
			} 
	    	showdaecha(currSelslip)
			saveSlip(currSelslip);
	    },
	    onCellSelect: function(rowid,name,val,iRow,iCol){
	    	currSelslip=rowid;
	    	showJourFunc(currSelslip);
	    	showdaecha(currSelslip)
	    	saveSlip(currSelslip);	    	
	    	$('#jourDetailTabs').css({'display':'none'});
	    },
	 });
	 
}
function saveSlip(rowid){				// 유형전까지 쓴 전표를 저장해야함
	var copyslipBean=copyObject(slipBean)
	copyslipBean.slipCode = $('#slipTable').getCell(rowid, 'slipCode');
	copyslipBean.writeDate = $('#slipTable').getCell(rowid, 'writeDate');
	copyslipBean.request = $('#slipTable').getCell(rowid, 'request').trim();
	copyslipBean.resolveDeptCode = $('#slipTable').getCell(rowid, 'resolveDeptCode');
	copyslipBean.resolveDeptName = $('#slipTable').getCell(rowid, 'resolveDeptName');
	copyslipBean.slipType = $('#slipTable').getCell(rowid, 'slipType');
	copyslipBean.okState = $('#slipTable').getCell(rowid, 'okState');
	copyslipBean.balanceDiff = $('#slipTable').getCell(rowid, 'balanceDiff');
	copyslipBean.writeEmpCode="${sessionScope.id}";
    copyslipBean.writeEmpName=$('#slipTable').getCell(rowid, 'writeEmpName');
	copyslipBean.status = $('#slipTable').getCell(rowid, 'status');
	
	if(slipBeanList.length>0){
		for(var i=0; i<slipBeanList.length; i++){
			if(slipBeanList[i].slipCode ==copyslipBean.slipCode){
				slipBeanList.splice(i,1);
				if(copyslipBean.status=="normal"){
					copyslipBean.status="update";											
				}
			}
		}
	}
	slipBeanList.push(copyslipBean)         // 모든 전표가 저장되어있음
	 
}
function saveJour(rowid){
	var copyjourBean=copyObject(jourBean)
	copyjourBean.slipCode = $("#jourTable").getCell(rowid, "slipCode")
	copyjourBean.journalItemCode = $("#jourTable").getCell(rowid, "journalItemCode")
	copyjourBean.balanceCode = $("#jourTable").getCell(rowid, "balanceCode")
	copyjourBean.balanceName = $("#jourTable").getCell(rowid, "balanceName")
	copyjourBean.accountCode = $("#jourTable").getCell(rowid, "accountCode")
	copyjourBean.accountName = $("#jourTable").getCell(rowid, "accountName")
	copyjourBean.businessCode = $("#jourTable").getCell(rowid, "businessCode")
	copyjourBean.businessName = $("#jourTable").getCell(rowid, "businessName")
	copyjourBean.amount = $("#jourTable").getCell(rowid, "amount")
	copyjourBean.keywordCode = $("#jourTable").getCell(rowid,"keywordCode")
	copyjourBean.keywordName = $("#jourTable").getCell(rowid,"keywordName")
	copyjourBean.evidenceCode = $("#jourTable").getCell(rowid,"evidenceCode")
	copyjourBean.evidenceName = $("#jourTable").getCell(rowid,"evidenceName")
	copyjourBean.status = $("#jourTable").getCell(rowid, "status")
	
	for(var i=0; i<jourBeanList.length; i++){
		if(jourBeanList[i].slipCode == copyjourBean.slipCode && jourBeanList[i].journalItemCode == copyjourBean.journalItemCode){
			if(copyjourBean.status=="normal"){
				copyjourBean.status="update"
			}
			jourBeanList.splice(i,1)
		}
	}
	jourBeanList.push(copyjourBean)
    
}
function checkdaecha(rowid,slipid){   //대차차액을 전표에 셋팅해야함;;
	 var alldae=[];
	 var allcha=[];
	 var daeAmount=0;
	 var chaAmount=0;
	 var diffAmount=0;
	 var dataIds = $("#jourTable").getDataIDs(); // 분개에 있는 모든 rowid 를 가져옴 , 대변 , 차변금액 갖고올꺼임 
	 var rownum = $("#jourTable").jqGrid("getGridParam", "selrow" );
	 if(dataIds.length!=0){
	 	for(var i=0; i<dataIds.length; i++){
	 		balanceCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).balanceCode
	 		accountCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).accountCode
	 		if(balanceCode=="DC001"){
	 			var copyJour=copyObject(jourBean)
	 			amount=$("#jourTable").jqGrid("getRowData", dataIds[i]).amount
	 			daeAmount+=Number(amount)
	 			copyJour.amount=amount;
	 			copyJour.balanceCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).balanceCode
	 			copyJour.slipCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).slipCode
	 			copyJour.accountCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).accountCode
	 			copyJour.accountName=$("#jourTable").jqGrid("getRowData", dataIds[i]).accountName
	 			copyJour.journalItemCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).journalItemCode
	 			alldae.push(copyJour)
	 		}
	 		else if(balanceCode=="DC002"){
	 			var copyJour=copyObject(jourBean)
	 			amount=$("#jourTable").jqGrid("getRowData", dataIds[i]).amount
	 			chaAmount+=Number(amount)
	 			copyJour.amount=amount;
	 			copyJour.balanceCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).balanceCode
	 			copyJour.slipCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).slipCode
	 			copyJour.accountCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).accountCode
	 			copyJour.accountName=$("#jourTable").jqGrid("getRowData", dataIds[i]).accountName
	 			copyJour.journalItemCode=$("#jourTable").jqGrid("getRowData", dataIds[i]).journalItemCode
	 			allcha.push(copyJour)
	 		}
	 	}
	 }
	if(!isNaN(diffAmount)){
		diffAmount=Number(chaAmount)-Number(daeAmount);
		$('#slipTable').setCell(slipid, 'balanceDiff' , diffAmount);
		var currAmount=$('#slipTable').getCell(slipid, 'balanceDiff' , diffAmount);
		if(currAmount>0){
			$('#slipTable').jqGrid('setCell',slipid,"balanceDiff","",{color:'green'});
		}
		if(diffAmount<0){
			$('#slipTable').jqGrid('setCell',slipid,"balanceDiff","",{color:'red'});
		}
				
		 allDae=alldae
		 allCha=allcha
		
		 showCreditFunc(allDae,daeAmount);
		 showDebtorFunc(allCha,chaAmount);
	} 
}

function showdaecha(row){                   // 전표 변경시 대차대조표 변경을 위해...
	var rowid;
	var allDae2=[]
	var allCha2=[]
	var debTotal=0;//차변의 총 금액
	var creTotal=0;//대변의 총 금액
	rowid=row;
	slipCode = $('#slipTable').getCell(rowid, 'slipCode');
	for(var i=0; i<jourBeanList.length; i++){
		if(slipCode==jourBeanList[i].slipCode && jourBeanList[i].balanceCode=="DC001"){
			var copyDae=copyObject(jourBean)
			creTotal+=Number(jourBeanList[i].amount) //합계
			copyDae.slipCode=jourBeanList[i].slipCode
			copyDae.balanceCode=jourBeanList[i].balanceCode
			copyDae.accountCode=jourBeanList[i].accountCode
			copyDae.accountName=jourBeanList[i].accountName
			copyDae.amount=jourBeanList[i].amount
			allDae2.push(copyDae)
			
		}
		else if(slipCode==jourBeanList[i].slipCode && jourBeanList[i].balanceCode=="DC002"){
			var copyCha=copyObject(jourBean)
			debTotal+=Number(jourBeanList[i].amount);
			copyCha.slipCode=jourBeanList[i].slipCode
			copyCha.balanceCode=jourBeanList[i].balanceCode
			copyCha.accountCode=jourBeanList[i].accountCode
			copyCha.accountName=jourBeanList[i].accountName
			copyCha.amount=jourBeanList[i].amount
			allCha2.push(copyCha)
		}
	}
	
	 for(var j=0; j<allDae2.length; j++)
		 for(var i=j+1; i<allDae2.length; i++){
			if(allDae2[j].accountCode==allDae2[i].accountCode){
			var total=Number(allDae2[j].amount)+Number(allDae2[i].amount);
			allDae2[j].amount="";
			allDae2[j].amount=total
			allDae2.splice(i,1);
		}
	}
	for(var j=0; j<allCha2.length; j++)
		for(var i=j+1; i<allCha2.length; i++){
			if(allCha2[j].accountCode==allCha2[i].accountCode){
			var total=Number(allCha2[j].amount)+Number(allCha2[i].amount);
			allCha2[j].amount="";
			allCha2[j].amount=total
			allCha2.splice(i,1);
		}
	}
	showDebtorFunc(allCha2,debTotal); //차변만
	showCreditFunc(allDae2,creTotal); //대변만
}

function addSlip(){
	$('#jourDetailTabs').css({'display':'none'});
   $("#jourDetailTable").clearGridData();
   accountCode="" // 새전표 선택하면 이전 accountCode 값을 초기화 해야함
   lastSlipCode+=1;//거기다가 +1
   var initSlipCode=firstSlipCode+lastSlipCode;  //앞에 SL2015랑 합침
   var copySlipBean = copyObject(slipBean);
   copySlipBean.slipCode=initSlipCode;                                           //전표 추가
   copySlipBean.writeDate=getToday;
   copySlipBean.resolveDeptCode="${sessionScope.deptcode}";
   copySlipBean.resolveDeptName="${sessionScope.deptname}";
   copySlipBean.balanceDiff=0;
   copySlipBean.writeEmpCode="${sessionScope.id}";
   copySlipBean.writeEmpName="${sessionScope.name}";
   copySlipBean.okState="미결"
   copySlipBean.status="insert";
   var nextRowId=$("#slipTable").getGridParam("records");
   $("#slipTable").addRowData(Number(nextRowId)+1,copySlipBean);
}

function showJourFunc(id){ //분개 리스트
    $("#jourTable").jqGrid("GridUnload") 
	rownum = id-1;
	var slipCode="" // 초기화작업
	var showJour=[];
	slipCode = $('#slipTable').getCell(id, 'slipCode');
	if(slipCode){
		for(var i=0; i<jourBeanList.length; i++){
			if(jourBeanList[i].slipCode == slipCode){
				var copyjourBean=copyObject(jourBeanList[i]);
				showJour.push(copyjourBean);
			}
		}
	}
	
	$('#jourTable').jqGrid({
	 	 datatype:"local",
	 	 data:showJour,
	     colNames:['전표코드','분개코드','대차구분코드','대차구분','계정과목코드','계정과목','거래처코드','거래처명','금액','적요코드','적요명','증빙코드','증빙','status'],
         colModel:[
         {name:'slipCode',width:10, editable:false},
         {name:'journalItemCode',width:10, editable:false},
         {name:'balanceCode',width:10, editable:false},
         {name:'balanceName',width:10, editable:false},
         {name:'accountCode',width:20, editable:false},
         {name:'accountName',width:20, editable:false},
         {name:'businessCode',width:10, editable:false},
         {name:'businessName',width:10, editable:false},
         {name:'amount',width:10, editable:true},
         {name:'keywordCode',width:20, editable:false},
         {name:'keywordName',width:20, editable:false},
         {name:'evidenceCode',width:10, editable:false},
         {name:'evidenceName',width:10, editable:false},
         {name:'status',width:10, editable:false}
       ],ondblClickRow : function (id) {
	          index=id-1;
	          //showJourDetail()
	      },
		  viewrecords:true,
	      caption:'분개리스트',
	  	  rownumbers: false,
	 	  rownumWidth: 40,
		  width:1000,
		  rowNum:10,
	      viewrecords: true,
	      rowList:[10,15,20],
	      multiboxonly : true,
	      multiselect : true,
	      cellEdit : true,
	      editurl :'clientArray',
	      cellsubmit : 'clientArray',
	      cellEdit : true,
	      afterSaveCell : function(rowid,name,val,iRow,iCol) {  //분개작성으로.

	    	 var dataIds = $("#jourTable").getDataIDs(); // 123
   			 var lastRowId = dataIds.length; 			 // 3
    			
				
	    }, onCellSelect: function(rowid,element){
	    currSelJour=rowid;
          if(element==3 ){
         	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=ACC&callBack=inputBalance',
     	 	 '대차구분','width=300px; height=350px;left=1000px; top=100px;');
 		  }
          
          else if(element==5){
             window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getCodeList&callBack=inputAccount',
     	 	 '계정과목','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==7){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=BUSI&callBack=inputBusiness',
     	 	 '거래처','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==10){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=KEY&callBack=inputKeyword&accCode='+selAccountCode,
     	 	 '적요코드','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==12){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=EVI&callBack=inputEvidence',
     	 	 '증빙코드','width=300px; height=350px;left=1000px; top=100px;');
          }  
          else if(element==14){
          	saveJour(rowid);
          	 saveSlip(currSelslip); 
           }
         
          checkdaecha(rowid,currSelslip);   
          accountCode = $('#jourTable').getCell(rowid, 'accountCode');
          if($('#jourTable').getCell(rowid, 'accountCode')!=""){
          	saveSlip(currSelJour);
          }
          if($('#jourTable').getCell(rowid, 'amount')!=""){
          	checkdaecha(rowid,currSelslip);
          }
          if(accountCode!=""){
              showDetailJour(accountCode,currSelslip,currSelJour);
          }
          
        	saveJour(rowid);
  			checkdaecha(rowid,currSelslip);   			
    		showdaecha(currSelslip) 
       }	  
       
	 });  	 
	  
}


 function inputBalance(openerJourRowid, code, codename){    //대차구분 입력 콜백함수
  $("#jourTable").setCell(openerJourRowid, 'balanceCode', code);
  $("#jourTable").setCell(openerJourRowid, 'balanceName', codename);  
 }
 function inputAccount(openerJourRowid, code, codename){    //계정과목 입력 콜백함수
  selAccountCode=code
  $("#jourTable").setCell(openerJourRowid, 'accountCode', code);
  $("#jourTable").setCell(openerJourRowid, 'accountName', codename); 
  if(selAccountCode!=""){ // 계정과목 선택되면 분개상세 ㄱㄱ
  		showDetailJour(selAccountCode,currSelslip,currSelJour) // 계정과목 셋팅이 와료되면 분개상세를 호출 
 	}
 }
 function inputBusiness(openerJourRowid, code, codename){   //거래처 입력
  $("#jourTable").setCell(openerJourRowid, 'businessCode', code);
  $("#jourTable").setCell(openerJourRowid, 'businessName', codename);
 }
 
 function inputKeyword(openerJourRowid, code, codename){   //거래처 입력
  $("#jourTable").setCell(openerJourRowid, 'keywordCode', code);
  $("#jourTable").setCell(openerJourRowid, 'keywordName', codename);
 }
 
  function inputEvidence(openerJourRowid, code, codename){   //거래처 입력
  $("#jourTable").setCell(openerJourRowid, 'evidenceCode', code);
  $("#jourTable").setCell(openerJourRowid, 'evidenceName', codename);
  if($('#jourTable').getCell(openerJourRowid, 'evidenceName')!=""){
  	saveJour(openerJourRowid);
  	checkdaecha(openerJourRowid,currSelslip);
    saveSlip(currSelJour); //checkdaecha 
    showdaecha(currSelslip) 
  }
 }
function showDebtorFunc(de,debTotal){   			    //차변 리스트
   $("#debtorTable").jqGrid("GridUnload")
   debt=de;
   if(debt.length>1)
   for(var j=0; j<5; j++)    
   for(var i=0; i<debt.length-1; i++){
   		if(debt[i].accountCode==debt[i+1].accountCode&&debt[i].journalItemCode!=debt[i+1].journalItemCode){
   			var total=Number(debt[i].amount)+Number(debt[i+1].amount);
   			debt[i].amount=0;
   			debt[i].amount=Number(total);
   			debt.splice(i+1,1);
   		}
   }
   $('#debtorTable').jqGrid({
   		 datatype:"local",
	 	 data:debt,
         colNames:['계정과목','금액'],
         colModel:[
         {name:'accountName',width:20, editable:false},
         {name:'amount',width:10, editable:true},
        
       ],
        viewrecords:true,
        caption:'차변',
        rownumbers: false,
        rownumWidth: 40,
        width:500,
        rowNum:10,
        viewrecords: true,
        rowList:[10,15,20],
        multiboxonly : true,
        multiselect : true,
        cellEdit : true,
        cellsubmit : 'clientArray',
        cellEdit : true,
         footerrow : true
       });
      $('#debtorTable').jqGrid('footerData', 'set', {accountName:'합계', amount:debTotal}); 
}
function showDetailJour(selAccountCode,slipCode,jourCode){ //계정과목 입력이 완료되면 해당하는 분개상세를 호출함
	//detailJourBean //분개상세 콜모델에 필요한 데이터를 뽑음
	var strcode=[];
	var strname=[];
	var colName=[];
	var colCode=[];
	var obj;
	var code;
	var name;
	var str={};
	$.ajax({
		url : "${pageContext.request.contextPath}/accounting/accountbase/account.do?oper=getDetailJour&accCode="+selAccountCode,
		datatype : "json",
		success : function(data){
			if(data.errorCode<0){
					alert(data.errorMsg+"디테일에러");
			}else{
			var detailJourCol = data.showCol
			$.each(detailJourCol,function(i){
				copydetailJourBean=copyObject(detailJourBean)
				colName.push(detailJourCol[i].accountDetailItemName);
				colCode.push(detailJourCol[i].accountDetailItemCode);
				strname.push(detailJourCol[i].accountDetailItemName+"");
				strcode.push({name:detailJourCol[i].accountDetailItemCode,width:'100',editable:true})
				//colmodel , colname 만듬
			})
			}
		},error : function(a,b,c){
			alert(a+b+c)
		},complete : function(){
				//slipCode = $('#slipTable').getCell(rowid, 'slipCode'); 
				if(detailJourList.length>0){
				obj=new Object();
				var selDetailJour=[];
				for(var i=0; i<detailJourList.length; i++){
					if($('#slipTable').getCell(currSelslip, 'slipCode')==detailJourList[i].slipCode && detailJourList[i].journalItemCode == $('#jourTable').getCell(currSelJour, 'journalItemCode') && detailJourList[i].accountDetailItemCode!="" && detailJourList[i].value!=""){
						itemcode=detailJourList[i].accountDetailItemCode;
						obj[itemcode]=detailJourList[i].value;
						obj.status="normal"
					}
					
						
					
				}
					selDetailJour.push(obj);
					if(selDetailJour[0].status==undefined)
						selDetailJour=null;
						
					showDetailJourGrid(strname,strcode,colName,colCode,selDetailJour);
				}
				
				
				else
				showDetailJourGrid(strname,strcode,colName,colCode,null);
		}
	});
	

}


function showDetailJourGrid(strname,strcode,colName,colCode,detailJour){ //데이터를 담은 분개상세를 뿌림
$('#jourDetailTabs').css({'display':'block'});
$("#jourDetailTable").jqGrid("GridUnload")
var addrow=false
 if(strname.length>0){ // strname에 데이터가 있어야 strname에 staus를 추가
   	 strname.push("status");
	 strcode.push({name : 'status' , width:'100',editable:false})
	 addrow=true
}
if(detailJour==null){
	detailJour=[]
}

$("#jourDetailTable").jqGrid({
		datatype : 'local',
		data:detailJour,// [ {dd : aa , ww : zz  }   ]
	 	colNames:strname,
        colModel:strcode,
        viewrecords:true,
        caption:'분개상세 리스트',
        rownumbers: false,
        rownumWidth: 40,
        width:1000,
        height:100,
        rowNum:10,
        viewrecords: true,
        rowList:[10,15,20],
        multiboxonly : true,
        multiselect : true,
        cellEdit : true,
        cellsubmit : 'clientArray',    
        afterSaveCell : function(rowid,name,val,iRow,iCol){
        	saveDetailJour(rowid,colName,colCode);            
        }
      });
   var nextRowId=$("#jourDetailTable").getGridParam("records");
   if(nextRowId==1 && detailJour.length<=1 && addrow){
   		//$('#jourDetailTable').setCell(1, 'status' , "insert");
   }                              // detailJour = [{}]
   if(detailJour.length<=1 && addrow && nextRowId==0){         // 위에 if문이 만족되면 한줄 추가함
	 var copyDetailJourBean=copyObject(detailJourBean)
	 copyDetailJourBean.status="insert"; 	 
   	 $("#jourDetailTable").addRowData(Number(nextRowId)+1,copyDetailJourBean); 
   	 
   }
  } 
function saveDetailJour(rowid,colName,colCode){ // 분개상세 한줄 저장해야함
	
	$.each(colName,function(i){   //분개상세 갯수만큼 돌리는데 상품 - 자금과목 1번 돌림
			saveDetailJourBean=copyObject(detailJourBean)
			saveDetailJourBean.item=colName[i];
			saveDetailJourBean.accountDetailItemCode=colCode[i];
			saveDetailJourBean.value=$('#jourDetailTable').getCell(1, colCode[i])
			saveDetailJourBean.status=$('#jourDetailTable').getCell(1, "status")
			saveDetailJourBean.slipCode=$('#slipTable').getCell(currSelslip,"slipCode");
			saveDetailJourBean.journalItemCode=$('#jourTable').getCell(currSelJour,"journalItemCode");
						
			if(detailJourList.length>0)
				for(var i=0; i<detailJourList.length; i++){
					if(detailJourList[i].slipCode==saveDetailJourBean.slipCode && detailJourList[i].journalItemCode==saveDetailJourBean.journalItemCode && detailJourList[i].accountDetailItemCode==saveDetailJourBean.accountDetailItemCode){
						if(saveDetailJourBean.status=="normal"){
							saveDetailJourBean.status="update";
					}
						detailJourList.splice(i,1)
				}
			}	
			
			detailJourList.push(saveDetailJourBean);	
	});
}    
function showCreditFunc(de,creTotal){   //대변 리스트
   $("#creditTable").jqGrid("GridUnload")
   debt=de;
   if(debt.length>1)
   for(var j=0; j<5; j++)    
   for(var i=0; i<debt.length-1; i++){
   		if(debt[i].accountCode==debt[i+1].accountCode&&debt[i].journalItemCode!=debt[i+1].journalItemCode){
   			var total=Number(debt[i].amount)+Number(debt[i+1].amount)
   			debt[i].amount=0;
   			debt[i].amount=Number(total);
   			debt.splice(i+1,1);
   		}
   }
   $('#creditTable').jqGrid({
         datatype:"local",
	 	 data:debt,
         colNames:['계정과목','금액'],
         colModel:[
         {name:'accountName',width:20, editable:false},
         {name:'amount',width:10, editable:true},
       ],
        viewrecords:true,
        caption:'대변',
        rownumbers: false,
        rownumWidth: 40,
        width:500,
        rowNum:10,
        viewrecords: true,
        rowList:[10,15,20],
        multiboxonly : true,
        multiselect : true,
        cellEdit : true,
        cellsubmit : 'clientArray',
        cellEdit : true,
        footerrow : true   
            
      });
    $('#creditTable').jqGrid('footerData', 'set', {accountName:'합계', amount:creTotal});   
}

function addJour(rowid){
	$('#jourDetailTabs').css({'display':'none'});
   var slipCode;
   var rownum = $("#slipTable").jqGrid("getGridParam", "selrow" );
   if(!isNaN(rowid)){
   	slipCode = $('#slipTable').getCell(rowid, 'slipCode');
   }
   else if(rownum!=null){
      slipCode=$("#slipTable").jqGrid("getRowData", rownum).slipCode
   }
   
   else{
   	alert("전표를 선택하세요")
   	return;
   }
   var jourdata=$("#jourTable").getDataIDs()
   var joursize=jourdata.length+1;
   var copyJourBean=copyObject(jourBean)
   copyJourBean.slipCode=slipCode;
   copyJourBean.journalItemCode=joursize
   copyJourBean.status="insert";
   var nextRowId=$("#jourTable").getGridParam("records");
   $("#jourTable").addRowData(Number(nextRowId)+1,copyJourBean);
}

</script>
<table style="width:100%">
<tr>
<td>
<input type="text" id="startDate">
<button id="searchSlip">전표검색</button>
<button id="addSlip">전표추가</button>
<button id="addJour">분개추가</button>
<button id="batchProcess">일괄처리</button>
<button id="checkData">수정된값 체크</button>
<button id="excelDown">엑셀다운</button>
<button id="pdfDown">pdf다운</button>
</td>
</tr>
</table>

<table style="width:100%">
<tr>
<td colspan="2"><table id="slipTable"></table></td>
</tr>
<tr>
<td colspan="2"><table id="jourTable"></table></td>
</tr>
<tr>
<td colspan="2" style="width: 100%"><div id=jourDetailTabs><table id="jourDetailTable"></table></div></td>
</tr>
<tr>
<td><table id="debtorTable"></table></td>

<td><table id="creditTable"></table></td>

</tr>
<tr>
<td><div id=debtorTotal></div></td>
<td><div id=creditTotal></div></td>
</tr>

</table>



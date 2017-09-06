<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<head>
<title>��ǥ �ۼ� ����</title>
</head>

<script type="text/javascript">
var detailJourBean={"slipCode" : "" , "journalItemCode" : "" , "accountDetailItemCode" : "" , "item" : "" , "value" : "" ,"status" : ""};
var slipBean={"slipCode" : "" , "writeDate":"","request":"","resolveDeptName":"","resolveDeptCode":"","slipType":"","kipyoNo":"",'balanceDiff':"","writeEmpCode":"","writeEmpName":"","okState":"","empCode":"x","status" : "","jourBeanList":""};
var jourBean={"slipCode":"","journalItemCode" : "" ,"balanceCode":"","balanceName":"","accountCode":"","accountName":"","businessCode":"","businessName":"","amount":"","keywordCode":"","keywordName":"","evidenceCode":"","evidenceName":"", "status" : ""};
var slipBeanList = []; // ��� ��ǥ�� ����Ǿ�����
var jourBeanList = []; // ��� �а��� ����Ǿ�����
var detailJourList = []; // ��� �а��󼼰� ����Ǿ�����
var lastSlipCode=0;
var showJourSplit; // ������ǥ�� �ֱ� ���ؼ� '���纸������ �а�ǥ' �� ���⿡ ������
var firstSlipCode = "SL2015";
var getToday; // ���� ��¥
var dataSet; // ��� �����͸� ��Ƽ� db�� ��������
var allDae=[]; // ���� ��ǥ�� �ش�Ǵ� �뺯�� ����
var allCha=[]; // ���� ��ǥ�� �ش�Ǵ� ������ ����
var currSelslip; // ���� ���õ� ��ǥ
var currSelJour; // ���� ���õ� �а�
var selAccountCode; // ���� ������ �������� -> �а��󼼶� , ���䰡 �޶�������
var dataSet=[];
var searchData=[];
var searchDate;
var dateType={
      dateFormat: "yy/mm/dd",
      changeMonth: true,
      changeYear: true,
      monthNames : ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'], 
      monthNamesShort : ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'], 
      dayNames : ['��', '��', 'ȭ', '��', '��', '��', '��'],
      dayNamesShort : ['��', '��', 'ȭ', '��', '��', '��', '��'],
      dayNamesMin : ['��', '��', 'ȭ', '��', '��', '��', '��'],
      showMonthAfterYear: true
 };

$(document).ready(function(){
	$('#checkData').click(function(){
		var updateList = $("#jourTable").getChangedCells('all'); //<--�������� ���� �� �ҷ���
		alert("������ üũ ----------->"+$.toJSON(slipBeanList))
		alert("�а��� üũ ----------->"+$.toJSON(jourBeanList))
		alert("�а��󼼺� üũ ----------->"+$.toJSON(detailJourList))
	})
	$('#excelDown').button()
	$('#excelDown').click(downExcel)
	$('#pdfDown').button()
	$('#pdfDown').click(downPDF)
	$('#searchSlip').button(); //��ǥ�� �˻�
	$('#searchSlip').click(searchDate);
	$("#addSlip").button(); // ��ǥ�� ���� �߰�
	$('#addSlip').click(addSlip); 
	$("#addJour").button(); // �а��� ���� �߰�
	$('#addJour').click(addJour);
	$("#batchProcess").button(); // �ϰ�ó��
	$('#batchProcess').click(processBatchData);
	$('#balance_detail_tabs').css({'display':'none'});
	$('#requestDate').datepicker(dateType); //��û��
	$('#expiryDate').datepicker(dateType);  //������
	$('#startDate').datepicker(dateType);   //�˻� ���۳�¥	
	showSlipFunc();// ��ǥ �׸���
	showJourFunc();// �а� �׸���
	getToday(); // ���� ��¥ �������� ���	
	getLastSlipCode(); //������ ��ȣ �����
	$('#jourDetailTabs').css({'display':'none'});
	//showDetailJour(); // �� �а��� �׸��� �Ѹ�
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
					alert(data.errorMsg+"�����Ͽ���");
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
	alert("��¥�� ���� �����Ͻÿ�");	
		
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
		slipBeanList=slipBeanList.concat(searchData[i]); // ��ǥ
		jourBeanList=jourBeanList.concat(searchData[i].jourBeanList) // ��ǥ.�а�
		if(searchData[i].jourBeanList)
		for(var j=0; j<searchData[i].jourBeanList.length; j++){ //��ǥ.�а�.�а���
			detailJourList=detailJourList.concat(searchData[i].jourBeanList[j].jourDetailBeanList)
		}			
	}
	
	}
	alert("������ ��ǥ--"+$.toJSON(slipBeanList))	
	alert("������ �а�--"+$.toJSON(jourBeanList))	
	alert("������ �а���--"+$.toJSON(detailJourList))	
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
						jourBeanList[k].status="delete";//����Ʈ��
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
				jourBeanList[j].status="delete";//��ǥ�� �����Ϸ��� ��ǥ�� ���� �а�,�а��󼼵� �α׸� ��������
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
	if (!confirm("��� �����Ͱ� dataSet�� ����ǰ� DB�� ���۵˴ϴ�."))
	return;	
	for(var i=0; i<slipBeanList.length; i++){ // ��ǥ �迭
		var jourList=[];
		slipBeanList[i].jourBeanList=jourList; // �� ��ǥ�� �а�����Ʈ�� ����
		for(var j=0; j<jourBeanList.length; j++){
			var jourDetailList=[];
			jourBeanList[j].jourDetailBeanList=jourDetailList; // �� �а��� �а��󼼸���Ʈ�� ����
			if(slipBeanList[i].slipCode==jourBeanList[j].slipCode){ // ���� ��ǥ�� ���� �а��� ������
				for(var k=0; k<detailJourList.length; k++){ // �ϴ� �а��� �а��󼼸� ã�Ƽ�
					if(jourBeanList[j].journalItemCode==detailJourList[k].journalItemCode){ //
						jourBeanList[j].jourDetailBeanList.push(detailJourList[k]); // �а��� �а��󼼸���Ʈ�� ����
					}
				}
				slipBeanList[i].jourBeanList.push(jourBeanList[j]);
			}	
		}
	}		
	//dataSet=[];
	dataSet=slipBeanList;
	var processData = '{"dataSet":'+ $.toJSON(dataSet) +'}'
	alert("������//-----"+$.toJSON(dataSet))
		$.ajax({
			url : '${pageContext.request.contextPath}/accounting/slip/slip.do?oper=batchProcess',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : 'post',
			data : {
			
				'batchList' : processData
			},
			success : function(data, textStatus, jqXHR){				
					if(data.errorCode<0){
					alert(data.errorMsg+"�����Ͽ���");
				}else{
					alert("ó���Ǿ����ϴ�");	
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

function copyObject(obj){           //ī�� , �迭�ּ� ����
	 	return JSON.parse(JSON.stringify(obj));
	 	//JSON.parse -> json���ڿ� -> �迭
	 	//JSON.stringify -> �迭 -> json���ڿ�
} 
function getLastSlipCode(){
	$.ajax({
		url :"${pageContext.request.contextPath}/accounting/slip/slip.do?oper=getLastSlipCode",
		dataType:'json',
		success: function(data){
		if(data.errorCode<0){
					alert(data.errorMsg+"�����Ͽ���");
				}else{
			lastSlipCode=Number(data.lastSlipCode);   
			}
	 	},error : function(a,b,c){
	 		alert("��������ȣ ������� ����"+$.toJSON(a)+b+c)
	 	}
	});
}

function getToday(){ // �ۼ����� ������ ����
var date = new Date(); 
var year = date.getFullYear(); 
var month = new String(date.getMonth()+1); 
var day = new String(date.getDate()); 
getToday = year+"/"+month+"/"+day;
}
function showSlipFunc(){ // ��ǥ ����Ʈ 
  $("#slipTable").jqGrid("GridUnload") 
	    $('#slipTable').jqGrid({
	   	    datatype:"local",
  			data : slipBeanList,
	      colNames:['��ǥ�ڵ�','�ۼ�����','ǰ�ǳ�����','���Ǻμ��ڵ�','���Ǻμ���','����','���λ���','��ǥ��ȣ','��������','�ۼ����ڵ�','�ۼ��ڸ�','������','status'],
	      colModel:[
	      {name:'slipCode',width:15, editable:false,align:"center"},
	      {name:'writeDate',width:20, editable:false,align:"center"},
	      {name:'request',width:30, editable:true,align:"center"},
	      {name:'resolveDeptCode',width:20, editable:false,align:"center"},
	      {name:'resolveDeptName',width:20, editable:false,align:"center"},
	      {name:'slipType',width:10, editable:true,edittype:"select",
				editoptions:{value:"�Ϲ�:�Ϲ�"}},
	      {name:'okState',width:10, editable:false,align:"center"},
	      {name:'kipyoNo',width:20, editable:false,align:"center"},
	      {name:'balanceDiff',width:20, editable:false,align:"center"},
	      {name:'writeEmpCode',width:20, editable:false,align:"center"},
	      {name:'writeEmpName',width:20, editable:false,align:"center"},
	      {name:'empCode',width:20, editable:false,align:"center"},
	      {name:'status',width:10, editable:false,align:"center"},
	 	      
	    ],
	      viewrecords:true,
	      caption:'��ǥ����Ʈ',
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
          afterSaveCell : function(rowid,name,val,iRow,iCol) {  //�а��ۼ�����.
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
function saveSlip(rowid){				// ���������� �� ��ǥ�� �����ؾ���
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
	slipBeanList.push(copyslipBean)         // ��� ��ǥ�� ����Ǿ�����
	 
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
function checkdaecha(rowid,slipid){   //���������� ��ǥ�� �����ؾ���;;
	 var alldae=[];
	 var allcha=[];
	 var daeAmount=0;
	 var chaAmount=0;
	 var diffAmount=0;
	 var dataIds = $("#jourTable").getDataIDs(); // �а��� �ִ� ��� rowid �� ������ , �뺯 , �����ݾ� ����ò��� 
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

function showdaecha(row){                   // ��ǥ ����� ��������ǥ ������ ����...
	var rowid;
	var allDae2=[]
	var allCha2=[]
	var debTotal=0;//������ �� �ݾ�
	var creTotal=0;//�뺯�� �� �ݾ�
	rowid=row;
	slipCode = $('#slipTable').getCell(rowid, 'slipCode');
	for(var i=0; i<jourBeanList.length; i++){
		if(slipCode==jourBeanList[i].slipCode && jourBeanList[i].balanceCode=="DC001"){
			var copyDae=copyObject(jourBean)
			creTotal+=Number(jourBeanList[i].amount) //�հ�
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
	showDebtorFunc(allCha2,debTotal); //������
	showCreditFunc(allDae2,creTotal); //�뺯��
}

function addSlip(){
	$('#jourDetailTabs').css({'display':'none'});
   $("#jourDetailTable").clearGridData();
   accountCode="" // ����ǥ �����ϸ� ���� accountCode ���� �ʱ�ȭ �ؾ���
   lastSlipCode+=1;//�ű�ٰ� +1
   var initSlipCode=firstSlipCode+lastSlipCode;  //�տ� SL2015�� ��ħ
   var copySlipBean = copyObject(slipBean);
   copySlipBean.slipCode=initSlipCode;                                           //��ǥ �߰�
   copySlipBean.writeDate=getToday;
   copySlipBean.resolveDeptCode="${sessionScope.deptcode}";
   copySlipBean.resolveDeptName="${sessionScope.deptname}";
   copySlipBean.balanceDiff=0;
   copySlipBean.writeEmpCode="${sessionScope.id}";
   copySlipBean.writeEmpName="${sessionScope.name}";
   copySlipBean.okState="�̰�"
   copySlipBean.status="insert";
   var nextRowId=$("#slipTable").getGridParam("records");
   $("#slipTable").addRowData(Number(nextRowId)+1,copySlipBean);
}

function showJourFunc(id){ //�а� ����Ʈ
    $("#jourTable").jqGrid("GridUnload") 
	rownum = id-1;
	var slipCode="" // �ʱ�ȭ�۾�
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
	     colNames:['��ǥ�ڵ�','�а��ڵ�','���������ڵ�','��������','���������ڵ�','��������','�ŷ�ó�ڵ�','�ŷ�ó��','�ݾ�','�����ڵ�','�����','�����ڵ�','����','status'],
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
	      caption:'�а�����Ʈ',
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
	      afterSaveCell : function(rowid,name,val,iRow,iCol) {  //�а��ۼ�����.

	    	 var dataIds = $("#jourTable").getDataIDs(); // 123
   			 var lastRowId = dataIds.length; 			 // 3
    			
				
	    }, onCellSelect: function(rowid,element){
	    currSelJour=rowid;
          if(element==3 ){
         	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=ACC&callBack=inputBalance',
     	 	 '��������','width=300px; height=350px;left=1000px; top=100px;');
 		  }
          
          else if(element==5){
             window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getCodeList&callBack=inputAccount',
     	 	 '��������','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==7){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=BUSI&callBack=inputBusiness',
     	 	 '�ŷ�ó','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==10){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=KEY&callBack=inputKeyword&accCode='+selAccountCode,
     	 	 '�����ڵ�','width=300px; height=350px;left=1000px; top=100px;');
          }
          else if(element==12){
          	 window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=EVI&callBack=inputEvidence',
     	 	 '�����ڵ�','width=300px; height=350px;left=1000px; top=100px;');
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


 function inputBalance(openerJourRowid, code, codename){    //�������� �Է� �ݹ��Լ�
  $("#jourTable").setCell(openerJourRowid, 'balanceCode', code);
  $("#jourTable").setCell(openerJourRowid, 'balanceName', codename);  
 }
 function inputAccount(openerJourRowid, code, codename){    //�������� �Է� �ݹ��Լ�
  selAccountCode=code
  $("#jourTable").setCell(openerJourRowid, 'accountCode', code);
  $("#jourTable").setCell(openerJourRowid, 'accountName', codename); 
  if(selAccountCode!=""){ // �������� ���õǸ� �а��� ����
  		showDetailJour(selAccountCode,currSelslip,currSelJour) // �������� ������ �ͷ�Ǹ� �а��󼼸� ȣ�� 
 	}
 }
 function inputBusiness(openerJourRowid, code, codename){   //�ŷ�ó �Է�
  $("#jourTable").setCell(openerJourRowid, 'businessCode', code);
  $("#jourTable").setCell(openerJourRowid, 'businessName', codename);
 }
 
 function inputKeyword(openerJourRowid, code, codename){   //�ŷ�ó �Է�
  $("#jourTable").setCell(openerJourRowid, 'keywordCode', code);
  $("#jourTable").setCell(openerJourRowid, 'keywordName', codename);
 }
 
  function inputEvidence(openerJourRowid, code, codename){   //�ŷ�ó �Է�
  $("#jourTable").setCell(openerJourRowid, 'evidenceCode', code);
  $("#jourTable").setCell(openerJourRowid, 'evidenceName', codename);
  if($('#jourTable').getCell(openerJourRowid, 'evidenceName')!=""){
  	saveJour(openerJourRowid);
  	checkdaecha(openerJourRowid,currSelslip);
    saveSlip(currSelJour); //checkdaecha 
    showdaecha(currSelslip) 
  }
 }
function showDebtorFunc(de,debTotal){   			    //���� ����Ʈ
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
         colNames:['��������','�ݾ�'],
         colModel:[
         {name:'accountName',width:20, editable:false},
         {name:'amount',width:10, editable:true},
        
       ],
        viewrecords:true,
        caption:'����',
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
      $('#debtorTable').jqGrid('footerData', 'set', {accountName:'�հ�', amount:debTotal}); 
}
function showDetailJour(selAccountCode,slipCode,jourCode){ //�������� �Է��� �Ϸ�Ǹ� �ش��ϴ� �а��󼼸� ȣ����
	//detailJourBean //�а��� �ݸ𵨿� �ʿ��� �����͸� ����
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
					alert(data.errorMsg+"�����Ͽ���");
			}else{
			var detailJourCol = data.showCol
			$.each(detailJourCol,function(i){
				copydetailJourBean=copyObject(detailJourBean)
				colName.push(detailJourCol[i].accountDetailItemName);
				colCode.push(detailJourCol[i].accountDetailItemCode);
				strname.push(detailJourCol[i].accountDetailItemName+"");
				strcode.push({name:detailJourCol[i].accountDetailItemCode,width:'100',editable:true})
				//colmodel , colname ����
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


function showDetailJourGrid(strname,strcode,colName,colCode,detailJour){ //�����͸� ���� �а��󼼸� �Ѹ�
$('#jourDetailTabs').css({'display':'block'});
$("#jourDetailTable").jqGrid("GridUnload")
var addrow=false
 if(strname.length>0){ // strname�� �����Ͱ� �־�� strname�� staus�� �߰�
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
        caption:'�а��� ����Ʈ',
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
   if(detailJour.length<=1 && addrow && nextRowId==0){         // ���� if���� �����Ǹ� ���� �߰���
	 var copyDetailJourBean=copyObject(detailJourBean)
	 copyDetailJourBean.status="insert"; 	 
   	 $("#jourDetailTable").addRowData(Number(nextRowId)+1,copyDetailJourBean); 
   	 
   }
  } 
function saveDetailJour(rowid,colName,colCode){ // �а��� ���� �����ؾ���
	
	$.each(colName,function(i){   //�а��� ������ŭ �����µ� ��ǰ - �ڱݰ��� 1�� ����
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
function showCreditFunc(de,creTotal){   //�뺯 ����Ʈ
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
         colNames:['��������','�ݾ�'],
         colModel:[
         {name:'accountName',width:20, editable:false},
         {name:'amount',width:10, editable:true},
       ],
        viewrecords:true,
        caption:'�뺯',
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
    $('#creditTable').jqGrid('footerData', 'set', {accountName:'�հ�', amount:creTotal});   
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
   	alert("��ǥ�� �����ϼ���")
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
<button id="searchSlip">��ǥ�˻�</button>
<button id="addSlip">��ǥ�߰�</button>
<button id="addJour">�а��߰�</button>
<button id="batchProcess">�ϰ�ó��</button>
<button id="checkData">�����Ȱ� üũ</button>
<button id="excelDown">�����ٿ�</button>
<button id="pdfDown">pdf�ٿ�</button>
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



<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<head>
<title>리스트폼임니다</title>
</head>
<style>
<!--
#updateDetailTabs {
	width: 705px;
	font-size: 12px;
}

#empdetail {
	font-size: 18px;
}

#empImg {
	border: 1px solid green;
	width: 150px;
	height: 170px;
	background-size: cover
}

#imgFrame {
	width: 200px;
	height: 270px;
}

#companydetail {<!--
	회사정보 --> width: 705px;
	font-size: 12px;
}
-->
</style>
<script type="text/javascript">
	var empBean;
	var dataSet;
	var index;

	$(document).ready(
			function() {
				showEmpGrid();
				$('#updateDetailTabs').css({
					'display' : 'none'
				});
				 $('#xmlView').button();
				 $('#xmlView').click(showXmlView);
				$('#updateDetailTabs').tabs();
				$('#addEmpBtn').button();
				$('#delEmpBtn').button();
				$('#modifyEmpBtn').button();
				$('#allDataProcessBtn').button();
				$('#empBirthday').datepicker(
								{
									changeYear : true,
									changeMonth : true,
									monthNames : [ '1월', '2월', '3월', '4월',
											'5월', '6월', '7월', '8월', '9월',
											'10월', '11월', '12월' ],
									monthNamesShort : [ '1월', '2월', '3월', '4월',
											'5월', '6월', '7월', '8월', '9월',
											'10월', '11월', '12월' ],
									firstDay : 0,
									//showAnim:"fadeIn",
									duration : "slow",
									showOtherMonths : true,
									showOptions : {
										direction : "up"
									},
									//numberOfMonths: [ 3, 3 ],
									dateFormat : "yy-mm-dd",
									gotoCurrent : true,
								});

				///////////////////////// ▼  일괄처리  ▼  //////////////////////////
				$("#allDataProcessBtn").click(function() {
					setBatchData(); // 사원정보 수정
					ProcessData(); // 'list' 로 toJson 작업 -> sendBatchData 호출 url = emp.do oper=batch
					location.href = "listForm.do";
				});

				//////////////////////// ▲ 일괄처리 끝 ▲ /////////////////////////  
			})



 
 function showXmlView(){
  $.ajax({
   url:'${pageContext.servletContext.contextPath}/base/emp.do',
   data:{oper:"setDeptXmlList"},
   dataType:"xml",
   cache:false,
   success:function(data){
    var list=$(data).find("array-list");
    var empList=list.find("emp-bean");
    alert(
     "1- : "+empList.eq(0).find("emp-name").text()+"\n"+
     "2- : "+empList.eq(3).find("emp-head-name").text()+"\n"+
     "요소 xmlns:xsi : "+empList.eq(0).attr("xmlns:xsi")+"\n"+
     "요소 xmlns:java : "+empList.eq(0).attr("xmlns:java")+"\n"+
     "요소 xsi:type : "+empList.attr("xsi:type")+"\n"
    );
   },error : function(a,b,c){
   	alert("xmlview error"+a+b+c);
   }
  });
 }

			
	function sendBatchData(list2) {
		alert("---"+list2)
		$.ajax({
			url : 'base/emp.do?oper=batchProcess',
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			type : 'post',
			data : {
				'batchList' : list2
			},
			success : function(data, textStatus, jqXHR) {
				if (data.errorCode < 0) {
					alert(data.errorMsg);
				} else {
					alert("처리 되었습니다.");
					$("#grid").trigger("reloadGrid");

				}
			},
			error : function(jqXHR, textStatus, error) {
				alert("일괄처리 오류입니다!>>");
			}
		});

	}
	function ProcessData() {
		if (!confirm("계속 진행????"))
			return;

		var list2 = '{"empBeanList":' + $.toJSON(updateEmpBeanArray) + '}';
		sendBatchData(list2);

	}
	function copyObject(obj) { //카피 , 배열주소 섞기
		return JSON.parse(JSON.stringify(obj));
		//JSON.parse -> json문자열 -> 배열
		//JSON.stringify -> 배열 -> json문자열
	}

	function setBatchData() {
		updateEmpBeanArray = [];
		var delEmpBean = {
         "status" : "",
         "empName" : "", 
         "empBirthday" : "", 
         "empTel" : "",
         "empPhone" : "",
         "empZip" : "",
         "empAddr" : "",
         "empPw" : "",
         "deptCode" : "",
         "positionCode" : "",
         "empCode" : "",
      };
		empBean.empName = document.getElementById("empName").value;
		empBean.empBirthday = document.getElementById("empBirthday").value;
		empBean.empTel = document.getElementById("empTel").value;
		empBean.empPhone = document.getElementById("empPhone").value;
		empBean.empZip = document.getElementById("empZip").value;
		empBean.empAddr = document.getElementById("empAddr").value;
		empBean.deptCode = document.getElementById("deptCode").value;
		empBean.positionCode = document.getElementById("positionCode").value;
		empBean.empFilename=document.getElementById("empFilename").value;
		empBean.empTempFilename=document.getElementById("empFilename").value;
		empBean.status = "update";
		updateEmpBeanArray.push(empBean);

		var deleteList = $("#grid").jqGrid('getGridParam', 'selarrrow'); //<-- 체크한 줄 불러옴
		if (deleteList != "") {
			for (var index = 0; index < deleteList.length; index++) {
				var copyEmpBean = copyObject(delEmpBean);
				copyEmpBean.empCode = $("#grid").getRowData(deleteList[index]).empCode;
				copyEmpBean.status="delete";
				updateEmpBeanArray.push(copyEmpBean);
			}
		}
	}

	function copyObject(obj) {
		return JSON.parse(JSON.stringify(obj));
	}

	function showEmpDetail() { //        신상/재직정보 탭
		empBean = copyObject(dataSet[index]);
		$("#empCode").text(dataSet[index].empCode)
		$("#empName").val(dataSet[index].empName)
		$("#empBirthday").val(dataSet[index].empBirthday)
		$("#empTel").val(dataSet[index].empTel)
		$("#empPhone").val(dataSet[index].empPhone)
		$("#empZip").val(dataSet[index].empZip)
		$("#empAddr").val(dataSet[index].empAddr)
		$("#deptCode").val(dataSet[index].deptCode)
		$("#positionCode").val(dataSet[index].positionCode)
		alert("C:\\dev\\httpd\\htdocs\\accountingProject\\temp\\"+dataSet[index].empFilename+"유자소주")
		parent.document.frames[0].$("#empImg").attr({"background":"C:\\dev\\httpd\\htdocs\\accountingProject\\temp\\"+dataSet[index].empFilename});
		$('#updateDetailTabs').css({
			'display' : 'block'
		});
	}

	////////////////////////////////emp grid/////////////////////////////////////
	function showEmpGrid() {

		$('#grid').jqGrid({
			url : '${pageContext.request.contextPath}/base/emp.do?oper=getEmpList',
			datatype : 'json',
			jsonReader : {
				page : 'page',
				total : 'total',
				root : 'list'

			},
			beforeProcessing : function(data) {
				if (data.errorCode < 0) {
					alert(data.errorMsg);
				} else {
					dataSet = data.list;
					empBean = data.empBean;

				}
			},

			colNames : [ '사원번호', '이 름', '주소', '생일' ],
			colModel : [ {
				name : 'empCode',
				width : 20,
				editable : false
			}, {
				name : 'empName',
				width : 20,
				editable : false
			}, {
				name : 'empAddr',
				width : 30,
				editable : false
			}, {
				name : 'empBirthday',
				width : 50,
				editable : false
			}, ],
			ondblClickRow : function(id) {
				index = id - 1;
				showEmpDetail();

			},
			width : 500,
			height : 400,
			viewrecords : true,
			multiselect : true,
			//multiboxonly : true,
			cellsubmit : 'clientArray',
			rownumbers : true,
			sortname : 'empCode',
			sortorder : 'desc',
			sortable : true,
			rowNum : 5,
			rowList : [ 3, 6, 9 ],
			pager : '#pager',
			caption : '사원리스트'
		});
		$("#grid").jqGrid('navGrid', "#pager", {
			add : false,
			edit : false,
			del : false
		}, //options
		{}, // edit options
		{}, // add options
		{}, //del options
		{} // search options
		);

	}
</script>
<button id=xmlView>xml으로보기</button>
<table id="grid"></table>
<div id="pager"></div>
<br>

<form action="${pageContext.request.contextPath}/base/emp.do" id="empForm">
	<input type="hidden" name="oper" value="modify">
	<div id="updateDetailTabs">
		<ul>
			<li id="human"><a href="#empdetail">신원정보</a></li>
			<li id="company"><a href="#companydetail">재직정보</a></li>
		</ul>
		<div id='empdetail'>
			<input type="hidden" id="empFilename" name="empFilename">
			<table><tr>
				<td ><iframe  height="220px" name="imgFrame" id="imgFrame" src="addImg.do" frameborder="0" allowfullscreen></iframe></td>
			
					      
					<td width="500px">
						<table style="font-size: 2em">
							<tr>
								<td><label>사원번호 : </label></td>
								<td><div id="empCode"></div></td>
							</tr>
							<tr>
								<td><label>사원이름 : </label></td>
								<td><input type="text" id="empName"></td>
							</tr>
							<tr>
								<td><label>생일 : </label></td>
								<td><input type="text" id="empBirthday"></td>
							</tr>
							<tr>
								<td><label>전화번호 : </label></td>
								<td><input type="text" id="empTel"></td>
							</tr>
							<tr>
								<td><label>휴대폰 : </label></td>
								<td><input type="text" id="empPhone"></td>
							</tr>
							<tr>
								<td><label>우편번호 : </label></td>
								<td><input type="text" id="empZip"></td>
							</tr>
							<tr>
								<td><label>주소 : </label></td>
								<td><input type="text" id="empAddr"></td>
							</tr>
							<tr>
								<td><label>부서코드 : </label></td>
								<td><input type="text" id="deptCode"></td>
							</tr>
							<tr>
								<td><label>직급코드 : </label></td>
								<td><input type="text" id="positionCode"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="button" id="allDataProcessBtn"
						value="사원신상정보 일괄처리"></td>
				</tr>
			</table>
		</div>
		<!-- 신원정보끝 -->
	</div>
	<br>
	<!--  위에 큰 div 끝 -->
</form>

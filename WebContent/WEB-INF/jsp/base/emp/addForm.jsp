<%@ page language="java" contentType="text/html; charset=EUC-KR"  pageEncoding="EUC-KR"%>
<%@ page import="java.util.ArrayList" %>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- 맞음 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- 맞음 -->

</head>
<style>

#addForm {width:650px; font-size:15px;}
table {font-size:12px;}
#empImg{
   border : 1px solid skyblue; width : 200px; height : 200px; background-size:100% 100%;
}

#imgFrame{
   width : 200px; height : 270px;
}
</style>


<script>

var empBean;
var emptyEmpBean;
var index;

$(document).ready(function() {
    $('#addForm').tabs();
    setEmpCode();    //사원번호 세팅
    initData();
    $('#empBirthday').datepicker({
                           changeMonth : true,
                           changeYear : true,

                           monthNames : [ '1월', '2월', '3월', '4월',
                                 '5월', '6월', '7월', '8월', '9월',
                                 '10월', '11월', '12월' ],
                           monthNamesShort : [ '1월', '2월', '3월', '4월',
                                 '5월', '6월', '7월', '8월', '9월',
                                 '10월', '11월', '12월' ],

                           showAnim : "fadeIn",
                           duration : "slow",
                           firstDay : 0,
                           dateFormat : "yy/mm/dd",
                           showMonthAfterYear : true
                        });
    $('#empZip').attr('readOnly', true);
    $('#empAddr').attr('readOnly', true);
    $("#zipBtn").click(selectZip);
    $('#selDeptBtn').click(function(){
        var features = 'width=300px; height=340px; left=550px; top=150px; titlebar=no; status=no';
        window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=DEPT&callBack=inputDept','부서검색',features);
    });
    $('#selPositionBtn').click(function(){
        var features = 'width=300px; height=340px; left=550px; top=150px; titlebar=no; status=no';
        window.open('${pageContext.request.contextPath}/base/code/helpCode.do?oper=getInfocode&code=POSI&callBack=inputPosi','직급검색',features);
    });
   
    $('#addBtn').button();
    $('#addBtn').click(function(){
         setEmpData();
    })
});
function inputDept(rowid,code,name){
	$("#deptCode").val(code);
}

function inputPosi(rowid,code,name){
	$("#positionCode").val(code);
}

function selectZip() {
      var features = 'width=600px; height=520px; left=400px; top=100px;';
      window.open('${pageContext.request.contextPath}/base/post/post.do', '주소검색', features);
   }
   function initData(){            
      $("#empName").val("");
      $("#empBirthday").val("");
      $("#empTel").val("");
      $("#empPhone").val("");
      $("#empZip").val("");
      $("#empAddr").val("");
      $("#deptCode").val("");
      $("#positionCode").val("");

   }

function checkEmpData(){
   var ename=$.trim($('#empName').val());
   var deptCode=$.trim($('#deptCode').val());
   
   if(ename=='') {alert('이름을 입력하세요.'); $('#empName').focus(); return false;}
      else return true;
   if(deptCode=='') {alert('부서번호를 입력하세요.'); $('#deptCode').focus(); return false;}
      else return true;
}

   function setEmpCode() {
      $.ajax({
         url : "${pageContext.request.contextPath}/base/emp.do?oper=setEmpCode",
         dataType : "json",
         success : function(data) {
         	alert($.toJSON(data))
            if (data.errorCode < 0) {
               alert(data.errorMsg);
            } else {
               $("#empCode").val(data.lastEmpCode);
               empBean=data.emptyEmpBean            
            }
         }
      });

   }


function copyObject(obj){
    return JSON.parse(JSON.stringify(obj));
}

function setEmpData(){
   if(!confirm("등록하시겠습니까?")) return;
   empBean.empCode=document.getElementById("empCode").value;
   empBean.empName=document.getElementById("empName").value;
   empBean.empPw=document.getElementById("empPw").value;
   empBean.empBirthday=document.getElementById("empBirthday").value;
   empBean.empTel=document.getElementById("empTel").value;
   empBean.empPhone=document.getElementById("empPhone").value;
   empBean.empZip=document.getElementById("empZip").value;
   empBean.empAddr=document.getElementById("empAddr").value;
   empBean.empFilename=document.getElementById("empFilename").value;
   empBean.empTempFilename=document.getElementById("empFilename").value;
   empBean.deptCode=document.getElementById("deptCode").value;
   empBean.deptName=document.getElementById("deptName").value;
   empBean.positionCode=document.getElementById("positionCode").value;
   empBean.status="insert";
   
   var list='{"empBean":'+$.toJSON(empBean)+'}';
   alert(list);
   sendEmpData(list);
   window.opener.location.href="listForm.do";
   window.close();
}


function sendEmpData(list){
   $.ajax({
       url : '${pageContext.request.contextPath}/base/emp.do?oper=insertEmp',
       contentType : "application/x-www-form-urlencoded; charset=UTF-8",
       type : 'post',
       data :{'insertList':list},
       success : function(data, textStatus, jqXHR) {
         if(data.errorCode<0){
            alert(data.errorMsg);
         }else{
             alert("처리 되었습니다.");
          }
       },
       error : function(jqXHR, textStatus, error) {
           alert("일괄처리 오류입니다!>>");
       }
   });
   
}


</script>
<body>

   <div id="addForm">
   <ul>
      <li><a href="#">직원등록</a></li>
   </ul>
      <div id="tabs">
      <table>
         <tr>
         	<td><input type="hidden" id="empFilename" name="empFilename">
            <table><tr>
               <td><iframe id='imgFrame' src="addImg.do" frameborder="0" allowfullscreen></iframe></td>
            </tr></table>
        	 </td>
			<td>
            <form action="${pageContext.request.contextPath}/base/emp.do?oper=add" name="joinData">
            <input type="hidden" name="oper" value="add">
            <table>
               <tr><td>사원번호:</td>
                  <td><input type="text" size="8" id="empCode" name="empCode" readonly></td>
               </tr>
               <tr><td>비밀번호 :</td>
                  <td><input type="text" size="8" name="empPw" id="empPw"></td>
               </tr>
               <tr><td>이 름 :</td>
                  <td><input type="text" size="8" name="empName" id="empName"></td>
               </tr>
               <tr><td>생년월일 :</td>
                  <td><input type="text" size="10" id="empBirthday" name="empBirthday"></td>
               </tr>
               <tr>
                  <td><label>전화번호: </label></td>
                  <td><input type=text size="20" id="empTel" name="empTel"></td>
               </tr>
               <tr>
                  <td><label>핸드폰번호: </label></td>
                  <td><input type=text size="20" id="empPhone" name="empPhone"></td>
               </tr>
               <tr><td>우편번호:</td>
                  <td><input type="text" size="10" id="empZip" name="empZip">
                  <input type="button" id="zipBtn" value="우편번호"></td>
               </tr>
               <tr><td>주 소 :</td>
                  <td><input type="text" size="50" id="empAddr" name="empAddr"></td>
               </tr>
               <tr><td>부서코드 :</td>
                  <td><input type=text name="deptNo" id="deptCode" size="4" readonly> <span id="empDept"></span>
                  <input type="button" id="selDeptBtn" value="+"></td>
               </tr>
               <tr><td>직급코드 :</td>
                  <td><input type=text name="positionNo" id="positionCode" size="2" readonly> <span id="empPosition"></span>
                  <input type="button" id="selPositionBtn" value="+"></td>
               </tr>
               <tr><td><input type=button id=addBtn value="등록"></td></tr>
               <tr><td><input type=hidden id=deptName></td></tr>
            </table>
         </form>
         </td></tr>
      </table>
      </div>
   </div>

</body>
</html>
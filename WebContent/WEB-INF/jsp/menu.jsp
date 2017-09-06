<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>

<script>
	 $(document).ready(function() {
		
		$('#menu').menu();
		$('#accordion').accordion();
		$('#logout').button();
		$('#login').button();
		$('#logout').click(function(){
			location.href="${pageContext.request.contextPath}/base/emp.do?oper=logout";
		});
		$('#login').click(function(){
			location.href="${pageContext.request.contextPath}/base/login/loginForm.do";
		});
	 });
		function addEmp(){
           var features = 'width=700px; height=650px; left=100px; top=10px; overflow=auto;';
           window.open('${pageContext.request.contextPath}/base/emp/addForm.do','사원등록', features);
    }
</script>
<style type="text/css">
td{font-size:80%;}
</style>
</head>
<body style="background-color:#A4e3dd">
	<c:if test='${sessionScope.id eq null}'>
		<center>
			<br> <input type=button value="관리자로그인" id="login"> 
		</center>
	</c:if>
	<c:if test='${sessionScope.id ne null}'>
		<center>
			<br> <b>관리자: [${sessionScope.id}] <br>부서:[${sessionScope.deptname}]<br> 
			<input type=button value="로그아웃" id="logout"></b> <br> <br>
		</center>
		<div id='accordion'>
			<h3>사원정보</h3>
			<div>
					<a href="${pageContext.request.contextPath}/base/emp/listForm.do">사원조회</a><br>
					<a href="#" onclick="addEmp()" id="addEmp">사원등록</a> 			
			</div>
			<c:if test='${sessionScope.deptname eq "회계1팀"}'>
			<h3>전표/장부관리</h3>
			<div>
					<a href="${pageContext.request.contextPath}/accounting/slip/slipForm.do">전표입력</a><br>	
			</div>
			</c:if>
			<h3>환경설정</h3>
			<div>
					<a href="${pageContext.request.contextPath}/base/code/listCode.do">코드관리</a><br>	
			</div>
		</div>
	</c:if>
</body>

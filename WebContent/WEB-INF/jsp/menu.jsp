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
           window.open('${pageContext.request.contextPath}/base/emp/addForm.do','������', features);
    }
</script>
<style type="text/css">
td{font-size:80%;}
</style>
</head>
<body style="background-color:#A4e3dd">
	<c:if test='${sessionScope.id eq null}'>
		<center>
			<br> <input type=button value="�����ڷα���" id="login"> 
		</center>
	</c:if>
	<c:if test='${sessionScope.id ne null}'>
		<center>
			<br> <b>������: [${sessionScope.id}] <br>�μ�:[${sessionScope.deptname}]<br> 
			<input type=button value="�α׾ƿ�" id="logout"></b> <br> <br>
		</center>
		<div id='accordion'>
			<h3>�������</h3>
			<div>
					<a href="${pageContext.request.contextPath}/base/emp/listForm.do">�����ȸ</a><br>
					<a href="#" onclick="addEmp()" id="addEmp">������</a> 			
			</div>
			<c:if test='${sessionScope.deptname eq "ȸ��1��"}'>
			<h3>��ǥ/��ΰ���</h3>
			<div>
					<a href="${pageContext.request.contextPath}/accounting/slip/slipForm.do">��ǥ�Է�</a><br>	
			</div>
			</c:if>
			<h3>ȯ�漳��</h3>
			<div>
					<a href="${pageContext.request.contextPath}/base/code/listCode.do">�ڵ����</a><br>	
			</div>
		</div>
	</c:if>
</body>

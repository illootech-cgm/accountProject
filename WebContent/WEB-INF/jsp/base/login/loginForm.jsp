<%@ page language="java" import="java.util.*" pageEncoding="euc-kr" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<script src="${pageContext.request.contextPath}/js/jquery-1.8.3.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#loginBtn').button();
	$('#id').focus();
});
</script>

</head>
<body>
	<form action="${pageContext.request.contextPath}/base/emp.do" method="post">
		<input type="hidden" name="oper" value="login">
		<br><br>
		<table align="center">
			<tr><td style="font-size:1em">아&nbsp;이&nbsp;디  :<td><input type="text" id="id" name="id"></td></tr>
			<tr><td style="font-size:1em" >비밀 번호 :<td><input type="password" id="pw" name="pw"></td></tr>
			<tr><td colspan="2" align="center">
			<input type="submit" value="확인" id="loginBtn">
			 </td></tr>
</table>
${msg}
</form></body>
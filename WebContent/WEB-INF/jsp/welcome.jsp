<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>ȯ���մϴ�</title>
</head>
<body>
	<%if(session.getAttribute("id")==null){ %>
	<img src="${pageContext.request.contextPath}/images/welcome1.png">
	<%}else{ %>
	<img src="${pageContext.request.contextPath}/images/welcome2.png">
	<%}%>
</body>
</html>
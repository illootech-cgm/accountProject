<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title><decorator:title/></title>

<style type="text/css">
td{font-size:80%;}
</style>
<decorator:head />

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- 맞음 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- 맞음 -->

</head>
<body>
	<center>
		<table class="mainTable">
			<tr>
				<td align="center" colspan="2" style="width:1000px;">
				<jsp:include page="top.jsp" /></td>
			</tr>
			<tr style="height: 500px">
				<td valign="top" style="width: 150px;">
					<jsp:include page="menu.jsp" />
				</td>
				<td align="center" valign="top"><decorator:body /></td>
			</tr>
			<tr>
				<td colspan="2"><jsp:include page="bottom.jsp" />
				</td>
			</tr>
		</table>
	</center>
</body>
</html>
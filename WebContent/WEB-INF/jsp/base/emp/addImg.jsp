<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<style type="text/css">
#empImg{
	border : 1px solid green; width : 150px; height : 170px; background-size:cover
}

</style>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- 맞음 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- 맞음 -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- 맞음 -->
<script type="text/javascript">
var imgFilename;
$(document).ready(function(){
	
});
$('#addImgForm').ajaxForm({
		dataType:'json',
	    success: function(responseText, statusText, xhr, $form){
			if(responseText.errorCode<0){
				alert(responseText.errorMsg);
			}else{
		    	imgFilename=responseText.imgFilename;
		    	document.getElementById('imgFilename').value=imgFilename;
	    		parent.document.getElementById('empFilename').value=imgFilename;
	    		alert('사진이 저장되었습니다.');
	    	}
		},error : function(a,b,c){
			alert(a+"//"+b+"//"+c)
		}
});
function insertImg(img){
	alert(img+"이 사진이왔네여")
   parent.document.frames[0].document.getElementById('empImg').background=img.value;
}
</script>

<form id="addImgForm" action="${pageContext.request.contextPath}/base/emp.do"  method="post" enctype="multipart/form-data" name="addImgForm">
	<input type=hidden name="oper" value="saveImg">
	<table><tr><td id="empImg"></td></tr></table>
	<input type=file id="tmpfile" name="tmpfile" style="display: none;" onchange="insertImg(this)">
	<button type="button" onclick="document.getElementById('tmpfile').click();">찾아보기</button>
	<input type=submit id="btn1" name="btn1" style="display:none">
	<button type="button" onclick="document.getElementById('btn1').click();">저장</button>
	<input type="hidden" id="imgFilename">
</form>


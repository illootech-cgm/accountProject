<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<style type="text/css">
#empImg{
	border : 1px solid green; width : 150px; height : 170px; background-size:cover
}

</style>
<script src="http://code.jquery.com/jquery-1.7.js"> </script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/eggplant/jquery-ui.css" /><!-- ���� -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/css/ui.jqgrid.css" /><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/i18n/grid.locale-en.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.min.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/scripts/js/jquery.jqGrid.src.js" type="text/javascript"></script><!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.9.2.custom.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.json-2.3.js"></script> <!-- ���� -->
<script src="${pageContext.request.contextPath}/js/jquery.form.js"></script> <!-- ���� -->
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
	    		alert('������ ����Ǿ����ϴ�.');
	    	}
		},error : function(a,b,c){
			alert(a+"//"+b+"//"+c)
		}
});
function insertImg(img){
	alert(img+"�� �����̿Գ׿�")
   parent.document.frames[0].document.getElementById('empImg').background=img.value;
}
</script>

<form id="addImgForm" action="${pageContext.request.contextPath}/base/emp.do"  method="post" enctype="multipart/form-data" name="addImgForm">
	<input type=hidden name="oper" value="saveImg">
	<table><tr><td id="empImg"></td></tr></table>
	<input type=file id="tmpfile" name="tmpfile" style="display: none;" onchange="insertImg(this)">
	<button type="button" onclick="document.getElementById('tmpfile').click();">ã�ƺ���</button>
	<input type=submit id="btn1" name="btn1" style="display:none">
	<button type="button" onclick="document.getElementById('btn1').click();">����</button>
	<input type="hidden" id="imgFilename">
</form>


<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>MBTI result</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
		var testedMbti = '${testedMbti}';
		console.log(testedMbti);
		//$j("#result").text(testedMbti);
		
	});
	
</script>
<body>
	 <div id="result" align="center">
	 	<h2>�˻� ��� ${testedMbti} �Դϴ�.</h2>
	 </div>
</body>
</html>
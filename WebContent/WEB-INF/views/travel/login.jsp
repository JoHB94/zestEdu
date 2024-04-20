<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login</title>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	var clientInfoVo = {};
	
	$j("#login").on("click",function(){
		clientInfoVo = {};
		var userName = $j("[name='userName']").val();
		var userPhone = $j("[name='userPhone']").val();
		
		
		if(userName === ""){
			alert("이름을 입력하세요.");
			$j("[name='name']").focus();
			return
		}
		if(userPhone === ""){
			alert("전화번호를 입력하세요.");
			$j("[name='phone']").focus();
			return
		}
		
		clientInfoVo=
		{userName : userName , userPhone : userPhone}		
		
		
		var param = JSON.stringify(clientInfoVo);
		
		$j.ajax({
		    url : "/travel/loginAction.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : param,
		    success: function(data, textStatus, jqXHR)
		    {
		    	var isMember = data.isMember;
		    	if(isMember){
		    		//멤버일 경우 : 수정 페이지로
		    		location.href = "/travel/clientPage.do";	
		    	}else{
		    		//멤버가 아닐 경우 : 견적 페이지로
					location.href = "/travel/estimate.do";			    		
		    	}
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		});	
		
	});
});
</script>
<body>
<form class="loginForm">
	<table align="center">
		<tr>
			<td>
			<table border="1">
				<tr>
					<td>이름</td>
					<td>
					<input type="text" name="userName"/>
					</td>
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td>
					<input type="text" name="userPhone"/>
					</td>
				</tr>
				
			</table>		
			</td>
		</tr>
		<tr>
			<td align="center">
			<input id="login" type="button" value="로그인"/>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
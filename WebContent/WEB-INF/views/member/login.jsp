<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta>
<title>Login</title>
</head>
<script type="text/javascript">
	
	$j(document).ready(function(){
		
		$j("#submit").on("click",function(){
			var userId 	= $j("[name='userId']").val();
			var userPw 	= $j("[name='userPw']").val();
			var $frm 	= $j(".login :input");
			var param 	= $frm.serialize();
			console.log("param : " + param);
			
			if(userId.trim() === ''){
				$j("[name='userId']").focus();
				alert('아이디를 입력해주세요.');
				return;
			}
			else if(userPw.trim() === ''){
				$j("[name='userPw']").focus();
				alert('비밀번호를 입력해주세요.');
				return;
			}
			else {
				$j.ajax({
				    url : "/board/loginAction.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						var msg = data.success;
						if(msg === "Y"){
							var userName = data.userName;
							alert(userName + "님  " + "로그인에 성공하셨습니다." );
						}
						location.href = "/board/boardList.do";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("로그인 정보가 일치하지 않습니다.");
				    }
				});	
			}
		});
	})	
</script>
<body>
<form class="login">
	<table align="center">
		<tr>
			<td>
				<table border="1">
					<tr>
						<td align="center" width="120">id</td>
						<td>
						<input type="text" name="userId">
						</td>
					</tr>
					<tr>
						<td align="center" width="120">pw</td>
						<td>
						<input type="password" name="userPw">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right">
				<input id="submit" type="button" value="login"> 
			</td>
		</tr>
	</table>
</form>
</body>
</html>
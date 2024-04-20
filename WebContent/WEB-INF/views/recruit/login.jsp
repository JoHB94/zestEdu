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
		var phoneReg = /^\d{3}-\d{4}-\d{4}$/;

	//*****************input을 제한하는 함수 ***************************
		$j("input[name='name']").on("input keydown",function(){
			var regexp = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;
			var $input = $j(this).val();
			
			if(regexp.test($input)) {
				$j(this).val($input.replace(regexp,''));		
			}
				
		});
	
		$j("input[name='phone']").on("input keydown",function(event){
			var inputValue = $j(this).val().replace(/[^\d]/g, ''); // 숫자와 하이픈만 허용
		    var formattedValue = inputValue.replace(/(\d{1,3})(\d{0,4})?(\d{0,4})?/, function(match, p1, p2, p3) {
		        var parts = [p1];
		        if (p2) parts.push("-" + p2);
		        if (p3) parts.push("-" + p3);
		        return parts.join("");
		    });
		    $j(this).val(formattedValue);
		    // 입력값이 13자리를 넘어가면 입력을 받지 않음
		    if (formattedValue.length > 13) {
		    	event.target.value = event.target.value.substring(0,13);
		    }

			
		});
		//document.getElementsByName('phone')[0].addEventListener('input', function(event) {
		//    event.target.value = event.target.value.replace(/\D/g, '');
		//});
		
		
	
	//**************************로그인 클릭시 ************************
		$j("#login").on("click", function(){
			
			var name = $j("[name='name']").val();
			var phone = $j("[name='phone']").val();
			var $frm = $j(".loginForm :input");
			var param = $frm.serialize();
			console.log(param);
			
			if(name === ""){
				alert("이름을 입력하세요.");
				$j("[name='name']").focus();
				return
			}
			if(phone === ""){
				alert("전화번호를 입력하세요.");
				$j("[name='phone']").focus();
				return
			}
			
			if(!phoneReg.test(phone)){
				alert("전화번호 형식이 틀렸습니다." + "\n" + "전화번호 형식: xxx-xxxx-xxxx");
				$j("[name='phone']").focus();
				return;
			}
			
			if(name !== "" && phone !== ""){
				$j.ajax({
				    url : "/recruit/loginAction.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
				    	var isMember = data.isMember;
				    	if(isMember){
				    		location.href = "/recruit/recruitUpdate.do";	
				    	}else{
							location.href = "/recruit/recruitWrite.do";			    		
				    	}
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("통신오류");
				    }
				});	
			}
			
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
					<input type="text" name="name"/>
					</td>
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td>
					<input type="text" name="phone"/>
					</td>
				</tr>
				
			</table>		
			</td>
		</tr>
		<tr>
			<td align="center">
			<input id="login" type="button" value="입사지원"/>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
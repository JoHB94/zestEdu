<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta>
<title>memberJoin</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
//********유효성 확인 변수******************************
		
		var isRequired 	= false;
		var isCheckedId = false;                                
		var isCheckedPw = false;
		var postalCodePattern = /^\d{3}-\d{3}$/;
			
//********문자열의 실제 바이트 수를 계산하는 함수***************
				
		function byteLength(str) {
		    return new Blob([str]).size;
		}
		
//********아이디 중복을 체크하는 함수***********************
		
		$j("#checkId").on("click",function(){
			isCheckedId = false;
			if($j("input[name='userId']").val() === ''){
				alert("아이디를 입력해주세요.")
			}else{
				var $frm 	= $j("input[name='userId']");   
				var param	= $frm.serialize();
				
				$j.ajax({
					url : "/board/checkId.do",
					dataType : "json",
					type : "GET",
					data : param,
					success : function(data, textStatus, jqXHR)
					{	
						var message= "";
						if(data.success === "Y"){
							message = "사용이 가능한 아이디 입니다."
						} 
						else {
							message = "중복된 아이디 입니다."
						}
						alert("메세지 : " + message);
						isCheckedId = true;
						console.log("아이디 중복 체크여부 : " + isCheckedId);
					},
					error : function(jqXHR, textStatus, errorThrown)
					{
						alert("통신 실패");
					}
				})
			}
		});
		
//********* input을 제한하는 함수********************************
		
		$j("input[name='userAddr1']").on("input keydown",function(event){
			var $input = $j(this).val().replace(/[^0-9]/g,'');
			$j(this).val($input);
			if($input.length > 3 && $input.length <= 6){
				var formatted = $input.slice(0,3) + '-' + $input.slice(3);
				$j(this).val(formatted);
			}
			
			if($input.length >= 6 && event.key !== 'Backspace' && event.key !== 'Tab'){
				event.preventDefault();
			}
		});
		
		
		$j("input[name='userName']").on("keyup",function(){
			var regexp = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]/g;
			var $input = $j(this).val();
			
			if(regexp.test($input)) {
				$j(this).val($input.replace(regexp,''));		
			}
		});

		$j("input[name='userId']").on("input keydown",function(event){
			isCheckedId = false;
			var $input 	= $j(this).val().replace(/[^a-zA-Z0-9]/g, '');
			$j(this).val($input);
			if($input.length >= 15 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='userPhone2']").on("input keydown",function(event){
			var $input = $j(this).val().replace(/[^0-9]/g, '');
			$j(this).val($input);
			
			console.log("userPhone2 의 길이 : " + $input.length);
			if($input.length >= 4 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='userPhone3']").on("input keydown",function(event){
			var $input = $j(this).val().replace(/[^0-9]/g, '');
			$j(this).val($input);
			console.log("userPhone3 의 길이 : " + $input.length);
			if($input.length >= 4 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='userPw']").on("input keydown",function(event){
			var $input = $j(this).val();
			console.log("userPw 의 길이 : " + $input.length);
			if($input.length >= 12 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='pwCheck']").on("input keydown",function(event){
			var $input = $j(this).val();
			console.log("pwCheck 의 길이 : " + $input.length);
			if($input.length >= 12 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
			
		
//**********submit 버튼 클릭시*************************************
		$j("#submit").on("click",function(){
			
			var $userInfo = $j(".userJoin input").add($j(".userJoin select"));
			
			var param = $userInfo.serialize();
			
			//userJoin 필드값	not null
			var $userId 	= $j("input[name='userId']").val();
			var $userPw 	= $j("input[name='userPw']").val();
			var $pwCheck 	= $j("input[name='pwCheck']").val();
			var $userName 	= $j("input[name='userName']").val();
			var $userPhone1 = $j("input[name='userPhone1']").val();
			var $userPhone2 = $j("input[name='userPhone2']").val();
			var $userPhone3 = $j("input[name='userPhone3']").val();
			//userJoin 필드값 nullable
			var $userAddr1 	= $j("input[name='userAddr1']").val();
			var $userAddr2 	= $j("input[name='userAddr2']").val();
			var $userCompany= $j("input[name='userCompany']").val();
			
			
			//유효성 검증
			if($userId === ''){
				alert("아이디는 필수 항목입니다.");
				$j("[name = 'userId']").focus();
				return;
			}
			if($userId.length > 15){
				alert("아이디는 최대 15글자까지 입력 가능합니다.");
				$j("[name = 'userId']").focus();
				return;
			}
			if($userId !== '' && !isCheckedId){
				alert("아이디 중복확인을 해주세요.");
				$j("#checkId").focus();
				return;
			}
			if($userPw === ''){
				alert("비밀번호는 필수 항목입니다.");
				$j("[name = 'userPw']").focus();
				return;
			}
			if($pwCheck === ''){
				alert("비밀번호 확인은 필수 항목입니다.");
				$j("[name = 'pwCheck']").focus();
				return;
			}
			if($userPw !== '' && $userPw.length < 6 ||$userPw.length > 12){
				alert("비밀번호는 최소 6자 최대 12자 까지 가능합니다.");
				$j("[name = 'userPw']").focus();
				return;
			}
			if($pwCheck !== ''&& $userPw !== $pwCheck){
				alert("비밀번호가 다릅니다.");
				$j("[name = 'pwCheck']").focus();
				return;              
			}
			if($userPw === $pwCheck){
				isCheckedPw = true;
				console.log("pw확인 여부 : " + isCheckedPw);
			}
			
			if($userName === ''){
				alert("이름은 필수 항목입니다.");
				$j("[name = 'userName']").focus();
				return;
			}
			if($userName.length > 5){
				alert("이름은 최대 5글자까지 입력이 가능합니다.");
				return;
			}
			if($userPhone1 === ''){
				alert("전화번호는 필수 항목입니다.");
				$j("[name = 'userPhone1']").focus();
				return;
			}else if($userPhone2 === ''){
				alert("전화번호는 필수 항목입니다.");
				$j("[name = 'userPhone2']").focus();
				return;					
				
			}else if($userPhone3 === ''){
				if($userPhone2.length !== 4){
					alert("전화번호 형식이 틀렸습니다. 'xxx-xxxx-xxxx' ");
					$j("[name = 'userPhone2']").focus();
					return;
				}else{
					alert("전화번호는 필수 항목입니다.");
					$j("[name = 'userPhone3']").focus();
					return;					
				}
			}else if($userPhone3.length !== 4){
				alert("전화번호 형식이 틀렸습니다. 'xxx-xxxx-xxxx' ");
				$j("[name = 'userPhone3']").focus();
				return;		
			}
			
						
			if($userPw !=='' && $userId !== '' && $userName !== '' && $userPhone1 !== null && $userPhone2 !== null && $userPhone3 !== null){
				isRequired = true;
				console.log("필수 항목 확인 여부 : " + isRequired);
			}
			if($userAddr1 !== '' && !postalCodePattern.test($userAddr1)){
				alert("우편번호 형식이 틀립니다.`\n` 숫자 'xxx-xxx'");
				$j("[name = 'userAddr1']").focus();
				return;
			}
			
			if($userAddr2 !== '' && byteLength($userAddr2) > 149){
				alert("주소가 너무 깁니다. 최대 150BYTE");
				return;
			}
			
			if($userCompany !== '' && byteLength($userCompany) > 59){
				alert("회사명이 너무깁 니다. 최대 60BYTE");
				return;  
			}
			
			
			if(isCheckedId === true && isCheckedPw === true && isRequired === true){
				console.log("가입 필수 조건 충족");
				$j.ajax({
					url : "/board/userJoinAction.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						alert("가입완료");
						
						alert("메세지:" + data.success);
						
						location.href = "/board/boardList.do";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("실패");
				    }
				})
			}
		});
	});
	
</script>
<body>
<form>
	<table align="center">
		<tr>
			<td>
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
		<tr>
			<td>
			<table class="userJoin" border="1">
				<tr>
					<td width="120" align="center">*id</td>
					<td width="300">
						<input name="userId" type="text">
						<input id="checkId" type="button" value="중복확인">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">*pw</td>
					<td width="300">
						<input name="userPw" type="password">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">*pw check</td>
					<td width="300">
						<input name="pwCheck" type="password">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">*name</td>
					<td width="300">
						<input name="userName" type="text">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">*phone</td>
					<td>
						<select name="userPhone1">
						<c:forEach var="item" items="${phones}">
							<option value="${item.codeId}">${item.codeName}</option>
						</c:forEach>
						</select>
					
						-
						<input type="text" name="userPhone2" style="width:40px;">
						-
						<input type="text" name="userPhone3" style="width:40px;">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">postNo</td>
					<td width="300">
						<input name="userAddr1" type="text">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">address</td>
					<td>
						<input width="300" name="userAddr2" type="text">
					</td>
				</tr>
				<tr>
					<td width="120" align="center">company</td>
					<td>
						<input width="300" name="userCompany" type="text">
					</td>
				</tr>
			</table>
		<tr>
			<td align="right">
				<input id="submit" type="button" value="join" >
			</td>
		</tr>
	</table>
</form>
</body>
</html>
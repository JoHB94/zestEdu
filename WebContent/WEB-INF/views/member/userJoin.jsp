<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>memberJoin</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
//********��ȿ�� Ȯ�� ����******************************
		
		var isRequired 	= false;
		var isCheckedId = false;                                
		var isCheckedPw = false;
		var postalCodePattern = /^\d{3}-\d{3}$/;
			
//********���ڿ��� ���� ����Ʈ ���� ����ϴ� �Լ�***************
				
		function byteLength(str) {
		    return new Blob([str]).size;
		}
		
//********���̵� �ߺ��� üũ�ϴ� �Լ�***********************
		
		$j("#checkId").on("click",function(){
			isCheckedId = false;
			if($j("input[name='userId']").val() === ''){
				alert("���̵� �Է����ּ���.")
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
							message = "����� ������ ���̵� �Դϴ�."
						} 
						else {
							message = "�ߺ��� ���̵� �Դϴ�."
						}
						alert("�޼��� : " + message);
						isCheckedId = true;
						console.log("���̵� �ߺ� üũ���� : " + isCheckedId);
					},
					error : function(jqXHR, textStatus, errorThrown)
					{
						alert("��� ����");
					}
				})
			}
		});
		
//********* input�� �����ϴ� �Լ�********************************
		
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
			
			console.log("userPhone2 �� ���� : " + $input.length);
			if($input.length >= 4 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='userPhone3']").on("input keydown",function(event){
			var $input = $j(this).val().replace(/[^0-9]/g, '');
			$j(this).val($input);
			console.log("userPhone3 �� ���� : " + $input.length);
			if($input.length >= 4 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='userPw']").on("input keydown",function(event){
			var $input = $j(this).val();
			console.log("userPw �� ���� : " + $input.length);
			if($input.length >= 12 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
		
		$j("input[name='pwCheck']").on("input keydown",function(event){
			var $input = $j(this).val();
			console.log("pwCheck �� ���� : " + $input.length);
			if($input.length >= 12 && event.key !== 'Backspace' && event.key !== 'Tab') {
				event.preventDefault();
			}
		});
			
		
//**********submit ��ư Ŭ����*************************************
		$j("#submit").on("click",function(){
			
			var $userInfo = $j(".userJoin input").add($j(".userJoin select"));
			
			var param = $userInfo.serialize();
			
			//userJoin �ʵ尪	not null
			var $userId 	= $j("input[name='userId']").val();
			var $userPw 	= $j("input[name='userPw']").val();
			var $pwCheck 	= $j("input[name='pwCheck']").val();
			var $userName 	= $j("input[name='userName']").val();
			var $userPhone1 = $j("input[name='userPhone1']").val();
			var $userPhone2 = $j("input[name='userPhone2']").val();
			var $userPhone3 = $j("input[name='userPhone3']").val();
			//userJoin �ʵ尪 nullable
			var $userAddr1 	= $j("input[name='userAddr1']").val();
			var $userAddr2 	= $j("input[name='userAddr2']").val();
			var $userCompany= $j("input[name='userCompany']").val();
			
			
			//��ȿ�� ����
			if($userId === ''){
				alert("���̵�� �ʼ� �׸��Դϴ�.");
				$j("[name = 'userId']").focus();
				return;
			}
			if($userId.length > 15){
				alert("���̵�� �ִ� 15���ڱ��� �Է� �����մϴ�.");
				$j("[name = 'userId']").focus();
				return;
			}
			if($userId !== '' && !isCheckedId){
				alert("���̵� �ߺ�Ȯ���� ���ּ���.");
				$j("#checkId").focus();
				return;
			}
			if($userPw === ''){
				alert("��й�ȣ�� �ʼ� �׸��Դϴ�.");
				$j("[name = 'userPw']").focus();
				return;
			}
			if($pwCheck === ''){
				alert("��й�ȣ Ȯ���� �ʼ� �׸��Դϴ�.");
				$j("[name = 'pwCheck']").focus();
				return;
			}
			if($userPw !== '' && $userPw.length < 6 ||$userPw.length > 12){
				alert("��й�ȣ�� �ּ� 6�� �ִ� 12�� ���� �����մϴ�.");
				$j("[name = 'userPw']").focus();
				return;
			}
			if($pwCheck !== ''&& $userPw !== $pwCheck){
				alert("��й�ȣ�� �ٸ��ϴ�.");
				$j("[name = 'pwCheck']").focus();
				return;              
			}
			if($userPw === $pwCheck){
				isCheckedPw = true;
				console.log("pwȮ�� ���� : " + isCheckedPw);
			}
			
			if($userName === ''){
				alert("�̸��� �ʼ� �׸��Դϴ�.");
				$j("[name = 'userName']").focus();
				return;
			}
			if($userName.length > 5){
				alert("�̸��� �ִ� 5���ڱ��� �Է��� �����մϴ�.");
				return;
			}
			if($userPhone1 === ''){
				alert("��ȭ��ȣ�� �ʼ� �׸��Դϴ�.");
				$j("[name = 'userPhone1']").focus();
				return;
			}else if($userPhone2 === ''){
				alert("��ȭ��ȣ�� �ʼ� �׸��Դϴ�.");
				$j("[name = 'userPhone2']").focus();
				return;					
				
			}else if($userPhone3 === ''){
				if($userPhone2.length !== 4){
					alert("��ȭ��ȣ ������ Ʋ�Ƚ��ϴ�. 'xxx-xxxx-xxxx' ");
					$j("[name = 'userPhone2']").focus();
					return;
				}else{
					alert("��ȭ��ȣ�� �ʼ� �׸��Դϴ�.");
					$j("[name = 'userPhone3']").focus();
					return;					
				}
			}else if($userPhone3.length !== 4){
				alert("��ȭ��ȣ ������ Ʋ�Ƚ��ϴ�. 'xxx-xxxx-xxxx' ");
				$j("[name = 'userPhone3']").focus();
				return;		
			}
			
						
			if($userPw !=='' && $userId !== '' && $userName !== '' && $userPhone1 !== null && $userPhone2 !== null && $userPhone3 !== null){
				isRequired = true;
				console.log("�ʼ� �׸� Ȯ�� ���� : " + isRequired);
			}
			if($userAddr1 !== '' && !postalCodePattern.test($userAddr1)){
				alert("�����ȣ ������ Ʋ���ϴ�.`\n` ���� 'xxx-xxx'");
				$j("[name = 'userAddr1']").focus();
				return;
			}
			
			if($userAddr2 !== '' && byteLength($userAddr2) > 149){
				alert("�ּҰ� �ʹ� ��ϴ�. �ִ� 150BYTE");
				return;
			}
			
			if($userCompany !== '' && byteLength($userCompany) > 59){
				alert("ȸ����� �ʹ��� �ϴ�. �ִ� 60BYTE");
				return;  
			}
			
			
			if(isCheckedId === true && isCheckedPw === true && isRequired === true){
				console.log("���� �ʼ� ���� ����");
				$j.ajax({
					url : "/board/userJoinAction.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						alert("���ԿϷ�");
						
						alert("�޼���:" + data.success);
						
						location.href = "/board/boardList.do";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("����");
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
						<input id="checkId" type="button" value="�ߺ�Ȯ��">
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
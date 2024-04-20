<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 여행견적 신청</title>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	//select option값에 배열값 부여.
	var traveCity = [
		"서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시",
		"울산광역시","세종특별자치시","경기도","강원도","충청북도","충청남도",
		"전라북도","전라남도","경상북도","경상남도","제주도"
	];
	var select =$j("#traveCitySelect");
	$j.each(traveCity, function(i,val){
		var option = $j("<option>").text(val);
		select.append(option);
	});
//*****************서버에 전송하게 될 최종 ClientInfoVo객체 ***********************
	var clientInfoVo = {};
	var onlyNum = /[^0-9]/g;
	
	$j("input[name='period']").on("input keydown",function(event){
		var $input = $j(this).val().replace(onlyNum,'');
		$j(this).val($input);
		if($input.length > 8){
			event.target.value = event.target.value.substring(0,8);
		}
	});
	
	$j("input[name='expend']").on("input keydown",function(event){
		var $input = $j(this).val().replace(onlyNum,'');
		$j(this).val($input);
		if($input.length > 8){
			event.target.value = event.target.value.substring(0,8);
		}
	});
	
	$j("#submit").on("click",function(){
		
		clientInfoVo = {};
		
		var userName = $j("[name='userName']").val();
		var userPhone = $j("[name='userPhone']").val();
		var period = $j("[name='period']").val();
		var transport = $j("[name='transport']").val();
		var expend = $j("[name='expend']").val();
		var traveCity = $j("[name='traveCity']").val();
		
		if(period === ""){
			alert("여행기간을 입력하세요.");
			$j("[name='period']").focus();
			return
		}
		if(period < 1 || period > 30){
			alert("여행기간은 1~30일 까지만 입력이 가능합니다.");
			$j("[name='period']").focus();
			return
		}
		
		if(transport === ""){
			alert("이동수단을 입력하세요.");
			$j("[name='transport']").focus();
			return
		}
		
		if(expend === ""){
			alert("예상경비를 입력하세요.");
			$j("[name='expend']").focus();
			return
		}
		if(traveCity === ""){
			alert("여행지를 입력하세요.");
			$j("[name='traveCity']").focus();
			return
		}
		
		clientInfoVo = 
			{
				userName : userName, userPhone : userPhone, period : period,
				transport : transport, expend : expend, traveCity : traveCity
			}
		var param = JSON.stringify(clientInfoVo);
		console.log("최종 전달 clientInfoVo: " + param);
		$j.ajax({
		    url : "/travel/estimateAction.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : param,
		    success: function(data, textStatus, jqXHR)
		    {
		    	var msg = data.success;
		    	if(msg === "Y"){
		    		alert("신청에 성공하였습니다.");
		    		//멤버일 경우 : 수정 페이지로
		    		location.href = "/travel/traveManagement.do";	
		    	}else{
		    		//멤버가 아닐 경우 : 견적 페이지로
		    		alert("신청에 실패하였습니다.");			    		
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
<form>
<h1 style="text-align: center">고객 여행 견적 신청</h1>
	<table align="center">
		<tr>
			<td>
			<table border="1">
				<tr>
					<td>고객명</td>
					<td>
						${sessionScope.userName }
						<input type="hidden" name="userName" value="${sessionScope.userName }">
					</td>				
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td>
						${sessionScope.userPhone }
						<input type="hidden" name="userPhone" value="${sessionScope.userPhone }">
					</td>
				</tr>
				<tr>
					<td>여행 기간</td>
					<td>
						<input type="text" name="period">
					</td>
				</tr>
				<tr>
					<td>이동수단</td>
					<td>
						<select name="transport">
							<option value="R">렌트</option>
							<option value="B">대중교통</option>
							<option value="C">자차</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>예상 경비</td>
					<td>
						<input type="text" name="expend">
					</td>
				</tr>
				<tr>
					<td>여행지</td>
					<td>
						<select id="traveCitySelect" name="traveCity">
							
						</select>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<div align="center">
		<input id="submit" type="button" value="신청">
	</div>
</form>
</body>
</html>
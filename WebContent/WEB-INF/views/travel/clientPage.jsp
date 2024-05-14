<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 여행견적 확인 및 수정요청</title>
<style type="text/css">
	.periodButton-style {
	    font-size: 16px; /* 버튼의 글꼴 크기 설정 */
	    padding: 5px 8px; /* 버튼의 내부 여백 설정 */
	}
	.selected {
  		background-color: highlight;
  		color: white; 
	}
</style>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	
	var inputDay = "";
	var clientSeq = "${clientInfoVo.seq}";
	
	$j("#periodDiv").on("click", ".periodButton-style", function() {
        // 기존에 선택된 버튼의 클래스 제거
        $j(".periodButton-style").removeClass("selected");

        // 현재 클릭된 버튼에 선택된 클래스 추가
        $j(this).addClass("selected");
    });
//************************html빌드 관련 메소드***********************************
	function updateHtml(data){
		console.log("updateHtml호출!!!");
		$j("#detailDiv").html(buildTable(data.detailTraveList));
	}
	
	function buildTable(detailTraveList){
		var html = '';
		html += '<table align="center">';
	    html += '<tr>';
	    html += '<td>';
	    html += '<input type="button" id="reqUpdate" value="수정요청" style="margin-bottom: : 10px">';
	    html += '</td>';
	    html += '</tr>';
	    html += '<tr>';
	    html += '<td>';
	    html += '<table id="detailTable" border="1">';
	    html += '<tr>';
	    html += '<td style="width: 20px"></td>';
	    html += '<td style="width: 140px">시간</td>';
	    html += '<td style="width: 160px">지역</td>';
	    html += '<td style="width: 160px">장소명</td>';
	    html += '<td style="width: 160px">이용시간</td>';
	    html += '<td style="width: 100px">교통편</td>';
	    html += '<td style="width: 160px">예상이동시간</td>';
	    html += '<td>이용요금(예상지출비용)</td>';
	    html += '<td style="width: 160px">계획상세</td>';
	    html += '<td>교통비</td>';
	    html += '</tr>';
	    
	    if (Array.isArray(detailTraveList) && detailTraveList.length > 0) {
	    	console.log("detailList 있음: else문 돈다.");
	    	 detailTraveList.forEach(function (item, index) {
	             html += '<tr id="detailInput' + (index + 1) + '">';
	             html += '<td>';
	             html += '<input type="checkbox" name="selection">';
	             html += '<input type="hidden" name="traveSeq" value="'+ item.traveSeq +'">'
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.traveTime + '';
	             html += '</td>';
	             html += '<td>';
	             html += ''+ item.traveCity +' ';
	             html += ''+ item.traveCounty +'';
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.traveLoc + '';
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.useTime + '';
	             html += '</td>';
	             html += '<td>';
	             
	             var traveTrans = '';
	             if (item.traveTrans === 'R') {
	                 traveTrans = '렌트';
	             } else if (item.traveTrans === 'B') {
	                 traveTrans = '버스';
	             } else if (item.traveTrans === 'C') {
	                 traveTrans = '자차';
	             } else if (item.traveTrans === 'W'){
	                 traveTrans = '도보';
	             } else if (item.traveTrans === 'T'){
	                 traveTrans = '택시';
	             } else if (item.traveTrans === 'S'){
	            	 traveTrans = '지하철';
	             }
	             html += traveTrans;
	             
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.transTime + '';
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.useExpend + '';
	             html += '</td>';
	             html += '<td>';
	             html += '' + item.traveDetail + '';
	             html += '</td>';
	             html += '<td class="transFee">';
	             html += '</td>';
	             html += '</tr>';
	         });
	    }
	    else{
	    	console.log("detailList 없음: if문 돈다.");
	        html += '<tr id="detailInput1">';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '<td>';
	        html += '-';
	        html += '</td>';
	        html += '-';
	        html += '</td>';
	        html += '</tr>';
	        html += '-';
	    }
	    html += '</table>';
	    html += '</td>';
	    html += '</tr>';
	    html += '</table>';
	    
	    return html;
	}
	
	$j("[name='periodButton']").on("click",function(){

		var traveInfoVo = {};

		inputDay = $j(this).val();
		
		console.log("periodButton 클릭시 inputDay: " + inputDay);
		traveInfoVo =
		{
			traveDay : inputDay, seq : clientSeq
		}
		
			
		var data = JSON.stringify(traveInfoVo);
		
		$j.ajax({
		    url : "/travel/detailTraveList.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : data,
		    success: function(data, textStatus, jqXHR)
		    {	
		    	$j("#detailDiv").empty();
		    	updateHtml(data);
		    	
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		});	
		
	});
	
	$j(document).on("click","#reqUpdate",function(){
		var updateList = [];
		$j("[type='checkbox']").each(function(){
			if($j(this).is(":checked")){
				var traveSeq = $j(this).closest("tr").find("[name='traveSeq']").val();
				updateList.push(
					{
						traveSeq : traveSeq
					}		
				);
			}
		});
		
		var data = { updateList : updateList };
		console.log("최종 전송 데이터: " + JSON.stringify(data));
		
		$j.ajax({
			url : "/travel/updateRequest.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : JSON.stringify(data),
		    success: function(data, textStatus, jqXHR)
		    {
		    	var msg = data.success;
		    	if(msg === "Y"){
		    		alert("수정요청에 성공하였습니다.");
		    		location.href = "/travel/traveManagement.do";	
		    	}else{
		    		alert("수정요청에 실패하였습니다.");			    		
		    	}
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		})
		
	});
});
</script>
<body>
	<h1 style="text-align: center">고객 여행 견적 확인 및 수정요청</h1>
<table align="center">
	<tr>
		<td>
			<table border="1">
				<tr>
					<td>고객명</td>
					<td style="width: 160px">
						${clientInfoVo.userName }
						<input type="hidden" name="userName" value="${sessionScope.userName }">
					</td>				
				</tr>
				<tr>
					<td>휴대폰번호</td>
					<td>
						${clientInfoVo.userPhone }
						<input type="hidden" name="userPhone" value="${sessionScope.userPhone }">
					</td>
				</tr>
				<tr>
					<td>여행 기간</td>
					<td>
						${clientInfoVo.period }
					</td>
				</tr>
				<tr>
					<td>이동수단</td>
					<td>
						<c:choose>
						    <c:when test="${clientInfoVo.transport eq 'R'}">
				        		렌트
						    </c:when>
						    <c:when test="${clientInfoVo.transport eq 'B'}">
						   	     대중교통
						    </c:when>
						    <c:when test="${clientInfoVo.transport eq 'C'}">
					      	  	자차
						    </c:when>						   
						    <c:otherwise>
								기타
						    </c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td>예상 경비</td>
					<td>
						${clientInfoVo.expend }
					</td>
				</tr>
				<tr>
					<td>여행지</td>
					<td>
						${clientInfoVo.traveCity }
					</td>
				</tr>
			</table>
			<br/>
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" name="logout" value="로그아웃">
		</td>
	</tr>

</table>
<div id="periodDiv" style="padding-left: 100px;padding-right: 100px; padding-bottom: 10px">
	<c:forEach var="i" begin="1" end="${period}" varStatus="loop">
    	<button name="periodButton" class="periodButton-style" value="${i}">${i}</button>
    	<c:if test="${not loop.last}"> | </c:if>
	</c:forEach>
</div>
<div id="detailDiv">
	
</div>
</body>
</html>
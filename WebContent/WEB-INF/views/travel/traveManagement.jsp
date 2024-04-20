<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>여행 일정 관리</title>
<style>
	.periodButton-style {
	    font-size: 16px; /* 버튼의 글꼴 크기 설정 */
	    padding: 5px 8px; /* 버튼의 내부 여백 설정 */
	}
</style>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	var clientList = [];
	var traveDate = "";
	var traveList = [];
	
	var period = "";

//*********************고객명을 클릭했을 때, 실행되는 함수 ************************
	$j("[id^='clientName']").on("click",function(){
		//기존에 존재하던 periodButton 삭제.
		$j('#periodDiv').empty();
		
		var seq = $j(this).closest("tr").find("input[name='seq']").val();
		console.log("seq: " + JSON.stringify(seq));
		if(seq !== ""){

			$j.ajax({
			    url : "/travel/getPeriodAction.do",
			    dataType: "json",
			    contentType: "application/json",
			    type: "POST",
			    data : JSON.stringify(seq),
			    success: function(data, textStatus, jqXHR) {
			        console.log("ajax통신 성공: " + period);
			        period = data.period;
			        if (period !== "") {
			            for (var i = 0; i < period; i++) {
			                var button = $j("<button></button>");
			                button.text(i + 1);
			                button.val(i + 1);

			                button.attr("name", "periodButton");
			                button.attr("data-custom", seq);
			                button.addClass("periodButton-style");
			                // 버튼 사이에 '|' 추가
			                if (i > 0) {
			                    $j("#periodDiv").append(" | ");
			                }

			                // 버튼을 periodDiv에 추가
			                $j("#periodDiv").append(button);
			            }
			        }
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("통신 오류 발생 ajax");
			    }
			});
		}
		
	});
//*******************버튼을 클릭했을 경우 ***************************
	$j(document).on("click","[name='periodButton']",function(){
		var traveInfoVo = {};
		var traveDay = $j(this).val();
		var seq = $j(this).data("custom");
		console.log("buttonVal: " + traveDay);
		console.log("seq: " + seq);
		
		traveInfoVo =
			{
				traveDay : traveDay, seq : seq
			}
		var data = JSON.stringify(traveInfoVo);
		
		$j.ajax({
		    url : "/travel/loginAction.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : data,
		    success: function(data, textStatus, jqXHR)
		    {
		    	var detailTraveList = data.detailTraveList;
		    	
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		});	
		
	});
//******************주소 select option에 관한 함수 *************************
	var traveCity = [
		"서울특별시","부산광역시","대구광역시","인천광역시","광주광역시","대전광역시",
		"울산광역시","세종특별자치시","경기도","강원도","충청북도","충청남도",
		"전라북도","전라남도","경상북도","경상남도","제주도"
	];
	
	var traveCounty = {
			"서울특별시" : ["종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구",
				"강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구",
				"금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구"],
			"부산광역시" : ["중구","서구","동구","영도구","부산진구","동래구","남구","북구",
				"해운대구","사하구","금정구","강서구","연제구","수영구","사상구","기장군"],
			"대구광역시" : ["중구","동구","서구","남구","북구","수성구","달서구","달성군","군위군"],
			"인천광역시" : ["중구","동구","미추홀구","연수구","남동구","부평구","계양구","서구","강화군","옹진군"],
			"광주광역시" : ["동구","서구","남구","북구","광산구"],
			"대전광역시" : ["동구","중구","서구","유성구","대덕구"],
			"울산광역시" : ["중구","남구","동구","북구","울주군"],
			"세종특별자치시" : ["세종특별자치시"],
			"경기도" : ["수원시","용인시","고양시","화성시","성남시","부천시","남양주시","안산시",
				"평택시","안양시","시흥시","파주시","김포시","의정부시","광주시","하남시",
				"광명시","군포시","양주시","오산시","이천시","안성시","구리시","의왕시",
				"포천시","양평군","여주시","동두천시","과천시","가평군","연천군"],
			"강원도" : ["춘천시","원주시","강릉시","동해시","태백시","속초시","삼척시","홍천군","횡성군",
				"영월군","평창군","정선군","철원군","화천군","양구군","인제군","고성군","양양군"],
			"충청북도" : ["청주시","충주시","제천시","보은군","옥천군","영동군","증평군","진천군",
				"괴산군","음성군","단양군"],
			"충청남도" : ["천안시","공주시","보령시","아산시","서산시","논산시","계룡시","당진시",
				"금산군","부여군","서천군","청양군","홍성군","예산군","태안군"],
			"전라북도" : ["전주시","군산시","익산시","정읍시","남원시","김제시","완주군","진안군",
				"무주군","장수군","임실군","순창군","고창군","부안군"],
			"전라남도" : ["목포시","여수시","순천시","나주시","광양시","담양군","곡성군","구례군",
				"고흥군","보성군","화순군","장흥군","강진군","해남군","영암군","무안군","함평군",
				"영광군","장성군","완도군","진도군","신안군"],
			"경상북도" : ["포항시","경주시","김천시","안동시","구미시","영주시","영천시","상주시","문경시",
				"경산시","의성군","청송군","영양군","영덕군","청도군","고령군","성주군","칠곡군",
				"예천군","봉화군","울진군","울릉군"],
			"경상남도" : ["창원시","진주시","통영시","사천시","김해시","밀양시","거제시","양산시","의령군",
				"함안군","창녕군","고성군","남해군","하동군","산청군","함양군","거창군","합천군"],
			"제주도" : ["제주시","서귀포시"]
	};
	
	var traveTrans = {
		"도보" : "W", "버스" : "B", "지하철" : "S", "택시" : "T", "렌트" : "R", "자차" : "C"	
	};
	
	var citySelect = $j("[id^=traveCitySelect]");
	var countySelect = $j("[id^=traveCountySelect]");
	var transSelect = $j("[id^=traveTransSelect]");
	
	$j.each(traveCity, function(i,val){
		var option = $j("<option>").text(val);
		citySelect.append(option);
	});

	initializeCounty();
	
	$j.each(traveTrans, function(key, val){
	    var option = $j("<option>").text(key).val(val);
	    transSelect.append(option);
	});
	
	function updateCounty(countyArray) {    
	    countySelect.empty();
	    $j.each(countyArray, function (i, val) {
	        var option = $j("<option>").text(val);
	        countySelect.append(option);
	    });
	}
	
	function initializeCounty() {
	    var defaultCity = "서울특별시";
	    var defaultCounty = traveCounty[defaultCity];
	    updateCounty(defaultCounty);
	}
	
	$j("[id^=traveCitySelect]").on("change",function(){
		var currentCity = $j(this).val();
	    var countyArray = traveCounty[currentCity];

	    updateCounty(countyArray);
	});
	//두번째 select 초기값 설정
	function initializeCounty() {
	    var defaultCity = "서울특별시";
	    var defaultCounty = traveCounty[defaultCity];
	    updateCounty(defaultCounty);
	}
//******************대중교통 비용 함수 *****************************

	function taxiFee(traveTime,transTime){
		
		//traveTime을 분으로 변환
		var traveTimeMin = parseInt(traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
		var transTimeMin = parseInt(transTime);
		
		var basicTaxiFee = 3800;
		var basicExtraFee = 5000;
		var per20ExtraFee = basicExtraFee * 1.2;
		var full20ExtraFee = per20ExtraFee * 6 * 2;
		var per40ExtraFee = basicExtraFee * 1.4;
		var full40ExtraFee = per40ExtraFee * 6 * 4;
		
		var outTime = traveTimeMin + transTimeMin;
		var finalTaxiFee = 0;
		console.log("탑승시각: " + traveTimeMin +" 탑승시간: " + transTime + " 하차시각: " + outTime);
		
		
		//탑승시각이 노멀타임인 경우
		if (traveTimeMin >= 240 && traveTimeMin < 1320){		
			//outTime이 22시 미만일때
			if (outTime < 1320){
				finalTaxiFee = (basicTaxiFee + transTimeMin/10 * basicExtraFee) - basicExtraFee;
			}
			//outTime이 22시 이상 24시 미만일때
			else if (outTime < 1440){
				finalTaxiFee = (basicTaxiFee + (1320-traveTimeMin)/10 * basicExtraFee + (outTime - 1320)/10 * per20ExtraFee) - basicExtraFee;
			}
			//outTime이 00시 이상 04시 미만일때 
			else if (outTime < 1680){
				finalTaxiFee = (basicTaxiFee + full20ExtraFee + (outTime - 1440)/10 * per40ExtraFee) - basicExtraFee;
			}
			//outTime이 04시 이상일때
			else{
				finalTaxiFee = (basicTaxiFee + full20ExtraFee + full40ExtraFee + (transTimeMin - 360)/10 * basicExtraFee) - basicExtraFee;
			}
		}
		//탑승시각이 20%할증 타임인 경우
		else if (traveTimeMin >= 1320 && traveTimeMin < 1440){
			//outTime이 24시 미만일때
			if (outTime < 1440){
				finalTaxiFee = (1.2 * basicTaxiFee + transTimeMin/10 * per20ExtraFee) - per20ExtraFee;
			}
			//outTime이 00시 이상 04시 미만일때
			else if (outTime < 1680){
				finalTaxiFee = (1.2 * basicTaxiFee + full20ExtraFee + (outTime - 1440)/10 * per40ExtraFee) - per20ExtraFee;
			}
			//outTime이 04시 이상일때
			else{
				finalTaxiFee = (1.2 * basicTaxiFee + full20ExtraFee + full40ExtraFee + (transTimeMin - 360)/10 * basicExtraFee) - per20ExtraFee;
			}
		}
		//탑승시각이 40%할증 타임인 경우
		else if (traveTimeMin >= 0 && traveTimeMin < 240){
			//outTime이 04시 미만일때
			if (outTime <240){
				finalTaxiFee = (1.4 * basicTaxiFee + transTimeMin/10 * per40ExtraFee) - per40ExtraFee;
			}
			//outTime이 04시 이상일때
			else{
				finalTaxiFee = (1.4 * basicTaxiFee + full40ExtraFee  + (transTimeMin - 240)/10 * basicExtraFee) - per40ExtraFee;
			}
		}
		
		console.log("finalTaxiFee: " + finalTaxiFee);
		return finalTaxiFee;
		
	}
//****************교통비 출력 함수 ********************************
	$j("select[name='traveTrans'],input[name='transTime'],input[name='traveTime']").on("change",function(){
		var traveTrans = $j(this).closest('tr').find('select[name="traveTrans"]').val();
		var traveTime = $j(this).closest('tr').find('input[name="traveTime"]').val();
		var transTime = $j(this).closest('tr').find('input[name="transTime"]').val();
		console.log("traveTrans: " + traveTrans);
		if(traveTrans === "T"){
			if(traveTime !== undefined && transTime !== undefined){
				taxiFee(traveTime,transTime);			
			}			
		}
	});
	
});
</script>
<body>
<h1 style="text-align: center">여행 일정 관리</h1>
<table align="center">
	<tr>
		<td>
			<table border="1" id="clientTable">
				<tr>
					<td>고객명</td>
					<td>휴대폰번호</td>
					<td>여행지</td>
					<td>여행 기간</td>
					<td>이동수단</td>
					<td>예상 경비</td>
					<td>견적 경비</td>
				</tr>
				<c:forEach items="${clientList }" var="list" varStatus="loop">
				
				<tr>
					<td style="display: none">
						<input type="hidden" name="seq" value="${list.seq }">
					</td>
					<td id="clientName${loop.index +1 }">${list.userName }</td>
					<td>${list.userPhone }</td>
					<td>${list.traveCity }</td>
					<td>${list.period }</td>
					<c:choose>
						<c:when test="${list.transport eq 'R'}">
							<td>렌트</td>				
						</c:when>
						<c:when test="${list.transport eq 'B'}">
							<td>대중교통</td>				
						</c:when>
						<c:when test="${list.transport eq 'C'}">
							<td>자차</td>				
						</c:when>
					</c:choose>
					<td>${list.expend }</td>
					<td></td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
<div id="periodDiv"></div>
<div id="detailDiv">
	<table align="center">
		<tr>
			<td>
			<table border="1">
				<tr>
					<td></td>
					<td>시간</td>
					<td>지역</td>
					<td>장소명</td>
					<td>교통편</td>
					<td>예상이동시간</td>
					<td>이용요금(예상지출비용)</td>
					<td>계획상세</td>
					<td>교통비</td>
				</tr>
				<!--detailTraveList 가 비어있는 경우  -->
				<c:if test="${detailTraveList eq null }">
					<tr>
						<td>
							<input type="checkbox" name="selection">
						</td>
						<td>
							<input type="time" name="traveTime">
						</td>
						<td>
							<select id="traveCitySelect1" name="traveCity"></select>
							<select id="traveCountySelect1" name="traveCounty"></select>
						</td>
						<td>
							<input type="text" name="traveLoc">
						</td>
						<td>
							<select id="traveTransSelect1" name="traveTrans"></select>
						</td>
						<td>
							<input type="text" name="transTime">
						</td>
						<td>
							<input type="text" name="useExpend">
						</td>
						<td>
							<input type="text" name="traveDetail">
						</td>
						<td>
							
						</td>
						
					</tr>
				</c:if>
				<!--detailTraveList에 값이 존재하는 경우  -->
				<c:if test="${detailTraveList eq not null }">
					<c:forEach items="${detailTraveList }" var="list" varStatus="loop">
						<tr id="detailInput${loop.index +1 }">
							<td>
								<input type="checkbox" name="selection">
							</td>
						</tr>				
					</c:forEach>				
				</c:if>
			</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
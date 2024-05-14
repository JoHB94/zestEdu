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
	.selected {
  		background-color: highlight;
  		color: white; 
	}
</style>
</head>
<script type="text/javascript">
$j(document).ready(function(){
	$j('#periodDiv').css('width', $j('#detailTable').outerWidth());
//**********************************************************************	
	
	var client = {};
	var inputDay = "";
	var traveList = [];
	var initialCity = "";
	
	var clientSeq = "";
	var period = "";
	var estimatedExpenes = "";
	var rowCnt = 1;
//*********************고객명을 클릭했을 때, 실행되는 함수 ************************
	$j("[id^='clientName']").on("click",function(){
		client = {};
		//css효과 부여
		$j("#clientTable tr.selected").removeClass('selected');
		$j(this).closest("tr").addClass('selected');
		//기존에 존재하던 periodButton 삭제.
		$j('#periodDiv').empty();
		$j('#detailDiv').empty();
		var rowId = $j(this).closest("tr").attr("id");
		console.log("rowId: " + rowId);
		var seq = $j("#"+rowId + " input[name='seq']").val();
		var userName = $j("#"+rowId + " input[name='userName']").val();
		var userPhone = $j("#"+rowId + " input[name='userPhone']").val();
		var traveCity = $j("#"+rowId + " input[name='traveCity']").val();
		var period = $j("#"+rowId + " input[name='period']").val();
		var transport = $j("#"+rowId + " input[name='transport']").val();
		var expend = $j("#"+rowId + " input[name='expend']").val();
		
		clientSeq = seq;
		
		client = 
		{
				seq : seq,
				userName : userName,
				userPhone : userPhone,
				traveCity : traveCity,
				period : period,
				transport : transport,
				expend : expend
		};
		
		
		console.log("client: " + JSON.stringify(client));
		
		if(seq !== ""){

			$j.ajax({
			    url : "/travel/getPeriodAction.do",
			    dataType: "json",
			    contentType: "application/json",
			    type: "POST",
			    data : JSON.stringify(seq),
			    success: function(data, textStatus, jqXHR) {
			        console.log("ajax통신 성공: " + period);
			        rowCnt = 1;
			        period = data.period;
			        //버튼 생성
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
			        //traveCity 값 할당.
			        initialCity = traveCity;
			        
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("통신 오류 발생 ajax");
			    }
			});
		}
		
	});
//*******************period버튼을 클릭했을 경우 ***************************
	$j("#periodDiv").on("click", ".periodButton-style", function() {
        // 기존에 선택된 버튼의 클래스 제거
        $j(".periodButton-style").removeClass("selected");

        // 현재 클릭된 버튼에 선택된 클래스 추가
        $j(this).addClass("selected");
    });
    
	$j(document).on("click","[name='periodButton']",function(){

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
		    	
		    	//traveList가 있는 경우 : DB저장값에 맞게 값을 뿌린다.
		    	if(Array.isArray(data.detailTraveList) && data.detailTraveList.length > 0){
		    		rowCnt = data.detailTraveList.length;
		    		console.log("rowCnt: " + rowCnt);
					for(var i=0; i < data.detailTraveList.length; i++){
						var citySelect = $j("#traveCitySelect" + (i + 1));
						var countySelect = $j("#traveCountySelect" + (i + 1));
						var transSelect = $j("#traveTransSelect" + (i + 1));
						
						var savedCity = data.detailTraveList[i].traveCity;
						var savedCounty = data.detailTraveList[i].traveCounty;
						var savedTrans = data.detailTraveList[i].traveTrans;
						
						console.log("savedCity: " + savedCity + " savedCounty: " + savedCounty);
						
						setCity(citySelect, savedCity);
						setCounty(countySelect, savedCity, savedCounty);
						setTrans(transSelect, savedTrans);
					}
					//수정요청이 있는 줄을 노란색으로 변경
					$j("#detailDiv input[name='request']").each(function() {
					    if ($j(this).val() === 'M') {
					        $j(this).closest("tr").css("background-color", "yellow");
					    }
					});
					//교통비를 계산하는 함수
					$j("#detailTable tr").each(function(index, element) {
			            var tr = $j(element);
			            var traveTrans = tr.find("input[name='traveTrans']").val();
			            var traveTime = tr.find("input[name='traveTime']").val();
			            var transTime = tr.find("input[name='transTime']").val();

			            if (traveTime !== "" && transTime !== "" && traveTrans !== undefined) {
			                var transFeeCell = tr.find(".transFee");
			                var finalFee;

			                if (traveTrans === "T") {
			                    finalFee = taxiFee(traveTime, transTime) + "원";
			                } else if (traveTrans === "B" || traveTrans === "S") {
			                    finalFee = publicTransFee(traveTrans, traveTime, transTime) + "원";
			                }

			                transFeeCell.text(finalFee);
			            }
			        });
		    	}else{	    		
			    	//traveList가 없는 경우 : initailize함수로 select 초기화
			    	rowCnt = 1;
			    	var citySelect = $j("[id^=traveCitySelect]:first");
			    	var countySelect = $j("[id^=traveCountySelect]:first");
			    	var transSelect = $j("[id^=traveTransSelect]:first");
			    	initializeCity(citySelect);
			    	initializeCounty(countySelect);
			    	initializeTrans(transSelect);
		    	}
		    	
		    	
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		});	
		
	});
	
	$j(document).on("click","[name='save']",function(){
		console.log("saveButton 클릭시 inputDay: " + inputDay);
		var rowNumbers = [];
		var traveList = [];
		$j("[id^='detailInput']").each(function(){
			var rowId = $j(this).attr('id');
			var rowNumber = parseInt(rowId.replace('detailInput',''));
			rowNumbers.push(rowNumber);
		});
		for(var i =0; i < rowNumbers.length; i ++){
			var $row = $j("#detailInput" + rowNumbers[i]);
			
			var traveDay = $row.find('[name="traveDay"]').val();
			var traveTime = $row.find('[name="traveTime"]').val();
			var traveCity = $row.find('[name="traveCity"]').val();
			var traveCounty = $row.find('[name="traveCounty"]').val();
			var traveLoc = $row.find('[name="traveLoc"]').val();
			var traveTrans = $row.find('[name="traveTrans"]').val();
			var transTime = $row.find('[name="transTime"]').val();
			var useTime = $row.find('[name="useTime"]').val();
			var useExpend = $row.find('[name="useExpend"]').val();
			var traveDetail = $row.find('[name="traveDetail"]').val();
			var request = $row.find('[name="request"]').val();
			var seq = clientSeq;
			
			var traveTimeMin = parseInt(traveTime.split(":")[1]);
			
			if(traveTime === ""){
				$row.find('[name="traveTime"]').focus();
				alert("시간을 입력하세요.");
				return;
			}
			if(traveTimeMin %10 !== 0){
				$row.find('[name="traveTime"]').focus();
				alert("시간은 10분 단위로 입력하세요.");
				return;
			}
			if(traveLoc === ""){
				$row.find('[name="traveLoc"]').focus();
				alert("장소를 입력하세요.");
				return;
			}
			if(useTime === ""){
				$row.find('[name="useTime"]').focus();
				alert("이용시간을 입력하세요.");
				return;
			}
			if(useTime < 10 || useTime.slice(-1)!=="0"){
				$row.find('[name="useTime"]').focus();
				alert("시간은 10분 단위로 입력하세요.");
				return;
			}
			if(transTime === ""){
				$row.find('[name="transTime"]').focus();
				alert("이동시간을 입력하세요.");
				return;
			}
			
			if(transTime < 10 || transTime.slice(-1)!=="0"){
				$row.find('[name="transTime"]').focus();
				alert("시간은 10분 단위로 입력하세요.");
				return;
			}
			if(useExpend === ""){
				$row.find('[name="useExpend"]').focus();
				alert("이용요금을 입력하세요.");
				return;
			}
			if(traveDetail === ""){
				$row.find('[name="traveDetail"]').focus();
				alert("계획상세를 입력하세요.");
				return;
			}
			
			
			
			//**************유효성 검증 코드가 들어갈 곳 *********************
			traveList.push(
				{
					traveDay : inputDay, traveTime : traveTime, traveCity : traveCity,
					traveCounty : traveCounty, traveLoc : traveLoc, traveTrans : traveTrans,
					transTime : transTime, useTime : useTime, useExpend : useExpend,
					traveDetail : traveDetail, request : request, seq :clientSeq, useTime : useTime
				}	
			);
		}
		traveList.sort(function(a, b) {
		    // transTime을 Date 객체로 변환
		    var transTimeA = parseInt(a.transTime);
		    var transTimeB = parseInt(b.transTime);
		    
		    var useTimeA = parseInt(a.useTime);
		    var useTimeB = parseInt(b.useTime);

		    // traveTime에 transTime과 useTime을 더하여 endTime을 계산
		    var traveTimeA = parseInt(a.traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
		    var traveTimeB = parseInt(b.traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
		    
		    var endTimeA = traveTimeA + transTimeA + useTimeA;
		    var endTimeB = traveTimeB + transTimeB + useTimeB;

		    // endTime을 기준으로 정렬
		    return endTimeA - endTimeB;
		});
		
		for(i=0; i<traveList.length; i++){
			console.log(JSON.stringify(traveList,null,2));
		}

		for (var i = 0; i < traveList.length -1; i++) {
			var traveTimeMin = parseInt(traveList[i].traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
			var transTime = parseInt(traveList[i].transTime);
			var useTime = parseInt(traveList[i].useTime);
			
			var nextTraveTimeMin = parseInt(traveList[i+1].traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
			
			var currentEndTime = traveTimeMin + transTime + useTime;
			var nextStartTime = nextTraveTimeMin;
			console.log("traveTimeMin: " + traveTimeMin);
			console.log("nextTraveTimeMin: " + nextTraveTimeMin);
			console.log("transTime: " + transTime);
			console.log("useTime: " + useTime);
		    console.log("currentEndTime: " + currentEndTime);
		    console.log("nextStartTime: " + nextStartTime);
		    if(traveTimeMin > 240 && traveTimeMin <420){
		    	
		    	alert("스케줄 등록 가능시간은 오전7시 ~ 새벽4시 입니다.");
		    }
		    
			// 이전 인덱스의 traveTime + useTime + transTime과 현재 인덱스의 traveTime을 비교하여 조건을 만족하는지 확인
		    if (currentEndTime >=  nextStartTime) {
		        // 조건을 만족하는 경우 스케줄 시간이 겹친다는 경고를 출력하고 종료
		        alert("스케줄 시간이 겹칩니다.");
		        return;
		    }
		}
		
				
		var data = {
			client : client, traveList : traveList, traveDay : inputDay
		}
	
		
		$j.ajax({
		    url : "/travel/saveTraveList.do",
		    contentType: "application/json",
		    dataType: "json",
		    type: "POST",
		    data : JSON.stringify(data),
		    success: function(data, textStatus, jqXHR)
		    {
		    	var msg = data.success;
		    	if(msg === "Y"){
		    		alert("저장에 성공하였습니다.");
		    		location.href = "/travel/traveManagement.do";	
		    	}else{
		    		alert("저장에 실패하였습니다.");			    		
		    	}
		    },
		    error: function (jqXHR, textStatus, errorThrown)
		    {
		    	alert("통신오류");
		    }
		});	
		
	});
//******************정규식 관련 메소드 *************************************
	var onlyNum = /[^0-9]/g;
	$j(document).on("input keydown","input[name='useTime']",function(event){
		 event.target.value = event.target.value.replace(onlyNum, '');
	});
	$j(document).on("input keydown","input[name='transTime']",function(event){
		 event.target.value = event.target.value.replace(onlyNum, '');
	});
	$j(document).on("input keydown","input[name='useExpend']",function(event){
		 event.target.value = event.target.value.replace(onlyNum, '');
	});
	
//******************html빌드 관련 메소드 **********************************
	function updateHtml(data){
		console.log("updateHtml호출!!!");
		$j("#detailDiv").html(buildTable(data.detailTraveList));
	}
	
	function buildTable(detailTraveList){
		var html = '';
		html += '<table align="center">';
	    html += '<tr>';
	    html += '<td>';
	    html += '<input type="button" id="detailAdd" value="추가" style="margin-bottom: 10px"> | ';
	    html += '<input type="button" id="detailDel" value="삭제" style="margin-bottom: : 10px">';
	    html += '</td>';
	    html += '</tr>';
	    html += '<tr>';
	    html += '<td>';
	    html += '<table id="detailTable" border="1">';
	    html += '<tr>';
	    html += '<td></td>';
	    html += '<td>시간</td>';
	    html += '<td>지역</td>';
	    html += '<td>장소명</td>';
	    html += '<td>이용시간(분)</td>';
	    html += '<td>교통편</td>';
	    html += '<td>예상이동시간(분)</td>';
	    html += '<td>이용요금(예상지출비용)</td>';
	    html += '<td>계획상세</td>';
	    html += '<td>교통비</td>';
	    html += '</tr>';
	    
	    if (Array.isArray(detailTraveList) && detailTraveList.length > 0) {
	    	console.log("detailList 있음: else문 돈다.");
	    	 detailTraveList.forEach(function (item, index) {
	             html += '<tr id="detailInput' + (index + 1) + '">';
	             html += '<td>';
	             html += '<input type="checkbox" name="selection">';
	             html += '<input type="hidden" name="request" value="' + item.request +'">';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="time" name="traveTime" value="' + item.traveTime + '">';
	             html += '</td>';
	             html += '<td>';
	             html += '<select id="traveCitySelect' + (index + 1) + '" name="traveCity"></select>';
	             html += '<input type="hidden" name="traveCity" value="'+ item.traveCity +'">';
	             html += '<select id="traveCountySelect' + (index + 1) + '" name="traveCounty"></select>';
	             html += '<input type="hidden" name="traveCounty" value="'+ item.traveCounty +'">';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="text" name="traveLoc" value="' + item.traveLoc + '">';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="text" name="useTime" value="' + item.useTime + '">분';
	             html += '</td>';
	             html += '<td>';
	             html += '<select id="traveTransSelect' + (index + 1) + '" name="traveTrans"></select>';
	             html += '<input type="hidden" name="traveTrans" value="'+ item.traveTrans +'">';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="text" name="transTime" value="' + item.transTime + '">분';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="text" name="useExpend" value="' + item.useExpend + '">원';
	             html += '</td>';
	             html += '<td>';
	             html += '<input type="text" name="traveDetail" value="' + item.traveDetail + '">';
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
	        html += '<input type="checkbox" name="selection">';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="time" name="traveTime">';
	        html += '</td>';
	        html += '<td>';
	        html += '<select id="traveCitySelect1" name="traveCity"></select>';
	        html += '<select id="traveCountySelect1" name="traveCounty"></select>';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="text" name="traveLoc">';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="text" name="useTime">분';
	        html += '</td>';
	        html += '<td>';
	        html += '<select id="traveTransSelect1" name="traveTrans"></select>';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="text" name="transTime">분';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="text" name="useExpend">원';
	        html += '</td>';
	        html += '<td>';
	        html += '<input type="text" name="traveDetail">';
	        html += '</td>';
	        html += '<td class="transFee">';
	        html += '</td>';
	        html += '</tr>';
	        html += '<tbody id="appendDiv"></tbody>';
	    }
	    html += '<tbody id="appendDiv"></tbody>';
	    html += '</table>';
	    html += '</td>';
	    html += '</tr>';
	    html += '<tr>';
	    html += '<td align="center">';
	    html += '<br><input type="button" name="save" value="저장">';
	    html += '</td></tr></table>';
	    
	    return html;
	}
	
	
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
	

	
	
	
	function initializeCity(citySelect){
		console.log(initialCity);
		var option = $j("<option>").text(initialCity);
		citySelect.append(option);		
	}
	
	function setCity(citySelect, savedCity){
	    
        var option = $j("<option>").text(savedCity);
        citySelect.append(option);
	   
	}
	
	
	//두번째 select 초기값 설정
	function initializeCounty(countySelect) {
	    var defaultCity = initialCity;
	    var defaultCounty = traveCounty[defaultCity];
	    
	    countySelect.empty();
	    $j.each(defaultCounty, function (i, val) {
	        var option = $j("<option>").text(val);
	        countySelect.append(option);
	    });
	    
		console.log("지역 초기화값 설정 함수 호출: " + defaultCity + " " + defaultCounty);
	}
	
	function setCounty(countySelect, savedCity, savedCounty) {
	    var defaultCity = savedCity;
	    var defaultCounty = traveCounty[defaultCity];
	    
	    countySelect.empty();
	    $j.each(defaultCounty, function (i, val) {
	        var option = $j("<option>").text(val).attr('value', val);
	        if (val === savedCounty) {
	            option.attr('selected', 'selected');
	        }
	        countySelect.append(option);
	    });
	}
	
	function initializeTrans(transSelect) {
		$j.each(traveTrans, function(key, val){
		    var option = $j("<option>").text(key).val(val);
		    transSelect.append(option);
		});		
	}
	
	function setTrans(transSelect, savedTrans) {
		$j.each(traveTrans, function(key, val){
		    var option = $j("<option>").text(key).val(val);
		    if (val === savedTrans) {
	            option.attr('selected', 'selected');
	        }
		    transSelect.append(option);
		});		
	}
	
	
	$j(document).on("change","[name=traveCity]",function(){
		
		var cityCurrentId = $j(this).attr('id'); 
		var num = cityCurrentId.replace(/\D/g, '');
		var numberedCountySelect = $j('#traveCountySelect' + num);
		
		var currentCity = $j(this).val();
	    var countyArray = traveCounty[currentCity];
	    console.log("citySelect값 변화: " + "현재 selectId: " + cityCurrentId + " 현재 도시: " + currentCity );
	    
	    numberedCountySelect.empty();
	    
	    $j.each(countyArray, function (i, val) {
	        var option = $j("<option>").text(val);
	        numberedCountySelect.append(option);
	    });
	});
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
	
	function publicTransFee(traveTrans,traveTime,transTime){		
		//traveTime을 분으로 변환
		var traveTimeMin = parseInt(traveTime.split(':').reduce((acc, val, index) => index === 0 ? acc + parseInt(val) * 60 : acc + parseInt(val), 0));
		var transTimeMin = parseInt(transTime);
		var extraCnt =  Math.floor(transTimeMin/20);
		//traveTrans값에 의해 버스와 지하철을 구분
		//traveTrans가 버스인 경우
		if(traveTrans === "B"){
			var finalFee = 1400 + extraCnt * 200;
			return finalFee;
		}
		//traveTrans가 지하철인 경우
		else{
			var finalFee = 1450 + extraCnt * 200;
			return finalFee;
		}
		
	}
//****************교통비 출력 함수 ********************************
	$j(document).on("change","select[name='traveTrans'],input[name='transTime'],input[name='traveTime']",function(){
		var traveTrans = $j(this).closest('tr').find('select[name="traveTrans"]').val();
		var traveTime = $j(this).closest('tr').find('input[name="traveTime"]').val();
		var transTime = $j(this).closest('tr').find('input[name="transTime"]').val();
		console.log("traveTrans: " + traveTrans);
		console.log("traveTime: " + traveTime);
		console.log("transTime: " + transTime);
		//traveTrans가 택시일 경우
		$j(this).closest('tr').find('td.transFee').html('');
		
		if(traveTime !== "" && transTime !== "" && traveTrans !== undefined){
			if(traveTrans === "T"){		
				var finalFee = taxiFee(traveTime,transTime) + "원";
				$j(this).closest('tr').find('td.transFee').append(finalFee);					
			}
			//taveTrans가 버스 또는 지하철일 경우
			if(traveTrans === "B" || traveTrans === "S"){
				var finalFee = publicTransFee(traveTrans,traveTime,transTime) + "원";
				$j(this).closest('tr').find('td.transFee').append(finalFee);
			}
		}	
	});
//****************상세 스케줄 행 추가 **********************************
	$j(document).on("click","#detailAdd",function(){
		rowCnt ++;
		console.log("행 추가 클릭 행 갯수: " + rowCnt);
		var clonedRow = $j("[id^=detailInput]:first").clone();
		
		console.log("clonedRow: " + JSON.stringify(clonedRow));
		clonedRow.attr("id","detailInput" + rowCnt);
		clonedRow.find("[name='selection']").prop("checked",false);
		clonedRow.find("input").val('');
		clonedRow.find(".transFee").html('');
		
		var newCitySelectId = "traveCitySelect" + rowCnt;
	    var newCountySelectId = "traveCountySelect" + rowCnt;
		
		clonedRow.find('[id^="traveCitySelect"]').attr('id',newCitySelectId);
		clonedRow.find('[id^="traveCountySelect"]').attr('id',newCountySelectId);
		
		console.log("newCountySelectId: " + newCountySelectId);
			
		clonedRow.appendTo("#appendDiv").show();
		initializeCounty($j("#" + newCountySelectId));
		
	});
//**************상세 스케줄 행 삭제 ************************************
	$j(document).on("click","#detailDel",function(){
		
		console.log("행 삭제 클릭, 행 갯수: " + rowCnt);
		var checkedIds = [];
		$j("[type='checkbox']").each(function(){
			if($j(this).is(":checked")){
				var rowId = $j(this).closest("tr").attr("id");
				checkedIds.push(rowId);
			}
		});
		console.log("체크 행 갯수: " + checkedIds.length);
		if(rowCnt > checkedIds.length){
			checkedIds.forEach(function(rowId){
				$j("#" + rowId).remove();
				rowCnt --;
			});
		}else{
			alert("최소 1개 이상의 행이 존재해야 합니다.");
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
				
				<tr id="clientRow${loop.index +1}">
					<td style="display: none">
						<input type="hidden" name="seq" value="${list.seq }">
					</td>
					<td id="clientName${loop.index +1 }">
						${list.userName }<input type="hidden" name="userName" value="${list.userName }">
					</td>
					<td>
						${list.userPhone }<input type="hidden" name="userPhone" value="${list.userPhone }">
					</td>
					<td>
						${list.traveCity }<input type="hidden" name="traveCity" value="${list.traveCity }">
					</td>
					<td>
						${list.period }<input type="hidden" name="period" value="${list.period }">
					</td>
					<td>
						<c:choose>
							<c:when test="${list.transport eq 'R'}">
								렌트		
							</c:when>
							<c:when test="${list.transport eq 'B'}">
								대중교통			
							</c:when>
							<c:when test="${list.transport eq 'C'}">
								자차		
							</c:when>
						</c:choose>
						<input type="hidden" name="transport" value="${list.transport }">					
					</td>
					<td>
						${list.expend }<input type="hidden" name="expend" value="${list.expend }">
					</td>
					<td>
						${list.estimatedExpenses }
					</td>
				</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
	<tr>
		<td><a href="/travel/login.do">로그인 페이지로 이동</a></td>
	</tr>
</table>

<br/>
<div id="periodDiv" style="padding-left: 100px;padding-right: 100px; padding-bottom: 10px"></div>

<div id="detailDiv">
	
</div>
</body>
</html>
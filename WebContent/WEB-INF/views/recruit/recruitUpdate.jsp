<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
		var name = "${sessionScope.name}";
		var phone = "${sessionScope.phone}";
		var submit = "${savedRecruit.getSubmit()}";
		var seq = "${savedRecruit.getSeq()}";
		console.log("submit: " + submit);
		console.log("seq: " + seq);
		var savedEducation = "${savedEducation}";
		var savedCareer = "${savedCareer}";
		var savedCertificate = "${savedCertificate}";
		//**********submit상태에 따라 입력을 방지***********************
		
		//**********각 테이블의 현재 수 *******************************	
		var educationTableCnt = 1;
		var careerTableCnt =1;
		var certificateTableCnt =1;	
		//***********input에 값을 세팅하는 함수 *******************
		
		educationTableCnt = "${savedEducation.size()}";
		
		if(savedCareer !== ""){
			careerTableCnt = "${savedCareer.size()}";
		}
		if(savedCertificate !== ""){
			certificateTableCnt = "${savedCertificate.size()}";
		}
		var academicYears = "${profile.getEducation().getAcademicYears()}";
		var totalCareer = Math.floor("${profile.getCareer()}"/12) + "년 " + "${profile.getCareer()}"%12+"개월";
		var recruitLocation = "${savedRecruit.getLocation()}";
		console.log("recruitLocation: " + recruitLocation);
		$j("#totalCareer").text("경력 " + totalCareer);						
		$j("#recruitTable [name='gender']").val("${savedRecruit.getGender()}");	
		$j("#recruitTable [name='workType']").val("${savedRecruit.getWorkType()}");	
		$j("#recruitTable [name='location']").val("${savedRecruit.getLocation()}");			
		
		//**********각 테이블의 원형을 복사해서 넣을 변수 ********************	
		var educationHTML = "";
		var careerHTML = "";
		var certificateHTML = "";
		//**********각 테이블의 유효성이 체크 되었는지 표시하는 변수 *************
		var isCheckedRecruit = false;
		var isCheckedEducation = false;
		var isCheckedCareer = false;
		var isCheckedCertificate = false;
		var isRequired = false;
		//**********최종 전송하게 될 VO와 LIST에 매핑될 객체*****************	
		var recruit = {};
		var education = [];
		var career = [];
		var certificate = [];
		var delEducationSeqList = [];
		var delCareerSeqList = [];
		var delCertificateList = [];
		//*********정규식 표현 변수 ************************************
		var onlyKor = /[a-z0-9]|[ \[\]{}()<>?|`~!@#$%^&*_+=,.;:"'\\]/g;
		var onlyNum = /[^0-9]/g;
		var engAndNum = /[^a-zA-Z0-9]/g;
		var emailReg = /[a-z0-9]+@[a-z]+\.[a-z]{2,3}/;
		var addressReg =/^((?:[가-힣]+(?:시|도))\s(?:[가-힣]+(?:구|군|시))?)/;
		var taskReg = /^[^/]+\/[^/]+\/[^/]+$/;
			
		//***********dateFormat을 만드는 함수 **************************
		function formatDate($table,fieldName) {
		    var numberInput = $table.find('[name="' + fieldName + '"]').val();
		    console.log("formatDate 호출  fieldName: " + fieldName);
		    console.log("formatDate 호출  numberInput: " + numberInput);
		    
		    if(numberInput.includes("-")){
		    	return numberInput;
		    }else{
			    var year = numberInput.substring(0, 4);
			    var month = numberInput.substring(4, 6);
			    var day = numberInput.substring(6, 8);
			    
			    var isValidMonth = parseInt(month, 10) >= 1 && parseInt(month, 10) <= 12;
			    var isValidDay = parseInt(day, 10) >= 1 && parseInt(day, 10) <= 31;
			    
			    if(numberInput == ""){
			    	return "";
			    }
			    
			    if (year < 1900 || year > new Date().getFullYear()) {	
			
			        return -2;
			    }
			    if (month < 1 || month > 12) {		
			    	
			        return -1;
			    }
			    if (day < 1 || day > 31) {	
			    	
			        return -1;
			    }
			    var maxDay;
			    if (month == 2) {
			        // 윤년인 경우
			        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
			            maxDay = 29;
			        } else {
			            maxDay = 28;
			        }
			    } else if ([04, 06, 09, 11].includes(month)) {
			        maxDay = 30;
			    } else {
			        maxDay = 31;
			    }
			    console.log("maxDay: " + maxDay);
			    if (day > maxDay) {
			        return -3;
			    }

			    if(numberInput !== ""){
			    	
			    	return  year +  month +  day;
			    }
			    else{
			    	return -1;
			    }    	
		    }	    
		}
		
		function formatDateMonth($table, fieldName){
			var numberInput = $table.find('[name="' + fieldName + '"]').val();
		    console.log("formatDate 호출  fieldName: " + fieldName);
		    console.log("formatDate 호출  numberInput: " + numberInput);
		    if(numberInput.includes("-")){
		    	return numberInput;
		    }else{		    	
			    var year = numberInput.substring(0, 4);
			    var month = numberInput.substring(4, 6);
			    
			    if (numberInput == "") {
			        return "";
			    }
			    if (year < 1900 || year > new Date().getFullYear()) {
			        return -2;
			    }
			    if (month < 1 || month > 12) {
			        return -1;
			    }
			    if (numberInput !== "") {
			        return year + month;
			    } else {
			        return -1;
			    }	    
		    }
		}
		//***********input을 제한하는 함수 ******************************
		//recruit table
		$j("input[name='birth']").on("input keydown",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 8){
				event.target.value = event.target.value.substring(0,8);
			}
		});
		
		$j("input[name='addr']").on("input keydown",function(event){
			var $input = $j(this).val().replace(/[a-zA-Z]/g, '');
			$j(this).val($input);
		});
		
		//education table
		$j("#educationBox").on("input keydown","input[name='startPeriod']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 6){
				event.target.value = event.target.value.substring(0,6);
			}
		});
		
		$j("#educationBox").on("input keydown","input[name='endPeriod']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 6){
				event.target.value = event.target.value.substring(0,6);
			}
		});
		
		$j("#educationBox").on("input keydown","input[name='schoolName']",function(event){
			var $input = $j(this).val();
			if(onlyKor.test($input)) {
				$j(this).val($input.replace(onlyKor,''));		
			}
		});
		
		$j("#educationBox").on("input keydown","input[name='major']",function(event){
			var $input = $j(this).val();
			if(onlyKor.test($input)) {
				$j(this).val($input.replace(onlyKor,''));		
			}
		});
		
		$j("#educationBox").on("input keydown","input[name='grade']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 1 ){
				var formatted = $input.slice(0,1) + '.' + $input.slice(1);
				$j(this).val(formatted);
			}
			if($input.length > 1 && event.key !== 'Backspace' && event.key !== 'Tab'){
				event.preventDefault();
				if($input.length == 1){
					
				}
			}
		});
		//career table
		$j("#careerBox").on("input keydown","input[name='startPeriod']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 6){
				event.target.value = event.target.value.substring(0,6);
			}
		});
		
		$j("#careerBox").on("input keydown","input[name='endPeriod']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 6){
				event.target.value = event.target.value.substring(0,6);
			}
		});
		
		$j("#careerBox").on("input keydown","input[name='location']",function(event){
			var $input = $j(this).val();
			if(onlyKor.test($input)) {
				$j(this).val($input.replace(onlyKor,''));		
			}
		});
		//certificate table
		$j("#certificateBox").on("input keydown","input[name='acquDate']",function(event){
			var $input = $j(this).val().replace(onlyNum,'');
			$j(this).val($input);
			if($input.length > 8){
				event.target.value = event.target.value.substring(0,8);
			}
		});
		//************각 테이블을 체클하는 함수 ****************************	
		function checkRecruit(){
			isCheckedRecruit = false;
			//기본 정보를 받아와 유효성 검증을 진행한 뒤 통과한다면
			//checked변수를 true로 바꾸고 recruit 변수에 할당합니다.  
			var birth = formatDate($j("#recruitTable"),'birth');
			var gender = $j('#recruitTable [name="gender"]').val();
			var email = $j('#recruitTable [name="email"]').val();
			var addr = $j('#recruitTable [name="addr"]').val();
			var location = $j('#recruitTable [name="location"]').val();
			var workType = $j('#recruitTable [name="workType"]').val();
			
			//유효성 검사
			if(birth === ""){
				$j('#recruitTable [name="birth"]').focus();
				alert("생년월일을 입력하세요.");
				return false;
			}else if(birth === -1){
				$j('#recruitTable [name="birth"]').focus();
				alert("날짜가 유효하지 않습니다." + "\n" + "입력 형식: YYYYMMDD");
				isValid = false;
				return false;
			}else if(birth === -2){
				$j('#recruitTable [name="birth"]').focus();
				alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYYMMDD");
				return false;
			}else if(birth === -3){
				$j('#recruitTable [name="birth"]').focus();
				alert("유효하지 않은 날짜입니다.");
				return false;
			}
			if(email === ""){
				$j('#recruitTable [name="email"]').focus();
				alert("이메일을 입력하세요.");
				return false;
			}
			if(!emailReg.test(email)){
				$j('#recruitTable [name="email"]').focus();
				alert("이메일 형식이 잘못되었습니다." + "\n" + "입력 형식: xxx@xxx.xxx" );
				return false;
			}
			if(addr === ""){
				$j('#recruitTable [name="addr"]').focus();
				alert("주소를 입력하세요.");
				return false;
			}
			
			if(birth !== "" && email !== "" && addr !== ""){
				isCheckedRecruit = true;				
			}
			recruit = 
			{
					name : name, birth : birth, gender : gender,
					phone : phone, email : email, addr : addr,
					location : location, workType : workType, seq : seq
			}
		}
		
		function checkEducation(){
			education = [];        
			console.log("education 초기화 완료: " + education.length);
			isCheckedEducation = false;
			//기본 정보를 받아와 유효성 검증을 진행한 뒤 통과한다면
			//checked변수를 true로 바꾸고 education 변수에 할당합니다. 

			var tableNumbers = [];
			$j('[id^="educationInput"]').each(function() {
		        var tableId = $j(this).attr('id');
		        var tableNumber = parseInt(tableId.replace('educationInput', ''));
		        tableNumbers.push(tableNumber);
		    });
			console.log("educationInput의 수 : " + tableNumbers.length);
			console.log("educationTableCnt : " + educationTableCnt);
			for(var i =0; i < tableNumbers.length; i ++){

				var birth = formatDate($j("#recruitTable"),'birth');

				var $table = $j("#educationInput" + tableNumbers[i]);
				console.log("formatDate 시 넘기게 될 table 내용: " + JSON.stringify($table.find('[name="startPeriod"]').val()));
				var schoolName = $table.find('[name="schoolName"]').val();
				var division = $table.find('[name="division"]').val();
				var startPeriod = formatDateMonth($table,"startPeriod");
				var endPeriod = formatDateMonth($table,"endPeriod");
				var major = $table.find('[name="major"]').val();
				var grade = $table.find('[name="grade"]').val();
				var location = $table.find('[name="location"]').val();
				var eduSeq = $table.find('[name="eduSeq"]').val();
				
				if(startPeriod === ""){
					console.log("if문 진입 : StartPeriod")
					$table.find('[name="startPeriod"]').focus();
					alert("입학 일자를 입력하세요.");
					return;
				}else if(startPeriod === -1){
					$table.find('[name="startPeriod"]').focus();
					alert("날짜가 유효하지 않습니다.");
					return;
				}else if(startPeriod === -2){
					$table.find('[name="startPeriod"]').focus();
					alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYYMMDD");
					return;
				}else if(startPeriod === -3){
					$table.find('[name="startPeriod"]').focus();
					alert("유효하지 않은 날짜입니다.");
					return;
				}else if(startPeriod < birth){
					$table.find('[name="startPeriod"]').focus();
					alert("입학일자는 생년월일보다 늦어야 합니다.");
					return;
				}
				
				if(endPeriod === ""){
					$table.find('[name="endPeriod"]').focus();
					alert("졸업 일자를 입력하세요.");
					return;
				}else if(endPeriod === -1){
					$table.find('[name="endPeriod"]').focus();
					alert("날짜가 유효하지 않습니다.");
					return;
				}else if(endPeriod === -2){
					$table.find('[name="endPeriod"]').focus();
					alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYYMMDD");
					return;
				}else if(endPeriod === -3){
					$table.find('[name="endPeriod"]').focus();
					alert("유효하지 않은 날짜입니다.");
					return;
				}
				
				if(startPeriod >= endPeriod){
					$table.find('[name="startPeriod"]').focus();
					alert("입학일은 졸업일보다 빨라야 합니다.");
				
					return;
				}
				
				if(schoolName === ""){
					$table.find('[name="schoolName"]').focus();
					alert("학교명을 입력하세요.");
					return;
				}
				if(major === ""){
					$table.find('[name="major"]').focus();
					alert("전공을 입력하세요.");
				
					return;
				}
				if(grade === ""){
					$table.find('[name="grade"]').focus();
					alert("학점을 입력하세요.");
				
					return;
				}
				
				education.push(
					{	
						schoolName : schoolName, division : division, startPeriod : startPeriod,
						endPeriod : endPeriod, major : major, grade : grade, location : location, seq : seq
						
					}		
				);
			}
			//반복문에서 모든 유효성이 통과가 되면,
			isCheckedEducation = true;
			
			education.sort(function(a, b) {
			    return new Date(a.endPeriod) - new Date(b.endPeriod);
			});
			
			for(i=0; i<education.length; i++){
				console.log(JSON.stringify(education,null,2));
			}
			
			for(i=0; i< education.length -1; i++){
				console.log("educationCheck 반복문 끝나구 period 유효성 체크중");
				var currentEndPeriod = education[i].endPeriod;
				var nextStartPeriod = education[i + 1].startPeriod;
				
				 if (currentEndPeriod >= nextStartPeriod) {
					 isCheckedEducation = false;
					 alert("재학기간이 겹칩니다.");
					 return;
		        }
			}
			
		}
		
		function checkCareer(){
			career = [];
			console.log("career 초기화 완료: " + career.length);
			isCheckedCareer = false;
			//기본 정보를 받아와 유효성 검증을 진행한 뒤 통과한다면
			//checked변수를 true로 바꾸고 career 변수에 할당합니다. 
			var tableNumbers = [];
			$j('[id^="careerInput"]').each(function() {
		        var tableId = $j(this).attr('id');
		        var tableNumber = parseInt(tableId.replace('careerInput', ''));
		        tableNumbers.push(tableNumber);
		    });
			console.log("careerTable의 수 : " + tableNumbers.length);
			console.log("careerTableCnt : " + careerTableCnt);

			for(var i =0; i < tableNumbers.length; i ++){
				
				var birth = formatDate($j("#recruitTable"),'birth');
				
				var $table = $j("#careerInput" + tableNumbers[i]);
				
				var compName = $table.find('[name="compName"]').val();
				var location = $table.find('[name="location"]').val();
				var startPeriod = formatDateMonth($table,"startPeriod");
				var endPeriod = formatDateMonth($table,"endPeriod");
				var task = $table.find('[name="task"]').val();
				
				console.log("startPeriod" + startPeriod);
				
				if(i !==0 && compName === "" && location === "" && startPeriod === "" && endPeriod === "" && task ===""){
					continue;
				}
				
				if(startPeriod === ""){
					$table.find('[name="startPeriod"]').focus();
					alert("입사일을 입력하세요.");
					
					return;
				}else if(startPeriod === -1){
					$table.find('[name="startPeriod"]').focus();
					alert("날짜가 유효하지 않습니다." + "\n" + "입력 형식: YYYY-MM-DD");				
					return;
				}else if(startPeriod === -2){
					$table.find('[name="startPeriod"]').focus();
					alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYY-MM-DD");
					return;
				}else if(startPeriod === -3){
					$table.find('[name="startPeriod"]').focus();
					alert("유효하지 않은 날짜입니다.");
					return;
				}else if(startPeriod < birth){
					$table.find('[name="startPeriod"]').focus();
					alert("입사일자는 생년월일보다 늦어야 합니다.");
					return;
				}
				
				if(endPeriod === ""){
					$table.find('[name="endPeriod"]').focus();
					alert("퇴사일을 입력하세요.");					
					return;		
				}else if(endPeriod === -1){
					$table.find('[name="endPeriod"]').focus();
					alert("날짜가 유효하지 않습니다.");					
					return;
				}else if(endPeriod === -2){
					$table.find('[name="endPeriod"]').focus();
					alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYY-MM-DD");
					return;
				}else if(endPeriod === -3){
					$table.find('[name="endPeriod"]').focus();
					alert("유효하지 않은 날짜입니다.");
					return;
				}
				if(startPeriod >= endPeriod){
					$table.find('[name="startPeriod"]').focus();
					alert("입사일은 퇴사일보다 빨라야 합니다."); 
					return;
				}
				
				if(compName === ""){
					$table.find('[name="compName"]').focus();
					alert("회사명을 입력하세요.");
					return;
				}
				if(task === ""){
					$table.find('[name="task"]').focus();
					alert("당당업무를 입력하세요.");
					return;
				}
				if(!taskReg.test(task)){
					$table.find('[name="task"]').focus();
					alert("형식이 올바르지 않습니다." + "\n" + "입력 형식: 부서/직급/직책");
					return;
				}
				if(location === ""){
					$table.find('[name="location"]').focus();
					alert("지역을 입력하세요.");
					return;
				}
				
				career.push(
					{	
						compName : compName, location : location, startPeriod : startPeriod,
						endPeriod : endPeriod, task : task, seq : seq
					}		
				);		
			}
			isCheckedCareer = true;
			
			career.sort(function(a, b) {
			    return new Date(a.endPeriod) - new Date(b.endPeriod);
			});

			for(i=0; i< career.length -1; i++){
				console.log("careerCheck 반복문 끝나구 period 유효성 체크중");
				var currentEndPeriod = career[i].endPeriod;
				var nextStartPeriod = career[i + 1].startPeriod;
				
				 if (currentEndPeriod >= nextStartPeriod) {
					 isCheckedCareer = false;
					 alert("근무기간이 겹칩니다.");
			         return;
		        }
			}
		}
		
		function checkCertificate(){
			certificate = [];
			isCheckedCertificate =false;
			//기본 정보를 받아와 유효성 검증을 진행한 뒤 통과한다면
			//checked변수를 true로 바꾸고 certificate 변수에 할당합니다. 
			var tableNumbers = [];
			$j('[id^="certificateInput"]').each(function() {
		        var tableId = $j(this).attr('id');
		        var tableNumber = parseInt(tableId.replace('certificateInput', ''));
		        tableNumbers.push(tableNumber);
		    });
			console.log("certificateTable의 수 : " + tableNumbers.length);
			console.log("certificateTableCnt : " + certificateTableCnt);

			for(var i =0; i < tableNumbers.length; i ++){
				
				var birth = formatDate($j("#recruitTable"),'birth');
				
				var $table = $j("#certificateInput" + tableNumbers[i]);
				
				var qualifiName = $table.find('[name="qualifiName"]').val();
				var acquDate = formatDate($table,"acquDate");
				var organizeName = $table.find('[name="organizeName"]').val();
				
				if(i !==1 && qualifiName === "" && acquDate === "" && organizeName === ""){
					continue;
				}
				
				if(qualifiName === ""){
					$table.find('[name="qualifiName"]').focus();
					alert("자격증명을 입력하세요.");
					
					return;
				}
				
				if(acquDate === ""){
					$table.find('[name="acquDate"]').focus();
					alert("취득일을 입력하세요.");
					return;
				}else if(acquDate === -1){
					$table.find('[name="acquDate"]').focus();
					alert("날짜가 유효하지 않습니다.");
					return;
				}else if(acquDate === -2){
					$table.find('[name="acquDate"]').focus();
					alert("연도의 범위는 1900부터  당해 년도 까지 입니다." + "\n" + "입력 형식: YYYY-MM-DD");
					return false;
				}else if(acquDate === -3){
					$table.find('[name="acquDate"]').focus();
					alert("유효하지 않은 날짜입니다.");
					return false;
				}else if(acquDate < birth +1){
					$table.find('[name="acquDate"]').focus();
					alert("취득일자는 생년월일보다 늦어야 합니다.");
					return;
				}
				
				if(organizeName === ""){
					$table.find('[name="organizeName"]').focus();
					alert("발행처를 입력하세요.");
					
					return;
				}
				certificate.push(
					{	
						qualifiName : qualifiName, acquDate : acquDate, organizeName :organizeName, seq : seq						
					}		
				);
			}
			isCheckedCertificate = true;					
		}
		//*****************************행 추가 삭제에 대한 로직************************************		
		$j("#educationAdd").on("click",function(){
			var newEducationTable = "";
			if(educationHTML === ""){
				educationTableCnt ++;
				newEducationTable = $j("#educationInput1").clone();
				educationHTML = newEducationTable;
			}else{
				educationTableCnt ++;
				newEducationTable = educationHTML.clone();
			}
			newEducationTable.attr("id", "educationInput" + educationTableCnt);
			newEducationTable.find("[name='selection']").prop("checked",false);
			newEducationTable.find("[name='startPeriod'], [name='endPeriod']").val(""); 
            newEducationTable.find("[name='schoolName'], [name='major'], [name='grade']").val(""); 
            newEducationTable.find("[name='gender']").val("재학");
            newEducationTable.appendTo("#eduAppend").show();
            console.log("educationTableCnt: " + educationTableCnt);	
		});
		
		$j("#careerAdd").on("click",function(){
			var newCareerTable = "";
			if(careerHTML === ""){
				careerTableCnt ++;
				newCareerTable = $j("#careerInput1").clone();
				careerHTML = newCareerTable;					
			} else {
				careerTableCnt ++;
				newCareerTable = careerHTML.clone();			
			}			
			newCareerTable.attr("id", "careerInput" + careerTableCnt);
			newCareerTable.find("[name='selection']").prop("checked",false);
			newCareerTable.find("[name='startPeriod'], [name='endPeriod']").val("");
			newCareerTable.find("[name='compName'], [name='task'], [name='location']").val("");
			newCareerTable.appendTo("#carAppend").show();
			console.log("careerTableCnt: " + careerTableCnt);
		});
		
		$j("#certificateAdd").on("click",function(){
			var newcertificateTable = "";
			if(certificateHTML === ""){
				certificateTableCnt ++;
				newcertificateTable = $j("#certificateInput1").clone();
				certificateHTML = newcertificateTable;			
			}else{
				certificateTableCnt ++;
				newcertificateTable = certificateHTML.clone();								
			}			
			newcertificateTable.attr("id", "certificateInput" + certificateTableCnt);
			newcertificateTable.find("[name='selection']").prop("checked",false);
			newcertificateTable.find("[name='qualifiName'], [name='acquDate'], [name='organizeName']").val("");
			newcertificateTable.appendTo("#certAppend").show();	
			console.log("certificateTableCnt: " + certificateTableCnt);
		});
		
		$j("#educationDel").on("click",function(){	
			var checkedIds = [];
			$j("[id^='educationInput'] [type='checkbox']").each(function(){
				if($j(this).is(":checked")){
					var tableId = $j(this).closest("tr").attr("id");
					checkedIds.push(tableId);
				}
			});
			if(educationTableCnt > checkedIds.length){
				checkedIds.forEach(function(tableId){
					$j("#" + tableId).remove();
					educationTableCnt --;
					console.log("educationTableCnt: " + educationTableCnt);
				});				
			}else {
				alert("최소 1개 이상의 행이 존재해야 합니다.");
			}
		});
		
		$j("#careerDel").on("click",function(){	
			var checkedIds = [];
			$j("[id^='careerInput'] [type='checkbox']").each(function(){
				if($j(this).is(":checked")){
					var tableId = $j(this).closest("tr").attr("id");
					checkedIds.push(tableId);
				}
			});
			if(careerTableCnt > checkedIds.length){
				checkedIds.forEach(function(tableId){
					$j("#" + tableId).remove();
					careerTableCnt --;
					console.log("careerTableCnt: " + careerTableCnt);	
				});				
			}else{
				alert("최소 1개 이상의 행이 존재해야 합니다.");
			}
		});
		
		$j("#certificateDel").on("click", function(){
			var checkedIds = []; 
			$j("[id^='certificateInput'] [type='checkbox']").each(function(){
				if($j(this).is(":checked")){
					var tableId = $j(this).closest("tr").attr("id");
					checkedIds.push(tableId);
				}
			});
			if(certificateTableCnt > checkedIds.length){
				checkedIds.forEach(function(tableId){
					$j("#" + tableId).remove();
					certificateTableCnt --;
					console.log("certificateTableCnt: " + certificateTableCnt);	
				});
			}else{
				alert("최소 1개 이상의 테이블이 존재해야 합니다.");
			}
		});
		//******************재학기간과 근무기간이 겹치는지 여부를 파악하는 함수 ********************
		function checkOverlap(eduStart, eduEnd, carStart, carEnd){
			return !(eduEnd < carStart || carEnd < eduStart);
		}
		//객체 배열 형태로 매개변수를 받을 예정
		function checkDateOverlap(education, career){
			for(var i=0; i <education.length; i++){
				for(var j=0; j < career.length; j++){
					if(checkOverlap(education[i].startPeriod,education[i].endPeriod,
							career[j].startPeriod,career[j].endPeriod)){
						var schoolName = education[i].schoolName;
						var compName = career[j].compName;						
						var msg = "재학기간과 근무기간이 겹칩니다." + "\n" + "학교 명: " + schoolName + "\n" + "회사 명: " + compName;
						return msg;
					}
				}
			}
			return "";
		}
		
		//*******************선택 요소에 input값이 존재 하는지 찾는 함수 ***********************	
		function existCareer(){	
	 	   var inputExist = false;
		    $j("[id^='careerTable']").each(function() {
		        var inputs = $j(this).find('input');
		        //console.log(inputs.serialize());
		        inputs.each(function(){
		        	if($j(this).prop('value') !== '' && $j(this).prop('value') !== 'on'){
		        		console.log("careerTable의 각 list의 value 값: " + $j(this).prop('value'));
		        		inputExist = true;
		        		return false;
		        	}
		        });	       
		    });
		    console.log("careerTable의 input값 존재 여부" + inputExist)
		    return inputExist;
		}
		
		function existCertificate(){		
			var inputExist = false;
			 $j("[id^='certificateTable']").each(function() {
		        var inputs = $j(this).find('input');
			        
		        inputs.each(function(){
		        	if($j(this).prop('value') !== '' && $j(this).prop('value') !== 'on'){
		  
		        		inputExist = true;
		        		return false;
		        	}
		        });			       
	    	});		  
		    return inputExist;
		}
//******************************저장 또는 제출*********************************		
		$j("#save").on("click", function(){
			var overlapMsg = "";
			console.log("save버튼 클릭");
			if(submit === "Y"){
				alert("제출처리된 이력서는 수정할 수 없습니다.");
				return
			}
		
			checkRecruit();
			if(isCheckedRecruit){
				console.log("checkEducation 작동");
				checkEducation();				
			}
			if(isCheckedEducation){
				console.log("필수 요소 전부 체크 완료!");
				isRequired = true;
			}
			console.log("exist검사 전 isRequired: " + isRequired);
			if(isRequired && existCareer()){
				checkCareer();
				overlapMsg = checkDateOverlap(education,career);
				if(!isCheckedCareer){
					isRequired = false;
				}			
			}
		
			if(isRequired && overlapMsg !== ""){
				isRequired = false;
				alert(overlapMsg);
			}
			
			if(isRequired && existCertificate()){
				console.log("existCertificate 검사 결과가 true인 경우");
				checkCertificate();
				if(!isCheckedCertificate){
					isRequired = false;
				}
			}
			console.log("exist검사 후 isRequired: " + isRequired);
			
			if(isRequired && submit === "N"){
				console.log("ajax조건 충족");
				var data = {
						recruitVo : recruit,
						educationList : education,
						careerList : career,
						certificateList : certificate,
				};                                                  
				console.log("최종 전송 데이터: " + JSON.stringify(data));
				
				$j.ajax({
				    url : "/recruit/updateSave.do",
				    dataType: "json",
				    contentType: "application/json",
				    type: "POST",
				    data : JSON.stringify(data),
				    success: function(data, textStatus, jqXHR)
				    {
				    	var result = data;
				    	var status = Object.keys(result)[0];
				    	var submitState = result[status];
				    	
						if(status === "0"){
							alert("저장 성공!");
							location.reload();
						}else{
							alert("저장 실패!");
						}
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("통신 오류 발생 ajax");
				    }
				});
			}
		});

		$j("#submit").on("click", function(){
			console.log("save버튼 클릭");
			if(submit === "Y"){
				alert("제출처리된 이력서는 수정할 수 없습니다.");
			}
		
			checkRecruit();
			if(isCheckedRecruit){
				console.log("checkEducation 작동");
				checkEducation();				
			}
			if(isCheckedEducation){
				console.log("필수 요소 전부 체크 완료!");
				isRequired = true;
			}
			if(existCareer()){
				checkCareer();
				if(!isCheckedCareer){
					isRequired = false;
				}			
			}
			if(existCertificate()){
				checkCertificate();
				if(!isCheckedCertificate){
					isRequired = false;
				}
			}
			
			if(isRequired && submit === "N"){
				var data = {
						recruitVo : recruit,
						educationList : education,
						careerList : career,
						certificateList : certificate
				};                                                  
				
				$j.ajax({
				    url : "/recruit/updateSubmit.do",
				    dataType: "json",
				    contentType: "application/json",
				    type: "POST",
				    data : JSON.stringify(data),
				    success: function(data, textStatus, jqXHR)
				    {
				    	var result = data;
				    	var status = Object.keys(result)[0];
				    	var submitState = result[status];
				    	
						if(status === "0"){
							alert("저장 성공!");
							location.reload();
						}else{
							alert("저장 실패!");
						}
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("통신 오류 발생 ajax");
				    }
				});
			}
		});
	});
</script>
<body>
	<c:if test="${savedRecruit.getSubmit() eq 'N' }">
	<h2 align="center">입사 지원서</h2>
	<table align="center">
		<tr>
			<td align="left">
				<span>
				상태 :
				<c:if test="${savedRecruit.getSubmit() eq 'N' }">SAVED</c:if>
				<c:if test="${savedRecruit.getSubmit() eq 'Y' }">SUBMITTED</c:if> 
				</span>
			</td>
			<td align="right">
				<a href = "/recruit/logout.do">로그아웃</a>
			</td>
		</tr>
		<tr>
			<td>
				<table id="recruitTable" border="1" align="center">
					<tr>
						<td>이름</td>
						<td>
							${name }
							<input type="hidden" value="${name }" name="name">
						</td>
						<td>생년월일</td>
						<td>
							<input type="text" name="birth" value="${savedRecruit.getBirth()}">
						</td>
					</tr>
					<tr>
						<td>성별</td>
						<td>
							<select name="gender">
								<option value="M">남자</option>
								<option value="W">여자</option>														
							</select>
						</td>
						<td>연락처</td>
						<td>
							${phone }
							<input type="hidden" value="${phone }" name="phone">
						</td>
					</tr>
					<tr>
						<td>email</td>
						<td>
							<input type="text" name="email" value="${savedRecruit.getEmail()}">
						</td>
						<td>주소</td>
						<td>
							<input type="text" name="addr" value="${savedRecruit.getAddr()}">
						</td>
					</tr>
					<tr>
						<td>희망근무지</td>
						<td>
							<select name="location">
								<option value="서울">서울</option>
								<option value="경기">경기</option>
								<option value="충청">충청</option>
								<option value="경상">경상</option>
								<option value="전라">전라</option>
								<option value="강원">강원</option>
								<option value="제주">제주</option>
							</select>
						</td>
						<td>근무형태</td>
						<td>
							<select name="workType">
								<option value="정규직">정규직</option>
								<option value="비정규직">비정규직</option>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
			<table class="profileTable" border="1" style="width : 100%">
				<tr>
					<td>학력사항</td>
					<td>경력사항</td>
					<td>희망연봉</td>
					<td>희망근무지/근무형태</td>
				</tr>
				<tr>
					<td id="academicYears">
						<c:choose>
						    <c:when test="${profile.getEducation().getAcademicYears() < 24}">
						        대학교
						    </c:when>
						    <c:when test="${profile.getEducation().getAcademicYears() >= 24 && profile.getEducation().getAcademicYears() < 48}">
						        대학교(2년제)
						    </c:when>
						    <c:otherwise>
						        대학교(4년제)
						    </c:otherwise>
						</c:choose>
			            ${profile.getEducation().getDivision()}
					</td>
					<td id="totalCareer"></td>
					<td id="salary">
						${profile.getSalary()}
					</td>
					<td id="locationType">
						${profile.getLocation()}<br/>
						${profile.getWorkType()}
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td><h2>학력</h2></td>
		</tr>

		<tr>
			<td align="right">
			<input type="button" id="educationAdd" value="추가">
			<input type="button" id="educationDel" value="삭제">
			</td>
		</tr>
		<tr>
			<td id="educationBox">			
				<table id="educationTable1" border="1" >
					<tr>
						<td><input type="hidden" name="eduSeq" value="${list.getEduSeq()}"></td>
						<td>재학기간</td>
						<td>구분</td>
						<td>학교명(소재지)</td>
						<td>전공</td>
						<td>학점</td>
					</tr>
					<c:forEach items="${savedEducation}" var="list" varStatus="loop">
					<tr id="educationInput${loop.index +1 }">
						<td><input name="selection" type="checkbox"></td>
						
						<td>
							<input type="text" name="startPeriod"  value="${list.getStartPeriod() }">
							<br>~<br>
							<input type="text" name="endPeriod" value="${list.getEndPeriod() }">
						</td>
						<td>
							<select name="division">
								<c:set var="divisions" value="재학,중퇴,졸업" />
								<c:set var="divisionArray" value="${fn:split(divisions, ',')}" />
								<c:forEach items="${divisionArray}" var="division">
								    <option value="${division}" ${division eq list.getDivision() ? 'selected' : ''}>${division}</option>
								</c:forEach>
							</select>
						</td>                    
						<td>
							<input type="text" name="schoolName" value="${list.getSchoolName() }"><br>
							<select name="location">
								<c:set var="locations" value="서울,경기,충청,경상,전라,강원,제주" />
								<c:set var="locationArray" value="${fn:split(locations, ',')}" />
							    <c:forEach items="${locationArray}" var="location">
								    <option value="${location}" ${location eq list.getLocation() ? 'selected' : ''}>${location}</option>
								</c:forEach>
							</select>
						
						</td>
						<td>
							<input type="text" name="major" value="${list.getMajor() }">
						</td>
						<td>
							<input type="text" name="grade" value="${list.getGrade() }">
						</td>
					</tr>
					</c:forEach>
					<tbody id="eduAppend"></tbody>	
				</table>		
			</td>
		</tr>
		<tr>
			<td><h2>경력</h2></td>
		</tr>
		
		<tr>
			<td align="right">
			<input type="button" id="careerAdd" value="추가">
			<input type="button" id="careerDel" value="삭제">
			</td>
		</tr>
		<tr>
			<td id="careerBox">
			<c:if test="${not empty savedCareer}">
				<table id="careerTable1" border="1" style="width : 100%">
					<tr>
						<td><input type="hidden" name="carSeq" value="${list.getCarSeq()}"></td>
						<td>근무기간</td>
						<td>회사명</td>
						<td>부서/직급/직책</td>
						<td>지역</td>
					</tr>
					<c:forEach items="${savedCareer}" var="list" varStatus="loop">
					<tr id="careerInput${loop.index +1 }">
						<td><input name="selection" type="checkbox"></td>
						<td>
							<input type="text" name="startPeriod" value="${list.getStartPeriod()}">
							<br>~<br>
							<input type="text" name="endPeriod" value="${list.getEndPeriod()}">
						</td>
						<td>
							<input type="text" name="compName" value="${list.getCompName()}">
						</td>
						<td>
							<input type="text" name="task" value="${list.getTask()}">
						</td>
						<td>
							<input type="text" name="location" value="${list.getLocation()}">
						</td>
					</tr>
					</c:forEach>
					<tbody id="carAppend"></tbody>
				</table>
			</c:if>
			<c:if test="${empty savedCareer}">
				<table id="careerTable1" border="1" style="width : 100%">
					<tr>
						<td></td>
						<td>근무기간</td>
						<td>회사명</td>
						<td>부서/직급/직책</td>
						<td>지역</td>
					</tr>
					<tr id="careerInput1">
						<td><input name="selection" type="checkbox"></td>
						<td>
							<input type="text" name="startPeriod">
							<br>~<br>
							<input type="text" name="endPeriod">
						</td>
						<td>
							<input type="text" name="compName">
						</td>
						<td>
							<input type="text" name="task">
						</td>
						<td>
							<input type="text" name="location">
						</td>
					</tr>
					<tbody id="carAppend"></tbody>
				</table>
			</c:if>
				
			</td>
		</tr>
		<tr>
			<td><h2>자격증</h2></td>
		</tr>
		
		<tr>
			<td align="right">
			<input type="button" id="certificateAdd" value="추가">
			<input type="button" id="certificateDel" value="삭제">
			</td>
		</tr>
		<tr>
			<td id="certificateBox">
			<c:if test="${not empty savedCertificate}">
				<table id="certificateTable1" border="1"  style="width : 100%">
					<tr>
						<td><input type="hidden" name="certSeq" value="${list.getCertSeq()}"></td>
						<td>자격증명</td>
						<td>취득일</td>
						<td>발행처</td>
					</tr>
					<c:forEach items="${savedCertificate}" var="list" varStatus="loop">
					<tr id="certificateInput${loop.index + 1 }">
						<td><input name="selection" type="checkbox" ></td>
						<td>
							<input type="text" name="qualifiName" value="${list.getQualifiName()}">
						</td>
						<td>
							<input type="text" name="acquDate" value="${list.getAcquDate()}">
						</td>
						<td>
							<input type="text" name="organizeName" value="${list.getOrganizeName() }">
						</td>
					</tr>
					</c:forEach>
					<tbody id="certAppend"></tbody>
				</table>
			</c:if>
			<c:if test="${empty savedCertificate}">
				<table id="certificateTable1" border="1"  style="width : 100%">
					<tr>
						<td></td>
						<td>자격증명</td>
						<td>취득일</td>
						<td>발행처</td>
					</tr>
					<tr id="certificateInput1">
						<td><input name="selection" type="checkbox"></td>
						<td>
							<input type="text" name="qualifiName">
						</td>
						<td>
							<input type="text" name="acquDate">
						</td>
						<td>
							<input type="text" name="organizeName">
						</td>
					</tr>
					<tbody id="certAppend"></tbody>
				</table>
			</c:if>			
			</td>
		</tr>
	</table>
	<br>
	<div align="center">
		<input id="save" type="button" value="저장">
		<input id="submit" type="button" value="제출">
	</div>
</c:if>




<c:if test="${savedRecruit.getSubmit() eq 'Y' }">
	<h2 align="center">입사 지원서</h2>
	<table align="center">
		<tr>
			<td align="left">
				<span>
				상태 :
				<c:if test="${savedRecruit.getSubmit() eq 'N' }">SAVED</c:if>
				<c:if test="${savedRecruit.getSubmit() eq 'Y' }">SUBMITTED</c:if> 
				</span>
			</td>
			<td align="right">
				<a href = "/recruit/logout.do">로그아웃</a>
			</td>
		</tr>
		<tr>
			<td>
				<table id="recruitTable" border="1" align="center">
					<tr>
						<td>이름</td>
						<td>
							${name }
							<input type="hidden" value="${name }" name="name">
						</td>
						<td>생년월일</td>
						<td>
							${savedRecruit.getBirth()}
						</td>
					</tr>
					<tr>
						<td>성별</td>
						<td>
							<c:choose>
							    <c:when test="${savedRecruit.getGender() eq 'M'}">
							        남자
							    </c:when>
							    <c:when test="${savedRecruit.getGender() eq 'W'}">
							        여자
							    </c:when>
							</c:choose>
						</td>
						<td>연락처</td>
						<td style="width: 180px">
							${phone }
							<input type="hidden" value="${phone }" name="phone">
						</td>
					</tr>
					<tr>
						<td>email</td>
						<td>
							${savedRecruit.getEmail()}
						</td>
						<td>주소</td>
						<td>
							${savedRecruit.getAddr()}
						</td>
					</tr>
					<tr>
						<td>희망근무지</td>
						<td style="width: 180px">
							${savedRecruit.getLocation()}
						</td>
						<td>근무형태</td>
						<td>
							${savedRecruit.getWorkType()}						
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
			<table class="profileTable" border="1" style="width : 100%">
				<tr>
					<td>학력사항</td>
					<td>경력사항</td>
					<td>희망연봉</td>
					<td>희망근무지/근무형태</td>
				</tr>
				<tr>
					<td id="academicYears">
						<c:choose>
						    <c:when test="${profile.getEducation().getAcademicYears() < 24}">
						        대학교
						    </c:when>
						    <c:when test="${profile.getEducation().getAcademicYears() >= 24 && profile.getEducation().getAcademicYears() < 48}">
						        대학교(2년제)
						    </c:when>
						    <c:otherwise>
						        대학교(4년제)
						    </c:otherwise>
						</c:choose>
			            ${profile.getEducation().getDivision()}
					</td>
					<td id="totalCareer"></td>
					<td id="salary">
						${profile.getSalary()}
					</td>
					<td id="locationType">
						${profile.getLocation()}<br/>
						${profile.getWorkType()}
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td><h2>학력</h2></td>
		</tr>

		<tr>
			<td id="educationBox">			
				<table id="educationTable1" border="1" >
					<tr>
						<td>재학기간</td>
						<td>구분</td>
						<td>학교명(소재지)</td>
						<td>전공</td>
						<td>학점</td>
					</tr>
					<c:forEach items="${savedEducation}" var="list" varStatus="loop">
					<tr id="educationInput${loop.index +1 }">
						<td style="width: 180px">
							${list.getStartPeriod() }
							~<br>
							${list.getEndPeriod() }
						</td>
						<td>
							${list.getDivision() }
						</td>                    
						<td style="width: 180px">
							${list.getSchoolName() } (${list.getLocation() })
						</td>
						<td style="width: 180px">
							${list.getMajor() }
						</td>
						<td style="width: 180px">
							${list.getGrade() }
						</td>
					</tr>
					</c:forEach>
					<tbody id="eduAppend"></tbody>	
				</table>		
			</td>
		</tr>
		<tr>
			<td><h2>경력</h2></td>
		</tr>
		
		<tr>
			<td id="careerBox">
			<c:if test="${not empty savedCareer}">
				<table id="careerTable1" border="1" style="width : 100%">
					<tr>
						<td>근무기간</td>
						<td>회사명</td>
						<td>부서/직급/직책</td>
						<td>지역</td>
					</tr>
					<c:forEach items="${savedCareer}" var="list" varStatus="loop">
					<tr id="careerInput${loop.index +1 }">
						<td style="width: 180px">
							${list.getStartPeriod()}
							~<br>
							${list.getEndPeriod()}
						</td>
						<td style="width: 180px">
							${list.getCompName()}
						</td>
						<td style="width: 220px">
							${list.getTask()}
						</td>
						<td>
							${list.getLocation()}
						</td>
					</tr>
					</c:forEach>
					<tbody id="carAppend"></tbody>
				</table>
			</c:if>
			<c:if test="${empty savedCareer}">
				<table id="careerTable1" border="1" style="width : 100%">
					<tr>
						<td>근무기간</td>
						<td>회사명</td>
						<td>부서/직급/직책</td>
						<td>지역</td>
					</tr>
					<tr id="careerInput1">
						<td style="width: 180px">
							&nbsp;
						</td>
						<td style="width: 180px">
							&nbsp;
						</td>
						<td style="width: 220px">
							&nbsp;
						</td>
						<td>
							&nbsp;
						</td>
					</tr>
					<tbody id="carAppend"></tbody>
				</table>
			</c:if>
				
			</td>
		</tr>
		<tr>
			<td><h2>자격증</h2></td>
		</tr>
		
		<tr>
			<td id="certificateBox">
			<c:if test="${not empty savedCertificate}">
				<table id="certificateTable1" border="1"  style="width : 100%">
					<tr>
						<td>자격증명</td>
						<td>취득일</td>
						<td>발행처</td>
					</tr>
					<c:forEach items="${savedCertificate}" var="list" varStatus="loop">
					<tr id="certificateInput${loop.index + 1 }">
						<td>
							${list.getQualifiName()}
						</td>
						<td>
							${list.getAcquDate()}
						</td>
						<td>
							${list.getOrganizeName() }
						</td>
					</tr>
					</c:forEach>
					<tbody id="certAppend"></tbody>
				</table>
			</c:if>
			<c:if test="${empty savedCertificate}">
				<table id="certificateTable1" border="1"  style="width : 100%">
					<tr>
						<td>자격증명</td>
						<td>취득일</td>
						<td>발행처</td>
					</tr>
					<tr id="certificateInput1">
						<td>
							&nbsp;
						</td>
						<td>
							&nbsp;
						</td>
						<td>
							&nbsp;
						</td>
					</tr>
					<tbody id="certAppend"></tbody>
				</table>
			</c:if>			
			</td>
		</tr>
	</table>
</c:if>
</body>
</html>
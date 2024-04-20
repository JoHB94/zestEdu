<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main</title>

</head>
<script type="text/javascript">
$j(document).ready(function(){
   var recruitData = {};
   var educationDataArray = [];
   var careerDataArray = [];
   var certificateDataArray = [];

   function collectRecruitData() {

      var recruitTable = $j('.recruit tbody');
      
      
      var recData = {
            name : recruitTable.find('input[name="name"]').val(),
            birth : recruitTable.find('input[name="birth"]').val(),
            gender : recruitTable.find('select[name="gender"]').val(),
            phone : recruitTable.find('input[name="phone"]').val(),
            email : recruitTable.find('input[name="email"]').val(),
            addr : recruitTable.find('input[name="addr"]').val(),
            location : recruitTable.find('select[name="location"]').val(),
            workType : recruitTable.find('select[name="workType"]').val(),
            submit : ""
      };
      
      recruitData = recData;
   }

   function collectEducationData() {
      
      var educationTable = $j('.education tbody');
      
       $j('.education tbody tr').each(function() {
           var eduData = {
               startPeriod: $j(this).find('input[name="startPeriod"]').val(),
               endPeriod: $j(this).find('input[name="endPeriod"]').val(),
               division: $j(this).find('select[name="division"]').val(),
               schoolName: $j(this).find('input[name="schoolName"]').val(),
               location: $j(this).find('select[name="location"]').val(),
               major: $j(this).find('input[name="major"]').val(),
               grade: $j(this).find('input[name="grade"]').val()
           };
           educationDataArray.push(eduData); // 행 데이터를 배열에 추가합니다.
       });
      
   }
   
   function collectCareerData() {
       // 경력 테이블의 데이터 수집하는 코드 작성
       $j('.career tbody tr').each(function() {
              var carData = {
                  startPeriod: $j(this).find('input[name="startPeriod"]').val(),
                  endPeriod: $j(this).find('input[name="endPeriod"]').val(),
                  compName: $j(this).find('input[name="compName"]').val(),
                  task: $j(this).find('input[name="task"]').val(),
                  location: $j(this).find('input[name="location"]').val() // 지역
              };
              
              /*
              // 3개의 입력값을 /로 구분하여 변수에 할당
              var values = $j(this).find('input[name="3value"]').val().split("/");
              carData.department = values[0];
              carData.position = values[1];
              carData.duty = values[2];
              */

              careerDataArray.push(carData); // 행 데이터를 배열에 추가합니다.
          });
      }
   
   function collectCertificateData() {
       // 자격증 테이블의 데이터 수집하는 코드 작성
       $j('.certificate tbody tr').each(function() {
           var colData = {
               qualifiName: $j(this).find('input[name="qualifiName"]').val(),
               acquDate: $j(this).find('input[name="acquDate"]').val(),
               organizeName: $j(this).find('input[name="organizeName"]').val()
           };
           certificateDataArray.push(colData);
       });
   }
   
   function addRow(type) {
      
      switch (type) {
           case 'education':
              console.log("학력 행추가")
              var clonedRow = $j('.education tbody').clone();
              clonedRow.find('input').val('');
              $j('.education').append(clonedRow);
               break;
           case 'career':
               // 경력 추가 로직
              console.log("경력 행추가");
              var clonedRow = $j('.career tbody').clone();
              clonedRow.find('input').val('');
              $j('.career').append(clonedRow);
               break;
           case 'certificate':
               // 자격증 추가 로직
              console.log("자격증 행추가");
              var clonedRow = $j('.certificate tbody').clone();
              clonedRow.find('input').val('');
              $j('.certificate').append(clonedRow);
               break;
           default:
            console.error('Unknown item type');
      }
   }
   
   function deleteRow(type) {
      
      var checkBoard = $j('input[type="checkbox"]:checked');
       // type 매개변수를 통해 어떤 유형의 항목을 삭제할 지 결정
       switch (type) {
           case 'education':
              console.log("학력 행삭제");
              checkBoard.each(function() {
                 $j(this).closest('tbody').remove();
             });
               break;
           case 'career':
               // 경력 추가 로직
              console.log("경력 행삭제");
              checkBoard.each(function() {
                 $j(this).closest('tbody').remove();
             });
               break;
           case 'certificate':
               // 자격증 추가 로직
              console.log("자격증 행삭제");
              checkBoard.each(function() {
                 $j(this).closest('tbody').remove();
             });
               break;
           default:
               console.error('Unknown item type');
       }
   }
   

// 제출


      
      $j("#submit").on("click",function(){
         // 기본 이벤트 못하게 막기
         // event.preventDefault();
         
         collectRecruitData();
         collectEducationData();
          collectCareerData();
          collectCertificateData();
          
          console.log("Recruit Data: ", recruitData);
          console.log("Education Data: ", educationDataArray);
          console.log("Career Data: ", careerDataArray);
          console.log("Certificate Data: ", certificateDataArray);
          
          var sendData = {
               recruitVo : recruitData,
               educationList : educationDataArray,
               careerList : careerDataArray,
               certificateList : certificateDataArray
          };
          
          console.log("sendData: " + JSON.stringify(sendData));
          
          $j.ajax({
             url : "/recruit/mainSubmit.do",
             contentType: "application/json",
             dataType: "json", 
             type: "POST",
             data : JSON.stringify(sendData),
             success: function(data, textStatus, jqXHR)
             {
               alert("작성완료");
               
               // location.href = "/board/boardList.do?";
             },
             error: function (jqXHR, textStatus, errorThrown)
             {
                 var errorMessage = "요청이 실패했습니다.\n";
                 errorMessage += "상태 코드: " + jqXHR.status + "\n";
                 errorMessage += "응답 텍스트: " + jqXHR.responseText + "\n";
                 errorMessage += "오류 유형: " + textStatus + "\n";
                 errorMessage += "에러: " + errorThrown;
                 alert(errorMessage);
             }
          });
          
      });
      

   });      
   
   

</script>
<body>
<form name="recruitMain" >
   <div align="center" class="div">입사 지원서</div>
   <table align="center"  id="borderTable">
      <tr>
         <td colspan="3">
            <table border="1" align="center" class="recruit">
            <tbody>
               <tr>
               <th>이름</th>
               <td><input value="${loginSession.name}" readonly name="name"></td>
               <th>생년월일</th>
               <td>
                  <input name="birth">
               </td>
               </tr>
               <tr>
               <th>성별</th>
               <td>
                  <select name="gender">
                     <option vlaue="남자">남자</option>
                     <option vlaue="여자">여자</option>
                  </select>
               </td>
               <th>연락처</th>
               <td><input value="${loginSession.phone}" readonly name="phone"></td>
               </tr>
               <tr>
               <th>email</th>
               <td>
                  <input type="email" name="email">
               </td>
               <th>주소</th>
               <td>
                  <input name="addr">
               </td>
               </tr>
               <tr>
               <th>희망근무지</th>
               <td>
                  <select name="location">
                        <option value='서울'>서울</option>
                        <option value='부산'>부산</option>
                        <option value='대구'>대구</option>
                        <option value='인천'>인천</option>
                        <option value='광주'>광주</option>
                        <option value='대전'>대전</option>
                        <option value='울산'>울산</option>
                        <option value='강원'>강원</option>
                        <option value='경기'>경기</option>
                        <option value='경남'>경남</option>
                        <option value='경북'>경북</option>
                        <option value='전남'>전남</option>
                        <option value='전북'>전북</option>
                        <option value='제주'>제주</option>
                        <option value='충남'>충남</option>
                        <option value='충북'>충북</option>
                  </select>
               </td>
               <th>근무형태</th>
               <td>
                  <select name="workType">
                     <option value="계약직">계약직</option>
                     <option value="정규직" selected>정규직</option>
                  </select>
               </td>
               </tr>
               </tbody>
            </table>
         </td>
      </tr>
      <tr>
         <td><div class="div">학력</div></td>
         <td></td>
         <td></td>
      </tr>
      <tr>
         <td colspan="3" >
         <div class="button-container">
            <button onclick="addRow('education')" type="button">추가</button>
            <button onclick="deleteRow('education')" type="button">삭제</button>
            </div>
         </td>
      </tr>
      <tr>
         <td></td>
         <td>
            <table border="1" class="education">
               <thead>
               <tr>
                  <th class="ckb"></th>
                  <th class="tCell">재학기간</th>
                  <th class="tCell">구분</th>
                  <th class="tCell">학교명(소재지)</th>
                  <th class="tCell">전공</th>
                  <th class="tCell">학점</th>
               </tr>
               </thead>
               <tbody>
               <tr>
                  <td><input type="checkbox"></td>
                  <td>
                      <input name="startPeriod"><br>
                      ~<br>
                      <input name="endPeriod">
                  </td>
                  <td>
                     <select name="division">
                        <option value="재학">재학</option>
                        <option value="중퇴">중퇴</option>
                        <option value="졸업">졸업</option>
                     </select>
                  </td>
                  <td>
                     <input name="schoolName"><br>
                     <select name="location">
                           <option value='서울'>서울</option>
                           <option value='부산'>부산</option>
                           <option value='대구'>대구</option>
                           <option value='인천'>인천</option>
                           <option value='광주'>광주</option>
                           <option value='대전'>대전</option>
                           <option value='울산'>울산</option>
                           <option value='강원'>강원</option>
                           <option value='경기'>경기</option>
                           <option value='경남'>경남</option>
                           <option value='경북'>경북</option>
                           <option value='전남'>전남</option>
                           <option value='전북'>전북</option>
                           <option value='제주'>제주</option>
                           <option value='충남'>충남</option>
                           <option value='충북'>충북</option>
                     </select>
                  </td>
                  <td>
                     <input name="major">
                  </td>
                  <td>
                     <input name="grade">   
                  </td>
               </tr>
               </tbody>
            </table>
         </td>
         <td width="50px"></td>
      </tr>
      <tr>
         <td><div class="div">경력</div></td>
         <td></td>
         <td></td>
      </tr>
      <tr>
         <td colspan="3">
            <div class="button-container">
               <button onclick="addRow('career')" type="button">추가</button>
               <button onclick="deleteRow('career')" type="button">삭제</button>
            </div>
         </td>
      </tr>
      <tr>

         <td></td>
         <td>
            <table border="1" class="career">
               <thead>
               <tr>
                  <th class="ckb"></th>
                  <th class="tCell">근무기간</th>
                  <th class="tCell">회사명</th>
                  <th class="tCell">부서/직급/직책</th>
                  <th class="tCell">지역</th>
               </tr>
               </thead>
               <tbody>
               <tr>
                  <td><input type="checkbox"></td>
                  <td>
                      <input name="startPeriod"> ~<br>
                      <input name="endPeriod">
                  </td>
                  <td>
                     <input name="compName">
                  <td>
                     <input name="task">
                  </td>
                  <td>
                     <input name="location">   
                  </td>
               </tr>
               </tbody>
            </table>
         </td>
         <td></td>
      </tr>
      </tbody>
      <tbody>
      <tr>
         <td><div class="div">자격증</div></td>
         <td></td>
         <td></td>
      </tr>
      <tr>
         <td colspan="3">
            <div class="button-container">
               <button onclick="addRow('certificate')" type="button">추가</button>
               <button onclick="deleteRow('certificate')" type="button">삭제</button>
            </div>
         </td>
      </tr>
      <tr>

         <td></td>
         <td>
            <table border="1" class="certificate">
               <thead>
               <tr>
                  <th class="ckb"></th>
                  <th class="tCell">자격증명</th>
                  <th class="tCell">취득일</th>
                  <th class="tCell">발행처</th>
               </tr>
               </thead>
               <tbody>
               <tr>
                  <td><input type="checkbox"></td>
                  <td>
                      <input name="qualifiName">
                  </td>
                  <td>
                     <input name="acquDate">
                  </td>
                  <td>
                     <input name="organizeName">   
                  </td>
               </tr>
               </tbody>
            </table>
         </td>
         <td></td>
      </tr>
      </tbody>
   </table>
   <div align="center">
      <button onclick="save()">저장</button>
      <input id="submit" type="button" value="제출">
   </div>
</form>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>MBTI test</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
		var testResult = [];
		var pageNo = ${pageNo};

		function updatePage(data) {
			$j("#testTable").html(buildTable(data.questionList));
		}
		
		function buildTable(questionList){
			var tableHTML = '';
			$j.each(questionList, function(index,item){
				tableHTML += "<tr>";
                tableHTML += "<td align='center'>" + item.boardComment + "</td>";
                tableHTML += "</tr>";
                tableHTML += "<tr>";
                tableHTML += "<td class='radioGroup' align='center'>동의 ";
                for (var i = 1; i <= 7; i++) {
                    tableHTML += "<input type='radio' data-info='" + item.boardType + "' name='group_" + index + "' value='" + i + "'> ";
                }
                tableHTML += " 비동의</td>";
                tableHTML += "<tr><td><br><br></td></tr>";
			});
			return tableHTML;
		}
		
		
		//검사 완료 후 검사 결과 제출.
		$j(document).on("click","#result",function(){
			console.log("result 버튼 클릭: " + testResult);
			
			var param = JSON.stringify(testResult);
			
			if(testResult.length === 0){
				alert("한 문항도 입력하지 않으셨습니다.");
				
			}else{
				console.log(param);
				$j.ajax({
					url : "/board/mbtiResultAction.do",
					contentType: "application/json",
					type: "POST",
					data: param,
					success: function(data, textStatus, jqXHR)
					{	
						
						var testedMbti = data.testedMbti;
						console.log("testedMbti " + testedMbti);
						window.location.href = "/board/mbtiResult.do?testedMbti=" + testedMbti;
						
					},
					error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("실패");
				    }
				});
			}
		});
		
		$j("#next").on("click",function(){
			//pageNo 관련
			
			console.log("pageNo: " + pageNo);
			var currentResponse = $j("input[name^='group_']:checked").length;
			console.log("param: " + param);
			//결과값 임시 저장
			$j("input[name^='group_']:checked").each(function() {
			  
			    var question = {
						type : $j(this).data("info"),
						value : $j(this).val()
						}
			    console.log(question);
				testResult.push(question);
			});
			                   
			
			if(currentResponse === 5){
				if(pageNo < 4){
					pageNo ++;
				}
				
				var object = {pageNo : pageNo};
				var param = $j.param(object,true);
				
				$j.ajax({
					url : "/board/mbtiListNext.do",
					dataType: "json",
					type: "GET",
					data: param,
					success: function(data, textStatus, jqXHR)
					{	
						updatePage(data);
						console.log(data);
						if(pageNo == 4){
							 $j("#next").attr("value", "결과보기");
		                     $j("#next").attr("id", "result");
						}
					},
					error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("실패");
				    }
				});		
			}else{
				alert("모든 문항에 응답해 주세요");
			}
		});
	})
</script>
<body>
<form>
	<table align="center">
		<tr>
			<td align="center">
			<br>
			<h1>성격 유형  검사</h1>
			<br>
			<hr/>
			</td>
		</tr>
		<tr>
			<td>
				<table id="testTable">
					<c:forEach items="${questionList}" var="list" varStatus="loop">
					<tr>
						<td align = "center">
						${list.boardComment}
						<input name="boardType" type="hidden" value="${list.boardType}">
						</td>
					</tr>
					<tr>
						<td class="radioGroup" align = "center">
						동의
						<c:forEach var="i" begin="1" end="7">
		                    <input type="radio" data-info="${list.boardType}" name="group_${loop.index}" value="${i}">
		                </c:forEach>
						비동의
						</td>
					</tr>
					<tr>
					<td><br><br></td>
					<tr/>
					</c:forEach>
				</table>		
			</td>
		</tr>
		<tr>
			<td align="center">
			<input id="next" type="button" value="다음">
			</td>
		</tr>
	</table>
</form>
</body>
</html>
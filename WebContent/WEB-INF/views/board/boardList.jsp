<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>list</title>
</head>
<script type="text/javascript">

	function updatePage(data) {
		$j("#boardTable").html(buildTable(data.boardList));
		$j("#totalCnt").html("total : " + data.totalCnt);
	}
	
	function buildTable(boardList){
		var tableHTML = "<tr><td width='80' align='center'>Type</td><td width='40' align='center'>No</td><td width='300' align='center'>Title</td></tr>";
		$j.each(boardList, function(index,item){
			tableHTML += "<tr>";
			tableHTML += "<td align='center'>" + item.codeName + "</td>";
	        tableHTML += "<td>" + item.boardNum + "</td>";
	        tableHTML += "<td><a href='/board/" + item.boardType + "/" + item.boardNum + "/" + item.pageNo + "/boardView.do'>" + item.boardTitle + "</a></td>";
	        tableHTML += "</tr>";
		});
		return tableHTML;
	}
	
	
	$j(document).ready(function(){
			
		var boardTypes =[];
		var menuSize = ${fn:length(code)};
		var userName = "${sessionScope.userName}";
		
		//단일박스를 클릭하는 경우	
		$j(".selectGroup").on("click",function(){
			boardTypes = [];
			
			$j(".selectGroup:checked").each(function(){
				boardTypes.push($j(this).val());
			});
			//전체 체크 후 단일박스를 클릭하는 경우
			if(!$j(this).prop("checked")){
				$j("#selectAll").prop("checked",false);
			}
			//모든 단일박스가 클릭된 경우
			if (boardTypes.length === menuSize){
				console.log(menuSize);
				$j("#selectAll").prop("checked", true);
			}
		});
		
		//전체박스를 클릭하는 경우
		$j("#selectAll").on("click",function(){
			$j(".selectGroup").prop("checked",$j(this).prop("checked"));
			$j(".selectGroup:checked").each(function(){
				boardTypes.push($j(this).val());
			});
		});
		
		//submit
		$j("#submit").on("click",function(){
			var param = '';
			if(boardTypes.length === 0){
				param = 'boardTypes=1&boardTypes=2&boardTypes=3&boardTypes=4';
				
			}else {
				param = $j.param({ boardTypes: boardTypes},true);
				console.log("param" + param);
			}
			$j.ajax({
				url : "/board/boardListByBoardType.do",
				dataType: "json",
				type: "GET",
				data: param,
				success: function(data, textStatus, jqXHR)
				{	
					updatePage(data);
					console.log(data);
				},
				error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("실패");
			    }
			});
			
		});
		
			
	});

</script>
<body>
<form >

<table  align="center">
	<tr>
		<td align="left">
			<c:if test="${empty userName}">
			<a href="/board/login.do">login</a>
			<a href="/board/userJoin.do">join</a>
			</c:if>
			${sessionScope.userName}
		</td>
		<td id="totalCnt" align="right">
			total : ${totalCnt}
		</td>
	</tr>
	<tr>
		<td>
			<table id="boardTable" border = "1">
				<tr>
					<td width="80" align="center">
						Type
					</td>
					<td width="40" align="center">
						No
					</td>
					<td width="300" align="center">
						Title
					</td>
				</tr>
				<c:forEach items="${boardList}" var="list">
					<tr>
						<td align="center">
							${list.codeName}
						</td>
						<td>
							${list.boardNum}
						</td>
						<td>
							<a href = "/board/${list.boardType}/${list.boardNum}/${pageNo}/boardView.do">${list.boardTitle}</a>
						</td>
					</tr>	
				</c:forEach>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">
			<a href ="/board/boardWrite.do">글쓰기</a>
			<c:if test="${not empty userName}">
				<a href="/board/logout.do">로그아웃</a>
			</c:if>
		</td>
	</tr>
	<tr>
		<td>
		<input type="checkbox" id="selectAll" name="boardType">전체
		<c:forEach var="item" items="${code}">
			<input class="selectGroup" type="checkbox" name="boardType" value="${item.codeId}">${item.codeName}
		</c:forEach>
		<input id="submit" type="button" name="search" value="조회">
		</td>
	</tr>
</table>	
</form>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset ="UTF-8">
<title>list</title>
<style type="text/css">
	.current {
  		background-color: highlight;
  		color: white; 
	}
</style>
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
		
		var pageCnt = 5;
		var menuSize = ${fn:length(code)};
		var boardTypes =['a01','a02','a03','a04'];
		var currentPage = ${currentPage};
		var showPage = ${showPage};
		var endPage = ${endPage};
		console.log("페이지 로드시 boardTypes: " + boardTypes);
		console.log("페이지 로드시 currentPage: " + currentPage);
		console.log("페이지 로드시 endPage: " + endPage);
		var userName = "${sessionScope.userName}";
		
		function buildPage(currentPage,showPage,endPage){
			$j("#pageDiv").empty();
			var pageHTML = "";
			if(currentPage !== 1){
				pageHTML += "<input type='button' id='preBtn' value='&lt;'>";				
			}
			
			for(var i = currentPage; i < (currentPage + showPage); i ++){
				if(i > endPage){
					break;
				}				
	            pageHTML += "<input type='button' id='btn"+i+"' value='"+i+"'>";
			}			
			if((currentPage + showPage) <= endPage){
				pageHTML += "<input type='button' id='nextBtn' value='&gt;'>";				
			}			
			$j("#pageDiv").html(pageHTML);
		}
		
		buildPage(currentPage,showPage,endPage);
		$j("#btn"+currentPage ).addClass('current');
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
				param = 'boardTypes=a01&boardTypes=a02&boardTypes=a03&boardTypes=a04';
				
			}else {
				param = $j.param({ boardTypes: boardTypes , pageNo : 1},true);
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
					console.log("ajax success 후 boardTypes: " + boardTypes);
					currentPage = data.currentPage;
					showPage = data.showPage;
					endPage = data.endPage;
					buildPage(currentPage,showPage,endPage);
					
					$j("#btn"+currentPage ).addClass('current');
					
					console.log("showPage: " + showPage);
					console.log("currentPage: " + currentPage);
					console.log("endPage: " + endPage);
				},
				error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("실패");
			    }
			});
			
		});
		$j(document).on("click","#nextBtn", function(){
			var pageNo = parseInt($j("#pageDiv").find('input[id^="btn"]:first').val()) +5 ;
			console.log("nextPage: " + pageNo);
			param = $j.param({ boardTypes: boardTypes , pageNo : pageNo},true);
			
			$j.ajax({
				url : "/board/boardListByBoardType.do",
				dataType: "json",
				type: "GET",
				data: param,
				success: function(data, textStatus, jqXHR)
				{	
					
					updatePage(data);
					console.log("ajax success 후 boardTypes: " + boardTypes);
					showPage = data.showPage;
					endPage = data.endPage;
					currentPage = data.currentPage;
					buildPage(pageNo,showPage,endPage);
					
					$j("#btn"+currentPage ).addClass('current');
					
					console.log("showPage: " + showPage);
					console.log("currentPage: " + currentPage);
					console.log("endPage: " + endPage);

				},
				error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("실패");
			    }
			});
		});
		
		$j(document).on("click","#preBtn", function(){
			var pageNo = parseInt($j("#pageDiv").find('input[id^="btn"]:first').val()) -5 ;
			console.log("nextPage: " + pageNo);
			param = $j.param({ boardTypes: boardTypes , pageNo : pageNo},true);
			
			$j.ajax({
				url : "/board/boardListByBoardType.do",
				dataType: "json",
				type: "GET",
				data: param,
				success: function(data, textStatus, jqXHR)
				{	
					
					updatePage(data);
					console.log("ajax success 후 boardTypes: " + boardTypes);
					showPage = data.showPage;
					endPage = data.endPage;
					currentPage = data.currentPage;
					buildPage(pageNo,showPage,endPage);
					
					$j("#btn"+currentPage ).addClass('current');
					
					console.log("showPage: " + showPage);
					console.log("currentPage: " + currentPage);
					console.log("endPage: " + endPage);

				},
				error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("실패");
			    }
			});
		});
		
		$j(document).on("click","[id^='btn']" ,function(){
			console.log("페이지버튼 눌렀을 때 boardTypes: " + boardTypes);
			var pageNo = $j(this).val();
			$j("[id^='btn']").removeClass('current');
			$j(this).addClass('current');
			console.log("pageNo: " + pageNo);
			param = $j.param({ boardTypes: boardTypes , pageNo : pageNo},true);
			
			$j.ajax({
				url : "/board/boardListByBoardType.do",
				dataType: "json",
				type: "GET",
				data: param,
				success: function(data, textStatus, jqXHR)
				{	
					
					updatePage(data);
					console.log("ajax success 후 boardTypes: " + boardTypes);
					currentPage = data.currentPage;
					showPage = data.showPage;
					/*buildPage(pageNo,showPage);
					console.log("data.currentPage: " + data.currentPage);
					console.log("currentPage: " + currentPage);*/

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
	<tr>
		<td>
			<div id="pageDiv" align="center">
			
			</div>
		</td>
	</tr>
</table>	
</form>
</body>
</html>
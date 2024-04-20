<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardView</title>
</head>
<script type="text/javascript">
	$j(document).ready(function(){
		
		$j("#boardUpdate").on("click",function(){
			var userName= '${sessionScope.userName}';
			var creator	= '${board.creator}'; 
			if(userName === '' ){
				var res = confirm("로그인이 필요합니다. \n로그인 페이지로 이동하시겠습니까?");
				if(res){
					window.location.href = "/board/login.do";
				}else{
					return;
				}
			}else if(userName !== creator){
				alert("작성자만 수정할 수 있습니다.");
				return;
			}else {
				window.location.href = "/board/${boardType}/${boardNum}/boardUpdate.do";				
			}
		});
		
		
		$j("#boardDelete").on("click",function(){
			
			var userName= '${sessionScope.userName}';
			var creator	= '${board.creator}'; 
			if(userName === '' ){
				var res = confirm("로그인이 필요합니다. \n로그인 페이지로 이동하시겠습니까?");
				if(res){
					window.location.href = "/board/login.do";
				}else{
					return;
				}
			}else if(userName !== creator){
				alert("작성자만 삭제할 수 있습니다.");
				return;
			}else {
				var $frm = $j('.boardDelete :input');
				var param = $frm.serialize();
				
				console.log("param : " + param);
				//serialize():쿼리스트링으로 만들어줌
				$j.ajax({
				    url : "/board/boardDelete.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						alert("삭제완료");
						
						alert("메세지:"+data.success);
						
						location.href = "/board/boardList.do";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("실패");
				    }
				});									
			}
			
		});
	});
</script>
<body>
<form class="boardDelete">
<table align="center">
	<tr>
		<td>
			<table border ="1">
				<tr>
					<td width="120" align="center">
					Title
					</td>
					<td width="400">
					${board.boardTitle}
					</td>
				</tr>
				<tr>
					<td height="300" align="center">
					Comment
					</td>
					<td>
					${board.boardComment}
					</td>
				</tr>
				<tr>
					<td align="center">
					Writer
					</td>
					<td>
					${board.creator}
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">
			<input name="boardType" type="hidden" value="${boardType}">
			<input name="boardNum" type="hidden" value="${boardNum}">
			<input id="boardDelete" type="button" value="Delete">
			
			<input id="boardUpdate" type="button" value="Update" ></input>
			
			<a href="/board/boardList.do?pageNo=${pageNo}">List</a>
		</td>
		
	</tr>
</table>
</form>	
</body>
</html>
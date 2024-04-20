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
				var res = confirm("�α����� �ʿ��մϴ�. \n�α��� �������� �̵��Ͻðڽ��ϱ�?");
				if(res){
					window.location.href = "/board/login.do";
				}else{
					return;
				}
			}else if(userName !== creator){
				alert("�ۼ��ڸ� ������ �� �ֽ��ϴ�.");
				return;
			}else {
				window.location.href = "/board/${boardType}/${boardNum}/boardUpdate.do";				
			}
		});
		
		
		$j("#boardDelete").on("click",function(){
			
			var userName= '${sessionScope.userName}';
			var creator	= '${board.creator}'; 
			if(userName === '' ){
				var res = confirm("�α����� �ʿ��մϴ�. \n�α��� �������� �̵��Ͻðڽ��ϱ�?");
				if(res){
					window.location.href = "/board/login.do";
				}else{
					return;
				}
			}else if(userName !== creator){
				alert("�ۼ��ڸ� ������ �� �ֽ��ϴ�.");
				return;
			}else {
				var $frm = $j('.boardDelete :input');
				var param = $frm.serialize();
				
				console.log("param : " + param);
				//serialize():������Ʈ������ �������
				$j.ajax({
				    url : "/board/boardDelete.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						alert("�����Ϸ�");
						
						alert("�޼���:"+data.success);
						
						location.href = "/board/boardList.do";
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	alert("����");
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
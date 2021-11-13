<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#contents{
	height:100%;
	width:100%;
}
.body{height: 50%;}
.footer{text-align: right}
input{width:100%}
.list a{
	color: black;
}
.title{
	overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
}
.delBtn{
	margin-top: 10px;
}
input[type=checkbox]{
	width: 15px;
}
.item{
	background-color : #6749b930;
}
.listItem:hover {
    background-color: whitesmoke;
}
</style>
</head>
<body>
   <div class="wrapper d-flex align-items-stretch">
      <%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>   <!-- Page Content  -->
      <div id="content" class="p-4 p-md-5 pt-5" style="min-width: 450px;">
      	<h2 class="mb-4">내게 쓴 메일함</h2>
      	<div class="listContainer">
      		<div class="row item p-3">
      			<div class="col-1"><b><input type=checkbox id="all" value=0></b></div>
      			<div class="col-1 text-center"><b>seq</b></div>
      			<div class="col-7 text-center"><b>제목</b></div>
      			<div class="col-3 text-center"><b>날짜</b></div>
      		</div>
      		<div class="list">
	      		<c:forEach var="list" items="${emailList }">
	      			<div class="row listItem p-3" style="border-bottom: 1px solid #c9c9c9">
      					<div class="col-1"><input type=checkbox name=delBox value="${list.seq }"></div>
      					<div class="col-1 text-center">${list.rownumber }</div>
		      			<div class="col-7 title"><a href="/email/readPage.email?seq=${list.seq }"><c:out value="${list.title }"></c:out></a></div>
		      			<div class="col-3 text-center">${list.write_date }</div>
		      		</div>
	      		</c:forEach>
      		</div>
    		<div class="row">
      			<div class="col text-right">
    				<button type=button class="delBtn btn btn-primary">삭제</button>
      			</div>
      		</div>
      		<script> 
      			$(".delBtn").click(function(){
      				var checkedList = "";
      				var count = 0;
      				$("input[type='checkbox']:checked").each(function(index){
      					if($(this).val() != 0){
      						count = count+1;
	      					checkedList += $(this).val() + ",";
	      				}
	      				
      				});
      				
      				if(count == 0){
      					alert("선택된 메일이 없습니다.");
      					return false;
      				}
      				
      				var msg = "총 " + count + "개의 메일을 삭제하시겠습니까?";
      				var confirmResult = confirm(msg);
      				
      				if(confirmResult){
      					location.href="/email/deleteToMeChecked.email?checkedList="+checkedList;
      				}else{
      					return false;
      				}
      			})
      			$("#all").click(function(){
      				if($("input:checkbox[id=all]").prop("checked")){
      					$("input[type=checkbox]").prop("checked", true);
      				}else{
      					$("input[type=checkbox]").prop("checked", false);
      				}
      			});
      		</script>
      	</div>
      	<div class="navi text-center">${navi }</div>
      </div>
   </div>
<script src="/js/bootstrap.min.js"></script>
</body>
</html>
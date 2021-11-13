<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style type="text/css">
		div{
			font-size: 16px;
		}
		select {
			min-width: 90px;
		}
		.textBox{
			overflow:hidden;
			text-overflow:ellipsis;
			white-space:nowrap;
		}
		.item{
			background-color : #6749b930;
		}
		.listItem:hover {
		    background-color: whitesmoke;
		}
		.row{
			margin-bottom: 10px;
		}
	</style>
</head>
<body>
<div class="wrapper d-flex align-items-stretch">
	<%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>
	<!-- Page Content  -->
	<div id="content" class="p-4 p-md-5 pt-5">
		<h2 class="mb-4">승인된 문서</h2>
		<hr>
		<form action="/document/d_searchApproval.document" method="get">
			<div class="search pb-2">
				<div class="row">
					<div class="col-2 col-md-2">저장일</div>
					<div class="col-9">
						<input type=date class="date ml-1 mr-1" name=startDate value=${startDate } max=${today }>
						~
						<input type=date class="date ml-1 mr-1" name=endDate value=${endDate } max=${today }>
					</div>

				</div>
				<div class="row">
					<div class="col-2 mb-2">기안양식</div>
					<div class="col-3 pl-3">
						<select class="selectTemplate" name=template id="templateSelect">
							<option value=0>전체</option>
							<c:forEach var="list" items="${tempList}" begin="3">
								<option value=${list.code }>${list.name }</option>
							</c:forEach>
						</select>
					</div>
					<div class="selectSearch col-2 mb-3">
						<select name=searchOption id="searchOption">
							<option value=title selected>제목</option>
						</select>
					</div>
					<script>
						$('#templateSelect').val("${template}").prop("selected",true);
					</script>
					<div class="col-3 col-sm-2 mb-3 pl-3">
						<input type=text name=searchText value=${searchText }>
					</div>
				</div>
				<div class="row">
					<div class="col-12 text-center">
						<input type=submit class="btn btn-primary" value=조회 >
					</div>
				</div>
			</div>
		</form>
		<hr>
		<div class="documentList row text-center item p-2">
			<div class="col-2"><b>문서번호</b></div>
			<div class="col-2 d-none d-sm-block"><b>양식</b></div>
			<div class="col-4"><b>제목</b></div>
			<div class="col-3 col-sm-2"><b>상신일</b></div>
			<div class="col-3 col-sm-2"><b>완료일</b></div>
		</div>

		<!-- 리스트 출력 부분 -->
		<c:forEach var="list" items="${list}">
			<div class="row text-center listItem p-2">
				<div class="col-2 textBox">${list.seq }</div>
				<div class="col-2 d-none d-sm-block textBox">${list.temp_name }</div>
				<div class="col-4 textBox text-left pl-4"><a href="/document/toReadPage.document?seq=${list.seq }">${list.title }</a></div>
				<div class="col-3 col-sm-2 textBox">${list.write_date }</div>
				<div class="col-3 col-sm-2 textBox">${list.final_date }</div>
			</div>
		</c:forEach>
		<!-- 리스트 출력 부분 -->

		<div class="row">
			<div class="navi col-12 text-center">${navi}</div>
		</div>
	</div>
</div>
<script src="/js/bootstrap.min.js"></script>
</body>
</html>
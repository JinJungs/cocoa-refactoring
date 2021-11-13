
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Request Log Read Page</title>
<link rel="stylesheet" href="/css/noBoard.css" type="text/css"
	media="screen" />
<style>
.contents_box{border: 1px solid lightgray;}
.left,.right{margin:10px;}
.fix>textarea{height:200px;}
.btn,.title{text-align:center;}
#btn_reject,#btn_confirm{width:30%}
</style>
</head>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<body>
	<div class="wrapper d-flex align-items-stretch">
		<%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>
   	<script src="/js/bootstrap.min.js"></script>
		<!-- Page Content  -->
		<div id="content" class="p-4 p-md-5 pt-5">
			<h2 class="mb-4 board_title">확인요청 업무일지</h2>


			<form  method="post" id="submitForm">
			
			<input type="hidden" id="status" name="status" value="${status }">
			<input type="hidden" id="seq" name="seq" value="${seq }">
			
			<div class="row main">
				<div class="col left">

					<div class="row">
						<div class="col-4 head_box">제목</div>
						<div class="col-8">${lr.title}</div>
					</div>

					<div class="row">
						<div class="col-4 head_box">업무일정 :</div>
						<div class="col-8">${lr.report_start}</div>
					</div>

					<div class="row">
						<div class="col-4 head_box">작성날짜 :</div>
						<div class="col-8">${lr.write_date}</div>
					</div>
					<div class="row">
						<div class="col-4 head_box">작성자 :</div>
						<div class="col-8">${lr.name}</div>
					</div>
					<div class="row">
						<div class="col-4 head_box">확인자 :</div>
						<div class="col-8">${writer_name}</div>
					</div>
					<div class="row">
						<div class="col head_box">Comment</div>
					</div>

					<div class="row">
						<div class="col fix">
							<textarea id="report_contents" name="report_contents"></textarea>
						</div>
					</div>

					<div class="row">
						<div class="col btn">
						<input type="submit" id="btn_confirm" class="btn btn-primary" value="승인" formaction="/log/logReqCheck2.log"> 
						<input type="submit" id="btn_reject" class="btn btn-primary" value="거절" formaction="/log/logReqCheck.log">
						</div>
					</div>
				</div>

				<div class="col right">
					<div class="row head_box">내용</div>
					<div class="row contents_box">${lr.contents}</div>
					<div class="row">
						<div class="col head_box">
							<b><span class="files" id="files">첨부파일 : ${fileCount}개</span></b>
							<ul>
								<c:forEach var="i" items="${fileList}">
									<li class="fileLi"><a
										href="/files/downloadNotificationBoardFiles.files?seq=${i.seq}&savedname=${i.savedname}&oriname=${i.oriname}">${i.oriname}</a>
									</li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</div>
			</div>
			</form>
		</div>
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Log Sent Board</title>
<link rel="stylesheet" href="/css/noBoard.css" type="text/css"
	media="screen" />
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
</head>
<body>
	<div class="wrapper d-flex align-items-stretch">
		<%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>
   	<script src="/js/bootstrap.min.js"></script>
		<div id="content" class="p-4 p-md-5 pt-5">
			<h2 class="mb-4 board_title">보낸 업무일지 보관함</h2>

			<input type="hidden" id="status" name="status" value="${status }">
			<ul class="nav nav-tabs">
				<li class="nav-item"><a class="nav-link active"
					data-toggle="tab" href="#all">전체</a></li>
				<li class="nav-item"><a class="nav-link" data-toggle="tab"
					href="#daily">일일</a></li>
				<li class="nav-item"><a class="nav-link" data-toggle="tab"
					href="#weekly">주간</a></li>
				<li class="nav-item"><a class="nav-link" data-toggle="tab"
					href="#monthly">월별</a></li>
			</ul>
			<!-- 공용 head -->
			<div class="row head_box" style="border-bottom: 1px solid lightgray;">
				<div class="col-md-1 d-none d-md-block">
					<b>#</b>
				</div>
				<div class="col-sm-12 col-md-7">
					<b>제목</b>
				</div>
				<div class="col-md-1 d-none d-md-block">
					<b>작성자</b>
				</div>
				<div class="col-md-1 d-none d-md-block">
					<b>업무기한</b>
				</div>
				<div class="col-md-1 d-none d-md-block">
					<b>작성일</b>
				</div>
				<div class="col-md-1 d-none d-md-block">
					<b>상태</b>
				</div>
			</div>
			<!-- 리스트 보이기 -->
			<div class="tab-content">
				<!-- 전체 -->
				<div class="tab-pane fade show active" id="all">
					<div class="row tab-content current" id="tab-1"
						style="border-bottom: 1px solid lightgray;">
						<c:choose>
							<c:when test="${empty logAllList}">
								<div class="row" id="notice" style="border: transparent;">
									<div class="col">작성된 글이 없습니다.</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${logAllList}">
									<div class="on col-md-1 d-none d-md-block">${i.seq}</div>
									<div class="on col-sm-12 col-md-7">
										<a href="/log/logRead.log?seq=${i.seq}&status=${i.status}">${i.title }</a>
									</div>
									<div class="on col-md-1 d-none d-md-block">${i.name}</div>
									<div class="on col-md-1 d-none d-md-block">${i.report_start}</div>
									<div class="on col-md-1 d-none d-md-block">${i.write_date}</div>
									<!-- 상태 이미지 -->
									<c:choose>
										<c:when test="${i.status eq 'CONFIRM'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/승인4.jfif"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'RAISE'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/대기10.png"
													style="height: 20px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'REJECT'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/거절4.png"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<!-- 일일 -->
				<div class="tab-pane fade" id="daily">
					<div class="row tab-content" id="tab-2"
						style="border-bottom: 1px solid lightgray;">
						<c:choose>
							<c:when test="${empty dailyList}">
								<div class="row" id="notice" style="border: transparent;">
									<div class="col">작성된 글이 없습니다.</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${dailyList}">
									<div class="on col-md-1 d-none d-md-block">${i.seq}</div>
									<div class="on col-sm-12 col-md-7">
										<a href="/log/logRead.log?seq=${i.seq}&status=${i.status}">${i.title }</a>
									</div>
									<div class="on col-md-1 d-none d-md-block">${i.name}</div>
									<div class="on col-md-1 d-none d-md-block">${i.report_start}</div>
									<div class="on col-md-1 d-none d-md-block">${i.write_date}</div>
									<!-- 상태 이미지 -->
									<c:choose>
										<c:when test="${i.status eq 'CONFIRM'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/승인4.jfif"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'RAISE'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/대기10.png"
													style="height: 20px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'REJECT'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/거절4.png"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<!-- 주간 -->
				<div class="tab-pane fade" id="weekly">
					<div class="row tab-content" id="tab-2"
						style="border-bottom: 1px solid lightgray;">
						<c:choose>
							<c:when test="${empty weeklyList}">
								<div class="row" id="notice" style="border: transparent;">
									<div class="col">작성된 글이 없습니다.</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${weeklyList}">
									<div class="on col-md-1 d-none d-md-block">${i.seq}</div>
									<div class="on col-sm-12 col-md-7">
										<a href="/log/logRead.log?seq=${i.seq}&status=${i.status}">${i.title }</a>
									</div>
									<div class="on col-md-1 d-none d-md-block">${i.name}</div>
									<div class="on col-md-1 d-none d-md-block">${i.report_start}</div>
									<div class="on col-md-1 d-none d-md-block">${i.write_date}</div>
									<!-- 상태 이미지 -->
									<c:choose>
										<c:when test="${i.status eq 'CONFIRM'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/승인4.jfif"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'RAISE'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/대기10.png"
													style="height: 20px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'REJECT'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/거절4.png"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<!-- 월별 -->
				<div class="tab-pane fade" id="monthly">
					<div class="row tab-content" id="tab-2"
						style="border-bottom: 1px solid lightgray;">
						<c:choose>
							<c:when test="${empty monthlyList}">
								<div class="row" id="notice" style="border: transparent;">
									<div class="col">작성된 글이 없습니다.</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:forEach var="i" items="${monthlyList}">
									<div class="on col-md-1 d-none d-md-block">${i.seq}</div>
									<div class="on col-sm-12 col-md-7">
										<a href="/log/logRead.log?seq=${i.seq}&status=${i.status}">${i.title }</a>
									</div>
									<div class="on col-md-1 d-none d-md-block">${i.name}</div>
									<div class="on col-md-1 d-none d-md-block">${i.report_start}</div>
									<div class="on col-md-1 d-none d-md-block">${i.write_date}</div>
									<!-- 상태 이미지 -->
									<c:choose>
										<c:when test="${i.status eq 'CONFIRM'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/승인4.jfif"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'RAISE'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/대기10.png"
													style="height: 20px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
										<c:when test="${i.status eq 'REJECT'}">
											<div class="on col-md-1 d-none d-md-block">
												<img alt="" src="/img/거절4.png"
													style="height: 25px; width: 25px; border-radius: 20px;">
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
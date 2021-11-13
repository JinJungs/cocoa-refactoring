<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
	<title>Chat</title>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">
	<link rel="stylesheet" href="/css/messenger.css">
	<meta name="mobile-web-app-capable" content="yes">
</head>
<!--Coded With Love By Mutiullah Samim-->
<body>
<div class="w-100 h-100 chat container-fluid p-0 min-w-450">
	<%-- 오늘 날짜 --%>
	<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="nowFormed" />
	<fmt:parseNumber value="${now.time / (1000*60*60*24)}" integerOnly="true" var="nowDays" scope="request"/>
	<!-- 전체 시작 -->
	<div class="row m-0 h-100 whiteBg contactList_body">
		<!-- 왼쪽 - contact list sidebar -->
		<div class="col-3 col-md-2 col-xl-1 bgMain container-fluid p-o m-0 pl-2 con-sidebar">
			<a href="#" id="chatLogo">
				<div class="row p-0 m-0 text-center">
					<div class="col-12 align-self-center">
						<img src="/icon/chat-text.svg">
					</div>
				</div>
			</a><a href="#" id="showAll">
				<div class="row p-2 text-center">
					<div class="col-12 ml-2 text-left">
						<img src="/icon/person.svg">
						<span>전체</span>
					</div>
				</div>
			</a> <a href="#" id="showDept">
			<div class="row p-2 text-center">
				<div class="col-12 ml-2 text-left">
					<img src="/icon/diagram-3.svg">
					<span>부서원</span>
				</div>
			</div>
		</a> <a href="#" id="showTeam">
			<div class="row p-2 text-center">
				<div class="col-12 ml-2 text-left">
					<img src="/icon/people.svg">
					<span>팀원</span>
				</div>
			</div>
		</a> <a href="#" id="showChat">
			<div class="row p-2 text-center">
				<div class="col-12 ml-2 text-left">
					<img src="/icon/chat.svg">
					<span>채팅방</span>
				</div>
			</div>
		</a>
		</div>
		<!-- 오른쪽 -->
		<div class="col-9 col-md-10 col-xl-11 p-0">
			<!-- top head -->
			<div class="row w-100 m-0 h20 whiteBg">
				<div class="card-header col-12 p-0" style="border-radius: 0%;">
					<div class="row w-100 m-0 p-4 con-title">
						<div class="col-10 m-0 p-0 align-self-center">
							<span id="chatTitle">전체 연락처</span>
						</div>
						<div class="col-2 m-0 p-0 d-flex justify-content-end align-self-center" id="openMemberList">
							<a class="btn btn-outline-light">
							<img src="/icon/chat-plus.svg"></a>
						</div>
					</div>
					<div class="input-group float-right col-12 col-sm-11 col-md-10 col-lg-8 col-xl-6 pl-4 pr-4 p-0">
						<input type="text" placeholder="이름, 메세지 검색" name=""
							   class="form-control search" id="searchContents">
						<div class="input-group-prepend">
						  <span class="input-group-text search_btn" id="searchBtn"> <i
								  class="fas fa-search"></i>
						  </span>
						</div>
					</div>
				</div>
			</div>
			<!-- contact list part -->
			<div class="row w-100 m-0 h80">
				<div class="con-memberList col-12 p-0">
					<div class="card contacts_card h-100 b-radius-0">
						<div class="card-body contacts_body" style="border-radius:0 !important;">
						<!-- 나의 프로필 상단 고정 -->
						<ui class="contacts" id="myProfil">
							<li class="con-list">
								<div class="d-flex bd-highlight">
									<div class="img_cont myprofilImg align-self-center">
										<a href="#"> <img src="${loginDTO.profile}"
														  class="rounded-circle user_img">
										</a>
									</div>
									<a href="#">
										<div class="user_info align-self-center">
											<span>${loginDTO.name}</span>
											<p>${loginDTO.deptname} | ${loginDTO.teamname}<c:if test="${empty loginDTO.teamname}">무소속</c:if></p>
										</div>
									</a>
								</div>
							</li>
						</ui>
						<ui class="contacts" id="memberAll">
							<c:choose>
								<c:when test="${empty memberList}">
									<div class='none h-100' style="background-color: transparent !important;">
										<img class='noFileImg' alt='nofile' src='/img/cocoa2.png'>
										<p class='noFileMsg'>전체 멤버가 없습니다.</p>
									</div>
								</c:when>
								<c:otherwise>
								<c:forEach var="i" items="${memberList}">
								<li class="con-list">
									<div class="d-flex bd-highlight" ondblclick="toSingleChatRoom(${i.code})" >
										<div class="img_cont align-self-center">
											<a href="#"> <img src="${i.profile}"
															  class="rounded-circle user_img">
											</a>
										</div>
										<div class="user_info align-self-center">
											<span>${i.name}</span>
											<p>${i.deptname} | ${i.teamname}<c:if test="${empty i.teamname}">무소속</c:if></p>
										</div>
									</div>
								</li>
								</c:forEach>
								</c:otherwise>
							</c:choose>
						</ui>
						<ui class="contacts" id="memberDept">
							<c:choose>
								<c:when test="${empty memberList}">
									<div class='none h-100' style="background-color: transparent !important;">
										<img class='noFileImg' alt='nofile' src='/img/cocoa2.png'>
										<p class='noFileMsg'>부서원이 없습니다.</p>
									</div>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" items="${memberList}">
									<c:if test="${i.dept_code eq loginDTO.dept_code}">
										<li class="con-list">
											<div class="d-flex bd-highlight" ondblclick="toSingleChatRoom(${i.code})">
												<div class="img_cont align-self-center">
													<a href="#"> <img src="${i.profile}"
																	  class="rounded-circle user_img">
													</a>
												</div>
												<div class="user_info align-self-center">
													<span>${i.name}</span>
													<p>${i.deptname} | ${i.teamname}<c:if test="${empty i.teamname}">무소속</c:if></p>
												</div>
											</div>
										</li>
									</c:if>
								</c:forEach>
								</c:otherwise>
							</c:choose>
						</ui>
						<ui class="contacts" id="memberTeam">
							<c:choose>
								<c:when test="${empty memberList}">
									<div class='none h-100' style="background-color: transparent !important;">
										<img class='noFileImg' alt='nofile' src='/img/cocoa2.png'>
										<p class='noFileMsg'>팀원이 없습니다.</p>
									</div>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" items="${memberList}">
									<c:if test="${i.team_code eq loginDTO.team_code}">
										<li class="con-list">
											<div class="d-flex bd-highlight" ondblclick="toSingleChatRoom(${i.code})">
												<div class="img_cont align-self-center">
													<a href="#"> <img src="${i.profile}" class="rounded-circle user_img">
													</a>
												</div>
												<div class="user_info align-self-center">
													<span>${i.name}</span>
													<p>${i.deptname} | ${i.teamname}<c:if test="${empty i.teamname}">무소속</c:if></p>
												</div>
											</div>
										</li>
									</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ui>
						<ui class="contacts" id="chatList">
							<c:choose>
								<c:when test="${empty chatList}">
									<div class='none h-100' style="background-color: transparent !important;">
										<img class='noFileImg' alt='nofile' src='/img/cocoa2.png'>
										<p class='noFileMsg'>채팅방이 없습니다.</p>
									</div>
								</c:when>
								<c:otherwise>
									<c:forEach var="i" items="${chatList}">
										<li class="con-list chat-list" id="chat-list${i.seq}">
											<div class="d-flex bd-highlight" ondblclick="toChatRoom(${i.seq})">
												<div class="img_cont align-self-center">
													<img src="${i.profile}" class="rounded-circle user_img">
												</div>
												<div class="user_info align-self-center">
													<c:choose>
														<c:when test="${i.type=='S'}"> <!--1:1채팅방-->
															<span class="con-room" id="con-room${i.seq}">${i.empname}</span>
														</c:when>
														<c:otherwise> <!--1:N채팅방-->
															<span class="con-room" id="con-room${i.seq}">${i.name}</span>
														</c:otherwise>
													</c:choose>
													<p>
														<c:choose>
															<c:when test="${i.msg_type=='IMAGE'}">
																<span class="con-message" id="con-message${i.seq}"><c:out value="사진"/></span>
															</c:when>
															<c:otherwise>
																<span class="con-message" id="con-message${i.seq}"><c:out value="${i.contents}"/></span>
															</c:otherwise>
														</c:choose>
													</p>
												</div>
												<div class="con-rightMenu">
													<div class="con-date" id="con-date${i.seq}">
														<fmt:formatDate value="${i.write_date}" pattern="yyyy-MM-dd" var="formed"/>
														<fmt:formatDate value="${i.write_date}" pattern="HH:mm" var="formedTime"/>
														<fmt:parseNumber value="${i.write_date.time / (1000*60*60*24)}" integerOnly="true" var="formedDays" scope="request"/>
														<c:choose>
															<c:when test="${nowFormed==formed}">
																${formedTime}
															</c:when>
															<c:when test="${nowDays-formedDays==1}">
																어제
															</c:when>
															<c:otherwise>
																${formed}
															</c:otherwise>
														</c:choose>
													</div>
													<div class="con-msgCount-box m-0 pt-2 p-0">
														<div class="con-msgCount ml-auto p-0" id="con-msgCount${i.seq}">
															12
														</div>
													</div>
												</div>
											</div>
										</li>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ui>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<input id="onclickNow" type="hidden" value="all">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- sockjs, stomp CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.3.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<!-- 날짜 변경 라이브러리-->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script>
	let chatTitle = document.getElementById("chatTitle");
	let memberAll = document.getElementById("memberAll");
	let memberDept = document.getElementById("memberDept");
	let memberTeam = document.getElementById("memberTeam");
	let chatList = document.getElementById("chatList");

	let showAll = document.getElementById("showAll");
	let showDept = document.getElementById("showDept");
	let showTeam = document.getElementById("showTeam");
	let showChat = document.getElementById("showChat");
	const textLength = 20;

	//자식창(chat.jsp)에서 부모창 리로드시 funcOnclickNow 안먹힘/ 안되면 지우기 ============
	function funcOnclickNow(onclickNow){
		if(onclickNow == 'all'){
			this.showAllClick();
		}else if (onclickNow == 'dept'){
			this.showDeptClick();
		}else if(onclickNow == 'team'){
			this.showTeamClick();
		}else if(onclickNow == 'chat'){
			this.showChatClick();
		}
	}
	//자식창(chat.jsp)에서 부모창 리로드시 funcOnclickNow 안먹힘/ 안되면 지우기 ============
	showAll.addEventListener("click", showAllClick);
	function showAllClick(){
		memberAll.style.display="block";
		memberDept.style.display="none";
		memberTeam.style.display="none";
		chatList.style.display="none";
		chatTitle.innerHTML = "전체 연락처";
		$("#myProfil").show();
		$(".search").focus();
		document.getElementById("onclickNow").value = "all";
	}

	showDept.addEventListener("click", showDeptClick);
	function showDeptClick(){
		memberAll.style.display="none";
		memberDept.style.display="block";
		memberTeam.style.display="none";
		chatList.style.display="none";
		chatTitle.innerHTML = "부서원";
		$("#myProfil").show();
		$(".search").focus();
		document.getElementById("onclickNow").value = "dept";
	}

	showTeam.addEventListener("click", showTeamClick);
	function showTeamClick(){
		memberAll.style.display="none";
		memberDept.style.display="none";
		memberTeam.style.display="block";
		chatList.style.display="none";
		chatTitle.innerHTML = "팀원";
		$("#myProfil").show();
		$(".search").focus();
		document.getElementById("onclickNow").value = "team";
	}

	showChat.addEventListener("click", showChatClick);
	function showChatClick(){
		memberAll.style.display="none";
		memberDept.style.display="none";
		memberTeam.style.display="none";
		chatList.style.display="block";
		chatTitle.innerHTML = "채팅방";
		$("#myProfil").hide();
		$(".search").focus();
		document.getElementById("onclickNow").value = "chat";
	}

	// 연락처리스트 소켓으로 메세지받기
	// 스톰프 연결
	let msgCount = 0;
	function connectStomp() {
		var sock = new SockJS("/stompTest"); // endpoint
		var client = Stomp.over(sock); //소크로 파이프 연결한 스톰프
		isStomp = true;
		socket = client;

		client.connect({}, function () {
			// 채팅방의 개수만큼 Stomp로 받아야한다.
			<c:forEach var="i" items="${chatList}">
				client.subscribe('/contact/' +${i.seq}, function (e) {
				let msg = JSON.parse(e.body).contents;
				let type = JSON.parse(e.body).type;
				let write_date = JSON.parse(e.body).write_date;
				let roomname = JSON.parse(e.body).roomname;
				let parent = document.getElementById("chatList");
				let child = document.getElementById("chat-list${i.seq}");
				// (1) 날짜
				let formed_write_date = moment(write_date).format('HH:mm');
				$("#con-date${i.seq}").html(formed_write_date);
				// (2) 메세지
				// type이 IMAGE일 때는 '사진'으로 메세지를 띄워준다.
				if(type=='IMAGE'){
					parent.insertBefore(child,parent.firstChild);
					$("#con-message${i.seq}").html("사진");
				}else if(type=='TEXT' || type=='FILE'){
					// 위치 맨위로 올리기
					parent.insertBefore(child,parent.firstChild);
					if(msg.length > textLength){
						msg = msg.substr(0, textLength-2) + '...';
					}
					$("#con-message${i.seq}").html(msg);
				// (3) 채팅방 이름 변경
				}else if(type=='AN_MODIF'){
					$("#con-room${i.seq}").html(roomname);
				}
			});
			</c:forEach>
		});
	}

	// 의진 추가 - room의 seq를 받아 해당 채팅방으로 이동
	let winFeature = 'width=450px,height=660px,location=no,toolbar=no,menubar=no,scrollbars=no,resizable=no,fullscreen=yes';
    function toChatRoom(seq) {
      window.open('/messenger/chat?seq='+seq,'chat'+seq,winFeature);
    }

    // 소형 추가 - 상대방 EMP_CODE를 받아 개인 채팅방 열기
    function toSingleChatRoom(code) {
      window.open('/messenger/openCreateSingleChat?partyEmpCode='+code,'singleChat'+code,winFeature);
    }

	$(document).ready(function () {
		// 검색창 포커스
		$(".search").focus();
		// 스톰프 연결
		connectStomp();
	});

    //-------------------------------- 검색 -------------------------------------
    document.getElementById("searchBtn").addEventListener("click",search);
	// enter키 클릭시 검색
	$("#searchContents").on("keydown", function (e) {
		if (e.keyCode == 13) {
			search();
		}
	});
	// esc 누르면 창닫기
	$(document).keydown(function(e) {
		if ( e.keyCode == 27 || e.which == 27 ) {
			window.close();
		}
	});

	//검색창 열기
    function search(){
		let searchContents = $("#searchContents").val().trim();
		if(searchContents == ''){
			return;
		}
		window.open('/messenger/messengerSearch?contents='+searchContents,'search',winFeature);
	}
	
    //-------------------------------- 채팅방 추가 ---------------------------------
	document.getElementById("openMemberList").addEventListener("click", openMemberList);
    function openMemberList(){
		var popup = window.open('/messenger/openMemberList?seq=0','',winFeature);
    }
</script>
<script src="/resources/static/js/messenger.js"></script>
<script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.js"></script>
</body>
</html>
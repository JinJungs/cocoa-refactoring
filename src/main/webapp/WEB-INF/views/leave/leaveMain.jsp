<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.selectBox{
	margin-left: 85%;
}
select{
	width: 80px;
}
.title{
	margin-top: 30px;
	margin-bottom: 10px;
	font-size: 1.3rem;
}
.backgroundC{
	background-color : #6749b930;
}
.fixdiv{
	min-width: 100px;
}
</style>
</head>
<body>
   <div class="wrapper d-flex align-items-stretch">
      <%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>   <!-- Page Content  -->
      <div id="content" class="p-4 p-md-5 pt-5" style="min-width: 800px;">
      	<h2 class="mb-4">휴가 현황보기</h2>
     		<div class="selectBox">
     			<select name=year id=yearSelect onchange="fn_yearChanged()">
     				<c:forEach var="year" items="${yearList}">
     					<option value=${year }>${year }</option>
				</c:forEach>
     			</select>
     		</div>
     		<script>
     			$('#yearSelect').val("${year}").prop("selected",true);
     			
     			function fn_yearChanged(){
     				var yearVal = $("#yearSelect > option:selected").val();
     				location.href="/leave/toLeaveMain.leave?year=" + yearVal;
     			}
     		</script>
     		<div class="row title float" style="margin-top: 0px;">▶내 휴가 정보</div>
     		<div class="row" style="border-top: 1px solid #bfbfbf;">
      		<div class="col-4 col-md-3 col-xl-2 p-3 backgroundC" style="border-right: 1px solid #bfbfbf;"><b>입사일</b></div>
      		<div class="col-8 col-md-9 col-xl-10 p-3">${hireDate }</div>
     		</div>
     		<div class="row" style="border-top: 1px solid #bfbfbf;">
     			<div class="col-4 col-md-3 col-xl-2 p-3 backgroundC" style="border-right: 1px solid #bfbfbf;"><b>휴가 지급일수</b></div>
     			<div class="col-2 col-md-3 col-xl-4 p-3" style="border-right: 1px solid #cacaca;">${ltuLeaveDTO.leave_got }일</div>
     			<div class="col-4 col-md-3 col-xl-2 p-3 backgroundC" style="border-right: 1px solid #bfbfbf;"><b>휴가 총 사용일</b></div>
     			<div class="col-2 col-md-3 col-xl-4 p-3">${ltuLeaveDTO.leave_used }일</div>
     		</div>
     		<div class="row" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf">
     			<div class="col-4 col-md-3 col-xl-2 p-3 backgroundC" style="border-right: 1px solid #bfbfbf;"><b>조퇴 / 반차 누적시간</b></div>
     			<div class="col-2 col-md-3 col-xl-4 p-3" style="border-right: 1px solid lightgray;">${timeSum }시간</div>
     			<div class="col-4 col-md-3 col-xl-2 p-3 backgroundC" style="border-right: 1px solid #bfbfbf;"><b>휴가 잔여일수</b></div>
     			<div class="col-2 col-md-3 col-xl-4 p-3">${ltuLeaveDTO.leave_got - ltuLeaveDTO.leave_used }일</div>
     		</div>
     		
     		
     		
     		<div class="row title">▶휴가 사용 일수</div>
	     		<div class="row">
	     			<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf;"><b>정기</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf;">${ordinaryL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>병가</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${sickL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>보건</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${longSickL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>조퇴</b><b style="font-size: 11px;">(시)</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${earlyL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>반차</b><b style="font-size: 11px;">(시)</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${halfL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf;"><b>경조사</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${familyL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>출산</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${childBirthL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>기타</b><b style="font-size: 11px;">(차감)</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${etcMinusL }</div>
				</div>
				<div class="col">
					<div class="row p-2 backgroundC fixdiv" style="border-top: 1px solid #bfbfbf; border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf"><b>기타</b><b style="font-size: 11px;">(미차감)</b></div>
					<div class="row p-2" style="border-bottom: 1px solid #bfbfbf; border-left: 1px solid #bfbfbf">${etcNMinusL }</div>
				</div>
     		</div>
     		
     		<div class="row title">▶휴가 사용현황</div>
     		<div class="row" style="border-top: 1px solid #bfbfbf;border-bottom: 1px solid #bfbfbf;">
     			<div class="col-1 p-1 text-center backgroundC" style="border-right: 1px solid #bfbfbf;"><b>seq</b></div>
     			<div class="col-3 p-2 text-center backgroundC" style="border-right: 1px solid #bfbfbf;"><b>휴가 종류</b></div>
     			<div class="col-3 p-2 text-center backgroundC" style="border-right: 1px solid #bfbfbf;"><b>시작 날짜</b></div>
     			<div class="col-3 p-2 text-center backgroundC" style="border-right: 1px solid #bfbfbf;"><b>끝 날짜</b></div>
     			<div class="col-2 p-2 text-center backgroundC"><b>시간</b></div>
     		</div>
     		
     		<c:forEach var="i" items="${leaveList }">
      		<div class="row" style="border-bottom: 1px solid #bfbfbf;">
      			<div class="col-1 p-2 text-center" style="border-right: 1px solid #bfbfbf;">${i.rownumber }</div>
      			<div class="col-3 p-2 text-center" style="border-right: 1px solid #bfbfbf;">${i.type }</div>
      			<div class="col-3 p-2 text-center" style="border-right: 1px solid #bfbfbf;">${i.start_date }</div>
      			<div class="col-3 p-2 text-center" style="border-right: 1px solid #bfbfbf;">
      				<c:if test="${empty i.end_date}">
      					-
      				</c:if>
      				${i.end_date}
      			</div>
      			<div class="col-2 p-2 text-center">
      				<c:choose>
	      				<c:when test="${i.time eq '0'}">
	      					-
	      				</c:when>
	      				<c:otherwise>
	      					${i.time }
	      				</c:otherwise>
      				</c:choose>
      			</div>
      		</div>
      	</c:forEach>
      	
      </div>
   </div>
<script src="/js/bootstrap.min.js"></script>
</body>
</html>
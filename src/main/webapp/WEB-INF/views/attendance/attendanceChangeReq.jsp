<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset='utf-8' />
    <title>근태</title>
    <style>
        #comments:hover{
            color:#00bfff;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="wrapper d-flex align-items-stretch">
    <%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>
    <div id="content" class="p-4 p-md-5 pt-5">
        <div class="container-fluid">
            <div class="row">
                <div class="col-12" style="min-width: 170px;">
                    <h5><b>출퇴근 내역</b></h5>
                </div>
            </div>

            <div class="row ">
                <div class="col-12 p-2">
                    <table class="table" >
                        <thead>
                        <tr>
                            <th class="p-0 pl-2 pt-5 pb-5" scope="col" style="min-width: 76px;">기간 선택</th>
                            <th class="p-0 pt-5 pb-5" scope="col" style="min-width: 350px;">
                                <input type="date" id="search-start_time"> ~
                                <input type="date" id="search-end_time"></th>

                            <th class="p-0 pt-5 pb-5" scope="col" style="min-width: 400px;">
                                출퇴근 여부 &nbsp
                                <select class="form-select" id="search-select" style="min-width: 250px;min-height: 30px">
                                    <option value="" selected>전체</option>
                                    <option value=IN>정상출근</option>
                                    <option value=LATE >지각</option>
                                    <option value=OUT >외근</option>
                                </select>
                                &nbsp
                                <button class="btn btn-outline-primary btn-sm" onclick="fn_search()">조회</button>
                            </th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>
            <div class="row text-right pb-1">
                <div class="col-12" style="min-width: 890px;">
                    <select id="select-number" style="min-height: 30px; width: 60px; border-color: #c9c9c9" onchange="fn_changeNumber()">
                        <option selected>10</option>
                        <option>20</option>
                        <option>30</option>
                    </select>
                </div>
            </div>
            <div class="row" style="min-width: 890px;">
                <div class="col-12 text-center">
                    <table class="table table-hover">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">날짜</th>
                            <th scope="col">출퇴근 여부</th>
                            <th scope="col">출근 시간</th>
                            <th scope="col">퇴근 시간</th>
                            <th scope="col">상태</th>
                            <th scope="col">처리 의견</th>
                            <th scope="col">요청</th>
                        </tr>
                        </thead>
                        <tbody id="contents-container">

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<div class="modal fade " id="reqModal" data-backdrop="false" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document" style="min-width: 500px;">
        <div class="modal-content" style="min-width: 500px;">
            <div class="modal-header border-bottom-0 p-0 pt-2 pr-2">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>

            </div>
            <form id="modal-form">
                <div class="modal-body" >
                    <div class="container"  style="min-width: 500px;">
                        <div class="row p-2" >
                            <div class="col-12">
                                <b>출근 시간 변경</b>
                            </div>
                        </div>
                        <div class="row p-2">
                            <div class="col-3">날짜</div>
                            <div class="col-8" id="modal-date"></div>
                        </div>
                        <div class="row p-2 ">
                            <div class="col-3 pt-1">출근 시간</div>
                            <input type="hidden" id="modal-seq">
                            <div class="col-8">
                                <select  id="startTime" name="starttime" style="min-height: 35px; min-width: 80px; border-radius: 5px" >
                                    <c:forEach var="i"  begin="0" end="23">
                                        <option value="${i}">${i>9?i:'0'}${i>9?'':i}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select  id="endTime" name="endtime" style="min-height: 35px; min-width: 80px; border-radius: 5px">
                                    <c:forEach var="i"  begin="0" end="59">
                                        <option value="${i}">${i>9?i:'0'}${i>9?'':i}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row  p-2">
                            <div class="col-3 pt-1">퇴근 시간</div>
                            <div class="col-8">
                                <select  id="startTime2" name="starttime2"  style="min-height: 35px; min-width: 80px; border-radius: 5px">
                                    <c:forEach var="i"  begin="0" end="23">
                                        <option value="${i}">${i>9?i:'0'}${i>9?'':i}</option>
                                    </c:forEach>
                                </select>
                                :
                                <select id="endTime2" name="endtime2" style="min-height: 35px; min-width: 80px; border-radius: 5px">
                                    <c:forEach var="i"  begin="0" end="59">
                                        <option value="${i}">${i>9?i:'0'}${i>9?'':i}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row  p-2">
                            <div class="col-3">사유</div>
                            <div class="col-8"><textarea class="w-100" name="contents" id="modal-contents" style="min-width:210px; min-height: 150px; max-height: 150px;" oninput="fn_getlength()" maxlength="100"></textarea></div>
                        </div>
                    </div>
                </div>
            </form>
            <div class="modal-footer border-top-0">
                <button type="button" class="btn btn-outline-primary btn-sm" id="btn_ok" data-dismiss="modal" onclick="fn_changeReq()">변경 요청</button>
                <button type="button" class="btn btn-outline-info btn-sm" id="btn_cancel" data-dismiss="modal" style="display: none" onclick="fn_delChangeReq()">요청 취소</button>
                <button type="button" class="btn btn-outline-dark btn-sm" id="btn_close" data-dismiss="modal" >취소</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade " id="alertModal" data-backdrop="false" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm" role="document" >
        <div class="modal-content">
            <div class="modal-body d-flex justify-content-center h-100 pt-5" style="min-height: 120px;">
                <b id="atdResultMsg">출근이 처리가 완료 되었습니다.</b>
            </div>
        </div>
    </div>
</div>

<div class="modal fade " id="reqCommentAlert" data-backdrop="false" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm" role="document" >
        <div class="modal-content">
            <div class="modal-header border-bottom-0 p-0 pt-2 pr-2">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body pb-2 text-center" style="min-height: 100px;">
                <div class="container" style="word-break:break-all;">
                    <div class="row">
                        <div class="col-12">
                            <h5><b>처리 의견</b></h5>
                        </div>
                    </div>
                    <b class="p-3" id="reqCommentAlertMsg" style="text-overflow: ellipsis;"></b>
                </div>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/Chart.min.js"></script>
<script>

    var curdate = new Date();
    var year =curdate.getFullYear();
    var month =curdate.getMonth()+1;
    var date = curdate.getDate();
    var today ="";
    if(month.toString().length==1&&date.toString().length==1) {
        today = year + "-0" + month + "-0" + date;

    }else if(month.toString().length==1){
        today =year + "-0" + month + "-" + date;

    }else{
        today =year + "-" + month + "-" + date;

    }
    var oneMonthAgo = new Date(curdate.setMonth(curdate.getMonth()-1));
    var omayear = oneMonthAgo.getFullYear();
    var omamonth = oneMonthAgo.getMonth()+1;
    var omadate = oneMonthAgo.getDate();
    var oma = ""

    if(omamonth.toString().length==1&&omadate.toString().length==1){
        oma= omayear +"-0"+omamonth+"-0"+omadate;
    }else if(omamonth.toString().length==1){
        oma= omayear +"-0"+omamonth+"-"+omadate;
    }else{
        oma= omayear +"-"+omamonth+"-"+omadate;
    }





    $( function() {
        $("#search-start_time").val(oma);
        $("#search-end_time").val(today);
        fn_getAtdList();

        setTimeout(function reloadpage() {
            setTimeout(reloadpage,30000);
            fn_getAtdList();
        },30000)
    });

    function fn_getlength() {
        var count = $("#modal-contents").val().length;
        var maxleng = $("#modal-contents").attr("maxlangth");
        if(count>maxleng){
            $("#modal-contents").val().substr(0,maxleng);
            count = $("#modal-contents").val().length;
        }
    }

    function fn_getAtdList(){
        $.ajax({
            type : "POST",
            url : "/restattendance/getAtdList",
            data :{number:$("#select-number").val()},
            dataType:"json",
            success : function(data) {
                var html="";
                for(var i=0;i<data.length;i++) {
                    var compDate=data[i].today.substr(0,8).replaceAll("-","");
                    html+="<tr>";
                    html+="<td>"+(i+1)+"</td>";
                    html+="<td>"+data[i].today+"</td>";
                    html+="<td>"+data[i].status+"</td>";
                    if(today.substr(2,8).replaceAll("-","")==compDate&&data[i].sub_start_time=="출근 누락"){
                        html+="<td style='color:blue'>출근 전</td>";
                    }
                    else if(data[i].sub_start_time=="출근 누락"){
                        html+="<td style='color:red'>"+data[i].sub_start_time+"</td>";
                    }
                    else{
                        html+="<td>"+data[i].sub_start_time+"</td>";
                    }
                    if(today.substr(2,8).replaceAll("-","")==compDate&&data[i].sub_end_time=="퇴근 누락"){
                        html+="<td style='color:blue'>퇴근 전</td>";
                    }
                    else if(data[i].sub_end_time=="퇴근 누락"){
                        html+="<td style='color:red'>"+data[i].sub_end_time+"</td>";
                    }else{
                        html+="<td>"+data[i].sub_end_time+"</td>";
                    }


                    html+="<td>"+data[i].req_status+"</td>";
                    if(data[i].comments!="-"){
                        html+="<td class='text-truncate' id='comments' style='max-width: 160px; cursor: pointer;' onclick='fn_openReqCommentModal("+data[i].seq+")'>"+data[i].comments+"</td>";
                    }else{

                        html+="<td class='text-truncate' style='max-width: 160px;'>"+data[i].comments+"</td>";
                    }
                    if(data[i].req_status == "미승인" || data[i].req_status == "승인"){
                        html+="<td><button class='btn btn-outline-dark btn-sm' onclick=fn_openIsReqModal("+ data[i].seq +",'"+ data[i].today.substr(0, 8) +"')>재요청</button>";
                    }else{
                        html+="<td><button class='btn btn-outline-dark btn-sm' onclick=fn_openReqModal("+ data[i].seq +",'"+ data[i].today.substr(0, 8) +"')>요청</button>";
                    }

                }
                $("#contents-container").empty();
                $("#contents-container").append(html);
            }
        });
    }

    function fn_search() {
        var start_time = parseInt($("#search-start_time").val().replaceAll("-",""));
        var end_time = parseInt($("#search-end_time").val().replaceAll("-",""));
        if(start_time>end_time){
            start_time=$("#search-end_time").val();
            end_time=$("#search-start_time").val();
        }else{
            start_time=$("#search-start_time").val();
            end_time=$("#search-end_time").val();
        }
        $.ajax({
            type : "POST",
            url : "/restattendance/search",
            data :{number:$("#select-number").val(),search:$("#search-select").val(),
                start_time:start_time,end_time:end_time},
            dataType:"json",
            success : function(data) {
                var html="";
                for(var i=0;i<data.length;i++){
                    var compDate=data[i].today.substr(0,8).replaceAll("-","");
                    html+="<tr>";
                    html+="<td>"+(i+1)+"</td>";
                    html+="<td>"+data[i].today+"</td>";
                    html+="<td>"+data[i].status+"</td>";
                    html+="<td>"+data[i].sub_start_time+"</td>";

                    if(compDate==today.replaceAll("-","").substr(2)&&data[i].sub_end_time==null){
                        html+="<td style='color:blue'>퇴근 전</td>"
                    }
                    else if(data[i].sub_end_time==null){
                        html+="<td style='color:red'>퇴근 누락</td>";
                    }
                    else{
                        html+="<td>"+data[i].sub_end_time+"</td>";
                    }
                    html+="<td>"+data[i].req_status+"</td>";
                    if(data[i].comments!="-"){
                        html+="<td class='text-truncate' id='comments' style='max-width: 160px; cursor: pointer;' onclick='fn_openReqCommentModal()'>"+data[i].comments+"</td>";
                    }else{
                        html+="<td class='text-truncate' style='max-width: 160px;'>"+data[i].comments+"</td>";
                    }
                    if(data[i].req_status == "미승인" || data[i].req_status == "승인"){
                        html+="<td><button class='btn btn-outline-dark btn-sm' onclick=fn_openIsReqModal("+ data[i].seq +",'"+ data[i].today.substr(0, 8) +"')>재요청</button>";
                    }else{
                        html+="<td><button class='btn btn-outline-dark btn-sm' onclick=fn_openReqModal("+ data[i].seq +",'"+ data[i].today.substr(0, 8) +"')>요청</button>";
                    }
                }
                $("#contents-container").empty();
                $("#contents-container").append(html);
            }
        });
    }

    function fn_changeNumber() {
        var isSearch = $("#search-select").val();
        if(isSearch==''){
            fn_getAtdList();
        }else{
            fn_search();
        }
    }

    function fn_openReqModal(atd_seq,today) {
        $.ajax({
            type : "POST",
            url : "/restattendance/getReqInfo",
            data :{atd_seq:atd_seq},
            dataType:"json",
            success : function(data) {
                $("#modal-seq").val(atd_seq);
                $("#btn_ok").text("변경 요청");
                if(data!=false){
                    var start_time =data.start_time.substr(10,6).split(":");
                    var end_time=data.end_time.substr(10,6).split(":");
                    $("#btn_ok").attr("onclick","fn_modChangeReq()");
                    $("#modal-date").text(today);
                    $("#startTime").val(parseInt(start_time[0]));
                    $("#endTime").val(parseInt(start_time[1]));
                    $("#startTime2").val(parseInt(end_time[0]));
                    $("#endTime2").val(parseInt(end_time[1]));
                    $("#modal-contents").val(data.contents);
                    $("#btn_cancel").show();
                    $("#reqModal").modal();
                }else{
                    $("#btn_ok").attr("onclick","fn_changeReq()");
                    $("#startTime").val(0);
                    $("#endTime").val(0);
                    $("#startTime2").val(0);
                    $("#endTime2").val(0);
                    $("#modal-contents").val("");
                    $("#modal-date").text(today);
                    $("#btn_cancel").hide();
                    $("#reqModal").modal();
                }
            }
        });
    }


    function fn_openIsReqModal(atd_seq,today){
        $.ajax({
            type : "POST",
            url : "/restattendance/getReqInfo",
            data :{atd_seq:atd_seq},
            dataType:"json",
            success : function(data) {
                $("#btn_cancel").hide();
                $("#btn_ok").text("재요청");
                $("#modal-seq").val(atd_seq);
                var start_time =data.start_time.substr(10,6).split(":");
                var end_time=data.end_time.substr(10,6).split(":");
                $("#btn_ok").attr("onclick","fn_reChangeReq()");
                $("#modal-date").text(today);
                $("#startTime").val(parseInt(start_time[0]));
                $("#endTime").val(parseInt(start_time[1]));
                $("#startTime2").val(parseInt(end_time[0]));
                $("#endTime2").val(parseInt(end_time[1]));
                $("#modal-contents").val(data.contents);
                $("#reqModal").modal();
            }
        });
    }

    function fn_openReqCommentModal(atd_seq) {
        $.ajax({
            type : "POST",
            url : "/restattendance/getIsReqInfo",
            data :{atd_seq:atd_seq},
            dataType:"json",
            success : function(data) {
                $("#reqCommentAlertMsg").text(data.comments);
                $("#reqCommentAlert").modal();
            }
        });

    }

  /*  function getReXSSFilter(value) {

        value = value.replaceAll("&amp;", "&");

        value = value.replaceAll("&#35;", "#");

        value = value.replaceAll("&#59;", ";");



        value = value.replaceAll("&#92;", "\\\\");



        value = value.replaceAll("&lt;" , "<");

        value = value.replaceAll("&gt;" , ">");

        value = value.replaceAll("&#40;", "(");

        value = value.replaceAll("&#41;", ")");

        value = value.replaceAll("&#39;", "'");



        value = value.replaceAll("&quot;", "\"");



        value = value.replaceAll("&#36;" , "\\$");

        value = value.replaceAll("&#42;" , "*");

        value = value.replaceAll("&#43;" , "+");

        value = value.replaceAll("&#124;", "|");



        value = value.replaceAll("&#46;" , "\\.");

        value = value.replaceAll("&#63;" , "\\?");

        value = value.replaceAll("&#91;" , "\\[");

        value = value.replaceAll("&#93;" , "\\]");

        value = value.replaceAll("&#94;" , "\\^");

        value = value.replaceAll("&#123;", "\\{");

        value = value.replaceAll("&#125;", "\\}");



        value = value.replaceAll("&#33;" , "!");

        value = value.replaceAll("&#37;" , "%");

        value = value.replaceAll("&#44;" , ",");

        value = value.replaceAll("&#45;" , "-");

        value = value.replaceAll("&#47;" , "/");

        value = value.replaceAll("&#58;" , ":");

        value = value.replaceAll("&#61;" , "=");

        value = value.replaceAll("&#64;" , "@");

        value = value.replaceAll("&#95;" , "_");

        value = value.replaceAll("&#96;" , "`");

        value = value.replaceAll("&#126;", "~");



        return value;

    }
*/


    function fn_changeReq() {
        var seq= $("#modal-seq").val();
        //출근시간
        var startTime=$("#startTime option:selected").val();
        var endTime=$("#endTime option:selected").val();
        //퇴근시간
        var startTime2=$("#startTime2 option:selected").val();
        var endTime2=$("#endTime2 option:selected").val();
        var sum_start_time="";
        var sum_end_time="";
        if(startTime.length==1&&endTime.length!=1){
            sum_start_time="0"+startTime+endTime;
        }else if(startTime.length!=1&&endTime.length==1){
            sum_start_time=startTime+"0"+endTime;
        }else if(startTime.length==1&&endTime.length==1){
            sum_start_time="0"+startTime+"0"+endTime;
        }else{
            sum_start_time=startTime+endTime;
        }
        if(startTime2.length==1&&endTime2.length!=1){
            sum_end_time="0"+startTime2+endTime2;
        }else if(startTime2.length!=1&&endTime2.length==1){
            sum_end_time=startTime2+"0"+endTime2;
        }else if(startTime2.length==1&&endTime2.length==1){
            sum_end_time="0"+startTime2+"0"+endTime2;
        }else{
            sum_end_time=startTime2+endTime2;
        }

        $.ajax({
            type : "POST",
            url : "/restattendance/changeReq",
            data:{start_time:sum_start_time,end_time:sum_end_time,
                contents:$("#modal-contents").val(),atd_seq:$("#modal-seq").val(),
                today:$("#modal-date").text()
            },
            success : function(data) {
                if(data=="successInsert"){
                    var isSearch = $("#search-select").val();
                    if(isSearch==''){
                        fn_getAtdList();
                    }else{
                        fn_search();
                    }
                }
                $("#alertModal").modal();
                $("#atdResultMsg").text("변경 요청이 완료되었습니다.");
                var setTime=setTimeout(function () {
                    $("#alertModal").modal('hide');
                },1500)
            }
        });
    }

    function fn_modChangeReq() {
        var seq= $("#modal-seq").val();
        //출근시간
        var startTime=$("#startTime option:selected").val();
        var endTime=$("#endTime option:selected").val();
        //퇴근시간
        var startTime2=$("#startTime2 option:selected").val();
        var endTime2=$("#endTime2 option:selected").val();
        var sum_start_time="";
        var sum_end_time="";
        if(startTime.length==1&&endTime.length!=1){
            sum_start_time="0"+startTime+endTime;
        }else if(startTime.length!=1&&endTime.length==1){
            sum_start_time=startTime+"0"+endTime;
        }else if(startTime.length==1&&endTime.length==1){
            sum_start_time="0"+startTime+"0"+endTime;
        }else{
            sum_start_time=startTime+endTime;
        }
        if(startTime2.length==1&&endTime2.length!=1){
            sum_end_time="0"+startTime2+endTime2;
        }else if(startTime2.length!=1&&endTime2.length==1){
            sum_end_time=startTime2+"0"+endTime2;
        }else if(startTime2.length==1&&endTime2.length==1){
            sum_end_time="0"+startTime2+"0"+endTime2;
        }else{
            sum_end_time=startTime2+endTime2;
        }

        $.ajax({
            type : "POST",
            url : "/restattendance/modChangeReq",
            data:{start_time:sum_start_time,end_time:sum_end_time,
                contents:$("#modal-contents").val(),atd_seq:$("#modal-seq").val(),
                today:$("#modal-date").text()
            },
            success : function(data) {
                if(data=="successUpdate"){
                    var isSearch = $("#search-select").val();
                    if(isSearch==''){
                        fn_getAtdList();
                    }else{
                        fn_search();
                    }
                    $("#alertModal").modal();
                    $("#atdResultMsg").text("변경이 완료되었습니다.");
                    var setTime=setTimeout(function () {
                        $("#alertModal").modal('hide');
                    },1000)
                }
            }
        });
    }


    function fn_delChangeReq() {
        $.ajax({
            type : "POST",
            url : "/restattendance/delChangeReq",
            data:{atd_seq:$("#modal-seq").val()},
            success : function(data) {
                if(data=="successDelete"){
                    var isSearch = $("#search-select").val();
                    if(isSearch==''){
                        fn_getAtdList();
                    }else{
                        fn_search();
                    }
                }
                $("#alertModal").modal();
                $("#atdResultMsg").text("요청이 취소되었습니다.");
                var setTime=setTimeout(function () {
                    $("#alertModal").modal('hide');
                },1000)
            }
        });
    }

    function fn_reChangeReq(){
        var seq= $("#modal-seq").val();
        //출근시간
        var startTime=$("#startTime option:selected").val();
        var endTime=$("#endTime option:selected").val();
        //퇴근시간
        var startTime2=$("#startTime2 option:selected").val();
        var endTime2=$("#endTime2 option:selected").val();
        var sum_start_time="";
        var sum_end_time="";
        if(startTime.length==1&&endTime.length!=1){
            sum_start_time="0"+startTime+endTime;
        }else if(startTime.length!=1&&endTime.length==1){
            sum_start_time=startTime+"0"+endTime;
        }else if(startTime.length==1&&endTime.length==1){
            sum_start_time="0"+startTime+"0"+endTime;
        }else{
            sum_start_time=startTime+endTime;
        }
        if(startTime2.length==1&&endTime2.length!=1){
            sum_end_time="0"+startTime2+endTime2;
        }else if(startTime2.length!=1&&endTime2.length==1){
            sum_end_time=startTime2+"0"+endTime2;
        }else if(startTime2.length==1&&endTime2.length==1){
            sum_end_time="0"+startTime2+"0"+endTime2;
        }else{
            sum_end_time=startTime+endTime;
        }

        $.ajax({
            type : "POST",
            url : "/restattendance/reChangeReq",
            data:{start_time:sum_start_time,end_time:sum_end_time,
                contents:$("#modal-contents").val(),atd_seq:$("#modal-seq").val(),
                today:$("#modal-date").text()
            },
            success : function(data) {
                if(data=="successUpdate"){
                    var isSearch = $("#search-select").val();
                    if(isSearch==''){
                        fn_getAtdList();
                    }else{
                        fn_search();
                    }
                    $("#alertModal").modal();
                    $("#atdResultMsg").text("재요청이 완료 되었습니다.");
                    var setTime=setTimeout(function () {
                        $("#alertModal").modal('hide');
                    },1000)
                }
            }
        });
    }




</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <style type="text/css">
        select {
            min-width: 90px;
        }

        .row {
            margin-top: 10px;
        }
        .textBox{
            overflow:hidden;
            text-overflow:ellipsis;
            white-space:nowrap;
        }
    </style>
</head>
<body>
<div class="wrapper d-flex align-items-stretch">
    <%@ include file="/WEB-INF/views/sidebar/sidebar.jsp"%>
    <!-- Page Content  -->
    <div id="content" class="p-4 p-md-5 pt-5">
        <h2 class="mb-4">결재전 문서</h2>
        <hr>
        <form action="/document/d_searchTemporary.document" method="post">
            <div class="search pb-2">
                <div class="row">
                    <div class="col-2 col-md-2">저장일</div>
                    <div class="col-9">
                        <input type=date class="date ml-1 mr-1" name=startDate>
                        ~
                        <input type=date class="date ml-1 mr-1" name=endDate>
                    </div>
                </div>
                <div class="row">
                    <div class="col-2 mb-2">기안양식</div>
                    <div class="col-3 pl-3">
                        <select class="selectTemplate" name=template id="templateSelect">
                            <option value=0>전체</option>

                                <option value=></option>

                        </select>
                    </div>
                    <div class="selectSearch col-2 mb-3">
                        <select name=searchOption id="searchOption">
                            <option value=title selected>제목</option>
                        </select>
                    </div>
                    <script>
                        $('#templateSelect').val("").prop("selected",true);
                    </script>
                    <div class="col-3 col-sm-2 mb-3 pl-3">
                        <input type=text name=searchText value=>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 text-center">
                        <input type=submit value=조회 >
                    </div>
                </div>
            </div>
        </form>
        <hr>
        <div class="documentList row text-center">
            <div class="col-2"><b>문서번호</b></div>
            <div class="col-2 d-none d-sm-block"><b>양식</b></div>
            <div class="col-4"><b>제목</b></div>
            <div class="col-3 col-sm-2"><b>상신일</b></div>
            <div class="col-3 col-sm-2"><b>완료일</b></div>
        </div>

        <!-- 리스트 출력 부분 -->

            <div class="row text-center">
                <div class="col-2 textBox"><a href="/document/toReadPage.document?seq="></a></div>
                <div class="col-2 d-none d-sm-block textBox"><a href="/document/toReadPage.document?seq="></a></div>
                <div class="col-4 textBox"><a href="/document/toReadPage.document?seq="></a></div>
                <div class="col-3 col-sm-2 textBox"><a href="/document/toReadPage.document?seq="></a></div>
                <div class="col-3 col-sm-2 textBox"><a href="/document/toReadPage.document?seq=></a></div>
            </div>

        <!-- 리스트 출력 부분 -->

        <div class="row">
            <div class="navi col-12 text-center"></div>
        </div>
    </div>
</div>
</body>
</html>
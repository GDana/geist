<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Geist</title>
	<!-- main Css-->
    <link href="${pageContext.request.contextPath}/resources/css/document.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet" />
   	<!-- Bootstrap -->
    <script src="https://cdn.datatables.net/t/bs-3.3.6/jqc-1.12.0,dt-1.10.11/datatables.min.js"></script>
    <link href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" rel="stylesheet" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	<style>
	.form-control{
		width : 28%;
		float : right;
		margin : 5px 4px 5px 4px;
	}
	.app-page-title{
		margin : 0px;
		padding : 50px 0px 10px 0px;
	}
	.dt-button{
		float : right;
		margin : 7px 5px 5px 5px;
	}
	#select-input{
		width : 15%;
	}
	</style>
	<script>
	    $(document).ready(function() {
	    	$('div').removeClass('form-inline');
	    });
    </script>
</head>
<body>

	<%
		request.setCharacterEncoding("UTF-8");
		
	    String contentPage=request.getParameter("contentPage");
	    if(contentPage==null)
	        contentPage="main.jsp";
	    
	    String admin_nav = (String)session.getAttribute("sys");
	    
	  	if(admin_nav == "sys") {
	  		admin_nav="admin-nav.jsp";
	  	}else{
	  		admin_nav="nav.jsp";
	  	}
	%>
	
	<input type="hidden" name="login_no" value="${member.emp_no}">
	
	<div id="header">
		<jsp:include page="topnav.jsp" />
	</div>
    <div id="side">
    	<jsp:include page="<%=admin_nav%>" />
    </div>
    
	<div class="app-container fixed-sidebar fixed-header closed-sidebar">
        <!-- Lower -->
        <div class="app-main">
            <!-- Main page -->
            <div class="app-main-outer">
                    <!-- Main button page -->
                    <div class="app-main_inner">
                        <div class="container-fluid">
                            <div class="container">
                                <!-- Title -->
	                            <div class="app-page-title">
	                                <div class="page-title-heading">
	                                    <i class="pe-7s-master-inverse"></i>
	                                    <h2><sub>사원조회</sub></h2>
	                                    <p>
	                                </div>
	                                <hr class="Geist-board-hr">
	                            </div>
                                <!-- table -->
                                <div class="page-title-wrapper">
                                    <div id="foo-table_wrapper" >
                                        <div class="row">
                                        	<form id="searchForm" action="/empManage" method="get" class="col-sm-12">
											    <button class="btn btn-lg dt-button" id="clear">지우기</button>
											    <button class="btn btn-lg dt-button" id="search">검색</button>
											    <input type="text" name="keyword" value="" class="form-control ">
											    <select name="type" id="select-input" class="form-control">
											        <option value="">선택하세요</option>
											        <option value="N">이름</option>
											        <option value="P">직급</option>
											        <option value="D">부서</option>
											    </select>
											</form>
											<br>
                                            <div class="col-sm-12">
                                                <table id="foo-table" class="table table-bordered dataTable" role="grid"
                                                    aria-describedby="foo-table_info">
                                                    <thead>
                                                        <tr role="row">
                                                            <th class="sorting_asc" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-sort="ascending" aria-label="사원번호: activate to sort column descending"
                                                                style="width: 100px;">사원 번호</th>
                                                            <th class="sorting_asc" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-sort="ascending" aria-label="이름: activate to sort column descending"
                                                                style="width: 300px;">이름</th>
                                                            <th class="sorting_asc" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-sort="ascending" aria-label="직급: activate to sort column descending"
                                                                style="width: 300px;">직급</th>
                                                            <th class="sorting" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-label="입사일: activate to sort column ascending" style="width: 300px;">입사일</th>
                                                            <th class="sorting" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-label="부서: activate to sort column ascending" style="width: 400px;">부서</th>
                                                                <th class="sorting_asc" tabindex="0" aria-controls="foo-table" rowspan="1" colspan="1"
                                                                aria-sort="ascending" aria-label="조회: activate to sort column descending"
                                                                style="width: 100px;">조회</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="table-body">
                                                        
                                                    </tbody>
                                                </table>
                                                
                                                <div class="table-page">
	
												</div><br>
												
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            </div>
        </div>
    </div>

	<div id="footer">
    	<jsp:include page="footer.jsp" />
    </div>
    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/include.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/admin-page.js"></script>
    
</body>
</html>
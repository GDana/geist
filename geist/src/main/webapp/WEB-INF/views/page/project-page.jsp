<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Geist</title>
<!-- main Css-->
<link href="/resources/css/document.css" rel="stylesheet" />
<link href="/resources/css/main.css" rel="stylesheet" />
<!-- Data table-->
<script
	src="http://cdn.datatables.net/1.10.18/js/jquery.dataTables.min.js"></script>
<!-- Bootstrap -->
<script
	src="https://cdn.datatables.net/t/bs-3.3.6/jqc-1.12.0,dt-1.10.11/datatables.min.js"></script>
<link
	href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css"
	rel="stylesheet" crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
<!-- Data button-->
<script
	src="https://cdn.datatables.net/buttons/1.6.1/js/dataTables.buttons.min.js"></script>
<script>
    function showPopupWrite() { window.open("/project/projectWrite", "프로젝트 작성", "width=1200, height=700, left=100, top=50"); }
</script>

<style>
	ul {
		list-style-type : none;
		margin : 0;
		padding : 0;
	}
</style>

</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
	
	    String contentPage=request.getParameter("contentPage");
	    if(contentPage==null)
	        contentPage="main.jsp";
	    
	    String admin_nav = (String)session.getAttribute("adminOk");
		if(admin_nav == null) {
			admin_nav="admin-nav.jsp";
		}else{
			admin_nav="admin-nav.jsp";
		}
	%>

	<div id="header">
		<jsp:include page="topnav.jsp" />
	</div>
	<div id="side">
		<jsp:include page="<%=admin_nav%>" />
	</div>
	<div class="app-container fixed-sidebar fixed-header closed-sidebar">
		<div class="app-main">
			<!-- Side navbar -->

			<!-- Main page -->
			<div class="app-main-outer">
				<!-- Main button page -->
				<div class="app-main_inner">
					<div class="container-fluid">
						<div class="container">
							<!-- Title -->
							<div class="app-page-title">
								<div class="page-title-heading">
									<i class="pe-7s-project-inverse"></i>
									<h1>
										<sub> 프로젝트</sub>
									</h1>
									<p />
								</div>
								<hr class="Geist-board-hr" />
							</div>
							<!-- table -->
							<div class="page-title-wrapper">
								<div id="foo-table_wrapper" class="">
									<div class="row">
										<div class="col-sm-12">

											<table id="foo-table" class="table table-bordered dataTable"
												role="grid" aria-describedby="foo-table_info">
												<thead>
													<tr role="row">
														<th id="ch-row"></th>
														<th class="sorting" tabindex="0" aria-controls="foo-table"
															rowspan="1" colspan="1"
															aria-label="제목: activate to sort column ascending"
															style="width: 1500px;">프로젝트 번호</th>
														<th class="sorting" tabindex="0" aria-controls="foo-table"
															rowspan="1" colspan="1"
															aria-label="제목: activate to sort column ascending"
															style="width: 1500px;">프로젝트 명</th>
														<th class="sorting" tabindex="0" aria-controls="foo-table"
															rowspan="1" colspan="1"
															aria-label="작성날짜: activate to sort column ascending"
															style="width: 600px;">주체기관</th>
														<th class="sorting" tabindex="0" aria-controls="foo-table"
															rowspan="1" colspan="1"
															aria-label="작성날짜: activate to sort column ascending"
															style="width: 200px;">시작일</th>
														<th class="sorting" tabindex="0" aria-controls="foo-table"
															rowspan="1" colspan="1"
															aria-label="작성날짜: activate to sort column ascending"
															style="width: 200px;">종료일</th>
													</tr>
												</thead>
												<tbody id="table-body">
												</tbody>
											</table>
											<div class="pt-2" style="float: right;">
												<button type="button" class="btn btn-sm dt-button"
													id="proWrite" onclick="showPopupWrite();">작성</button>
												<button type="button" class="btn btn-sm dt-button"
													id="proUpdate" onclick="">수정</button>
												<button type="button" class="btn btn-sm dt-button"
													id="proDelete" onclick="">삭제</button>
											</div>
										</div>
										<div class="table-page">
										
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

	<!--js-->
	<script type="text/javascript" src="/resources/js/include.js"></script>
	<script type="text/javascript" src="/resources/js/main.js"></script>
	<script type="text/javascript" src="/resources/js/register.js"></script>
	<script type="text/javascript" src="/resources/js/My-register.js"></script>
	<script type="text/javascript" src="/resources/js/projectPage.js"></script>
	
	</body>
</html>

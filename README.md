<div align="center">
<h1>KIC Campus Final Project</h1>
<img src="https://user-images.githubusercontent.com/35926413/85043691-9aaf2800-b1c7-11ea-8065-aec506086be0.png" style="box-shadow:4px 2px 7px rgba(0,0,0,0.14);">
</div>

<br>

# 목차
- [Geist](#Geist)
- [담당 역할](#담당-역할)
- [담당 기능 설명](#담당-기능-설명)
- [문제해결 과정](#문제해결-과정)
- [느낀점](#느낀점)


<br>
<br>

# Geist
회사의 인사, 근태, 결재, 공지 등의 관리 사이트를 개발한다.

#### 개발 기간
2020.03.09 ~ 2020.06.01

#### 개발 도구
- Frontend : JavaScript, JQuery, Ajax, JSP
- Backend : Java1.8, Spring5, JSP
- DB : Oracle
- Manage : Git

#### 개발 인원
- Frontend : 2명
- Backend : 3명

#### ERD 
![ERD테이블](https://user-images.githubusercontent.com/35926413/85044647-e31b1580-b1c8-11ea-8cf7-5d7af08521c8.jpg)

<br>

[:arrow_up: TOP](#목차) 

<br>
<br>


# 담당 역할
### 마이페이지
- REST 방식의 마이페이지
- 마이페이지 수정 기능 구현
### 주소록
- REST 방식의 주소록 구현
- '이름'으로 검색 기능 추가
### 결재
- REST 방식의 결재 구현
- 결재 문서 생성하면 결재 요청자(발신함), 결재 승인자(수신함)에 동기적 insert 구현
- 복수 선택할 수 있는 승인자들이 모두 승인을 할 경우에 결재 요청자의 발신함의 최종 상태가 '승인'이 되는 로직 구현
### 기타 기능
- 특정 URI로 접근을 막는 Interceptor 적용
- 인라인 뷰를 적용한 페이징 처리
### 기타 역할
- [작업 태스크](https://www.notion.so/gdana/4d802a0693ab44c5ae4b96973ed2189f?v=3a8257579ca24a2391a1345d50d1da04) 및 [팀문서 관리](https://www.notion.so/gdana/warr-ab31674d4f4247ac988a93c04c3fd8fb)
- 전반적인 프론트, 백엔드 이슈 해결


<br>

[:arrow_up: TOP](#목차) 

<br>
<br>

# 담당 기능 설명
### 1. 로그인 세션 체크 및 Interceptor 적용
![1 로그인세션체크](https://user-images.githubusercontent.com/35926413/85046958-1f03aa00-b1cc-11ea-892d-bed464b03aa5.png)
특정 URI로 들어오는 요청을 가로채서 Controller 진입 전 작업인 로그인 세션이 만료되지 않았는지 체크했습니다.

#### 적용기술 
Interceptor

#### 코드
<details>
<summary>LoginController</summary>

```java
package com.geist.login.controller;

@RestController
@RequestMapping("/login/*")
@AllArgsConstructor
@Log4j
public class LoginController {
	private LoginService service;
	
	@PostMapping(value = "/login", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> login(@RequestBody LoginVO vo, HttpServletRequest req){
		log.info("vo : " + vo);
		
		HttpSession session = req.getSession();
		LoginVO login = service.login(vo);
		String result = "";
		String sys = "";
		String position = "";

		if(login == null) {
			session.setAttribute("member", null);
			result = "fail";
		}else {
			position = login.getEmp_position();
			
			if(login.getEmp_no() == 100) {
				sys = "sys";
				result = "success";
				session.setAttribute("sys", sys);
				session.setAttribute("empPosition", login.getEmp_position());
				session.setAttribute("member", login);
			}else if(position.equals("부장")) {
				result = "success";				
				session.setAttribute("empPosition", login.getEmp_position());
				session.setAttribute("member", login);
			}else {
				result = "success";				
				session.setAttribute("empPosition", login.getEmp_position());
				session.setAttribute("member", login);
			}
			log.info("session : " + session);
			
		}
		return new ResponseEntity<String>(result, HttpStatus.OK);
	}
}

```
</details>

<details>
<summary>LoginInterceptor</summary>

```java
package com.geist.login.controller;

@Log4j
public class LoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		if(session.getAttribute("member") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			log.info("로그인하지 않은 사용자가 매핑된 url로 접근!!!!!!");
			return false;
		}else {
			return true;
		}
	}
}

```
</details>

<details>
<summary>servlet-context.xml</summary>

```xml
<!-- interceptor : 인증되지 않은 사용자의 매핑된 url 접근을 막기 위한 기능  -->
<interceptors>
<interceptor>
	<mapping path="/**" />
	<exclude-mapping path="/resources/**" />
	<exclude-mapping path="/login/**" />
	<exclude-mapping path="/idSearch" />
	<exclude-mapping path="/pwSearch" />
	<exclude-mapping path="/register/**" />
	<beans:bean class="com.geist.login.controller.LoginInterceptor" />
</interceptor>
</interceptors>	
```
</details>

<br>

### 2. REST 적용
![3 마이페이지](https://user-images.githubusercontent.com/35926413/85047328-9cc7b580-b1cc-11ea-8c19-c5a645fd5555.png)
REST를 구현할 수 있는 어노테이션 `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping` 중 `@GetMapping`을 사용하여 로그인한 사원의 정보를 읽어왔습니다.

#### 적용기술
`@RestController` 

#### 코드
<details>
<summary>MypageController</summary>

```java
package com.geist.myPage.controller;

@RestController
@RequestMapping("/mypage")
@AllArgsConstructor
public class MypageController {
	private MypageService service;

	@GetMapping(value = "/{emp_no}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<MypageDTO> read(@PathVariable("emp_no") Long emp_no) {
		return new ResponseEntity<>(service.read(emp_no), HttpStatus.OK);
	}
	
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/detail/{emp_no}", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody MypageDTO dto, @PathVariable("emp_no") Long emp_no){
		dto.setEmp_no(emp_no);
		
		return service.modify(dto) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	};	
}
```
</details>

<br>

### 3. 인라인 뷰를 적용한 페이징 처리
![7 결재조회](https://user-images.githubusercontent.com/35926413/85047384-b537d000-b1cc-11ea-81dd-5ced6fabc9eb.png)
특정 사원이 작성한 모든 결재 문서 목록을 가져오는 쿼리로 FROM 절에 사용한 인라인 뷰를 이용하여 내림차순 정렬하고 다시 rownum의 일련번호를 이용해 필요한 페이지의 데이터를 출력하는 쿼리를 작성하여 페이징 처리 했습니다.

#### 적용기술
SQL 인라인뷰

#### 코드
<details>
<summary>AppSearchMapper.xml</summary>

```xml
<!-- 결재 요청 조회 -->	
<select id="reqListWithPaging" resultType="com.geist.approval.domain.ApprovalDTO">
<![CDATA[
	SELECT
		app_no, app_class, app_date, app_title, emp_name, app_status
	FROM
		(
		SELECT /*+ INDEX_DESC(app_request pk_app_request) */
	        appSearch.*, rownum rn
	    FROM (
	        SELECT arq.app_no, a.app_class, to_char(app_date, 'YYYY-MM-DD') app_date, a.app_title, e.emp_name, a.app_status
	        FROM approval a, employee e, app_request arq
	        WHERE 
	            e.emp_no = arq.emp_no   
	            and arq.app_no = a.app_no  
	            and arq.emp_no = #{emp_no}
	        ORDER BY app_no DESC
	        ) appSearch
	    WHERE        
			rownum <= #{cri.pageNum} * #{cri.amount}
	    )
	WHERE rn >  (#{cri.pageNum} - 1) * #{cri.amount}
]]>
</select>	
```
</details>

<br>

### 4. Ajax 통신
3번에서 페이징 처리 한 reqListWithPaging 쿼리를 프론트단에서 Ajax 통신으로 데이터를 가져와 html에 뿌려주었습니다.

#### 적용기술
Ajax, jQuery

#### 코드
<details>
<summary>approval-search.js</summary>

```javascript
var approvalSearchService = (function(){
	function getList(param, callback, error){
		var page = param.page;
		var emp_no = param.emp_no;
		
		$.getJSON("/approvalSearch/" + page + "/" + emp_no + ".json", function(data){
			if(callback){
				callback(data.count, data.list);
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	// 관리자 로그인시 모든 결재 조회
	function getAllList(param, callback, error){
		var page = param.page;
		
		$.getJSON("/approvalSearch/allList/" + page + ".json", function(data){
			if(callback){
				callback(data.count, data.list);
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	return{
		getList : getList,
		getAllList : getAllList
	};
})();

$(document).ready(function() {
	var admin_sys = ($("input[name='admin_sys']").val());
	var emp_no = ($("input[name='login_no']").val());
	var tbody = $(".table-body");
	var tpage = $(".table-page");
	var pageNum = 1;
	
	if(typeof emp_no === 'string'){
		emp_no = parseInt(emp_no);
		console.log("emp_no === " + emp_no);
	}

	// 관리자 로그인시 모든 결재 조회
	function showAllList(page){
		approvalSearchService.getAllList({
			page : page || 1
		}, function(count, list){
			if (page == -1) {
				pageNum = Math.ceil(count / 10.0);
				showList(pageNum);
				return;
			}
			var str = "";
			if(list == null || list.length == 0){
				return;
			}
			
			for(var i = 0, len = list.length || 0; i < len; i++){
				var status = "";
				switch(list[i].app_status){
				case 1:
					status = "처리중";
					break;
				case 2:
					status = "승인";
					break;
				case 3:
					status = "반려";
					break;
				default:
					status = "알 수 없음";
				}
				str += "<tr>";
				str += "<td>" + list[i].app_date + "</td>";
				str += "<td><a href='#'>" + list[i].app_title 
				+ "<input type='hidden' name='app_no' value='" + list[i].app_no + "'>" 
				+ "<input type='hidden' name='app_class' value='" + list[i].app_class + "'></a></td>";
				str += "<td>" + list[i].emp_name + "</td>";
				str += "<td style='background-color:#F5F9FC;'>" + status + "</td>";
				str += "</tr>";
			}
			tbody.html(str);
			showListPage(count);
		});
	}
	
	function showList(page, emp_no){
		approvalSearchService.getList({
			page : page || 1,
			emp_no : emp_no
		}, function(count, list){
			if (page == -1) {
				pageNum = Math.ceil(count / 10.0);
				showList(pageNum);
				return;
			}
			var str = "";
			if(list == null || list.length == 0){
				return;
			}
			
			for(var i = 0, len = list.length || 0; i < len; i++){
				var status = "";
				switch(list[i].app_status){
				case 1:
					status = "처리중";
					break;
				case 2:
					status = "승인";
					break;
				case 3:
					status = "반려";
					break;
				default:
					status = "알 수 없음";
				}
				str += "<tr>";
				str += "<td>" + list[i].app_date + "</td>";
				str += "<td><a href='#'>" + list[i].app_title 
				+ "<input type='hidden' name='app_no' value='" + list[i].app_no + "'>" 
				+ "<input type='hidden' name='app_class' value='" + list[i].app_class + "'></a></td>";
				str += "<td>" + list[i].emp_name + "</td>";
				str += "<td style='background-color:#F5F9FC;'>" + status + "</td>";
				str += "</tr>";
			}
			tbody.html(str);
			showListPage(count);
		});
	}
	
	function showListPage(count) {
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		var prev = startNum != 1;
		var next = false;
		
		console.log(count)

		if (endNum * 10 >= count) {
			endNum = Math.ceil(count / 10.0);
		}
		if (endNum * 10 < count) {
			next = true;
		}

		var str = "<ul class='pagination justify-content-end'>";
	    if(prev){
	        str += "<li class='page-item'><a href='" + (startNum - 1) + "'class='page-link'>Prev</a></li>";
	    }
	    for(var i = startNum; i <= endNum; i++){
	        var linkStart = pageNum != i ? "'><a href='" + i + "'>" : "active'><a href='" + i + "'>";
	        var linkEnd = pageNum != i ? "</a>" : "</a>" ;
	        str += "<li class='page-item " + linkStart + i + linkEnd + "</a></li>";
	    }
	    if(next){
	        str += "<li class='page-item'><a href='" + (endNum + 1) + "'>Next</a></li>";
	    }
	    str += "</ul>";
	    
	    tpage.html(str);
	}
	
    // 관리자 로그인 체크
	if(admin_sys === "sys"){
		console.log("login_sys === " + admin_sys);
		showAllList(1)
	}else{
		console.log("로그인 정보 안 넘어옴")
		showList(1, emp_no);
	}	
	
	tpage.on("click", "li a", function(e) {
		e.preventDefault();

		var targetPageNum = $(this).attr("href");
		pageNum = targetPageNum;

		if(admin_sys === "sys"){
			console.log("login_sys === " + admin_sys);
			showAllList(pageNum)
		}else{
			console.log("로그인 정보 안 넘어옴")
			showList(pageNum, emp_no);
		}		
	});
	
	tbody.on("click", "tr td a", function(e){
		e.preventDefault();	
		
		var app_no = $(this).children().eq(0).val();
		var app_class = $(this).children().eq(1).val();
		var search = "search";

		if(app_class === "1"){
			location.href = "/approval/detail/1?app_no=" + app_no + "&emp_no=" + emp_no + "&whoRu=" + search;
		}else if(app_class === "2"){
			location.href = "/approval/detail/2?app_no=" + app_no + "&emp_no=" + emp_no + "&whoRu=" + search;
		}else if(app_class === "3"){
			location.href = "/approval/detail/3?app_no=" + app_no + "&emp_no=" + emp_no + "&whoRu=" + search;
		}
	});
});
```
</details>

<br>

[:arrow_up: TOP](#목차) 

<br>
<br>

# 문제해결 과정
### 1. 페이징 처리를 위한 인라인뷰
##### 수정전 
`app_no`는 java쪽에서 `년월일시분초`로 결재번호가 생성되기 때문에 order by의 기준을 app_no로 지정했지만 예상했던 결과와는 달리 최신순으로 정렬되지 않은 select한 리스트에서 10개로 잘려지고 DESC 처리만된 결과가 출력되는 문제가 있었습니다.
```sql
SELECT
    app_no, app_class, app_date, app_title, emp_name, app_status
FROM
    (
    SELECT /*+ INDEX_DESC(app_request pk_app_request) */
        rownum rn, arq.app_no, a.app_class, to_char(app_date, 'YYYY-MM-DD') app_date, a.app_title, e.emp_name, a.app_status
    FROM approval a, employee e, app_request arq
    WHERE    
        e.emp_no = arq.emp_no   
        and arq.app_no = a.app_no  
        and arq.emp_no = 106
        and rownum <= 1 * 10
    )
WHERE rn >  (1 - 1) * 10
ORDER BY app_no DESC;
```

##### 수정후
FROM 절에 사용한 인라인 뷰를 이용하여 내림차순 정렬하고 다시 rownum의 일련번호를 이용해 `app_no`가 최신순으로 정렬되지 않았던 문제를 해결했습니다.
```sql
SELECT
    app_no, app_class, app_date, app_title, emp_name, app_status
FROM
    (
    SELECT /*+ INDEX_DESC(app_request pk_app_request) */
        appSearch.*, rownum rn
    FROM (
        SELECT arq.app_no, a.app_class, to_char(app_date, 'YYYY-MM-DD') app_date, a.app_title, e.emp_name, a.app_status
        FROM approval a, employee e, app_request arq
        WHERE 
            e.emp_no = arq.emp_no   
            and arq.app_no = a.app_no  
            and arq.emp_no = 106
        ORDER BY app_no DESC
        ) appSearch
    WHERE        
        rownum <= 1 * 10
    )
WHERE rn >  (1 - 1) * 10;
```

#### 주요 성취
막연히 서브쿼리라고 생각하고 썼던 구문이 FROM 절에 쓰는 서브쿼리인 인라인 뷰라는 것과 인라인 뷰를 하나의 테이블 처럼 사용할 수 있다는 것을 알게됬습니다.

<br>

### 2. 누락기능은 작업태스크에서 관리
![작업현황](https://user-images.githubusercontent.com/35926413/85051668-c1269080-b1d2-11ea-90ad-8f7ea8de895e.png)
모든 구현이 끝났다 생각하고 실행한 테스트마다 "왜 이 기능을 넣지 않았을까?" 하는 누락된 기능과 기능 오류들을 작업태스크에 작성하고 관리했습니다.<br>
[:arrow_upper_right: 작업태스트](https://www.notion.so/gdana/4d802a0693ab44c5ae4b96973ed2189f?v=3a8257579ca24a2391a1345d50d1da04)

#### 주요 성취
경우의 수에 따라 테스트를 진행할 수록 초기 구상에서 뻗어나온 기능들을 설계하지 못한 누락이 발생하면서 설계의 중요성을 알게된 경험이 되었습니다.

<br>
<br>

# 느낀점
원할하지 못한 소통은 협업에 혼선이 올 수 있다는 것을 알게된 팀프로젝트였고, 현업에서 가장 많이 쓰인다는 Spring4(리포지토리 [zerockcode-gupan](https://github.com/GDana/zerockcode-gupan))를 공부한 후 개인프로젝트로 프론트에서 백엔드까지 처음부터 경험해보는 것이 향후 계획입니다.

[:arrow_up: TOP](#목차) 

<br>
<br>

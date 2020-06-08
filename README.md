# KIC Campus Final Project
## GEIST by team mental.warr
[geist 사이트 들어가기](http://3.34.110.36:8080/geist/login)
- 최고관리자 : sys/sys12345
- 부장 : test/123
- 차장 : chajang/chajang
- 과장 : gwajang/gwajang
- 사원 : test2/test2

<br>

## 1. 프로젝트 개요
- 회사의 인사, 근태, 결재, 공지 등의 관리 사이트를 개발한다.

## 2. 개발 도구
- Frontend : JavaScript, JQuery, Ajax, JSP
- Backend : Java, Spring, JSP
- DB : Oracle
- Manage : Git

## 3. 인원 구성
- Frontend : 박동한, 장혜영
- Backend : 김현선, 김호영, 홍예진

## 4. 구현 기능
### 마이페이지
- REST 방식의 마이페이지, 마이페이지 수정 기능 구현
### 주소록
- REST 방식의 주소록 구현
- '이름'으로 검색 기능 추가
### 결재
- REST 방식의 결재 구현
- 결재 문서 생성하면 결재 요청자(발신함), 결재 승인자(수신함)에 동기적 insert 구현
- 복수 선택할 수 있는 승인자들이 모두 승인을 할 경우에 결재 요청자의 발신함의 최종 상태가 '승인'이 되는 로직 구현
### 페이징 처리를 위한 hint 쿼리문
- 원하는 데이터를 빠른 속도로 가져오기 위해 hint 사용하여 페이징 처리

<br>

## 5. 구현 기능 설명
### 페이징 처리를 위한 hint 쿼리문
#### 수정전 
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
`app_no`가 제대로 정렬되지 않은 원상태에서 10개로 잘려지고 이 데이터로 DESC 처리만 된 결과가 출력된다.


#### 수정후
app_request의 pk_app_request는 app_no, emp_no 이므로 hint 구문이 원하는 형태로 출력이 안될 수밖에 없다. 때문에 인라인뷰만 실행된 채로 정렬되었던 문제를 인라인뷰에서 order by 정렬을 하고 만들어진 결과를 hint구문을 이용하여 원하는 데이터를 추출하였다.
![app_request](https://user-images.githubusercontent.com/35926413/84043501-59f22a80-a9e1-11ea-8c0b-6eb615dc3e31.png)

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



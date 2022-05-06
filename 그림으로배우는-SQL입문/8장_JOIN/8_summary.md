# 8장. 테이블을 붙이자

## 8-1. 테이블을 세로로 붙이자 : UNION

### 8-1-1. ~ 8-1-2. UNION, UNION ALL

```sql
-- UNION의 사용법
SELECT *
FROM 테이블A
UNION
SELECT *
FROM 테이블B
```

- 양쪽 테이블의 컬럼 내용은 같아야 함

\*\* 테이블A
| id | pref | age | star |
| :--: | :--: | :--: | :--: |
| 1 | 서울시 | 20 | 2 |
| 2 | 충청도 | 30 | 5 |

\*\* 테이블B
| id | pref | age | star |
| :--: | :--: | :--: | :--: |
| 1 | 서울시 | 10 | 4 |
| 2 | 충청도 | 20 | 3 |

- 컬럼 개수가 같은 두 테이블을 붙일 수 있음
- 테이블 컬럼명이 다른 경우 : 첫 번째 테이블의 컬럼명이 표시 됨
  - 컬럼명이 달라도 컬럼 수만 맞으면 UNION이 가능한 것 같다
- UNION은 중복을 허용하지 않는다 : 완전히 데이터(모든 컬럼 각각의 값)이 같다면 중복으로 취급하여 하나만 표시된다
  - 중복을 허락해서 그대로 붙이려면 UNION ALL을 사용한다
- UNION을 여러번 사용해서 여러개(3개 이상) 테이블을 붙일 수도 있다

### 8-1-3. UNION의 사용법

```sql
SELECT *
FROM inquiry
UNION
(
  SELECT *
  FROM inquiry_2019
  LIMIT 2
)
ORDER BY star
;
```

- 특정 테이블에서만 LIMIT을 사용하고 싶다면 괄호로 감싸고
- UNION한 결과(두개를 붙인 전체 데이터)에서 LIMIT을 사용하고 싶다면 괄호를 감싸지 않으면 된다

```sql
-- UNION 결과에 WHERE 구 붙이기
SELECT *
FROM (
  SELECT *
  FROM inquiry
  UNION
  SELECT *
  FROM inquiry_2019
) AS a
WHERE a.star >= 4;
```

- 서브쿼리로 테이블 처럼 가져와서 마지막에 WHERE 구 적용

#### 테이블을 붙이는 다른 연산자들

- mysql에선 지원하지 않지만 EXCEPT(두 테이블의 차이), INTERSECT(두 테이블의 공통부만)를 지원하는 DB도 있음

## 8-2. 테이블을 가로로 붙이자 : JOIN

- JOIN : 테이블을 붙이기 위해 관련이 있는 것 끼리 레코드를 붙임

```sql
-- JOIN 사용법
FROM 테이블A
JOIN 테이블B
ON 테이블A.컬럼C = 테이블B.컬럼C;
```

- ON구에 테이블끼리 붙이기 위한 조건을 적습니다

#### 간단한 예시

- customer 테이블과 membertype테이블을 JOIN을 이용해서 가로로 붙여보자

\*\* customer 테이블

| customer_id | customer_name |  birthday  | membertype_id |
| :---------: | :-----------: | :--------: | :-----------: |
|      1      |    김바람     | 1984-06-24 |       2       |
|      2      |    이구름     | 1990-07-16 |       1       |
|      3      |    박하늘     | 1976-03-09 |       2       |
|      4      |     강산      | 1991-05-04 |       1       |
|      5      |    유바다     | 1993-04-21 |       2       |

\*\* membertype 테이블

| membertype_id | membertype |
| :-----------: | :--------: |
|       1       | 보통 회원  |
|       2       | 할인 회원  |

```sql
SELECT *
FROM customer AS a
JOIN membertype AS b
ON a.membertype_id = b.membertype_id;
```

| customer_id | customer_name |  birthday  | membertype_id | membertype_id | membertype |
| :---------: | :-----------: | :--------: | :-----------: | :-----------: | :--------: |
|      1      |    김바람     | 1984-06-24 |       2       |       2       | 할인 회원  |
|      2      |    이구름     | 1990-07-16 |       1       |       1       | 보통 회원  |
|      3      |    박하늘     | 1976-03-09 |       2       |       2       | 할인 회원  |
|      4      |     강산      | 1991-05-04 |       1       |       1       | 보통 회원  |
|      5      |    유바다     | 1993-04-21 |       2       |       2       | 할인 회원  |

- JOIN과 상관 서브 쿼리는 비슷하므로 서로 바꿔 쓸 수 있음

#### INNER JOIN

- 테이블A와 테이블B를 붙이는 위 방법은 사실 INNER JOIN(내부 결합)의 생략형
- INNER JOIN은 테이블B에서 조건에 일치하는 레코드가 없는 경우 테이블A의 레코드도 가져오는 대상이 되지 않음

```sql
FROM 테이블A
INNER JOIN 테이블B
ON 조건;
```

#### 다른 JOIN 방법들

- 테이블A엔 존재하지만 테이블B에 존재하지 않는 것도 결합하고 싶다면 OUTER JOIN 등을 사용할 수 있음

\*\* JOIN의 종류

|          JOIN의 종류           |                사용법                |                           의미                           |
| :----------------------------: | :----------------------------------: | :------------------------------------------------------: |
|       INNER JOIN<br>JOIN       |      a INNER JOIN b<br>a JOIN b      |              테이블 a와 테이블b를 내부 결합              |
|  LEFT OUTER JOIN<br>LEFT JOIN  | a LEFT OUTER JOIN b<br>a LEFT JOIN b |  테이블a에 테이블b를 외부 결합<br>(왼쪽의 a테이블 우선)  |
| RIGHT OUTER JOIN<br>RIGHT JOIN | a RIGHT OUTER JOIN<br>a RIGHT JOIN b | 테이블b에 테이블a를 외부 결합<br>(오른쪽의 b테이블 우선) |
|           CROSS JOIN           |            a CROSS JOIN b            |        테이블a와 테이블b의 모든 레코드를 조합한다        |

- 외부결합(OUTER JOIN)이 INNER JOIN과 다른 점은 없어도 NULL로 표시 된다
- RIGHT JOIN의 경우
  - 기준테이블에 없고 비교테이블에만 있어도 기준테이블에 NULL항목으로 JOIN이 된다

```sql
-- LEFT JOIN의 사용법
FROM 테이블A
LEFT JOIN 테이블B
ON 테이블A.컬럼C = 테이블B.컬럼C;
```

```sql
-- LEFT JOIN 예시
SELECT a.customer_id, a.customer_name, b.membertype
FROM customer AS a -- 기준(우선) 테이블
LEFT JOIN membertype AS b -- 비교 테이블
ON a.membertype_id = b.membertype_id;
```

```sql
SELECT a.customer_id, a.customer_name, b.membertype
FROM customer AS a
RIGHT JOIN membertype AS b -- 기준(우선) 테이블
ON a.membertype_id = b.membertype_id;
```

- RIGHT JOIN의 결과 데이터는 LEFT JOIN과 같지만
  - 테이블 표시 순서가 달라짐(b테이블이 앞에 위치함)

#### 자주 사용하는 JOIN은?

- 많지 않으면 LEFT JOIN 후 WHERE에서 조건
- 많으면 INNER JOIN으로 줄이고 시작

#### CROSS JOIN

- 모든 테이블을 조합
  - a : { ...b } 이런식으로 b테이블을 a테이블의 모든 레코드에 다 붙여버림

```sql
-- CROSS JOIN 사용법
FROM 테이블A
CROSS JOIN 테이블B

-- CROSS JOIN 예시
SELECT *
FROM customer
CROSS JOIN membertype;
```

- b테이블의 모든 것을 다 붙이기 때문에 ON구와 조합할 필요가 없음

| customer_id | customer_name |  birthday  | membertype_id | membertype_id | membertype |
| :---------: | :-----------: | :--------: | :-----------: | :-----------: | :--------: |
|      1      |    김바람     | 1984-06-24 |       2       |       1       | 보통 회원  |
|      1      |    김바람     | 1984-06-24 |       2       |       2       | 할인 회원  |
|      2      |    이구름     | 1990-07-16 |       1       |       1       | 보통 회원  |
|      2      |    이구름     | 1990-07-16 |       1       |       2       | 할인 회원  |

- 이런식으로 모든 경우를 다 붙임
  - 위 데이터에 CROSS JOIN은 적절한 예시는 아니지만 사용법을 익히기엔 충분한 예시

## 8-3. 테이블을 가로로 붙이는 방법을 조금 더 자세히

### 8-3-1. JOIN의 실행 순서

- INNER JOIN과 OUTER JOIN은 반드시 테이블끼리 붙이기 위한 조건을 ON 구에 적습니다

```sql
-- JOIN 공통
FROM 테이블A -- 테이블 A에
JOIN 테이블B -- 테이블 B 안에서
ON 결합조건; -- 결합조건에 맞는 것을 붙인다
```

- 작성법과 달리 실행순서는 FROM -> ON -> JOIN 순서

#### 작성법순

SELECT DISTINCT
FROM
JOIN
ON
WHERE
GROUP BY HAVING
ORDER BY LIMIT OFFSET

#### 실행순서

FROM
ON
JOIN
WHERE
GROUP BY HAVING
SELECT DISTINCT
ORDER BY LIMIT OFFSET

```sql
SELECT a.order_id, b.product_name, b.price
FROM prodctorder AS a
LEFT JOIN product AS b
ON a.product_id = b.product_id
WHERE a.price <= 500;
```

```sql
-- 일반 서브쿼리는 메인쿼리보다 먼저 실행 된다
SELECT order_id, price -- 5
FROM productorder -- 4
WHERE price >= ( -- 3
  SELECT AVG(price) -- 2
  FROM productorder -- 1
)
```

### 8-3-2. 조건에 여러 레코드가 일치한다면?

- CROSS JOIN 처럼 일치하는 레코드만큼 레코드 수를 늘려서 모두 표시

```sql
-- 주문 내역을 고객 정보와 LEFT조인, 주문을 여러번 한 경우 여러개 표시
SELECT a.customer_id, a.customer_name, b.order_id
FROM customer AS a
LEFT JOIN productorder AS b
ON a.customer_id = b.customer_id
ORDER BY a.customer_id;
```

| customer_id | customer_name | order_id |
| :---------: | :-----------: | :------: |
|      1      |    김바람     |    7     |
|      1      |    김바람     |    5     |
|      2      |    이구름     |    3     |
|      3      |    박하늘     |    4     |

- 김바람씨는 주문내역이 두 건이 있으므로 두 개 모두 표시

### 8-3-3. 붙이는 테이블을 그 자리에서 만들어도 된다!

#### 기존에 있는 테이블 여러개를 붙일 때

- 테이블을 옆으로 2개 이상 붙이고 싶을 때는 붙이는 테이블 마다 JOIN을 적습니다.

```sql
-- 주문 테이블을 기준으로 고객 테이블에서 customer_name을 가져오고 product테이블에서 product_name을 가져와서 표시
SELECT a.order_id, b.customer_name, c.product_name
FROM productorder AS a
LEFT JOIN customer AS b
ON a.customer_id = b.customer_id
LEFT JOIN product AS c
ON a.product_id = c.product_id;
```

#### 테이블을 만들어서 붙일 때

```sql
SELECT a.customer_id, a.customer_name, b.total
FROM customer AS a
LEFT JOIN (
  SELECT customer_id, SUM(price) AS total
  FROM productorder
  GROUP BY customer_id
) AS b
ON a.customer_id = b.customer_id;
```

### 8-3-4. 결합 조건의 작성법은?

- 여러 조건을 사용하고 싶다면 ON 구에 WHERE에서 조건을 적는 것 처럼 여러개를 적을 수 있음

```sql
FROM 테이블A
JOIN 테이블B
ON 조건1 AND 조건2;
```

```sql
SELECT a.customer_id, a.customer_name, b.order_id, b.price
FROM customer AS a
LEFT JOIN productorder AS b
ON a.customer_id = b.customer_id AND b.price >= 500
ORDER BY b.customer_id;
```

- 붙일 때 기준 테이블엔 있지만 비교 테이블에서 없다면 NULL로 표시 됨

### 8-3-5. ON vs. USING

- ON a.column_id = b.column_id 는 USING (column_id) 로 대체 가능하다
- USING은 간단하게 표현가능하지만 지원하지 않는 DB가 있을 수 있고
  - 비교를 `=`로만 할 수 있다
- USING 뒤의 컬럼명은 반드시 괄호로 감싸줘야 한다

```sql
-- ON과 = 로 JOIN
SELECT a.order_id, b.product_name
FROM productorder AS a
LEFT JOIN product AS b
ON a.product_id = b.product_id;

-- USING을 이용해서 JOIN
SELECT a.order_id, b.product_name
FROM productorder AS a
LEFT JOIN product AS b
USING (product_id);
```

# 8장 연습문제

## 8-1

- 8-1-1, 8-1-2 : skip
- 8-1-3 : 10
- 8-1-4 : 20

## 8-2

### 8-2-1

```sql
(SELECT *
FROM eval_1
WHERE rank_val = 'A')
UNION
(SELECT *
FROM eval_2
WHERE rank_val = 'A' OR rank_val = 'B');
```

- 정답 : UNION 기준으로 괄호를 둘다 넣어 줘야함

### 8-2-2

```sql
-- 풀이
SELECT *, b.student_name
FROM eval_2 AS a
JOIN eval_student AS b
ON a.student = b.student

-- 정답
SELECT a.eval_id, a.student, a.rank_val, b.student_name
FROM eval_2 AS a
JOIN eval_student AS b
ON a.student = b.student;
```

- `*` 대신 다 나열해서 적어줘야되나보다

### 8-2-3

```sql
SELECT a.eval_id, a.student, a.rank_val, b.rank_name
FROM eval_1 AS a
JOIN eval_rank AS b
ON a.rank_val = b.rank_val;
```

### 8-2-4

```sql
SELECT a.eval_id, a.student, a.rank_val, b.student_name, c.rank_name
FROM eval_1 AS a
LEFT JOIN eval_student AS b
ON a.student = b.student
LEFT JOIN eval_rank AS c
ON a.rank_val = c.rank_val;
```

### 8-2-5

```sql
SELECT a.eval_id, a.student, a.rank_val, b.student_name, c.rank_name
FROM eval_1 AS a
LEFT JOIN eval_student AS b
USING (student)
LEFT JOIN eval_rank AS c
USING (rank_val);
```

## 8-3

- 책 참고

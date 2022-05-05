# 7장. SELECT의 안에서 SELECT를 실행하자

## 7-1. 여러 SELECT문을 한번에 실행하자

- SELECT문 안에 SELECT를 넣어서 여러 SELECT문을 한번에 실행

### 7-1-1. 서브 쿼리

- price의 평균값 이상인 레코드를 가져온다

1. 평균을 구한다
2. 구한 평균으로 다시 평균이상인 레코드를 가져온다

```sql
-- 1. 평균을 구한다
SELECT AVG(price)
FROM product;

-- 2. 구한 평균으로 다시 평균이상인 레코드를 가져온다
SELECT order_id, price
FROM product
WHERE price >= 700;
```

위 두 개의 쿼리를 하나로 만들어보자

```sql
SELECT order_id, price
FROM product
WHERE price >= (
  SELECT AVG(price)
  FROM product
);
```

- 서브 쿼리 : SELECT문 안에 적은 다른 SELECT문
- 메인 쿼리 : 가장 바깥쪽에 있는 SELECT문
- 서브쿼리엔 세미콜론(;)을 사용하지 않고 메인쿼리에서만 사용

### 7-1-2. 서브 쿼리는 언제 실행될까?

- 서브쿼리가 먼저 실행 됨 메인쿼리 보다

### 7-1-2. 서브 쿼리는 어디에 적을까?

- WHERE구에 적는 경우가 많지만 WHERE구 이외의 구에 적어도 됨

```sql
-- e.g., SELECT구에 서브 쿼리
SELECT order_id, price, (
    SELECT COUNT(*) -- 서브쿼리를 이용해서 집약함수를 사용한 데이터를 레코드에 포함시킬 수 있다
    FROM product
  ) AS order_count
FROM product
ORDER BY price
LIMIT 3;

-- 아래와 같은 집약함수는 사용할 수 없다
SELECT order_id, price, COUNT(*)
FROM product;
```

- 집약함수를 원래는 SELECT구에서 사용할 수 없지만(레코드 개수가 달라서 데이터가 맞지 않기 때문)
  - 위와 같이 사용하면 사용할 수 있음

```sql
-- HAVING구에 서브쿼리 사용해보기
SELECT customer_id, AVG(price)
FROM product
GROUP BY customer_id
HAVING AVG(price) < (
  SELECT AVG(price)
  FROM product
);
```

- 전체 평균을 구한 뒤
- 그룹화한 것 중에 전체 평균보다 작은 것의 customer_id, 평균 price를 보여줌
- 그룹화(GROUP BY)하고 그것의 평균만 컬럼에 표기하므로 하나로 압축 됨
  - 그런데 전체평균보다 작은 조건이 붙었으므로
  - 전체평균보다 작은 그룹들이 보여짐

| customer_id | AVG(price) |
| :---------: | :--------: |
|      1      |    330     |
|      5      |    650     |

- 전체 평균은 700 이고 700보다 작은 그룹화된 레코드들이 표시 됨

\*\* 메인 쿼리와 서브쿼리에서 사용하는 테이블은 각각 따로여도 문제가 없음

```sql
SELECT customer_id, customer_name
FROM customer
WHERE membertype_id = (
  SELECT membertype_id
  FROM membertype
  WHERE mebertype = '할인 회원'
);
```

### 7-1-4. 서브쿼리의 결과에 대해서 생각해보자

- 한 개의 값을 반환하는 서브쿼리 : 단일행 서브쿼리
- 서브쿼리의 결과로 여러행이 나오는 것 : 복수행 서브쿼리

  - 컬럼도 여러개가 될 수 있음

- 여러행을 반환하는 서브쿼리의 결과는 비교연산자를 사용할 수 없음

## 7-2. 결과가 여러 개가 되는 서브 쿼리

### 7-2-1. 여러 결과를 어떻게 사용할까?

- 서브쿼리의 1컬럼 여러 레코드의 결과를 사용하는 경우

| 연산자 |         사용법          | 의미                                                    |
| :----: | :---------------------: | ------------------------------------------------------- |
|   IN   |     a IN (서브쿼리)     | a가 서브쿼리의 결과 중 어느것에 일치하면 1을 반환한다   |
| NOT IN |   a NOT IN (서브쿼리)   | a가 서브쿼리 결과에 일치하지 않으면 1을 반환            |
|  ANY   | a 연산자 ANY (서브쿼리) | 서브쿼리의 결과 중 어느 것과 a의 연산결과가 1으 반환    |
|  ALL   | a 연산자 ALL (서브쿼리) | 서브쿼리의 결과 전체와 a의 연산결과가 true라면 1을 반환 |

- 서브쿼리의 결과가 여러개 일 때 서브쿼리의 결과에 사용하는 연산자들을 사용하여 조건과(a + 연산자) 비교할 수 있다

```sql
SELECT customer_id, customer_name
FROM customer
WHERE customer_id IN (
  SELECT DISTINCT customer_id
  FROM product
  WHERE price >= 700
);
```

- 서브쿼리 : product테이블에서 price가 700이상인 레코드들의 customer_id를 중복 없이(DISTINCT) 가져온다
- 메인쿼리 : customer테이블에서 customer_id가 서브쿼리의 결과에 포함된 customer_id와 customer_name을 가져온다

```sql
SELECT *
FROM product
WHERE stock < ANY (
  SELECT SUM(quantity)
  FROM product
  GROUP BY product_id
);
```

### 7-2-3. 복수행 서브쿼리에서 주의해야 할 점

#### NULL이 서브쿼리 결과에 없게 하자

- 서브 쿼리의 결과에 NULL이 포함되어 있는 경우
  - 조건에 만족한다면 상관없음
  - IN, ANY 연산자에서 일치하는 것이 없다면 NULL 이 반환됨(원래는 0)
    - NULL을 제외하는 조건을 서브쿼리에 추가함으로써 해결가능

```sql
SELECT *
FROM 테이블명
WHERE 컬럼명 IN (
  SELECT 컬럼명
  FROM 테이블명
  WHERE 컬렴명 IS NOT NULL -- 서브 쿼리의 결과에서 NULL을 제외해 둔다
);
```

#### LIMIT 사용 시 주의 점

```sql
SELECT customer_id, customer_name
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM (
    SELECT customer_id
    FROM product
    ORDER BY price DESC
    LIMIT 3 -- mysql에서 IN과 LIMIT은 같이 사용할 수 없음 -> 서브쿼리를 하나 더 만들어서 IN과 LIMIT이 직접 닿지 않게 함
  ) AS temp
);
```

### 7-2-4. 서브쿼리의 결과가 테이블이 될 때

- 복수행 서브 쿼리의 결과가 복수 컬럼을 갖는 경우
  - 한개의 테이블로 간주
  - FROM에서 사용할 수 있음

```SQL
SELECT AVG(c)
FROM (
  SELECT customer_id, COUNT(*) AS c
  FROM product
  GROUP BY customer_id
) AS a;
```

#### AS는 언제 필요한가요?

복수행 서브 쿼리 결과 등, SELECT문 안에서 사용하는 `일시적인 테이블`에는 AS로 별명을 붙여야 합니다

- AS가 필요한데 붙어있지않으면 : Every derived table must have its own alias

## 7-3. 상관 서브 쿼리

### 7-3-1. 상관 서브 쿼리

- 지금까지 서브쿼리는 메인과 독립적으로 실행되어 메인에서 사용 됨
- 상관 서브쿼리는 메인 쿼리와 연계해서 실행
  - 메인쿼리를 먼저 실행
  - 메인 쿼리의 1레코드마다 서브쿼리를 실행

```sql
SELECT product.product_id, product.product_name
FROM product
WHERE 3 < (
  SELECT SUM(quantity)
  FROM productorder
  WHERE product.product_id = productoder.product_id
);
```

- 서브쿼리는 메인쿼리의 값을 참조
  - 메인쿼리의 값 : product 테이블의 product_id

### 7-3-2. 상관 쿼리의 구조를 알자

- 메인 쿼리는 처음에 FROM구 다음에 WHERE구가 실행
- 상관 서브 쿼리는 WHERE구 안에 있음
- 상관 서브쿼리는 WHERE구에서 메인 쿼리의 1레코드씩 실행 됨

### 7-3-3. 드디어 **관계**가 나왔다

정보를 다른 테이블 컬럼으로 지정하여 양쪽 테이블에 `관계`를 갖게 함

관련된 다른 테이블의 컬럼 : 외부키(Foreign Key)

- product 테이블과 productorder 테이블 모두 customer_id를 가진다면
  - customer_id는 Foreign Key가 될 수 있음

### 7-3-4. 테이블에는 별명을 붙이자

- 간결하게 줄일 수 있음
  - 필요하진 않은 듯

### 7-3-5. 상관 서브 쿼리의 사용법

```sql
SELECT customer.customer_id, productorder.customer_name, (
  SELECT SUM(productorder.price)
  FROM productorder
  WHERE customer.customer_id = productorder.customer_id
) AS total
FROM customer;
```

## 7-3-6. EXISTS 연산자

- 상관 서브 쿼리의 결과에 사용하는 연산자
- 서브쿼리의 결과가 존재하면 1을 반환한다

```sql
SELECT a.product_id, a.product_name
FROM product AS a
WHERE EXISTS (
  SELECT *
  FROM productorder AS b
  WHERE a.product_id = b.product_id
);
```

# 7장 연습문제

## 7-1

### 7-1-1

```sql
-- 틀림 : 집약함수는 WHERE에서 사용할 수 없음(하나로 집약되면 레코드의 개수가 선택한 레코드와 달라지므로)
AVG(height)

-- 정답
SELECT AVG(height) FROM student
```

### 7-1-2

```sql
SELECT MAX(weight) FROM student
```

### 7-1-3

```SQL
-- 풀이 : 정답 (o)
SELECT AVG(c)
FROM (
  SELECT COUNT(*) AS c
  FROM student
  GROUP BY blood_type
) AS a;
```

### 7-1-4

```sql
-- 풀이 == 정답
SELECT student_name, blood_type
FROM student
WHERE blood_type IN (
  SELECT blood_type
  FROM student
  GROUP BY blood_type
  HAVING COUNT(*) = 1
);
```

## 7-2

- 테이블 그리는 건 패스

## 7-3

### 7-3-1

```sql
-- 풀이 - 나중에 실제 데이터로 확인 필요
SELECT student_id, student_name, (
  SELECT COUNT(*)
  FROM student_absence
  GROUP BY student_id
) AS absence
FROM student;

-- 정답
SELECT a.student_id, a.student_name, (
  SELECT COUNT(*)
  FROM student_absence AS b
  WHERE a.id = b.student_id
) AS absence
FROM student AS a;
```

### 7-3-2

```sql
-- 풀이 - 조건이 앞에 있어야 됨
SELECT a.student_id, a.student_name
FROM student AS a
WHERE (
  SELECT COUNT(*)
  FROM student_absence AS b
  WHERE a.id = b.student_id
) >= 2;

-- 정답
SELECT a.student_id, a.student_name
FROM student AS a
WHERE 2 <= (
  SELECT COUNT(*)
  FROM student_absence AS b
  WHERE a.id = b.student_id
);
```

### 7-3-3

```sql
-- 풀이 == 정답
SELECT a.student_id, a.student_name
FROM student AS a
WHERE NOT EXISTS (
  SELECT COUNT(*)
  FROM student_absence AS b
  WHERE a.id = b.student_id
);
```

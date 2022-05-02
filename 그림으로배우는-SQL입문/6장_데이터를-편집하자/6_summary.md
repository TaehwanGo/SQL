# 6장. 데이터를 편집하자

## 6-1. CASE로 조건 분류를 하자

- 지금까진 DB에 있는 데이터 또는 연산자, 집약함수로 계산한 값을 표시하였음
- 각 레코드 데이터를 바탕으로 조건 부류를 해서 전혀 다른 데이터를 표시할 수 있다

### 6-1-1. CASE로 조건 분류해보자

- SELECT문 안에서 조건A인 경우엔 aa를 조건B인 경우엔 bb 와 같은 처리를 할 수 있음

```sql
CASE
  WHEN 조건1 THEN 처리1
  WHEN 조건2 THEN 처리2
  ELSE 처리0
END
```

- ELSE는 없어도 상관없음

### 6-1-2. CASE를 사용해보자

- if문

```SQL
SELECT customer, quantity,
  CASE
    WHEN quantity <= 3 THEN 1000
    WHEN quantity <= 7 THEN 1200
    WHEN quantity <= 10 THEN 1500
    ELSE 2000
  END AS delivery_fee
FROM delivery;
-- CASE문은 길기 때문에 AS로 별명을 붙여서 표시
```

| customer | quantity | delivery_fee |
| :------: | :------: | :----------: |
|   A사    |    5     |     1200     |
|   B사    |    3     |     1000     |
|   C사    |    2     |     1000     |
|   D사    |    8     |     1500     |
|   E사    |    12    |     2000     |

### 또 하나의 CASE문

- 컬럼을 CASE로 두고 그 값을 비교 - switch문이라고 생각하면 될 듯

```SQL
SELECT customer,
  CASE delivery_time
    WHEN 1 THEN '오전'
    WHEN 2 THEN '오후'
    WHEN 3 THEN '야간'
    ELSE '지정 없음'
  END AS delivery_time2
FROM delivery;
```

## 6-2. IF로 조건 분류를 하자

### 6-2-1. IF로 조건 분류해보자

```sql
-- IF 함수의 사용법(Excel의 if와 같음)
-- 일반적인 if - else와 비슷
IF(조건, 조건이 TRUE일 때 반환하는 값, 조건이 FALSE일 때 반환하는 값)
```

### 6-2-2. IF함수를 사용해보자

```sql
SELECT customer, quantity,
  IF(
    quantity > 5, '로켓배송', '기본배송'
  ) AS delivery_method
FROM delivery;
```

- IF문은 길기 때문에 AS로 별명을 붙여서 사용합니다

### IF안에 IF를 적으면?

- 더 자세하게 조건분류를 할 수도 있음
- IF는 mysql 자체 함수이므로 지원이 안되는 DB가 있을 수 있음

### 6-2-4. 조건분류는 어디에서 하지?

- CASE문, IF함수는 WHERE구나 ORDER BY 구에서도 사용할 수 있음

```sql
SELECT *
FROM delivery
ORDER BY
  CASE delivery_time
    WHEN 1 then 3
    WHEN 2 then 1
    WHEN 3 then 2
    ELSE 4
  END;
```

```SQL
SELECT *
FROM newinfo
WHERE
  (
    CASE
      WHEN id < 3 THEN release_date
      WHEN id < 5 THEN register_date
      ELSE release_date
    END
  ) > '2020-02-03';
```

## 6-3. NULL 대응은 어떻게 하지?

- NULL을 연산한 결과는 NULL이 되고
- NULL을 정렬하면 맨 앞이나 맨 뒤가 됨
- NULL을 0 등 다른 값으로 자동으로 변환함으로써 문제를 해결할 수 있음
  - NULL을 0 같은 숫자로 바꾸면 계산결과도 null이 아니고
  - 정렬 시 무시되지 않음

### 6-3-1. NULL 전담 마크 => COALESCE(코어레스) 함수

- COALESCE(인수1, 인수2, 인수3, ..., 인수n)

  - 인수1이 null이면 인수2
  - 인수2가 null이면 인수3
  - ...

- COALESCE(컬럼명, 0)
  - 컬럼 값이 NULL이면 0을 반환한다
  - 컬럼 값이 null이 아니면 컬럼 값을 반환한다

### 6-3-2. COALESCE함수를 실제로 사용해보자

```sql
SELECT
  AVG(COALESCE(star, 0))
FROM inquiry;
```

### 6-3-3. IFNULL함수도 사용할 수 있다

- IFNULL(인수1, 인수2)

  - 인수1이 NULL이 아니면 인수1
  - 인수1이 NULL이면 인수2
  - 인수2가 NULL이면 NULL

- IFNULL(컬렴명, 0)
  - 컬렴 값이 NULL이면 0

```SQL
SELECT *
FROM product
ORDER BY
  IFNULL(price, 999999) ASC;
```

- price컬럼의 값이 null이면 999999를 넣고 오름차순으로 정렬
  - null값인 것들은 맨 뒤로 감

### 6-3-4 NULLIF

- NULLIF(인수1, 인수2)
  - 인수1 == 인수2 => NULL 반환
  - 인수1 != 인수2 => 인수1을 반환
- 사용 예
  - 0으로 나누는 경우를 피하고 싶을 때
  - 0은 평균에서 제외하고 싶을 때

```SQL
SELECT
  AVG(NULLIF(star, 0))
FROM
  inquiry;
```

## 6-4. 데이터형을 변환해보자

```sql
SELECT
  123 + 1,
  '123' + 1,
  '123' + '1';
```

- 위 결과 모두 124 (숫자)가 됨

  - 캐스팅

- 명시적으로 캐스팅하기

```SQL
SELECT
  CAST('123' AS SIGNED) + 1;
```

- CASE함수 안에 AS로 캐스팅
  - SIGNED : 부호 있는 정수

#### 데이터형

- BINARY
- CHAR
- DATE
- DATETIME
- TIME
- DECIMAL
- SIGNED
- UNSIGNED

```sql
SELECT
  CAST('123.45', AS SIGNED),
  CASE('123.45', AS DECIMAL(5, 2));
```

- SIGNED => 123
- DECIMAL => 123.45

\*\* 예약어를 컬럼으로 사용하려면?

- ORDER BY '예약어'

# 6장 연습문제

## 6-1

- 6-1-1

  - apply 테이블에서 apply_id, name 그리고 product_name을 가져오는데
    product_name은 사실 별명이고 product컬럼의 값이 A, B, C에 따라 정해진 문자열이 표시 됨

- 6-1-2
  - age2를 별명으로 표시 - age가 20미만 : 10대 이하, 30 미만 : 20대, 40미만 : 30대, 나머지 : 40대 이상

## 6-2

later

## 6-3

1. 'abc'
2. 1
3. null
4. 1
5. null
6. 2
7. 1.34

- CAST('1.34' AS DECIMAL(5, 3))
  - 1.340

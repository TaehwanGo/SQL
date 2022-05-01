# 5장. 레코드를 정렬해서 가져오자

## 5-1. 레코드를 정렬하자

### 5-1-1. 레코드를 정렬해보자

- 정렬에는 `ORDER BY`를 사용

```sql
SELECT *
FROM product
ORDER BY product_id ASC;
```

- ASC : 오름차순(작은 값에서 큰 값으로)
- DESC : 내림차순(큰 값에서 작은 값으로)
- 날짜의 경우
  - ASC(오름차순) : 오래된 경우(작은 값) -> 최신 날짜(큰 값)
  - DESC(내림차순) : 최신 날짜 -> 오래된 날짜
- ORDER BY + 컬럼 (+정렬순 : ASC or DESC) : 정렬순을 생략하면 자동으로 ASC

### 같은 순위의 레코드는 어떻게 될까?

- 같은 순위 부분의 순서는 정해져 있지 않습니다
- 같은 순위의 것을 거듭 정렬하려면 ORDER BY 구 안에 정렬을 위한 컬럼명을 여러개 지정
  - ORDER BY column1 DESC, column2 ASC, column3 DESC
    - 첫 번째 정렬에서 같은 순위의 부분이 나온 부분만 두 번째 이후에 정렬 함

```sql
SELECT *
FROM product
ORDER BY price ASC, stock DESC;
```

### ORDER BY 구에는 무엇을 지정할 수 있을까?

- 정렬 : sort
- ORDER BY에 이어서 적는 `컬럼명`은 `정렬 키(소트 키)`라고 불립니다
  - SELECT 구에 없는 것도 지정할 수 있음
- 정렬 키에는 SELECT 구에서 지정한 컬럼들 중에서 선택할 수 있음

```sql
SELECT product_name, stock
FROM product
ORDER BY 2 DESC;
```

- SELECT 구에 2번째에 위치한 stock으로 내림차순(DESC) 정렬을 하겠다는 의미
- `*` 인 경우 모든 컬럼을 기준으로 정렬키의 숫자 번째 있는 컬럼으로 정렬
- 정렬 키에 숫자를 지정하는 방식은 사용하지 않는 것이 좋음(가독성)
- 정렬 키엔 함수 또는 연산자를 사용할 수도 있음

```sql
SELECT product_name, stock * price
FROM product
ORDER BY stock * price;
```

- stock \* price의 오름차순(생략하면 오름차순이다)

### 5-1-4. WHERE구나 GROUP BY구와 함께 사용할 수 있다

```sql
SELECT *
FROM product
WHERE stock >= 20
ORDER BY price;
```

```sql
SELECT pref, COUNT(*)
FROM inquiry
GROUP BY pref
ORDER BY COUNT(*);
```

## 5-2. ORDER BY 구의 주의점

### 5-2-1. NULL은 어떻게 될까?

- NULL은 오름차순으로 처음에 오는 경우가 많음
  - 하지만 DB에 따라 마지막에 올 수도 있음
- 보통은 NULL을 0 또는 음수로 바꿔서 앞에 위치시키거나
  반대로 매우 큰 값으로 바꿔서 뒤에 위치시키기도 함
- NULL을 마지막에 가져오기 위한 방법

```sql
SELECT *
FROM product
ORDER BY price IS NULL ASC, price ASC;
```

- IS NULL은 값이 NULL이면 1을 반환
- NULL이 아니면 0을 반환
- 따라서 price값이 NULL이 아닌 레코드들이 앞으로 오고 NULL인 레코드들은 뒤에 배치 됨
- 그 다음 price로 거듭 정렬을 함으로써 NULL값들은 뒤에 배치시키고 나머지 price는 오름차순으로 정렬할 수 있음

### 5-2-2. 조금 바뀐 정렬을 해보자

- NULL을 마지막에 통합하는 방법 처럼 ORDER BY에 조건을 지정함으로써 특정 레코드를 처음이나 마지막에 가져올 수 있습니다
- product 테이블 중에서 price값이 정확히 150인 레코드를 처음에 정렬하고 싶은 경우

```sql
SELECT *
FROM product
ORDER BY price = 150 DESC, price ASC;
```

### 5-2-3. ORDERBY 구의 실행 순서

- 지금까지 공부한 내용 중에선 제일 마지막

```sql
-- 실행 순서
SELECT -- 5
DISTINCT -- 6
FROM -- 1
WHERE -- 2
GROUP BY -- 3
HAVING -- 4
ORDER BY -- 7
```

- SELECT구 다음에 실행 되므로 SELECT 구에서 AS를 사용했더라도 ORDER BY에서 그 별명을 사용할 수 있음
  - AS를 사용한 별명은 따옴표(')로 감싸면 안됨

### 5-2-4. 사전순

- 사전 순 정렬 시 주의 사항
  - 일반적인 테이블을 만들면 utf8_general_ci로 되어있음
  - 각 대조 순서에 따라 정렬이 다름

| utf8_general_ci | utf8_bin | utf8_unicode_ci |
| :-------------: | :------: | :-------------: |
|        1        |    1     |        1        |
|        A        |    A     |        A        |
|        a        |    B     |        a        |
|       ab        |    a     |       ab        |
|        B        |    ab    |        B        |

- 대소 순서의 설정은 특별한 SQL을 실행해서 할 수 있음(이 책에선 설명하지 않음)
  - DB에 설정된 코드 셋에 따라 정렬 순서가 달라질 수 있음

### 5-2-5. 인덱스

ORDER BY구에 의한 정렬 => 부하가 걸리고 처리시간도 길기 때문에 꼭 필요한 경우에만 사용해야 함

- 인덱스를 사용하면 더 빠른 정렬을 시행할 수 있음
- product_id의 위치를 바로 알 수 있는 구조로 되어있음
- 인덱스를 만드는 것은 특별한 SQL을 실행함으로써 할 수 있지만, 이 책에선 설명하지 않음

## 5-3. 레코드를 n행 가져오자

### 5-3-1. 레코드를 처음부터 n행 가져오기

- 가져온 레코드 중, 처음부터 n번째 까지만 가져오는 경우 limit을 사용해서 행수를 지정할 수 있음

```sql
SELECT 컬럼명
FROM 테이블명
LIMIT 행수;
```

```sql
SELECT *
FROM product
ORDER BY price
LIMIT 3;
```

### 5-3-2. 레코드를 n행부터 m행까지 가져오기

```SQL
SELECT 컬럼명
FROM 테이블명
LIMIT 행수
OFFSET 시작위치;
```

- 1번째 행부터 가져오는 경우는 OFFSET 이 `0` 이다

```sql
SELECT *
FROM product
LIMIT 50
OFFSET 50;
```

- 51번째 부터 50개를 가져옴(51~100번째 레코드)

\*\* 주의

- LIMIT과 OFFSET은 MySQL에서만 사용가능하므로 다른 DB에선 예약어가 다를 수 있음

### 5-3-3. LIMIT구와 OFFSET 구의 실행 순서

```sql
-- 실행 순서
SELECT -- 5
DISTINCT -- 6
FROM -- 1
WHERE -- 2
GROUP BY -- 3
HAVING -- 4
ORDER BY -- 7
LIMIT -- 9
OFFSET -- 8
```

# 5장 연습문제

## 5-1

- 5-1-1

  - book테이블에서 모든 컬럼을 가져와서 price를 기준으로 내림차순으로 정렬

- 5-1-2

  - book테이블에서 모든 컬럼을 가져오는데 release_date를 기준으로 오름차순으로 정렬

- 5-1-3
  - book테이블에서 모든 컬럼을 가져와서 price를 기준으로 오름차순으로 정렬 후
    동일우선순위가 있다면 release_date를 기준으로 내림차순으로 한번 더 정렬
    - date는 최신이 먼저나오게 하려면 내림차순(DESC)

## 5-2

### 5-2-1

```sql
SELECT student_id, korean, math, english, SUM(korean+math+english) AS 합계점수
FROM scores
ORDER BY SUM(korean+math+english); -- SUM 대신 합계점수 를 사용해도 됨

-- 정답
SELECT 학번, 국어 + 수학 + 영어 AS 합계 점수
FROM 성적
ORDER BY 합계 점수 DESC;
```

- DESC을 빼먹으면 안된다
- SUM을 사용하지 않아도 되네

### 5-2-2

```SQL
SELECT student_id, english, math
FROM scores
WHERE english >= 80
ORDER BY math ASC;
```

### 5-2-3

```SQL
SELECT student_id, korean
FROM scores
ORDER BY korean DESC
LIMIT 3;
```

## 5-3

30, 10, 10, 30

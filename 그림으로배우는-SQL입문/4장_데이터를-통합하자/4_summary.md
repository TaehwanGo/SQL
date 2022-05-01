# 4장. 데이터를 통합하자

## 4-1. 함수를 사용해서 집계하자

간단한 설문 결과가 들어간 inquiry 테이블을 만듭니다

### 4-1-1. 데이터를 통합하자

| id  |   pref   | age | start |
| :-: | :------: | :-: | :---: |
|  1  | '서울시' | 20  |   2   |
|  2  | '충청도' | 30  |   5   |
|  3  | '경기도' | 40  |   3   |
|  4  | '충청도' | 20  |   4   |
|  5  | '서울시' | 30  |   4   |
|  6  | '서울시' | 20  |   1   |

- `DISTINCT`를 사용하면 같은 데이터를 하나로 정리해 표시할 수 있습니다

```SQL
SELECT DISTINCT pref
FROM inquiry;
```

|  pref  |
| :----: |
| 서울시 |
| 충청도 |
| 경기도 |

- DISTINCT는 SELECT 구 안에서 중복 행을 생략하려는 컬럼명 앞에 적습니다
- inquiry 테이블에서 pref 컬럼을 `중복없이` 가져온다
  - SELECT로 가져오고 그 결과를 통합

### 4-1-2. 함수란?

- 함수 : 어떤 값을 넣으면 특정한 처리를 시행해서 그 결과를 내는 것
  - 함수에 넣는 값 : 인수
  - 함수가 낸 결과 : 반환 값
- 함수는 DBMS의존적인 것이 있다
  - DBMS 종류에 따라 사용할 수 없는 것이 있을 수 있다

```sql
SELECT COUNT(*)
FROM inquiry
```

- `COUNT`는 예약어가 아닌 `함수`
- COUNT 함수 : 인수로 컬럼명을 지정하면 NULL이 아닌 `레코드 수를 반환`
- 함수로 인자를 전달할 때 공백이 있으면 안 됨
  - COUNT( pref ) -> X
  - COUNT(pref) -> O

### 4-1-3. 집약함수를 사용해보자

- 지금까지 SELECT로 가져오면 여러 행(레코드)이었지만 COUNT함수는 1개 뿐이었습니다
  - 이런 함수를 집약 함수 또는 집계 함수라고 부릅니다
- 집약 함수(집계 함수)
  - 데이터를 집약(집계)하고 1개의 결과를 반환합니다

| COUNT(\*) |
| :-------: |
|     6     |

#### 집약함수의 목록

- COUNT : 레코드 또는 컬럼 수
- SUM : 컬럼의 합계 값
- MAX : 컬럼의 최대값 - 문자열은 사전순, 날짜는 최신순
- MIN : 컬럼의 최솟값 - 문자열은 사전순, 날짜는 오래된 순
- AVG : 컬럼의 평균값

### 4-1-4. 집약함수에는 규칙이 있다!

- 집약함수를 적는 곳은 정해져 있다

  - SELECT 구
  - HAVING 구
  - ORDER BY 구

- WHERE에서 사용할 수 없다 !!
- 집약함수는 결과가 하나만 나오므로 여러개의 레코드가 결과로 나오는 것과 같이 선택할 수 없다

  - 틀린 경우 : SELECT MIN(age), star FROM inquiry
    - star는 여러개의 레코드를 결과로 갖고, MIN은 하나만 결과로 가지므로
    - 올바른 데이터가 아니거나 에러를 발생

- 올바른 사용 예

```sql
SELECT COUNT(DISTINCT pref) FROM inquiry
```

- NULL에 주의하자
  - COUNT(\*) null 인 컬럼도 카운트
  - AVG
    - null을 무시하거나 0으로 취급하는 등의 처리 후 계산해야 됨 -> 6장

## 4-2. 데이터를 그룹화하자

### 4-2-1. 그룹화를 해보자

- 레코드를 그룹마다 통합하려면 GROUP BY 구를 사용해서 레코드를 그룹화

```sql
SELECT pref, AVG(star)
FROM inquiry
GROUP BY pref;
```

|  pref  | AGV(star) |
| :----: | :-------: |
| 경기도 |   3.000   |
| 서울시 |   2.333   |
| 충청도 |   4.500   |

- GROUP BY pref; => pref 값으로 그룹화
  - GROUP BY 뒤에 오는 것(예제의 pref)을 `집약 키` 라고 함
  - 집약키가 되는 컬럼에 NULL이 있으면 NULL도 1개의 그룹으로 분류 됨
- AVG(star) => 그룹화한 그룹별로 평균을 구함
- 출력

### 4-2-2. SELECT 구에는 무엇을 지정할 수 있는가?

- 그룹화를 하면 하나로 집약되는데 집약되지 않은 컬럼의 데이터와 같이 출력 될 수 없다

```sql
-- 잘 못된 예시
SELECT pref, age
FROM inquiry
GROUP BY pref;
```

- pref는 그룹화되어 하나로 집약되었는데
- 집약되지 않은 age와 같이 그룹화하여 출력할 수 없다 !

#### 그룹화를 시행했을 때, SELECT 구에 지정할 수 있는 것 3가지

- 상수
- 집약 함수
- 집약 키의 컬럼명

```SQL
SELECT '그룹', pref, COUNT(*) -- 상수, 집약 키의 컬럼명, 집약 함수
FROM inquiry
GROUP BY pref; -- 집약 키
```

### 4-2-3. 여러 집약 키를 지정해보자

```sql
SELECT pref, age, COUNT(*)
FROM inquiry
GROUP BY pref, age;
```

|  pref  | age | COUNT(\*) |
| :----: | :-: | :-------: |
| 경기도 | 40  |     1     |
| 서울시 | 20  |     2     |
| 서울시 | 30  |     1     |
| 충청도 | 20  |     1     |
| 충청도 | 30  |     1     |

- 집약 키가 여러개 인 경우
- 앞쪽에 있는 집약 키 부터 차례대로 그룹화
  - pref 값으로 그룹화 한 것을 다시 age값으로 그룹화
  - 한번 그룹화하고 그것을 다시 그룹화 함

### 4-2-4. GROUP BY는 언제 시행될까?

- WHERE 구가 있는 경우 WHERE 구에서 레코드를 축소한 다음
  GROUP BY가 시행 됨

```sql
SELECT pref, AVG(star)
FROM inquiry
WHERE star >= 3
GROUP BY pref;
```

- 순서 : WHERE -> GROUP BY

## 4-3. 그룹에 조건을 주자

- WHERE로 조건을 주는 것은 전체 레코드에 대한 조건
- HAVING구를 사용해서 그룹화 이후 조건을 줄 수 있음

```sql
-- HAVING의 사용법
SELECT 컬럼명
FROM 테이블명
GROUP BY 컬럼명
HAVING 조건
;

-- 예제
SELECT pref, COUNT(*)
FROM inquiry
GROUP BY pref
HAVING COUNT(*) >= 2;
```

- 그룹화 이후 그룹화한 결과에서 함수를 실행
  - 경기도 그룹의 COUNT(\*)는 1이므로 최종 결과에서 제외 됨

|  pref  | COUNT(\*) |
| :----: | :-------: |
| 서울시 |     3     |
| 충청도 |     2     |

- HAVING 구에 적을 수 있는 것 == 그룹화를 시행했을 때 SELECT 구에 적을 수 있는것
  - 상수
  - 집약 함수
  - 집약 키의 컬럼명
  - HAVING AVG(star) >= 3 : 가능
  - HAVING star >= 3 : 불가능

### 4-3-2. WHERE와 HAVING의 차이

- WHERE : 그룹화 전 레코드 전체에 대한 조건
- HAVING : 그룹에 대한 조건

### 4-3-3. SQL에는 구마다 실행 순서가 있다

```sql
-- 실행 순서
SELECT -- 5
DISTINCT -- 6
FROM -- 1
WHERE -- 2
GROUP BY -- 3
HAVING -- 4
```

- HAVING구 보다 WHERE 구가 먼저 실행
- WHERE에서 레코드 수를 축소함으로써 GROUP BY 구에서 그룹화의 대상이 되는 레코드 수가 줄어들음
- `pref != 서울시` 라는 조건을 WHERE구가 아닌 HAVING구에 적으면 GROUP BY구는 많은 레코드 수인 채로 처리하게 됨
- SELECT문은 되도록 레코드 수를 줄여두는 것이 핵심 !

```sql
-- 착각 하기 쉬운 에러
SELECT pref AS 시도군청
FROM inquiry
GROUP BY 시도군청;
```

- SELECT가 GROUP BY보다 나중에 실행되므로 오류가 발생함 !
  - 문법오류가 사소해서 오류가 발생하지 않더라도 데이터가 맞지 않을 수도 있음 !

## 4장 연습문제

### 4-1

- 4-1-1 : menu 테이블에서 category 컬럼을 가져오는데 중복을 제거
- 4-1-2 : 카테고리 중복 제거하고 그 price까지 가져옴
  - 정답 : 둘다 중복인 것만 제거 됨
- 4-1-3 : 카테고리를 그룹별로 정리하여 가져옴(DISTINCT와 같은 결과일 것으로 추정)

### 4-2

#### 4-2-1

```sql
SELECT COUNT(*)
FROM menu;
```

- o

#### 4-2-2

```sql
SELECT category, MAX(price)
FROM menu
GROUP BY category;
-- HAVING MAX(price); -- 이건 필요 없었음
```

- x

#### 4-2-3

```sql
SELECT category, AVG(price)
FROM menu
GROUP BY category;
-- HAVING AVG(price);
```

- x

#### 4-2-4

```sql
SELECT category, (MAX(price)+MIN(price))/2
FROM menu
GROUP BY category;
-- HAVING (MAX(price)+MIN(price))/2;
```

- x

#### 4-2-5

```sql
-- SELECT category, SUM(price)/COUNT(price)
SELECT category, SUM(price)/COUNT(*)
FROM menu;
-- GROUP BY category
-- HAVING SUM(price)/COUNT(price);
```

- x

### 4-3

- 4-3-1

  - category = 'FOOD'

- 4-3-2

  - category
  - COUNT(\*) - 놓친 부분

- 4-3-3

  - price

- 4-3-4
  - COUNT(\*) > 2
  - category = 'FOOD' - 놓친 부분

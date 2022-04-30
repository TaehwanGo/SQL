# 3장. OO에서 ㅁㅁ인 데이터를 가져오자

## 3-1. 여러 조건을 주자

### 3-1-1. 논리 연산자

#### AND를 사용해보자

조건을 여러개 넣을 때 사용

- AND : &&
- OR : ||
- NOT : !
- XOR : XOR
  - a XOR b
    - a와 b중 어느 한쪽만 1이면 참
    - 둘다 참이거나 둘다 거짓이면 거짓

```sql
SELECT *
FROM product
WHERE price >= 100 AND price < 150 AND stock >= 10
;
```

- 같은 연산자로 연결하는 경우 앞에서 부터 시행

#### OR를 사용해보자

```sql
SELECT *
FROM product
WHERE price < 100 OR price >= 150
;
```

#### NOT을 사용해보자

```sql
SELECT *
FROM custom
WHERE NOT (membertype_id = 1);
```

- custom 테이블에서 `membertype_id 컬럼의 값이 1이 아닌` 조건을 만족하는 모든 데이터(컬럼)을 가져온다

## 3-2. 자주 사용하는 조건의 조합

### 3-2-1. 그 밖에 편리한 연산자를 알아보자

- BETWEEN a AND b : a 이상 b이하인 경우
- NOT BETWEEN a AND b : a이상 b이하가 아닌 경우
- IN (a, b, c) : a, b, c 중 어느 것에 일치하는 경우
- NOT IN (a, b, c) : a, b, c 중 어느 것에 일치하지 않는 경우

### 3-2-2. BETWEEN 연산자를 사용해보자

```sql
SELECT *
FROM product
WHERE price BETWEEN 100 AND 150;
```

- price >= 100 AND price <= 150과 같다
- BETWEEN
  - `최소값 이상 최대값 이하`의 의미(미만 또는 초과가 아님)
- NOT BETWEEN
  - `최소값 미만 또는 최대값 초과`의 의미(포함하지 않음)

BETWEEN은 범위를 지정하는 연산자이므로 날짜 지정에도 자주 사용 됨

```sql
SELECT *
FROM customer
WHERE birthday BETWEEN '1990-01-01' AND '1999-12-31';
```

### IN 연산자를 사용해보자

- 여러 값 중 어느 것과 일치하는 것을 조건으로 하는 경우
  - column = A `OR` column = B `OR` ...
  - 여러개의 OR를 연결하는 대신 `IN`을 사용할 수 있음

```sql
SELECT *
FROM product
WHERE product_id IN (1, 3, 4);
```

- 1 또는 3 또는 4

```sql
-- NOT IN
SELECT *
FROM product
WHERE product_id NOT IN (1, 3, 4);
```

- 1, 3, 4 어느 것과도 일치하지 않는 것
  - 1~6까지 있다면 => 2, 5, 6

## 3-3. 연산자에는 우선순위가 있다

### 3-3-1. 산술 연산자를 사용해보자

- `+`
- `-`
- `*`
- `/` : 나누기
- `%` : 나눈 나머지
- `DIV` : 나눈 몫의 정수부분
- `MOD` : 나눈 나머지

```sql
SELECT *
FROM product
WHERE stock * price >= 5000;
```

### 3-3-2. 연산자 우선순위를 살펴보자

위에 있을 수록 우선순위가 높고 아래 위치할 수록 낮은 것

- `BINARY`
- `!`
- `*`, `/`, `DIV`, `%`, `MOD`
- `-`, `+`
- 비교 : `=`, `<=>`, `>=`, `<=`, `>`, `<`, `<>`, `!=`, `IS`, `LIKE`, `IN`
- `BETWEEN`, `CASE`, `WHEN`, `THEN`, `ELSE`
- `NOT`
- `&&`, `AND`
- `XOR`
- `||`, `OR`
- 괄호를 사용해서 우선순위를 높일 수 있음
  - e.g. : `(1 + 2) * 3`

```sql
SELECT *
FROM product
WHERE (price < 130 OR price > 150) AND stock >= 20;
```

- 괄호가 없다면 AND가 우선순위가 높아서 price > 150 AND stock >= 20 비교한 것과
  price < 130을 OR로 비교하지만
- 괄호를 씌워서 OR연산자의 우선순위를 높힐 수 있음

#### 연산자의 우선 규칙

1. () - 괄호 - 가 최우선
2. 우선 순위는 표에 따른다
3. 우선 순위가 같다면 앞에서 부터 차례대로 시행한다
4. 그냥 괄호를 사용해서 명시적으로 표현하자(모든 우선순위를 외우기 어렵기 때문)

## 3장 연습 문제

#### 문제 1.

- 1-1. 김동현, 김민준
- 1-2. 김민준, 이수민, 박서연
- 1-3. 이민지, 박서연, 김동현, 이수민

#### 문제 2.

- OR
- XOR
- AND, OR, AND

#### 문제 3.

```sql
-- 3-1. 두 개의 AND를 BETWEEN AND로
SELECT *
FROM student
WHERE birthday BETWEEN '1998-01-01' AND '1999-12-31';

-- 3-2. 여러개의 OR를 IN으로
SELECT *
FROM student
WHERE blood_type IN ('A', 'B');
```

- 대소문자 구분 안함

#### 문제 4.

- 3

#### 문제 5.

- 5-1 : 1
- 5-2 : 0
- 5-3 : 0
- 5-4 : 2
- 5-5 : 3

# 1장. SQL로 데이터를 가져오자

## 1. 데이터베이스와 SQL

## 2. 데이터베이스에 액세스하자

## 3. SELECT문으로 데이터를 가져오자

## 4. 컬럼명을 별명으로 해서 가져오자

```sql
SELECT
  product_id AS 상품ID,
  product_name AS 상품명
FROM
  product;
```

- `product_id`을 `상품ID`, `product_name`을 `상품명`으로 별명을 지정하여 가져온다
- 컬렴명을 변경해서 가져올 수 있음(JSON으로 추출해서 전달할 땐 의미 없을 듯?)

#### 기타

- AS는 CREATE VIEW view_name AS select_statement 와 같이 VIEW를 만들 때에도 사용 됨

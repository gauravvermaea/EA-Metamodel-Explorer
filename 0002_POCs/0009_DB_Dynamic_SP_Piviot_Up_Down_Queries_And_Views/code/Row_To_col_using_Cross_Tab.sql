https://onecompiler.com/postgresql/43yhxywvc

CREATE EXTENSION IF NOT EXISTS tablefunc;
CREATE TABLE sales (
    sale_month TEXT,
    product TEXT,
    quantity INT
);

INSERT INTO sales (sale_month, product, quantity) VALUES
('Jan', 'Product_A', 10),
('Jan', 'Product_B', 15),
('Feb', 'Product_A', 12),
('Feb', 'Product_C', 20),
('Mar', 'Product_B', 18),
('Mar', 'Product_C', 25);


SELECT product, sale_month, SUM(quantity)
FROM sales
GROUP BY product, sale_month
ORDER BY 1, 2;


SELECT * FROM crosstab(
  'SELECT product, sale_month, SUM(quantity) FROM sales GROUP BY product, sale_month ORDER BY 1, 2',
  'SELECT DISTINCT sale_month FROM sales ORDER BY 1'
) AS ct (
  product text,
  "Feb" int,
  "Jan" int,
  "Mar" int
);


SELECT * FROM crosstab(
  'SELECT product, sale_month, SUM(quantity) FROM sales GROUP BY product, sale_month ORDER BY 1, 2',
  'SELECT DISTINCT product FROM sales ORDER BY 1'
) AS ct (
  sale_month text,
  "Product_A" int,
  "Product_B" int,
  "Product_C" int
);

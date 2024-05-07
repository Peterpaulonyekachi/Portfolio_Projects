DROP TABLE IF EXISTS courses;

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(60),
    course_author VARCHAR(40),
    course_status VARCHAR(9),
    course_published_dt DATE
);

INSERT INTO courses
    (course_name, course_author, course_status, course_published_dt)
VALUES
    ('Programming using Python', 'Bob Dillon', 'published', '2020-09-30'),
    ('Data Engineering using Python', 'Bob Dillon', 'published', '2020-07-15'),
    ('Data Engineering using Scala', 'Elvis Presley', 'draft', null),
    ('Programming using Scala' , 'Elvis Presley' , 'published' , '2020-05-12'),
    ('Programming using Java' , 'Mike Jack' , 'inactive' , '2020-08-10'),
    ('Web Applications - Python Flask' , 'Bob Dillon' , 'inactive' , '2020-07-20'),
    ('Web Applications - Java Spring' , 'Bob Dillon' , 'draft' , null),
    ('Pipeline Orchestration - Python' , 'Bob Dillon' , 'draft' , null),
    ('Streaming Pipelines - Python' , 'Bob Dillon' , 'published' , '2020-10-05'),
    ('Web Applications - Scala Play' , 'Elvis Presley' , 'inactive' , '2020-09-30'),
    ('Web Applications - Python Django' , 'Bob Dillon' , 'published' , '2020-06-23'),
    ('Server Automation - Ansible' , 'Uncle Sam' , 'published' , '2020-07-05');
	
SELECT *
FROM courses
ORDER BY course_id;

-- GET ALL THE DETAILS OF THE COURSES WHICH ARE 'INACTIVE' OR 'DRAFT' STATE
select * 
from courses 
where course_status in ('draft','inactive')
order by course_id;

--GET ALL THE DETAILS OF THE COURSES WHICH ARE RELATED TO 'PYTHON' OR 'SCALA'
select *
from courses
where course_name like '%Scala%'
OR course_name like '%Python%'
order by course_id;

--GET COUNT OOF COURSES BY COURSE STATUS. THE OUTPUT SHOULD CONTAIN COURSE STATUS AND COURSE COUNT
SELECT count(*) AS course_count,course_status
from courses
group by 2;

--GET COUNT OF 'PUBLISHED' COURSES BY 'COURSE AUTHOR'
select count(course_status),course_author
from courses
where course_status = 'published'
group by 2;

--GET ALL THE DETAILS OF 'PYTHON' OR 'SCALA' RELATED COURSES IN 'DRAFT' STATUS
select course_name, course_id, course_status
from courses
where course_name like '%Scala%'
OR course_name like '%Python%'
group by 2
having course_status = 'draft'
order by course_id;

--GET THE AUTHOR AND COUNT WHERE THE AUTHOR HAVE MORE THAN ONE PUBLISHED COURSE
select count(course_name)as count_course, course_author
from courses
where course_status = 'published'
group by 2
having count(course_name) >1;
--VALIDATE TO CONFIRM THAT THE DATABASE IS SETUP 
SELECT count(*) FROM departments;
SELECT count(*) FROM categories;
SELECT count(*) FROM products;
SELECT count(*) FROM orders;
SELECT count(*) FROM order_items;
SELECT count(*) FROM customers;

select *
from customers;

select *
from orders;

select *
from order_items;

--CUSTOMER ORDER COUNT 
select count(DISTINCT order_customer_id)
from orders
where to_char(order_date, 'yyyy-MM')= '2014-01';


select c.customer_id, c.customer_fname, c.customer_lname, o.order_id ,o.order_date
from orders as o
join customers c on o.order_customer_id = c.customer_id
where to_char(order_date, 'yyyy-MM') = '2014-01'
order by 1 desc
limit 10;

select c.customer_id, c.customer_fname, c.customer_lname, count(*) AS customer_order_count
from orders as o
join customers c on o.order_customer_id = c.customer_id
where to_char(order_date, 'yyyy-MM') = '2014-01'
group by 1,2,3
order by 4 desc, 1
limit 10;

--DORMANT CUSTOMERS

SELECT COUNT(DISTINCT order_customer_id)
FROM orders
WHERE to_char(order_date,'yyyy-MM') = '2014-01';

SELECT COUNT(*)
FROM customers;

--The difference between both queries is the count of dormant customers


SELECT c.*
FROM customers c
	LEFT OUTER JOIN orders o
		ON o.order_customer_id = c.customer_id
			AND to_char(order_date,'yyyy-MM') = '2014-01'
WHERE o.order_customer_id IS NULL
ORDER BY 1
LIMIT 10;


--USING NOT IN
SELECT count(*)
FROM customers c
WHERE c.customer_id NOT IN(
	SELECT o.order_customer_id
	FROM orders o
	WHERE o.order_customer_id = c.customer_id
	AND to_char(order_date,'yyyy-MM') = '2014-01')
ORDER BY 1;
LIMIT 10;
	

--REVENUE PER CUSTOMER
SELECT count(*)
FROM customers;

SELECT c.*
from customers c 
left outer join orders o 
on o.order_customer_id = c.customer_id
and to_char(order_date, 'yyyy-MM') = '2014-01'
and o.order_status in ('COMPLETE','CLOSED')
order by 1
limit 10;


SELECT count(*)
from customers c 
left outer join orders o 
on o.order_customer_id = c.customer_id
and to_char(order_date, 'yyyy-MM') = '2014-01'
and o.order_status in ('COMPLETE','CLOSED')
order by 1
limit 10;

SELECT count(distinct c.customer_id)
from customers c 
left outer join orders o 
on o.order_customer_id = c.customer_id
and to_char(order_date, 'yyyy-MM') = '2014-01'
and o.order_status in ('COMPLETE','CLOSED')
order by 1
limit 10;


select c.customer_id, c.customer_fname, c.customer_lname, 
round(sum(oi.order_item_subtotal)::numeric,2) as customer_revenue
from customers c
left outer join orders o
on o.order_customer_id = c.customer_id
and to_char(order_date,'yyyy-MM')='2014-01'
and o.order_status in ('COMPLETE','CLOSED')
left outer join order_items oi
on o.order_id = oi.order_item_order_id
group by 1,2,3
order by 4 desc, 1
limit 10;


select c.customer_id, c.customer_fname, c.customer_lname, 
coalesce(round(sum(oi.order_item_subtotal)::numeric,2),0) as customer_revenue
from customers c
left outer join orders o
on o.order_customer_id = c.customer_id
and to_char(order_date,'yyyy-MM')='2014-01'
and o.order_status in ('COMPLETE','CLOSED')
left outer join order_items oi
on o.order_id = oi.order_item_order_id
group by 1,2,3
order by 4, 1
limit 10;


--REVENUE PER CATEGORY
select count(*)
from categories;

select c.category_id,c.category_department_id,c.category_name,
round(sum(oi.order_item_subtotal)::numeric,2) as category_revenue
from categories c
join products p
on c.category_id = p.product_category_id
join order_items oi
on p.product_id = oi.order_item_product_id
join orders o
on o.order_id = oi.order_item_order_id
where o.order_status in ('COMPLETE','CLOSED')
and to_char(o.order_date,'yyyy-MM') = '2014-01'
group by 1,2,3
order by 1;

--PRODUCT COUNT PER DEPARTMENT
SELECT*
FROM departments;

SELECT d.*,count(p.*)
FROM departments d
JOIN categories c on d.department_id = c.category_department_id
JOIN products p on c.category_id = p.product_category_id
GROUP BY department_id
ORDER BY department_id;

SELECT*
FROM categories;

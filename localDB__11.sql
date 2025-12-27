create table salespeople(snum number primary key,sname varchar2(20),city varchar2(10),comm decimal(5,2));
insert into salespeople values(1001,'Peel','London', 0.12);
insert into salespeople values(1002,'Serres','San Jose', 0.13);
insert into salespeople values(1003,'AxelRod','New YOrk', 0.10);
insert into salespeople values(1004,'Motika','London', 0.11);
insert into salespeople values(1005,'Fran','London', 0.26);
insert into salespeople values(1007,'Rifkin','Barcelona', 0.15);

create table customers (cnum number primary key, cname varchar2(20),city varchar2(10), rating number, snum number,
Foreign key (snum) references salespeople (snum));
insert into customers values(2001,'Hoffman','London',100,1001);
insert into customers values(2002,'Giovanni','Rome',200,1003);
insert into customers values(2003,'Liu','San Jose',200,1002);
insert into customers values(2004,'Grass','Berlin',300,1002);
insert into customers values(2006,'Clemens','London',100,1001);
insert into customers values(2007,'Pereira','Rome',100,1004);
insert into customers values(2008,'Cisneros','San Jose',300,1007);

create table orders (onum number primary key, Amt decimal(10,2),odate date,cnum number, snum number,
Foreign key (cnum) references customers (cnum),
Foreign key (snum) references salespeople(snum));
insert into orders values(3001,18.69,to_date('10/03/1996','MM/DD/YYYY'),2008,1007);
insert into orders values(3003,767.19,to_date('10/03/1996','MM/DD/YYYY'),2001,1001);
insert into orders values(3002,1900.10,to_date('10/03/1996','MM/DD/YYYY'),2007,1004);
insert into orders values(3005,5160.45,to_date('10/03/1996','MM/DD/YYYY'),2003,1002);
insert into orders values(3006,1098.16,to_date('10/03/1996','MM/DD/YYYY'),2008,1007);
insert into orders values(3009,1713.23,to_date('10/04/1996','MM/DD/YYYY'),2002,1003);
insert into orders values(3007,75.75,to_date('10/04/1996','MM/DD/YYYY'),2002,1003);
insert into orders values(3008,4723.00,to_date('10/05/1996','MM/DD/YYYY'),2006,1001);
insert into orders values(3010,1309.95,to_date('10/06/1996','MM/DD/YYYY'),2004,1002);
insert into orders values(3011,9891.88,to_date('10/06/1996','MM/DD/YYYY'),2006,1001);
select * from orders;

--1. List all the columns of the Salespeople table.
select * from salespeople;
--2. List all customers with a rating of 100.
select * from customers where rating=100;
--3. Find all records in the Customer table with NULL values in the city column.
select * from customers where city is null;
--4. Find the largest order taken by each salesperson on each date.
select snum,odate,max(amt) as max_order from orders group by snum,odate order by snum,odate;
--5. Arrange the Orders table by descending customer number.
select * from orders order by cnum desc;
--6. Find which salespeople currently have orders in the Orders table.
select distinct snum from orders;
--7. List names of all customers matched with the salespeople serving them.
select c.cname as customers_name,s.sname as salespeople_name from customers c join salespeople s on c.snum=s.snum order by cnum;
--8. Find the names and numbers of all salespeople who had more than one customer.
select s.snum,s.sname from salespeople s join customers c on s.snum=c.snum group by s.snum,s.sname having count (c.cnum)>1;
--9. Count the orders of each of the salespeople and output the results in descending order.
select snum,count(onum)as order_count from orders group by snum order by snum desc;
--10. List the Customer table if and only if one or more of the customers in the Customer table are
--located in San Jose.
select * from customers where exists(select 1 from customers where city='San Jose');
--11. Match salespeople to customers according to what city they lived in.
select s.sname,c.cname,s.city from salespeople s join customers c on s.city=c.city;
select sname as salespeople_name,cname as customers_name,s.city as common_city from salespeople s join customers c on s.city=c.city;
--12. Find the largest order taken by each salesperson.
select snum,max(amt) as largest_order from orders group by snum order by snum;
--13. Find customers in San Jose who have a rating above 200.
select * from customers where city='San Jose' and rating >200;
--14. List the names and commissions of all salespeople in London.
select sname,comm from salespeople where city='London';
--15. List all the orders of salesperson Motika from the Orders table.
select * from orders o join salespeople s on o.snum=s.snum where s.sname='Motika';
--16. Find all customers with orders on October 3.
select distinct c.cname,c.cnum,odate from customers c join orders o on c.cnum=o.cnum where o.odate= to_date ('03/10/1996','DD/MM/YYYY') order by c.cnum;
--17. Give the sums of the amounts from the Orders table, grouped by date, eliminating all those
--dates where the SUM was not at least 2000.00 above the MAX amount.
select odate,sum(amt) as total_amt,max(amt) from orders group by odate having sum(amt) >= max(amt) +2000 order by odate;
--18. Select all orders that had amounts that were greater than at least one of the orders from
--October 6.
select * from orders where amt > any (select amt from orders where odate= to_date ('06/10/1996','DD/MM/YYYY'))order by amt desc;
--19. Write a query that uses the EXISTS operator to extract all salespeople who have customers with a
--rating of 300.
select * from salespeople where exists (select 1 from customers where rating = 300 and salespeople.snum=customers.snum);
--20. Find all pairs of customers having the same rating.
select c1.cname as customer1,c2.cname as customer2,c1.rating from customers c1 join customers c2 on c1.rating=c2.rating and c1.cnum > c2.cnum;
--21. Find all customers whose CNUM is 1000 above the SNUM of Serres.
select * from customers where cnum = ( select snum + 1000 from  salespeople where sname='Serres');
--22. Give the salespeople’s commissions as percentages instead of decimal numbers.
select sname,comm*100 as commision_percentage from salespeople;
--23. Find the largest order taken by each salesperson on each date, eliminating those MAX orders
--which are less than $3000.00 in value
select snum,odate,max(amt) as largest_order from orders group by snum,odate having max(amt)>3000 order by snum,odate;
--24. List the largest orders for October 3, for each salesperson.
select snum,max(amt) as largest_order from orders where odate= to_date ('03/10/1996','DD/MM/YYYY')group by snum order by snum;
--25. Find all customers located in cities where Serres (SNUM 1002) has customers.
select cnum,cname,customers.city from customers join salespeople on customers.city=salespeople.city where sname='Serres';
select cnum,cname,c.city from customers c join salespeople s on c.city=s.city where s.sname='Serres' and s.snum =1002;
--26. Select all customers with a rating above 200.00.
select * from customers where rating >200;
--27. Count the number of salespeople currently listing orders in the Orders table.
select  count(distinct snum) as salespeople from orders;
--28. Write a query that produces all customers serviced by salespeople with a commission above
--12%. Output the customer’s name and the salesperson’s rate of commission.
select cname,comm from customers join salespeople on customers.snum=salespeople.snum where comm >0.12;
--29. Find salespeople who have multiple customers.
select sname,count(*) from salespeople join customers on salespeople.snum=customers.snum group by sname having count(*)>1;
--30. Find salespeople with customers located in their city.
select distinct sname,cname,salespeople.city from salespeople join customers on salespeople.SNUM=customers.snum;
--31. Find all salespeople whose name starts with ‘P’ and the fourth character is ‘l’.
select * from salespeople where sname like 'P__l';
--32. Write a query that uses a subquery to obtain all orders for the customer named Cisneros.
--Assume you do not know his customer number.
select * from customers where cnum =(select cnum from customers where cname='Cisneros');
--33. Find the largest orders for Serres and Rifkin.
select sname,max(amt) as lasrgest_order from orders join salespeople on orders.snum=salespeople.snum where sname in ('Serres','Rifkin') 
group by sname order by sname;
--34. Extract the Salespeople table in the following order : SNUM, SNAME, COMMISSION, CITY.
select snum,sname,comm,city from salespeople;
--35. Select all customers whose names fall in between ‘A’ and ‘G’ alphabetical range.
select * from customers where cname between 'A' and 'Gz';
--36. Select all the possible combinations of customers that you can assign.
select c1.cname as customers1,c2.cname as customers2 from customers c1 cross join customers c2;
--37. Select all orders that are greater than the average for October 4.
select * from orders where amt > (select avg(amt) from orders where odate= TO_DATE('1996-10-04', 'YYYY-MM-DD'));
--38. Write a select command using a correlated subquery that selects the names and numbers of all
--customers with ratings equal to the maximum for their city.
select cname,cnum,c.city,rating from customers c where rating =(select max(rating) from customers where city =c.city) order by cnum,city,cname;
--39. Write a query that totals the orders for each day and places the results in descending order.
select odate,sum(amt) as total_daily_amt from orders group by odate order by odate desc;
--40. Write a select command that produces the rating followed by the name of each customer in San
--Jose.
select cname,rating from customers where city='San Jose';
--41. Find all orders with amounts smaller than any amount for a customer in San Jose.
select * from orders where amt < all (select amt from orders where cnum in (select cnum from customers where city ='San Jose')) order by amt desc;
--42. Find all orders with above average amounts for their customers.
select * from orders where amt > (select avg (amt)from orders where cnum=orders.cnum);
--43. Write a query that selects the highest rating in each city.
select city,Max(rating) from customers group by city;
--44. Write a query that calculates the amount of the salesperson’s commission on each order by a
--customer with a rating above 100.00.
select onum,amt as order_amt,comm as commision_rate,rating from orders join salespeople on orders.snum=salespeople.snum join customers on orders.cnum=customers.cnum 
where rating >100 order by onum;
--45. Count the customers with ratings above San Jose’s average.
select count(cnum) as customer_count from customers where rating>(select avg(rating) from customers where city='San Jose');
--46. Write a query that produces all pairs of salespeople with themselves as well as duplicate rows
--with the order reversed.
select a.sname as salesperson1,b.sname as salesperson2 from salespeople a cross join salespeople b  order by salesperson1,salesperson2;
--47. Find all salespeople that are located in either Barcelona or London.
select sname,city from salespeople where city in ('Barcelona','London') order by sname,city;`
--48. Find all salespeople with only one customer.
select s.sname,s.snum from salespeople s join customers c on s.snum=c.snum group by s.sname,s.snum having count(c.cnum)= 1;
--49. Write a query that joins the Customer table to itself to find all pairs of customers served by a
--single salesperson.
select a.cname as customer1,
b.cname as customer2,
a.snum as salesperson_num 
from customers a join customers b on a.snum=b.snum and a.cnum<b.cnum order by salesperson_num,customer1,customer2;
--50. Write a query that will give you all orders for more than $1000.00
select * from orders where amt > 1000;
--51. Write a query that lists each order number followed by the name of the customer who made
--that order.
select onum,cname from orders join customers on orders.cnum=customers.cnum order by onum;
--52. Write 2 queries that select all salespeople (by name and number) who have customers in their
--cities who they do not service, one using a join and one a correlated subquery. Which solution is
--more elegant?
select  distinct s.sname, s.snum from salespeople s join customers c on s.city=c.city where s.snum != c.snum order by s.sname;
select sname,snum from salespeople s where EXISTS(select 1 from customers c where s.city=c.city and s.snum!=c.snum) order by sname;
--53. Write a query that selects all customers whose ratings are equal to or greater than ANY (in the
--SQL sense) of Serres’?
select * from customers where rating >= ANY(select rating from customers where snum =(select snum from salespeople where sname='Serres'));
select * from customers where rating >= ANY(select rating from customers where snum =(select snum from salespeople where sname='Serres'));
--54. Write 2 queries that will produce all orders taken on October 3 or October 4.
select * from orders where odate= to_date ('03/10/1996','DD/MM/YYYY') or odate= to_date ('04/10/1996','DD/MM/YYYY');
select * from orders where odate in (to_date ('03/10/1996','DD/MM/YYYY'), to_date ('04/10/1996','DD/MM/YYYY'));
--55. Write a query that produces all pairs of orders by a given customer. Name that customer and
--eliminate duplicates. 
select distinct onum,cname from orders join customers on orders.cnum=customers.cnum;
SELECT c.cname AS customer_name, a.onum AS order1, b.onum AS order2 FROM   Orders a JOIN Orders b ON a.cnum = b.cnum AND a.onum < b.onum JOIN
Customers c ON a.cnum = c.cnum
ORDER BY customer_name, order1, order2;
--56. Find only those customers whose ratings are higher than every customer in Rome.
select * from customers where rating > ALl(select rating from customers where city ='Rome');
--57. Write a query on the Customers table whose output will exclude all customers with a rating <=
--100.00, unless they are located in Rome.
select * from customers where rating > 100 or city = 'Rome' ;
select * from customers where not (rating <= 100 and city !='Rome');       
--58. Find all rows from the Customers table for which the salesperson number is 1001.
select * from customers where snum=1001;
--59. Find the total amount in Orders for each salesperson for whom this total is greater than the
--amount of the largest order in the table.
select snum,sum(amt) as total_orders from orders group  by snum having sum(amt)> (select max(amt) from orders; 
--60. Write a query that selects all orders save those with zeroes or NULLs in the amount field.
select * from orders  where amt is not null  and amt !=0 order by amt desc;
--61. Produce all combinations of salespeople and customer names such that the former precedes the
--latter alphabetically, and the latter has a rating of less than 200.
select s.sname as salesperson_name,c.cname as customer_name from salespeople s cross join customers c  where S.sname < c.cname  and rating  < 200
ORDER BY salesperson_name, customer_name;;
--62. List all Salespeople’s names and the Commission they have earned.
select sname,comm  from salespeople order by sname;
--63. Write a query that produces the names and cities of all customers with the same rating as
--Hoffman. Write the query using Hoffman’s CNUM rather than his rating, so that it would still be
--usable if his rating changed.
select cname,city from customers where rating =(select rating from customers where cnum=2001) and cname!='Hoffman' order by cname;
--64. Find all salespeople for whom there are customers that follow them in alphabetical order.
select distinct s.sname from salespeople s join customers c on s.sname<c.cname order by s.sname;
--65. Write a query that produces the names and ratings of all customers of all who have above
--average orders.
select distinct  c.cname,c.rating from customers c join  orders o on c.cnum=o.cnum where o.amt >(select Avg(amt) from orders);
--66. Find the SUM of all purchases from the Orders table.
select sum(amt) from orders;
--67. Write a SELECT command that produces the order number, amount and date for all rows in the
--order table.
select onum,amt,odate from orders;
--68. Count the number of not NULL rating fields in the Customers table (including repeats).
select count(rating) as non_null_rating from customers;
--69. Write a query that gives the names of both the salesperson and the customer for each order
--after the order number.
select s.sname as salesperson_name,c.cname as customer_name,o.onum from orders o join salespeople s on o.snum=s.snum join customers c on o.cnum=c.cnum 
order by o.onum;
--70. List the commissions of all salespeople servicing customers in London.
select  distinct s.comm from salespeople s join customers c on s.snum=c.snum where c.city ='London';


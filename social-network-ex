--Q1 Find the names of all students who are friends with someone named Gabriel. 

SELECT DISTINCT name
FROM Highschooler
WHERE ID IN
(
SELECT ID2
FROM Friend
WHERE ID1 IN 
(SELECT ID
FROM Highschooler
WHERE name='Gabriel')
)

--Q2 For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 

SELECT n1,g1,name,grade
FROM
((SELECT name as n1, grade as g1,ID1,ID2
FROM Highschooler 
JOIN Likes ON ID=ID1
) JOIN Highschooler ON Highschooler.ID=ID2) AS temp
WHERE temp.g1-temp.grade>=2

--Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT h1.name, h1.grade, h2.name, h2.grade  
FROM Likes l1, Likes l2, Highschooler h1, Highschooler h2
WHERE l1.ID1=l2.ID2 and l2.ID1=l1.ID2 and l1.ID1=h1.ID and l1.ID2=h2.ID 
and h1.name<h2.name;

--Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 

SELECT name,grade 
FROM Highschooler 
WHERE ID NOT IN (SELECT ID1 FROM Likes UNION SELECT ID2 FROM Likes) 
ORDER BY grade, name

--Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 

select distinct H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Likes, Highschooler H2
where H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and H2.ID not in (select ID1 from Likes)

--Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT name,grade
FROM Highschooler
WHERE ID NOT IN (
SELECT ID1
FROM Highschooler H1, Friend f, Highschooler H2
WHERE H1.ID=f.ID1 AND h2.ID=f.ID2 AND H1.grade<>h2.grade)
ORDER BY grade,name

--Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Likes, Highschooler H2, Highschooler H3,Friend F1,Friend F2
WHERE H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and
  H2.ID not in (select ID2 from Friend where ID1 = H1.ID) and
  H1.ID = F1.ID1 and F1.ID2 = H3.ID and
  H3.ID = F2.ID1 and F2.ID2 = H2.ID;

--Q8 Find the difference between the number of students in the school and the number of different first names. 

select st.sNum-nm.nNum from 
(select count(*) as sNum from Highschooler) as st,
(select count(distinct name) as nNum from Highschooler) as nm;


--Q9 Find the name and grade of all students who are liked by more than one other student. 
select name, grade 
from (select ID2, count(ID2) as numLiked from Likes group by ID2), Highschooler
where numLiked>1 and ID2=ID;

Social Network EXTRAS

--Q1 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT h1.name,h1.grade,h2.name,h2.grade,h3.name,h3.grade
FROM Highschooler h1, Likes l1, Highschooler h2, Likes l2, Highschooler h3
WHERE h1.ID=l1.ID1 AND l1.ID2=h2.ID AND l1.ID2=l2.ID1 AND l2.ID2=h3.ID AND
l2.ID2 <> l2.ID1 AND l1.ID1<>l2.ID2

--Q2 Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

SELECT name,grade
FROM Highschooler
WHERE ID NOT IN
(SELECT h1.ID
FROM Highschooler h1, Friend f1, Highschooler h2
WHERE h1.ID=f1.ID1 AND h2.ID=f1.ID2 AND h2.grade=h1.grade)

--Q3 What is the average number of friends per student? (Your result should be just one number.) 

SELECT SUM(c)*1.0/COUNT(n)
FROM
(SELECT h1.name as n, h1.grade as g,count(*) as c
FROM Highschooler h1, Friend f1, Highschooler h2
WHERE h1.ID=f1.ID1 AND h2.ID=f1.ID2
GROUP BY h1.name,h1.grade
)

--Q4 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT COUNT(*)
FROM
(SELECT h1.name
FROM Friend f1, Friend f2, Highschooler h1, Highschooler h2, Highschooler h3
WHERE f1.ID1=h1.ID AND f1.ID2=h2.ID AND f2.ID1=h2.ID AND f2.ID2=h3.ID AND
(h2.name='Cassandra' or h3.name='Cassandra')
GROUP BY h1.name
)

--Q5 Find the name and grade of the student(s) with the greatest number of friends. 

SELECT n,g
FROM
(SELECT h1.name as n, h1.grade as g,count(*) as c
FROM Highschooler h1, Friend f1, Highschooler h2
WHERE h1.ID=f1.ID1 AND h2.ID=f1.ID2
GROUP BY h1.name,h1.grade
)
WHERE c IN (
SELECT MAX(c)
FROM
(
SELECT h1.name as n, h1.grade as g,count(*) as c
FROM Highschooler h1, Friend f1, Highschooler h2
WHERE h1.ID=f1.ID1 AND h2.ID=f1.ID2
GROUP BY h1.name,h1.grade
)
)


--Modification EX

--Q1 It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 

DELETE FROM Highschooler
WHERE grade=12

--Q2 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

delete from Likes
where ID1 in (
select ID1 from (
select L1.ID1, L1.ID2
from Friend, Likes L1
where Friend.ID1 = L1.ID1
and Friend.ID2 = L1.ID2
except
select L1.ID1, L1.ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2
and L1.ID2 = L2.ID1
)
)

--Q3 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.

insert into Friend
select F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1
-- friends with oneself
and F1.ID1 <> F2.ID2
-- already exist friendship
except
select * from Friend


SQL Exercise

--1 Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie
WHERE director ='Steven Spielberg'

--2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT DISTINCT year
FROM Movie
WHERE Movie.mID IN (SELECT mID FROM Rating WHERE stars=4 or stars=5)
ORDER BY year

--3 Find the titles of all movies that have no ratings.

SELECT title
FROM Movie
WHERE Movie.mID NOT IN (SELECT mID FROM Rating)

--4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT name
FROM Reviewer
WHERE Reviewer.rID IN (SELECT rID FROM Rating WHERE ratingDate is NULL)

--5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewername, then by movie title, and lastly by number of stars.

SELECT DISTINCT name,title,stars,ratingDate
FROM Reviewer,Movie,Rating
WHERE Reviewer.rID=Rating.rID AND Rating.mID=Movie.mID
ORDER BY name,title,stars

--6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT s1.name,s1.title
FROM
(
SELECT DISTINCT name,title,stars,ratingDate
FROM Reviewer,Movie,Rating
WHERE Reviewer.rID=Rating.rID AND Rating.mID=Movie.mID
ORDER BY name,title,stars
) AS s1,
(
SELECT DISTINCT name,title,stars,ratingDate
FROM Reviewer,Movie,Rating
WHERE Reviewer.rID=Rating.rID AND Rating.mID=Movie.mID
ORDER BY name,title,stars
) AS s2
WHERE s1.name=s2.name AND
s1.title=s2.title AND
s1.stars<s2.stars AND
s1.ratingDate <s2.ratingDate

--7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

SELECT title,MAX(stars)
FROM
(
SELECT DISTINCT Rating.mID,Rating.stars
FROM Rating,Movie
WHERE Movie.mID NOT IN (SELECT mID FROM Rating)
) AS sub, Movie
WHERE sub.mID=Movie.mID
GROUP BY Movie.title
ORDER BY Movie.title

--8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

SELECT title,MAX(stars)-MIN(stars) AS spread
FROM
(
SELECT DISTINCT Rating.mID,Rating.stars
FROM Rating,Movie
WHERE Movie.mID NOT IN (SELECT mID FROM Rating)
) AS sub, Movie
WHERE Movie.mID=sub.mID
GROUP BY title
ORDER BY spread DESC,title

--9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT AVG(bf.stars)-AVG(af.stars)
FROM
(
SELECT stars
FROM
(
SELECT Rating.mID,AVG(Rating.stars) AS stars
FROM Rating
GROUP BY mID
) AS sub1,Movie
WHERE sub1.mID=Movie.mID AND Movie.year<'1980'
) as bf,
(
SELECT stars
FROM
(
SELECT Rating.mID,AVG(Rating.stars) AS stars
FROM Rating
GROUP BY mID
) AS sub2,Movie
WHERE sub2.mID=Movie.mID AND Movie.year>'1980'
) as af

--10 Find the names of all reviewers who rated Gone with the Wind.

SELECT DISTINCT name
FROM Reviewer,Rating,Movie
WHERE Reviewer.rID=Rating.rID AND Movie.mID=Rating.mID AND title='Gone with the Wind'

--11 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

SELECT name,title,stars
FROM Reviewer,Rating,Movie
WHERE Reviewer.rID=Rating.rID AND Movie.mID=Rating.mID AND Reviewer.name=Movie.director

--12 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

SELECT name
FROM Reviewer
UNION
SELECT title
FROM Movie

--13 Find the titles of all movies not reviewed by Chris Jackson.

SELECT DISTINCT title
FROM Movie
WHERE Movie.mID NOT IN
(
SELECT mID
FROM Rating,Reviewer
WHERE Reviewer.rID=Rating.rID
AND Reviewer.name='Chris Jackson'
)

--14 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.

SELECT DISTINCT s1.name,s2.name
FROM
(
SELECT name,title
FROM Reviewer,Rating,Movie
WHERE Reviewer.rID=Rating.rID AND Movie.mID=Rating.mID
) AS s1,
(
SELECT name,title
FROM Reviewer,Rating,Movie
WHERE Reviewer.rID=Rating.rID AND Movie.mID=Rating.mID
) AS s2
WHERE s1.title=s2.title AND s1.name<s2.name

--15 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

SELECT name,title,stars
FROM
(
SELECT rID,mID,stars
FROM Rating
WHERE stars IN (SELECT MIN(stars) FROM Rating)
GROUP BY mID
) as sub,Reviewer,Movie
WHERE sub.rID=Reviewer.rID AND sub.mID=Movie.mID

--16 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

SELECT title,AVG(stars)
FROM Movie,Rating
WHERE Movie.mID=Rating.mID
GROUP BY title
ORDER BY AVG(stars) DESC

--17 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

SELECT name
FROM
(
SELECT Rating.rID,COUNT(Rating.rID) AS ct
FROM Rating
GROUP BY rID
) AS sub, Reviewer
WHERE ct=3 AND Reviewer.rID=sub.rID

--18 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

SELECT Movie.title,Movie.Director
FROM
(
SELECT director,COUNT(director) AS ct
FROM Movie
GROUP BY director
)AS sub,Movie
WHERE Movie.director=sub.director AND ct>=2

--19 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

SELECT m.title, avg(r.stars) as strs
FROM Rating r JOIN Movie m on m.mID = r.mID
GROUP BY r.mID
HAVING strs = (SELECT MAX(s.stars) as stars
FROM
(
SELECT mID, avg(stars) as stars
FROM Rating
GROUP BY mID) as s)

--20 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

SELECT m.title, avg(r.stars) as strs
FROM Rating r JOIN Movie m on m.mID = r.mID
GROUP BY r.mID
HAVING strs = (SELECT MIN(s.stars) as stars
FROM
(
SELECT mID, avg(stars) as stars
FROM Rating
GROUP BY mID) as s)

--21 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

SELECT director,title,stars
FROM
(
SELECT director,title, MAX(stars) as stars
FROM Rating r JOIN Movie m on m.mID = r.mID
WHERE m.director is not NULL
GROUP BY m.director)



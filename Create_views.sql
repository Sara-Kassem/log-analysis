--
-- Define the views
--

CREATE VIEW title_by_author AS
	SELECT name, title
	FROM authors JOIN articles
	ON authors.id = articles.author;

CREATE VIEW title_by_views AS
	SELECT articles.title, count (log.path) AS "Number of views"
    FROM articles JOIN log ON log.path = concat('/article/', articles.slug)
    GROUP BY articles.title
    ORDER BY "Number of views" desc;

CREATE VIEW views AS
	SELECT name, title_by_views.title, "Number of views"
    FROM title_by_author JOIN title_by_views
    ON title_by_views.title = title_by_author.title;

CREATE VIEW status AS
	SELECT time::date,
    count (CASE status WHEN '404 NOT FOUND' THEN 1 ELSE NULL END) AS fail,
    count (*) AS total
    FROM log
    GROUP BY time::date;
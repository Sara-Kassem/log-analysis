--
-- Define the views
--

create view titath as select name, title from authors join articles on authors.id = articles.author;

create view titviw as select articles.title, count (log.path) as "Number of views"
    from articles join log on log.path = concat('/article/', articles.slug)
    group by articles.title
    order by "Number of views" desc;

create view views as select name, titviw.title, "Number of views"
    from titath join titviw on titviw.title = titath.title;

create view status as select time::date, count (case status when '200 OK' then 1 else null end) as success,
    count (case status when '404 NOT FOUND' then 1 else null end) as fail,
    count (*) as total from log group by time::date;
--
-- Define the views
--

create view title_by_author as select name, title from authors join articles on authors.id = articles.author;

create view title_by_views as select articles.title, count (log.path) as "Number of views"
    from articles join log on log.path = concat('/article/', articles.slug)
    group by articles.title
    order by "Number of views" desc;

create view views as select name, title_by_views.title, "Number of views"
    from title_by_author join title_by_views on title_by_views.title = title_by_author.title;

create view status as select time::date, count (case status when '200 OK' then 1 else null end) as success,
    count (case status when '404 NOT FOUND' then 1 else null end) as fail,
    count (*) as total from log group by time::date;
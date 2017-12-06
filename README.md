## Introduction
This Project is meant to do **analysis** on a **news database**.

## What can this code do?

- Select the most popular three articles.
- Select the most popular article authors.
- Select days when more than 1% of requests lead to errors.

## Required tools:

- [Python **3.6.3**](https://www.python.org/downloads/release/python-363/).
- [Vagrant **1.9.2**](https://www.vagrantup.com/downloads.html).
- [Oracle VM VirtualBox **5.1.30**](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1).
- [PostgreSQL **9.5.10**](https://www.postgresql.org/download/).
- [newsdata.zip](https://d17h27t6h515a5.cloudfront.net/topher/2016/August/57b5f748_newsdata/newsdata.zip), make sure you **unzip** this file to extract `newsdata.sql`.

## Views used in the program:

**`title_by_author`** contains **author names** and **article titles**.

```sql
CREATE VIEW title_by_author AS
  SELECT name, title
  FROM authors JOIN articles
  ON authors.id = articles.author;
```

**`title_by_views`** contains **article titles** and **Number of views** for each one.

```sql
CREATE VIEW title_by_views AS
  SELECT articles.title, count (log.path) AS "Number of views"
    FROM articles JOIN log ON log.path = concat('/article/', articles.slug)
    GROUP BY articles.title
    ORDER BY "Number of views" desc;
```

**`views`** contains **author names**,  **article titles** and **Number of views** for each one.

```sql
CREATE VIEW views AS
  SELECT name, title_by_views.title, "Number of views"
    FROM title_by_author JOIN title_by_views
    ON title_by_views.title = title_by_author.title;
```

**`status`** contains **date**, **fail**, and **total** requests.

```sql
CREATE VIEW status AS
  SELECT time::date,
  count (CASE status WHEN '404 NOT FOUND' THEN 1 ELSE NULL END) AS fail,
  count (*) AS total
  FROM log
  GROUP BY time::date;
```

## Steps for running:

1. After installing the above links start your prefered **command line**.
2. Change your working directory location to the folder containing  the **python** and **sql** files.
3. Type `vagrant up` in your command line then press **Enter**, this step may take a while if it's running for the first time.
4. When the command line finshes loading type `vagrant ssh`.
5. Use `cd /vagrant` command to change to `vagrant` directory.
6. Type this command `psql -d news -f newsdata.sql` to load the **news** database (**Only done once**).
7. Import the views for the database by typing `psql -d news -f create_views.sql`.
8. Enter `python reporting_tool.py` then press **Enter**.
9. **Done!** you result will show up in the command line.

## Changable Values
- You can change the **number of most popular articles** as wanted, to do so just open the `reporting_tool.py` file using **any text editor**
(code editor is prefered). In the few first lines you will find a **line** similar to this one:

  ```python
  limit = 3
  ```
  just **replace** `3` with any desired value then **save** and run using the **steps** in the section above.
  
- You can change the **percentage** of the **requests that lead to errors**, to do so just open the `reporting_tool.py` file using **any text editor**
(code editor is prefered). At the bottom of the file you will find a **block of code** similar to this one:

  ```python
  c.execute(
      'select time::date, round(100.0* fail / total, 2) as "Error Percentage"'
      ' from status where round(100.0* fail / total, 2) > 1'
      ' order by "Error Percentage" desc'
      )
  ```

  Replace the `1` after the `>` operator in the **second line** with the desired value then **save** and run using the **steps** in the section above.
  In this case the result will be day/s with **percentage of error requests** bigger than your **new value**.
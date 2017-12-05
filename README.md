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
- [newsdata.sql](https://d17h27t6h515a5.cloudfront.net/topher/2016/August/57b5f748_newsdata/newsdata.zip) file.

## Views used in the program:

**`titath`** contains **author names** and **article titles**.

```sql
create view titath as select name, title from authors join articles on authors.id = articles.author;
```

**`titviw`** contains **article titles** and **Number of views** for each one.

```sql
create view titviw as select articles.title, count (log.path) as "Number of views"
    from articles join log on log.path = concat('/article/', articles.slug)
    group by articles.title
    order by "Number of views" desc;
```

**`views`** contains **author names**,  **article titles** and **Number of views** for each one.

```sql
create view views as select name, titviw.title, "Number of views"
    from titath join titviw on titviw.title = titath.title;
```

**`status`** contains **date**, **success**, **fail**, and **total** requests.

```sql
create view status as select time::date, count (case status when '200 OK' then 1 else null end) as success,
    count (case status when '404 NOT FOUND' then 1 else null end) as fail,
    count (*) as total from log group by time::date;
```

**IMPORTANT!**
For the code to work correctly you must copy the codes above into the **bottom** of the **newsdata.sql** file.

**You can copy them as a whole from here**:

```sql
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
```

## Steps for running:

1. After installing the above links and **copying the views code** into the **sql** file, start your prefered **command line**.
2. Change your working directory location to the folder containing  the **python** and **sql** files.
3. Type `vagrant up` in you command line then press **Enter**, this step may take a while if you are running it for the first time.
4. When the command line finshes loading type `vagrant ssh`.
5. Use `cd /vagrant` command to change to `vagrant` directory.
6. Type this command `psql -d news -f newsdata.sql` to load the **news** database (**Only done once**).
7. Enter `python reporting_tool.py` then press **Enter**.
8. **Done!** you result will show up in the command line.

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
  

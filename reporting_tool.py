#!/usr/bin/env python3

import psycopg2
import datetime

# Set the name of the databse

DBNAME = 'news'

# Choose the number of the most popular articles

limit = 3

# Connect to the database

db = psycopg2.connect(database=DBNAME)

c = db.cursor()

# The most popular articles of all time

c.execute(
    'select title, "Number of views" from views'
    )

result = c.fetchall()

# Printing results

print("---------------------------------------------"
      "\n|| The most popular %d articles of all time ||"
      "\n---------------------------------------------" % limit)

# Loop in the results to print them seperately as wanted

for i in range(limit):
    print("%s -- %d views" % (result[i][0], result[i][1]))

# The most popular article authors of all time

c.execute(
    'select name, sum ("Number of views") as "Total Views"'
    ' from views group by name order by "Total Views" desc'
    )

result = c.fetchall()

# Printing results

print("\n--------------------------------------------------"
      "\n|| The most popular article authors of all time ||"
      "\n--------------------------------------------------")

# Loop in the results to print them seperately as wanted

for i in range(len(result)):
    print("%s -- %d views" % (result[i][0], result[i][1]))

# Days with more than 1% of requests lead to errors

c.execute(
    'select time::date, round(100.0* fail / total, 2) as "Error Percentage"'
    ' from status where round(100.0* fail / total, 2) > 1'
    ' order by "Error Percentage" desc'
    )

result = c.fetchall()

# Printing results

print("\n-------------------------------------------------------"
      "\n|| Days with more than 1% of requests lead to errors ||"
      "\n-------------------------------------------------------")

# Loop in the results to print them seperately as wanted

for i in range(len(result)):
    print("%s -- %.2f%% erros" % (result[i][0], result[i][1]))

# Close the database

db.close()

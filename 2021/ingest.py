import psycopg2
import sys

# This script is EXTREMELY insecure, do not run on a database you care about!

fname = sys.argv[1]
tname = fname.split('.')[0]

conn = psycopg2.connect(host='localhost',database='aoc2021',user='wparker')
cur = conn.cursor()

cur.execute('create table {} (id serial primary key, str text)'.format(tname))

with open(fname) as f:
    for line in f:
        cur.execute("insert into {} (str) select '{}'".format(tname, line.strip()))

cur.close()
conn.commit()

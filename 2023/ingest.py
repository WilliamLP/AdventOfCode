import psycopg2
import sys

# This script is EXTREMELY insecure, do not run on a database you care about!

fname = input('Filename?\n')
tname = fname.split('.')[0]

conn = psycopg2.connect(host='localhost', database='aoc2023', user='williamlp', password='williamlp')
cur = conn.cursor()

cur.execute('create table {} (row_num serial primary key, input text)'.format(tname))

with open(fname) as f:
    for line in f:
        cur.execute("insert into {} (input) select '{}'".format(tname, line.rstrip()))

cur.close()
conn.commit()

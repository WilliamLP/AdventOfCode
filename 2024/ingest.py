import psycopg2
import sys

# This script is EXTREMELY insecure, do not run on a database you care about!

tname = input('Filename?\n')

conn = psycopg2.connect(host='localhost', database='aoc2024', user='williamlp', password='williamlp')
cur = conn.cursor()

cur.execute('create table {} (row_num serial primary key, input text)'.format(tname))

with open(tname + '.txt') as f:
    for line in f:
        cur.execute("insert into {} (input) select '{}'".format(tname, line.rstrip()))

cur.close()
conn.commit()

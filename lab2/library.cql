cqlsh> create keyspace library with replication={'class':'SimpleStrategy', 'replication_factor':1};
cqlsh> describe keyspaces;

employee  system       system_distributed  system_traces  system_virtual_schema
library   system_auth  system_schema       system_views 

cqlsh> use library;
qlsh:library> create table lib_info( stud_id int, counter_val counter, stud_name text, book_name text, book_id int, date_of_issue text, primary key(stud_id, stud_name, book_name, book_id, date_of_issue));
cqlsh:library> select * from lib_info;

 stud_id | stud_name | book_name | book_id | date_of_issue | counter_val
---------+-----------+-----------+---------+---------------+-------------

(0 rows)
cqlsh:library> update lib_info set counter_val=counter_val+1 where stud_id=111 and stud_name='Prakash' and book_name='OOMD' and book_id=5121 and date_of_issue='21-9-2019';
cqlsh:library> select * from lib_info;

 stud_id | stud_name | book_name | book_id | date_of_issue | counter_val
---------+-----------+-----------+---------+---------------+-------------
     111 |   Prakash |      OOMD |    5121 |     21-9-2019 |           1

(1 rows)
cqlsh:library> update lib_info set counter_val=counter_val+1 where stud_id=112 and stud_name='Suhas' and book_name='BDA' and book_id=5122 and date_of_issue='12-9-2019';
cqlsh:library> update lib_info set counter_val=counter_val+1 where stud_id=112 and stud_name='Suhas' and book_name='BDA' and book_id=5122 and date_of_issue='31-7-2019';
cqlsh:library> select * from lib_info;

 stud_id | stud_name | book_name | book_id | date_of_issue | counter_val
---------+-----------+-----------+---------+---------------+-------------
     111 |   Prakash |      OOMD |    5121 |     21-9-2019 |           1
     112 |     Suhas |       BDA |    5122 |     12-9-2019 |           1
     112 |     Suhas |       BDA |    5122 |     31-7-2019 |           1

(3 rows)
qlsh:library> update lib_info set counter_val=counter_val+1 where stud_id=112 and stud_name='Suhas' and book_name='BDA' and book_id=5122 and date_of_issue='31-7-2019';
cqlsh:library> select * from lib_info;

 stud_id | stud_name | book_name | book_id | date_of_issue | counter_val
---------+-----------+-----------+---------+---------------+-------------
     111 |   Prakash |      OOMD |    5121 |     21-9-2019 |           1
     112 |     Suhas |       BDA |    5122 |     12-9-2019 |           1
     112 |     Suhas |       BDA |    5122 |     31-7-2019 |           2

(3 rows)
cqlsh:library> copy lib_info(stud_id, stud_name, book_name, book_id, date_of_issue, counter_val) to 'BDA/Lab1/lib_info.csv';
Using 1 child processes

Starting copy of library.lib_info with columns [stud_id, stud_name, book_name, book_id, date_of_issue, counter_val].
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row/s
cqlshlib.copyutil.ExportProcess.write_rows_to_csv(): writing row
Processed: 3 rows; Rate:      18 rows/s; Avg. rate:       1 rows/s
3 rows exported to 1 files in 4.358 seconds.
cqlsh:library> copy lib_info(stud_id, stud_name, book_name, book_id, date_of_issue, counter_val) from 'BDA/Lab1/lib_info.csv';
Using 1 child processes

Starting copy of library.lib_info with columns [stud_id, stud_name, book_name, book_id, date_of_issue, counter_val].
Processed: 3 rows; Rate:       1 rows/s; Avg. rate:       1 rows/s
3 rows imported from 1 files in 2.152 seconds (0 skipped).
cqlsh:library> select * from lib_info;

 stud_id | stud_name | book_name | book_id | date_of_issue | counter_val
---------+-----------+-----------+---------+---------------+-------------
     111 |   Prakash |      OOMD |    5121 |     21-9-2019 |           2
     112 |     Suhas |       BDA |    5122 |     12-9-2019 |           2
     112 |     Suhas |       BDA |    5122 |     31-7-2019 |           4

(3 rows)

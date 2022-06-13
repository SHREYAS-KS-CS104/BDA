cqlsh> create keyspace employee with replication = {'class':'SimpleStrategy', 'replication_factor': 1};
cqlsh> describe keyspaces

employee  system_auth         system_schema  system_views         
system    system_distributed  system_traces  system_virtual_schema

cqlsh> use employee
   ... ;
cqlsh:employee> create table employee_info(
            ... emp_id int primary key,
            ... emp_name text,
            ... designation text,
            ... date_of_joining text,
            ... salary int,
            ... dept text);
cqlsh:employee> begin batch
            ... insert into employee_info(emp_id, emp_name, designation, date_of_joining, salary, dept) values (120, 'Suhas', 'Assistant', '28-3-2000', 20000, 'HR');
            ... insert into employee_info(emp_id, emp_name, designation, date_of_joining, salary, dept) values (121, 'Rahul', 'Associate', '31-7-2000', 35000, 'HR');
            ... insert into employee_info(emp_id, emp_name, designation, date_of_joining, salary, dept) values (122, 'Ramesh', 'Director', '1-2-1996', 135000, 'Administration');
            ... apply batch
            ... ;
cqlsh:employee> describe table employee_info;

CREATE TABLE employee.employee_info (
    emp_id int PRIMARY KEY,
    date_of_joining text,
    dept text,
    designation text,
    emp_name text,
    salary int
) WITH additional_write_policy = '99p'
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | salary
--------+-----------------+----------------+-------------+----------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh | 135000
    121 |       31-7-2000 |             HR |   Associate |    Rahul |  35000

(3 rows)
cqlsh:employee> update employee_info set emp_name='Prabhas' ,dept='Administration' where emp_id=121;
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | salary
--------+-----------------+----------------+-------------+----------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |  35000

(3 rows)
cqlsh:employee> alter table employee_info add projects set<text>;
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | projects | salary
--------+-----------------+----------------+-------------+----------+----------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas |     null |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh |     null | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |     null |  35000

(3 rows)
cqlsh:employee> update employee_info set projects={'Hotel Management', 'Student Resource Management'} where emp_id = 120;
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | projects                                            | salary
--------+-----------------+----------------+-------------+----------+-----------------------------------------------------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas | {'Hotel Management', 'Student Resource Management'} |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh |                                                null | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |                                                null |  35000

(3 rows)
cqlsh:employee> update employee_info set projects={'Visualisation tool'} where emp_id=121;
cqlsh:employee> update employee_info set projects={'System debugger'} where emp_id=122;
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | projects                                            | salary
--------+-----------------+----------------+-------------+----------+-----------------------------------------------------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas | {'Hotel Management', 'Student Resource Management'} |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh |                                 {'System debugger'} | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |                              {'Visualisation tool'} |  35000

(3 rows)
cqlsh:employee> insert into employee_info(emp_id, emp_name, date_of_joining, designation, dept, salary, projects) values(123, 'Prakash', '4-10-2014', 'Associate', 'HR', 60000, {'Nakumora Company Deal'}) using ttl 15;
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | projects                                            | salary
--------+-----------------+----------------+-------------+----------+-----------------------------------------------------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas | {'Hotel Management', 'Student Resource Management'} |  20000
    123 |       4-10-2014 |             HR |   Associate |  Prakash |                           {'Nakumora Company Deal'} |  60000
    122 |        1-2-1996 | Administration |    Director |   Ramesh |                                 {'System debugger'} | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |                              {'Visualisation tool'} |  35000

(4 rows)
cqlsh:employee> select * from employee_info;

 emp_id | date_of_joining | dept           | designation | emp_name | projects                                            | salary
--------+-----------------+----------------+-------------+----------+-----------------------------------------------------+--------
    120 |       28-3-2000 |             HR |   Assistant |    Suhas | {'Hotel Management', 'Student Resource Management'} |  20000
    122 |        1-2-1996 | Administration |    Director |   Ramesh |                                 {'System debugger'} | 135000
    121 |       31-7-2000 | Administration |   Associate |  Prabhas |                              {'Visualisation tool'} |  35000

(3 rows)

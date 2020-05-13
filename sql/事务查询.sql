#查看事务相关信息，信息太杂一般不用
SHOW ENGINE INNODB STATUS;
#查看本连接的连接id
SELECT CONNECTION_ID();
#查看用户的连接信息
SHOW PROCESSLIST;
#同上
SELECT * from information_schema.`PROCESSLIST` where DB='uretaildata' and id =1277124;
#查看事务锁相关信息
SELECT * FROM information_schema.INNODB_TRX;
select * from information_schema.innodb_locks;
select * from information_schema.innodb_lock_waits;

#查看历史数据
SELECT * from performance_schema.events_statements_history where thread_id=1309015;

kill 1277124;

#查询当前连接事务信息，简略版
SELECT
    a.id,
    a. USER,
    a. HOST,
    a. DB,
    b.trx_started,
    b.trx_query
FROM
    information_schema. PROCESSLIST a
RIGHT OUTER JOIN information_schema.innodb_trx b ON a.id = b.trx_mysql_thread_id where a.DB='uretaildata';
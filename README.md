
# FMDB参考链接：https://www.jianshu.com/p/7958d31c2a97
1.什么是FMDB
iOS中使用C语言函数对原生SQLite数据库进行增删改查操作，复杂麻烦，于是，就出现了一系列将SQLite API封装的库，如FMDB
FMDB是针对libsqlite3框架进行封装的三方，它以OC的方式封装了SQLite的C语言的API，使用步骤与SQLite相似
FMDB的优点是：
(1) 使用时面向对象，避免了复杂的C语言代码
(2) 对比苹果自带的Core Data框架，更加轻量级和灵活
(3) 提供多线程安全处理数据库操作方法，保证多线程安全跟数据准确性
FMDB缺点：
(1) 因为是OC语言开发，只能在iOS平台上使用，所以实现跨平台操作时存在限制性
FMDB 在Git上的下载链接地址：https://github.com/ccgus/fmdb
2.主要类型
FMDatabase：一个FMDatabase对象代表一个单独的SQLite数据库，通过SQLite语句执行数据库的增删改查操作
FMResultSet：使用FMDatabase对象查询数据库后的结果集
FMDatabaseQueue：用于多线程操作数据库，它保证线程安全
3.FMDB使用方式
(1) GItHub中下载FMDB，将文件导入工程中
(2) 导入libsqlite3.0框架，导入头文件FMDatabase.h
(3)  创建数据库路径，创建数据库，操作前开启数据库，构建操作SQLite语句，数据库执行增删改查操作，操作完关闭数据库

# MySQL 数据类型：https://www.runoob.com/mysql/mysql-data-types.html



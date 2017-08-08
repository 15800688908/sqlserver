1.查询“111”课程比“112”课程成绩高的所有学生的学号
/*子查询版本*/
select a.S# 
from (select t1.S#,t1.SCORE from sc t1 where t1.C#=111) a
inner join (select t2.S#,t2.SCORE from sc t2 where t2.C#=112) b
	on a.S#=b.S#
where a.SCORE>b.SCORE;

/*EXISTS版本*/
select t1.S# 
from sc t1 
where t1.C#=111
 and exists (
			select 1 
			from sc t2 
			where t2.C#=112 
			and t1.S#=t2.S# --要求同一个学生
			and t1.SCORE>t2.SCORE);
2、查询平均成绩大于60分的同学的学号和平均成绩；
select t1.S# as ST_CODE,
		AVG(t1.SCORE) as CU_AVG
from sc t1
group by t1.S#
  having AVG(t1.SCORE)>60
3、查询所有同学的学号、姓名、选课数、总成绩；
/*group by的时候要注意选出来的字段是不是都是聚合函数或者分组的字段*/
select t1.S# as ST_CODE,
	MIN(t1.SNAME) as ST_NAME,
	COUNT(t2.C#) as CU_NUM,
	SUM(t2.SCORE) as CU_SUM
from student t1
left join sc t2
 on t1.S#=t2.S#
group by t1.S#
4、查询姓“李”的老师的个数；
select COUNT(t1.T#) as 李_NUM
from teacher t1
where t1.TNAME like 'li%'
5、查询没学过'陈奕迅'老师课的同学的学号、姓名；
/*一对多记得用distinct并且要考虑是不是要做一个子查询*/
/*当正面考虑比较困难的时候就要反方向考虑问题*/
select student.S#,student.SNAME
from student
where S# not in(
		select distinct(sc.S#) from sc,course,teacher 
		where sc.C#=course.C# and teacher.T#=course.T# and teacher.TNAME='chenyixun');


/*EXISTS版*/
select t5.S# as ST_CODE,
	   t5.SNAME as ST_NAME
from student t5
where not exists(
				select 1
				from (
					select distinct t1.S# as ST_CODE,
									t1.SNAME as ST_NAME,
									t4.TNAME
					from student t1
					left join sc t2
						on t1.S#=t2.S#
					left join course t3
						on t2.C#=t3.C#
					left join teacher t4
						on t3.T#=t4.T#
					where t4.TNAME='chenyixun'
					) as t
				where ST_CODE=t5.S#
				)
/*子查询版*/
/*select t5.S# as ST_CODE,
	   t5.SNAME as ST_NAME
from student t5
where t5.S# exists (
				select 1
				from(
					 SELECT DISTINCT t1.S# AS ST_CODE,
                                          t1.SNAME AS ST_NAME,
                                          t4.TNAME
                          FROM student t1
                          LEFT JOIN sc t2
                            ON t1.S# = t1.S#
                          LEFT JOIN course t3
                            ON t2.C# = t3.C#
                          LEFT JOIN teacher t4
                            ON t3.T# = t4.T#
                          WHERE t4.TNAME = '陈奕迅'
                         )
                   WHERE S# = t5.S#
                 );*/
					
6、查询学过“001”并且也学过编号“002”课程的同学的学号、姓名；
/*不能在where条件下面写where t2.C#=111 and t2.C#=112因为是对应同一条记录*/
select distinct t1.S#,t1.SNAME
from student t1
left join sc t2
	on t1.S#=t2.S#
where t2.C#=111
intersect --集合的交集
select distinct t1.S#,t1.SNAME
from student t1
left join sc t2
	on t1.S#=t2.S#
where t2.C#=112

7、查询学过“叶平”老师所教的所有课的同学的学号、姓名；
select distinct t1.S# as ST_CODE,
				t1.SNAME as ST_NAME
from student t1
left join sc t2
	on t1.S#=t2.S#
left join course t3
	on t2.C#=t3.C#
left join teacher t4
	on t3.T#=t4.T#
where t4.TNAME='libingbing'
8、查询课程编号“002”的成绩比课程编号“001”课程低的所有同学的学号、姓名
select S#,SNAME from (
					select student.S#,student.SNAME,SCORE,
					(select SCORE from sc SC_2 
					where SC_2.S#=student.S# and SC_2.C#='002') SCORE2 
			from student,sc where student.S#=sc.S# and C#='001') S_2
			where SCORE2 <SCORE; 



select a.S#
from (select t1.S#,t1.SCORE from sc t1 where t1.C#=111) a
inner join (select t2.S#,t2.SCORE from sc t2 where t2.C#=112) b
 on a.S#=b.S#
where a.SCORE<b.SCORE
9、查询所有课程成绩小于60分的同学的学号、姓名
select t1.S#,t1.SNAME
from student t1
inner join sc t2
	on t1.S#=t2.S#
where t2.C#<60
10、查询没有学全所有课的同学的学号、姓名
/*子查询版*/
select distinct t1.S#,t1.SNAME
from student t1
inner join sc t2
	on t1.S#=t2.S#
where t2.C# in(
			select t3.C#
			from course t3
			)
/*exists版*/
select distinct t1.S#,t1.SNAME
from student t1
inner join sc t2
	on t1.S#=t2.S#
where exists(
			select 1
			from course t3
			where t3.C#=t2.C#
			)
11、查询至少有一门课与学号为“1001”的同学所学相同的同学的学号和姓名
12、查询至少学过学号为“001”同学所有一门课的其他同学学号和姓名
13、把“SC”表中“叶平”老师教的课的成绩都更改为此课程的平均成绩
14、查询和“1002”号的同学学习的课程完全相同的其他同学学号和姓名
15、删除学习'陈奕迅'老师课的SC表记录
16、向SC表中插入一些记录，这些记录要求符合以下条件：没有上过编号“003”课程的同学学号、2号课的平均成绩
17、按平均成绩从高到低显示所有学生的“语文1”、“生物2”、“化学1”三门的课程成绩，按如下形式显示
18、查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分
19、按各科平均成绩从低到高和及格率的百分数从高到低顺序
20、查询如下课程平均成绩和及格率的百分数(用"1行"显示)
21、查询不同老师所教不同课程平均分从高到低显示
22、查询如下课程成绩第 3 名到第 6 名的学生成绩单：语文1（111），语文2（112），数学1 （113），数学2（114）
23、统计列印各科成绩,各分数段人数:课程ID,课程名称,[100-85] 优秀人数,[85-70] 良好人数,[70-60] 一般人数,[ <60] 刚及格人数
24、查询学生平均成绩及其名次 
25、查询各科成绩前三名的记录:(不考虑成绩并列情况)
26、查询每门课程被选修的学生数
27、查询出只选修了一门课程的全部学生的学号和姓名
28、查询男生、女生人数
29、查询名字中有'黑'的学生名单
30、查询同名同性学生名单，并统计同名人数
32、查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列
33、查询平均成绩大于85的所有学生的学号、姓名和平均成绩
34、查询课程名称为'语文1'，且分数低于60的学生姓名和分数
35、查询所有学生的选课情况
36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数
37、查询不及格的课程，并按课程号从大到小排列
38、查询课程编号为003且课程成绩在80分以上的学生的学号和姓名
39、求选了课程的学生人数
40、查询选修“叶平”老师所授课程的学生中，成绩最高的学生姓名及其成绩
41、查询各个课程及相应的选修人数
42、查询不同课程成绩相同的学生的学号、课程号、学生成绩
43、查询每门功成绩最好的前两名
44、统计每门课程的学生选修人数（超过10人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，查询结果按人数降序排列，若人数相同，按课程号升序排列
45、检索至少选修两门课程的学生学号
46、查询全部学生都选修的课程的课程号和课程名
47、查询没学过'陈奕迅'老师讲授的任一门课程的学生姓名
48、查询两门以上不及格课程的同学的学号及其平均成绩
49、检索'114'课程分数小于60，按分数降序排列的同学学号
50、删除'2'同学的'111'课程的成绩


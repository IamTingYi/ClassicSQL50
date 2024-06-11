use sql50;

/* 建立資料表 */
-- 學生表 --
CREATE TABLE IF NOT EXISTS student (s_id VARCHAR(10) PRIMARY KEY, s_name VARCHAR(20), s_age INT, s_sex VARCHAR(5));
-- 教師表 --
CREATE TABLE IF NOT EXISTS teacher(t_id VARCHAR(10) PRIMARY KEY, t_name VARCHAR(20));
-- 課程表 --
CREATE TABLE IF NOT EXISTS course(c_id VARCHAR(10), c_name VARCHAR(20), t_id VARCHAR(20), CONSTRAINT pk_course PRIMARY KEY (c_id,t_id));
-- 成績表 --
CREATE TABLE IF NOT EXISTS sc(s_id VARCHAR(10), c_id VARCHAR(10), score FLOAT, CONSTRAINT pk_sc PRIMARY KEY (s_id,c_id));

/* 插入資料 */
-- 插入學生表資料 --
INSERT INTO student VALUES ('s001','張三',23,'男');
INSERT INTO student VALUES ('s002','李四',23,'男');
INSERT INTO student VALUES ('s003','吳鵬',25,'男');
INSERT INTO student VALUES ('s004','琴沁',20,'女');
INSERT INTO student VALUES ('s005','王麗',20,'女');
INSERT INTO student VALUES ('s006','李波',21,'男');
INSERT INTO student VALUES ('s007','劉玉',21,'男');
INSERT INTO student VALUES ('s008','蕭蓉',21,'女');
INSERT INTO student VALUES ('s009','陳蕭曉',23,'女');
INSERT INTO student VALUES ('s010','陳美',22,'女');
INSERT INTO student VALUES ('s011','王麗',24,'女');
INSERT INTO student VALUES ('s012','蕭蓉',20,'女');
-- 插入教師表資料 --
INSERT INTO teacher VALUES ('t001', '劉陽');
INSERT INTO teacher VALUES ('t002', '諶燕');
INSERT INTO teacher VALUES ('t003', '胡明星');
-- 插入課程表資料 --
INSERT INTO course VALUES ('c001','J2SE','t002');
INSERT INTO course VALUES ('c002','Java Web','t002');
INSERT INTO course VALUES ('c003','SSH','t001');
INSERT INTO course VALUES ('c004','Oracle','t001');
INSERT INTO course VALUES ('c005','SQL SERVER 2005','t003');
INSERT INTO course VALUES ('c006','C#','t003');
INSERT INTO course VALUES ('c007','JavaScript','t002');
INSERT INTO course VALUES ('c008','DIV+CSS','t001');
INSERT INTO course VALUES ('c009','PHP','t003');
INSERT INTO course VALUES ('c010','EJB3.0','t002');
-- 插入成績表資料 --
INSERT INTO sc VALUES ('s001','c001',78.9);
INSERT INTO sc VALUES ('s002','c001',80.9);
INSERT INTO sc VALUES ('s003','c001',81.9);
INSERT INTO sc VALUES ('s004','c001',50.9);
INSERT INTO sc VALUES ('s005','c001',59.9);
INSERT INTO sc VALUES ('s001','c002',82.9);
INSERT INTO sc VALUES ('s002','c002',72.9);
INSERT INTO sc VALUES ('s003','c002',82.9);
INSERT INTO sc VALUES ('s001','c003',59);
INSERT INTO sc VALUES ('s006','c003',99.8);
INSERT INTO sc VALUES ('s002','c004',52.9);
INSERT INTO sc VALUES ('s003','c004',20.9);
INSERT INTO sc VALUES ('s004','c004',59.8);
INSERT INTO sc VALUES ('s005','c004',50.8);
INSERT INTO sc VALUES ('s002','c005',92.9);
INSERT INTO sc VALUES ('s001','c007',78.9);
INSERT INTO sc VALUES ('s001','c010',78.9);

/* 1. 查詢學生表的 前10條資料 */
SELECT * FROM student LIMIT 10;

/* 2. 查詢成績表所有成績的最低分,平均分,總分 */
SELECT MIN(score) AS '最低分', AVG(score) AS '平均分', SUM(score) AS '總分' FROM sc;

/* 3. 查詢老師 “諶燕” 所帶的課程設數量 */
SELECT COUNT(*) AS '課程數量'
FROM course C LEFT JOIN teacher T ON C.t_id = T.t_id
WHERE T.t_name = '諶燕';

/* 4. 查詢所有老師所帶 的課程 數量 */
SELECT T.t_name AS '教師姓名', COUNT(C.c_id) AS '課程數量'
FROM course C LEFT JOIN teacher T ON C.t_id = T.t_id
GROUP BY T.t_name;

/* 5. 查詢姓”張”的學生名單 */
SELECT s_name AS '學生姓名' FROM student WHERE s_name LIKE '張%';

/* 6. 查詢課程名稱為’Oracle’且分數低於60 的學號和分數 */
SELECT SC.s_id AS '學號', SC.score AS '分數'
FROM sc SC LEFT JOIN course C ON SC.c_id = C.c_id
WHERE C.c_name = 'Oracle' AND SC.score < 60;

/* 7. 查詢所有學生的選課 課程名稱 */
SELECT S.s_name AS '學生姓名', C.c_name AS '課程名稱'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
LEFT JOIN course C ON SC.c_id = C.c_id;

/* 8. 查詢任何一門課程成績在70 分以上的學生姓名.課程名稱和分數 */
SELECT S.s_name AS '學生姓名', C.c_name AS '課程名稱', SC.score AS '分數'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
LEFT JOIN course C ON SC.c_id = C.c_id
WHERE SC.score >= 70;

/* 9. 查詢不及格的課程,並按課程號從大到小排列 學號,課程號,課程名,分數 */
SELECT S.s_id AS '學號', C.c_id AS '課程號', C.c_name AS '課程名', SC.score AS '分數'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
LEFT JOIN course C ON SC.c_id = C.c_id
WHERE SC.score < 60
ORDER BY SC.c_id DESC;

/* 10. 查詢沒學過”諶燕”老師講授的任一門課程的學號,學生姓名 */
SELECT S1.s_id AS '學號', S1.s_name AS '學生姓名'
FROM student S1
WHERE S1.s_id NOT IN (SELECT DISTINCT S.s_id FROM sc SC
					  LEFT JOIN student S ON SC.s_id = S.s_id
                      LEFT JOIN course C ON SC.c_id = C.c_id
                      LEFT JOIN teacher T ON C.t_id = T.t_id
                      WHERE T.t_name = '諶燕');

/* 11. 查詢兩門以上不及格課程的同學的學號及其平均成績 */
SELECT s_id AS '學號', AVG(score) AS '平均成績'
FROM sc
WHERE score < 60
GROUP BY s_id
HAVING COUNT(c_id) >= 2;

/* 12. 檢索’c004’課程分數小於60,按分數降序排列的同學學號 */
SELECT s_id AS '學號' FROM sc
WHERE c_id = 'c004' AND score < 60
ORDER BY score DESC;

/* 13. 查詢’c001’課程比’c002’課程成績高的所有學生的學號 */
SELECT SC1.s_id AS '學號'
FROM sc SC1 LEFT JOIN sc SC2 ON SC1.s_id = SC2.s_id
WHERE SC1.c_id = 'c001' AND SC2.c_id = 'c002' AND SC1.score > SC2.score;

/* 14. 查詢平均成績大於60 分的同學的學號和平均成績 */
SELECT s_id AS '學號', AVG(score) AS '平均成績'
FROM sc
GROUP BY s_id
HAVING AVG(score) > 60;

/* 15. 查詢所有同學的學號.姓名.選課數.總成績 */
SELECT SC.s_id AS '學號', S.s_name AS '學生姓名', COUNT(SC.c_id) AS '選課數', SUM(SC.score) AS '總成績'
FROM sc SC LEFT JOIN student S ON SC.s_id = S.s_id
GROUP BY SC.s_id;

/* 16. 查詢姓”劉”的老師的個數 */
SELECT COUNT(*) AS '教師個數'
FROM teacher
WHERE t_name LIKE '劉%';

/* 17. 查詢只學”諶燕”老師所教的課的同學的學號:姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM sc SC1
LEFT JOIN student S ON SC1.s_id = S.s_id
WHERE SC1.s_id NOT IN (SELECT SC2.s_id
					   FROM sc SC2
					   WHERE SC2.c_id NOT IN (SELECT DISTINCT C.c_id
											  FROM course C
                                              LEFT JOIN teacher T ON C.t_id = T.t_id
                                              WHERE T.t_name = '諶燕'));

/* 18. 查詢學過”c001″並且也學過編號”c002″課程的同學的學號.姓名 */
SELECT s_id AS '學號', s_name AS '學生姓名'
FROM student
WHERE s_id IN (SELECT s_id
			   FROM sc
               WHERE c_id IN ('c001','c002')
               GROUP BY s_id
               HAVING COUNT(s_id) = 2);

/* 19. 查詢學過”諶燕”老師所教的所有課的同學的學號:姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM student S
WHERE S.s_id IN (SELECT SC.s_id
				 FROM sc SC
                 WHERE SC.c_id IN (SELECT C1.c_id
								   FROM course C1
                                   LEFT JOIN teacher T1 ON C1.t_id = T1.t_id
                                   WHERE T1.t_name = '諶燕')
GROUP BY SC.s_id
HAVING COUNT(SC.c_id) = (SELECT COUNT(C2.c_id)
						 FROM course C2
                         LEFT JOIN teacher T2 ON C2.t_id = T2.t_id
                         WHERE T2.t_name = '諶燕'));

/* 20. 查詢課程編號”c004″的成績比課程編號”c001″和”c002″課程低的所有同學的學號.姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM student S
WHERE S.s_id IN (SELECT SC1.s_id
				 FROM sc SC1
                 LEFT JOIN sc SC2 ON SC1.s_id = SC2.s_id
                 LEFT JOIN sc SC3 ON SC1.s_id = SC3.s_id
                 WHERE SC1.c_id = 'c004' AND SC2.c_id = 'c001' AND SC1.score < SC2.score
                 AND SC3.c_id = 'c002' AND SC1.score < SC3.score);

/* 21. 查詢所有課程成績小於60 分的同學的學號.姓名 */
SELECT DISTINCT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
WHERE S.s_id NOT IN (SELECT s_id FROM sc WHERE score > 60 GROUP BY s_id);

/* 22. 查詢沒有學課的同學的學號.姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM student S
LEFT JOIN sc SC ON S.s_id = SC.s_id
GROUP BY S.s_id
HAVING COUNT(SC.c_id) = 0;

/* 23. 查詢與學號為”s001″一起上過課的同學的學號和姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM student S
WHERE S.s_id IN (SELECT DISTINCT SC.s_id
				 FROM sc SC
                 WHERE SC.s_id != 's001' AND SC.c_id IN (SELECT c_id FROM sc WHERE s_id = 's001'));

/* 24. 查詢跟學號為”s005″所修課程完全一樣的同學的學號和姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM student S
WHERE S.s_id IN (SELECT SC1.s_id 
				 FROM sc SC1
                 LEFT JOIN (SELECT * FROM sc WHERE s_id = 's005') SCS ON SC1.c_id = SCS.c_id
                 WHERE SC1.s_id != 's005' AND SCS.c_id != ''
                 GROUP BY SC1.s_id
                 HAVING COUNT(SC1.c_id) = (SELECT COUNT(c_id) FROM sc WHERE s_id = 's005'));
                 
/* 25. 查詢各科成績最高和最低的分 顯示:課程ID,最高分,最低分 */
SELECT c_id AS '課程ID', MAX(score) AS '最高分', MIN(score) AS '最低分'
FROM sc
GROUP BY c_id;

/* 26. 按各科平均成績和及格率的百分數 照平均從低到高顯示 */
SELECT C.c_name AS '課程名稱', AVG(SC.score) AS '平均成績', AVG(IF(SC.score>=60,1,0))*100 AS '及格率百分數'
FROM sc SC
LEFT JOIN course C ON SC.c_id = C.c_id
GROUP BY C.c_id, C.c_name
ORDER BY AVG(SC.score);

/* 27. 查詢每個課程的老師及平均分從高到低顯示 老師名稱,課程名稱,平均分數 */
SELECT T.t_name AS '老師名稱', C.c_name AS '課程名稱', AVG(SC.score) AS '平均成績'
FROM sc SC
LEFT JOIN course C ON SC.c_id = C.c_id
LEFT JOIN teacher T ON C.t_id = T.t_id 
GROUP BY T.t_name, C.c_name, SC.c_id
ORDER BY AVG(SC.score);

/* 28. 統計列印各科成績,各分數段人數:課程ID,課程名稱,verygood[100-86], good[85-71], bad[0-60] */
SELECT C.c_id AS '課程ID', C.c_name AS '課程名稱',
	   SUM(IF(SC.score<=100 AND SC.score >= 86,1,0)) AS 'verygood',
       SUM(IF(SC.score<=85 AND SC.score >= 71,1,0)) AS 'good',
       SUM(IF(SC.score<=60 AND SC.score >= 0,1,0)) AS 'bad'
FROM sc SC
LEFT JOIN course C ON SC.c_id = C.c_id
GROUP BY C.c_id, C.c_name;

/* 29. 查詢各科成績前三名的記錄:(不考慮成績並列情況) */
SELECT *
FROM sc SC1
WHERE (SELECT COUNT(*) FROM sc SC2 WHERE SC1.c_id = SC2.c_id AND SC1.score < SC2.score) < 3
ORDER BY c_id, score DESC;

/* 30. 查詢每門課程被選修的學生數 */
SELECT c_id AS '課程ID', COUNT(s_id) AS '學生數'
FROM sc
GROUP BY c_id;

/* 31. 查詢出只選修了兩門課程的全部學生的學號和姓名 */
SELECT S.s_id, S.s_name
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
GROUP BY SC.s_id
HAVING COUNT(SC.c_id) = 2;

/* 32. 查詢男生.女生人數 */
SELECT s_sex, COUNT(*) FROM student
GROUP BY s_sex;

/* 32-1. 查詢每個課程的男生女生總數 */
SELECT SC.c_id, SUM(IF(S.s_sex = '男',1,0)) AS '男生', SUM(IF(S.s_sex = '女',1,0)) AS '女生'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
GROUP BY SC.c_id;

/* 33. 查詢同名同姓學生名單,並統計同名人數 */
SELECT S1.s_name AS '學生姓名', COUNT(*) AS '同名人數'
FROM student S1
LEFT JOIN student S2 ON S1.s_name = S2.s_name
WHERE S1.s_name = S2.s_name AND S1.s_id != S2.s_id
GROUP BY S1.s_name;

/* 34. 查詢年紀最小跟最大的學生名單(注:Student 表中Sage 列的型別是int) */
SELECT s_name, s_age
FROM student
WHERE s_age = (SELECT MIN(s_age) FROM student) OR s_age = (SELECT MAX(s_age) FROM student);

/* 35. 查詢每門課程的平均成績,結果按平均成績升序排列,平均成績相同時,按課程號降序排列 */
SELECT C.c_id, AVG(SC.score) AS '平均成績'
FROM sc SC
LEFT JOIN course C ON SC.c_id = C.c_id
GROUP BY SC.c_id
ORDER BY AVG(SC.score), c_id DESC;

/* 36. 查詢平均成績大於85 的所有學生的學號.姓名和平均成績 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名', AVG(SC.score) AS '平均成績'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
GROUP BY SC.s_id
HAVING AVG(SC.score) > 85;

/* 37. 查詢課程編號為c001 且課程成績在80 分以上的學生的學號和姓名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
WHERE SC.c_id = 'c001' AND SC.score >= 80;

/* 38. 檢索每課程第二高分的學號 分數(考慮成績並列) */
SELECT c_id AS '課程名稱', s_id AS '學號', score AS '分數'
FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY c_id ORDER BY score DESC) AS rnk FROM sc) AS ranked
WHERE rnk = 2;

/* 39. 求選了課程的學生人數 */
SELECT COUNT(*) AS '學生人數'
FROM (SELECT DISTINCT s_id FROM sc) AS scount;

/* 40. 查詢選修”諶燕”老師所授課程的學生中,成績最高的學生姓名及其成績 */
SELECT S1.s_name AS '學生姓名', SC1.score AS '成績'
FROM sc SC1
LEFT JOIN student S1 ON SC1.s_id = S1.s_id
LEFT JOIN course C1 ON SC1.c_id = C1.c_id
LEFT JOIN teacher T1 ON C1.t_id = T1.t_id
WHERE T1.t_name = '諶燕' AND SC1.score = (SELECT MAX(SC2.score)
										  FROM sc SC2
                                          LEFT JOIN course C2 ON SC2.c_id = C2.c_id
                                          LEFT JOIN teacher T2 ON C2.t_id = T2.t_id
                                          WHERE T2.t_name = '諶燕');
                                          
/* 41. 查詢不同課程成績有相同的學生的學號.課程號.學生成績 */
SELECT DISTINCT SC1.s_id AS '學號', SC1.c_id AS '課程號', SC1.score AS '學生成績'
FROM sc SC1
LEFT JOIN sc SC2 ON SC1.score = SC2.score
WHERE SC1.score = SC2.score AND SC1.c_id != SC2.c_id;

/* 42. 所有課程排名成績(不考慮並列) 學號,課程號,排名,成績 照課程,排名排序 */
SELECT s_id AS '學號', c_id AS '課程號', RANK() OVER (PARTITION BY c_id ORDER BY score DESC) AS '排名', score AS '成績'
FROM sc
ORDER BY '課程號','排名';

/* 43. 所有課程排名成績(考慮並列) 學號,課程號,排名,成績 照課程,排名排序 */
SELECT s_id AS '學號', c_id AS '課程號', DENSE_RANK() OVER (PARTITION BY c_id ORDER BY score DESC) AS '排名', score AS '成績'
FROM sc
ORDER BY '課程號','排名';

/* 44. 做所有學生顯示學生名稱,課程名稱,成績,老師名稱的視圖 */
SELECT S.s_name AS '學生名稱', C.c_name AS '課程名稱', SC.score AS '成績', T.t_name AS '老師名稱'
FROM student S
LEFT JOIN sc SC ON S.s_id = sc.s_id
LEFT JOIN course C ON SC.c_id = C.c_id
LEFT JOIN teacher T ON C.t_id = T.t_id;

/* 45. 查詢上過所有老師教的課程的學生 學號,學生名 */
SELECT S.s_id AS '學號', S.s_name AS '學生姓名'
FROM sc SC
LEFT JOIN student S ON SC.s_id = S.s_id
LEFT JOIN course C ON SC.c_id = C.c_id
GROUP BY SC.s_id
HAVING COUNT(DISTINCT C.t_id) = (SELECT COUNT(*) FROM teacher);

/* 46. 查詢包含數字的課程名 */
SELECT c_name FROM course
WHERE c_name REGEXP '[0-9]';

/* 47. 查詢只有英文的課程名 */
SELECT c_name FROM course
WHERE c_name REGEXP '^[A-Za-z]+$';

/* 48. 查詢所有學生的平均成績 並排名 , 學號,學生名,排名,平均成績(不考慮並列) 對平均成績高到低及學號低到高排序 */
SELECT s_id AS '學號', s_name AS '學生姓名', RANK() OVER (ORDER BY avg_score DESC) AS '排名', avg_score AS '平均成績'
FROM (SELECT S.s_id, S.s_name, AVG(SC.score) AS avg_score
	  FROM sc SC LEFT JOIN student S ON SC.s_id = S.s_id
      GROUP BY SC.s_id) AS average
ORDER BY '平均成績' DESC , '學號';

/* 49. 查詢所有學生的平均成績 並排名 , 學號,學生名,排名,平均成績(考慮並列) 對平均成績高到低及學號低到高排序 */
SELECT s_id AS '學號', s_name AS '學生姓名', DENSE_RANK() OVER (ORDER BY avg_score DESC) AS '排名', avg_score AS '平均成績'
FROM (SELECT S.s_id, S.s_name, AVG(SC.score) AS avg_score
	  FROM sc SC LEFT JOIN student S ON SC.s_id = S.s_id
      GROUP BY SC.s_id) AS average
ORDER BY '平均成績' DESC , '學號';

/* 50. 查詢課程有學生的成績是其他人成績兩倍的學號 學生名 */
SELECT SC1.s_id, S.s_name
FROM sc SC1
LEFT JOIN sc SC2 ON SC1.c_id = SC2.c_id AND SC1.s_id != SC2.s_id
LEFT JOIN student S ON SC1.s_id = S.s_id
WHERE SC1.score = SC2.score*2;
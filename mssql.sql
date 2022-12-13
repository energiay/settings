
SELECT * 
FROM custom_web_template
WHERE CAST(data AS NVARCHAR(max)) LIKE '%from library_material as LibraryData%'


SELECT sas.name, sas.modification_date, sa.*
FROM server_agent AS sa
LEFT JOIN server_agents AS sas ON sa.id=sas.id
WHERE CAST(data AS NVARCHAR(max)) LIKE '%6491170854400957603%'
ORDER BY sas.modification_date


SELECT 
	ar.id,
	ar.data.value('(//action_report/report_text)[1]', 'nvarchar(max)') AS report_text,
	ar.data
FROM action_report AS ar
WHERE	created > '2018-09-30'
		AND ar.data.value('(//action_report/report_text)[1]', 'nvarchar(max)') LIKE '%(Unknown source,   line 48)%'


SELECT *
FROM remote_action
WHERE CAST(data AS NVARCHAR(max)) LIKE '%ActionRequestPochtaBank%'


SELECT *
FROM remote_collection
WHERE CAST(data AS NVARCHAR(max)) LIKE '%SOAP Client%'


SELECT *
FROM notification_template
WHERE CAST(data AS NVARCHAR(max)) LIKE '%img%'

SELECT *
FROM active_notification
WHERE CAST(data AS NVARCHAR(max)) LIKE '%6589952435981348617%'

SELECT *
FROM notification
WHERE CAST(data AS NVARCHAR(max)) LIKE '%Инвестиционное страхование жизни программа%'

SELECT *
FROM [notification]
WHERE CAST(data AS NVARCHAR(max)) LIKE '%6568807292919025300%'

SELECT *
FROM notification_template
WHERE CAST(data AS NVARCHAR(max)) LIKE '%margin:0; padding-top: 10px; font-family: Calibri, Verdana, Ariel, sans-serif%'


-- XML exist
SELECT acs.id
FROM acquaints AS acs
LEFT JOIN acquaint AS ac ON acs.id=ac.id
WHERE 	acs.[status]=1 
		AND (
			ac.data.exist('(//acquaint/comment)')=0
			OR ac.data.value('(//acquaint/comment)[1]', 'nvarchar(max)') = ''
		)


-- Кастомные поля
SELECT 
	rs.id,
	ISNULL(r.data.value('(request/custom_elems/custom_elem[name="where"]/value)[1]', 'varchar(max)'),'') AS filter,
	ISNULL(r.data.value('(request/custom_elems/custom_elem[name="post_name"]/value)[1]', 'varchar(max)'),'') AS post_name,
	ISNULL(r.data.value('(request/custom_elems/custom_elem[name="sub"]/value)[1]', 'varchar(max)'),'') AS sub,
	ISNULL(r.data.value('(request/custom_elems/custom_elem[name="boss_posts"]/value)[1]', 'varchar(max)'),'') AS boss_posts
FROM requests AS rs
LEFT JOIN request AS r ON r.id=rs.id
WHERE	request_type_id='6592112108872686997'
		AND r.data.value('(request/custom_elems/custom_elem[name="post_name"]/value)[1]', 'varchar(max)') = 'финансовый эксперт'


-- 	CROSS APPLY
SELECT
	ls.id,
	col.code,
	col.fullname,
	TEST.xmldata.query('score').value('.', 'nvarchar(max)') AS score
FROM learnings AS ls
LEFT JOIN courses AS cs ON ls.course_id=cs.id
LEFT JOIN course AS c ON c.id=cs.id
LEFT JOIN learning AS l ON l.id=ls.id
LEFT JOIN collaborators AS col ON col.id=ls.person_id
CROSS APPLY l.data.nodes('learning/parts/part') AS TEST(xmldata)
WHERE	ls.state_id=3 
		AND cs.name LIKE '%обучение по изменениям и новым продуктам, август%' 
		AND c.data.value('(//course/mastery_score)[1]', 'int') <= ls.score
		AND ls.modification_date > '2018-08-16 00:00:00'
		AND TEST.xmldata.query('type').value('.', 'nvarchar(max)')='test'
		AND TEST.xmldata.query('state_id').value('.', 'nvarchar(max)')='0'
		AND TEST.xmldata.query('score').value('.', 'nvarchar(max)')='0'


-- Соединение строк из массива XML
WITH #table AS (
	SELECT 
		cc_cs.id,
		TEXTS.xmldata.query('.').value('.', 'nvarchar(max)') AS text
	FROM cc_un_commissions AS cc_cs
	INNER JOIN cc_un_commission AS cc_c ON cc_cs.id=cc_c.id
	CROSS APPLY cc_c.data.nodes('cc_un_commission/history_lists/history_list/result_text') AS TEXTS(xmldata)
	WHERE cc_cs.id=6572110192707192922
)
SELECT 
	DISTINCT id,
	STUFF((	SELECT t2.text + ' ; '
         	from #table AS t2
         	where t1.id = t2.id
            FOR XML PATH(''), TYPE
           ).value('.', 'NVARCHAR(MAX)') 
        ,1,0,'') data 
FROM #table AS t1


-- проверка на 0
SELECT isNULL(NULLIF(0, 0), 1) AS [nullif]


-- XML  кастомных полей можно получить так
SELECT CONVERT(xml,(data)) as xml_data
FROM [(spxml_blobs)]
where url like '%custom_templates%'


-- определение типа поля
SELECT DATA_TYPE 
FROM information_schema.COLUMNS
WHERE TABLE_NAME='un_effectiveness' AND COLUMN_NAME='assessment_id'


-- конвертация даты
SELECT convert(varchar, GETDATE(), 104) AS date
SELECT convert(datetime, '28.01.2020 11:59:36', 104)  AS date


-- конвертация 16 в 10
SELECT CAST(0x62839D5B0351215C AS bigint)

-- конвертация из 10 в 16
SELECT CONVERT(VARCHAR, CAST(CAST(6807538711954282890 AS bigint) AS VARBINARY), 1)


-- 1. получить всех сотрудников из подразделения
with tree1 (id,basic_collaborator_id, level) as (
	select id, basic_collaborator_id, 0
    from subs s
    where (s.parent_id = 6565269378535531547)
		union all
    select s.id, s.basic_collaborator_id, tree1.level + 1
    from subs s
    inner join tree1 on tree1.id = s.parent_id
)
select * from collaborators c 
where c.id in (
	select basic_collaborator_id as id
	from tree1 
	where basic_collaborator_id is not null
)


-- 2. получить всех сотрудников из подразделения
with collab_subdivision as (
    SELECT subdivisions.*, 0 [level]
    FROM subdivisions
    WHERE id = 6070756297892131940
    UNION ALL
    SELECT subdivisions.*, (collab_subdivision.level+1) [level]
    FROM subdivisions
    INNER JOIN collab_subdivision ON collab_subdivision.id = subdivisions.parent_object_id 
)
select cs.* from collaborators AS cs
where cs.position_parent_id in (
    SELECT id FROM collab_subdivision
) AND cs.is_dismiss = 0


--3. получить всех функциональных и непосредственных подчиненных
with collab_subdivision as (
    SELECT subdivisions.*, 0 [level]
    FROM subdivisions
    WHERE id in (
		-- непосредственное подразделение
		SELECT TOP 1 position_parent_id
		FROM collaborators AS cs
		LEFT JOIN positions AS ps ON ps.id=cs.position_id
		WHERE cs.id = 6807538711954282890 AND is_boss = 1
		UNION ALL
		-- функциональные подразделения с типон непосредственные
		SELECT fms.object_id AS id
		FROM func_managers AS fms
		WHERE catalog = 'subdivision' AND boss_type_id = 6148914691236517290 AND person_id = 6807538711954282890
	)
    UNION ALL
    SELECT subdivisions.*, (collab_subdivision.level+1) [level]
    FROM subdivisions
    INNER JOIN collab_subdivision ON collab_subdivision.id = subdivisions.parent_object_id 
)
select cs.* from collaborators AS cs
where cs.position_parent_id in (SELECT id FROM collab_subdivision)





-- GROUP BY 
select 
	creator_fullname,
	COUNT(creator_fullname) AS all_count
from dbo.bank_idea
where creator_fullname != 'Анонимно' and creator_fullname IS NOT NULL
GROUP BY creator_fullname


-- Возврат id последнй добавленной записи
INSERT INTO dbo.portal_news (creator_id,creator_fullname,create_date,news_title,news_short_desc,news_full_desc,role,notif,news_logo)
OUTPUT INSERTED.IDENTITYCOL 
VALUES ('1111','1111','2017-10-21 09:00:00.000','111','11111','111111','11111111111',0,NULL) 


-- удалить таблицу
DROP TABLE un.write_to_time_test


-- создать таблицу
CREATE TABLE un.write_to_time_test (
	id bigint IDENTITY(1,1) NOT NULL, 
	post nvarchar(max),
	set_date_time nvarchar(max),
	count_persons nvarchar(max),
	group_id nvarchar(max),
	create_date datetime
)


-- Возврат кол-ва добавленных записей
INSERT INTO un.write_to_time_test
	(post, set_date_time, count_persons, group_id, create_date)
VALUES
	('Финансовый специалист, Финансовый эксперт', '06.04.2019 13:00:00', '500', 'Клиентский центр', GETDATE()),
	('Финансовый спеиалист, Финансовый эксперт', '06.04.2019 14:00:00', '500', 'Клиентский центр', GETDATE()),
SELECT @@ROWCOUNT AS 'rowcount'


-- проверяем права
SELECT 
    class_desc 
  , CASE WHEN class = 0 THEN DB_NAME()
         WHEN class = 1 THEN OBJECT_NAME(major_id)
         WHEN class = 3 THEN SCHEMA_NAME(major_id) 
	END [Securable]
  , USER_NAME(grantee_principal_id) [User]
  , permission_name
  , state_desc
FROM sys.database_permissions order by permission_name asc


-- удаляем начальные/конечные пробелы
SELECT ltrim(rtrim('    [строка]     '))


-- проверка на дубли
SELECT
	person_id,
	COUNT(person_id) AS [count]
FROM cc_un_commissions
WHERE cc_un_commissions.assessment_appraise_id=6602496049947696878 
GROUP BY person_id
having count(person_id) > 1
ORDER BY [count]


-- создание констрайнт
ALTER TABLE [dbo].[un_effectiveness]
ADD CONSTRAINT UC_Person UNIQUE (assessment_id, tn, max_mark);
-- удаление констрайнт
ALTER TABLE [dbo].[un_effectiveness]
DROP CONSTRAINT UC_Person


-- удалить все записи
TRUNCATE TABLE [dbo].[un_effectiveness]


-- округление float
SELECT round( cast(77.12346578 as float), 2) as digital


-- рекурсия
WITH sub_cte
AS
(
   SELECT subdivisions.*, 0 [level]
   FROM subdivisions
   WHERE id = 5862174114543115429
   UNION ALL
   SELECT subdivisions.*, (sub_cte.level+1) [level]
   FROM subdivisions
   INNER JOIN sub_cte ON sub_cte.id = subdivisions.parent_object_id 
)
SELECT * FROM sub_cte ORDER BY level
-- ИЛИ
WITH sub_cte(id)
AS
(
   SELECT subdivisions.*, 0 [level]
   FROM subdivisions
   WHERE id = 6561558023922326966
   UNION ALL
   SELECT subdivisions.*, (sub_cte.level+1) [level]
   FROM subdivisions
   INNER JOIN sub_cte ON sub_cte.parent_object_id = subdivisions.id 
)
SELECT sub_cte.level, sub_cte.id, sub_cte.name FROM sub_cte ORDER BY level desc



-- Вычисляем код символа
-- отображается значение ASCII и символ для каждого символа в строке
SET TEXTSIZE 0;   
DECLARE @position int, @string char(8);  
SET @position = 1;  
SET @string = '1.	Ч';  
WHILE @position <= DATALENGTH(@string)  
   BEGIN  
   SELECT ASCII(SUBSTRING(@string, @position, 1)),   
      CHAR(ASCII(SUBSTRING(@string, @position, 1)))  
   SET @position = @position + 1  
   END;  
GO  



-- block посмотреть блокировки
SELECT session_id ,status ,blocking_session_id  
    ,wait_type ,wait_time ,wait_resource   
    ,transaction_id   
FROM sys.dm_exec_requests   
WHERE status not like N'background';  
GO
-- или
select TOP 10
	EQ.session_id
   ,ER.blocking_session_id
   ,db_name(ER.database_id) as dbname
   ,st.text
from
sys.dm_exec_query_memory_grants EQ
left join sys.dm_exec_requests ER on ER.session_id = EQ.session_id
outer apply sys.dm_exec_sql_text((EQ.sql_handle)) ST 
order by EQ.requested_memory_kb desc



-- курсор
declare crs cursor
for
	SELECT
		tl.person_id, MAX(tl.score) AS score
	FROM assessment_plans ap
	INNER JOIN assessment_plan ap2 on ap.id=ap2.id 
	INNER JOIN collaborators colls ON colls.id=ap.person_id
	LEFT JOIN test_learnings tl ON tl.person_id=colls.id AND tl.assessment_name LIKE '%04.2019%'
	LEFT JOIN subdivisions AS s1 ON colls.position_parent_id=s1.id
	LEFT JOIN subdivisions AS s2 ON s1.parent_object_id=s2.id
	LEFT JOIN subdivisions AS s3 ON s2.parent_object_id=s3.id
	LEFT JOIN subdivisions AS s4 ON s3.parent_object_id=s4.id
	LEFT JOIN subdivisions AS s5 ON s4.parent_object_id=s5.id
	LEFT JOIN subdivisions AS s6 ON s5.parent_object_id=s6.id
	WHERE ap.assessment_appraise_id = 6630744681293677377   AND colls.is_dismiss = 0 AND tl.score IS NOT NULL
	GROUP BY tl.person_id
open crs

declare  @low int, @medium int, @height int
declare  @person_id varchar(19), @values int
SET @low = 0
SET @medium = 0
SET @height = 0

fetch next from crs INTO  @person_id, @values
while @@FETCH_STATUS = 0
begin
	IF @values < 51 
		SET @low = @low + 1
	IF @values >= 51 and @values <= 57
		SET @medium = @medium + 1 
	IF @values > 57
		SET @height = @height + 1 
	
	fetch next from crs INTO  @person_id, @values
end

select @low as crs1, @medium AS crs2, @height AS crs3

close crs
deallocate crs



-- получение структуры из подразделения
WITH sub_cte AS (
   SELECT subdivisions.*, 0 [level]
   FROM subdivisions
   WHERE id = 6696629192545555420
   UNION ALL
   SELECT subdivisions.*, (sub_cte.level+1) [level]
   FROM subdivisions
   INNER JOIN sub_cte ON sub_cte.parent_object_id = subdivisions.id 
)
SELECT sub_cte.level, sub_cte.id, sub_cte.name FROM sub_cte ORDER BY level desc




-- дата приема / перевода не более 10 дней
SELECT
	cs.id
	,cs.fullname
	,colls.xmldata.query('position_name').value('.', 'nvarchar(max)') AS position_name
	,colls.xmldata.query('date').value('.', 'nvarchar(max)') AS pos_date

FROM collaborators AS cs
LEFT JOIN collaborator AS c ON c.id=cs.id
CROSS APPLY c.data.nodes('collaborator/change_logs/change_log') AS colls(xmldata)
WHERE	cs.id in (
	SELECT col.id 
	FROM collaborators AS col
	WHERE col.is_dismiss = 0 AND col.org_id=5832641339360551871
	--6602395350977744761
)
AND DATEDIFF(day,colls.xmldata.query('date').value('.', 'date'), getdate()) < 11



-- получить прошлый день
SELECT DATEADD(DAY, -1, GETDATE())


--получение даты из unixtimestamp
SELECT DATEADD(SECOND, 1546290000, '1970-01-01 03:00:00')



-- access_roles
SELECT 
	elem.xmldata.query('id').value('.', 'nvarchar(max)') AS id
	,elem.xmldata.query('name').value('.', 'nvarchar(max)') AS name
FROM (
	SELECT cast(data as  xml) as xml_data
	FROM [(spxml_blobs)]
	where url = 'x-local://wt_data/lists/wtv_access_roles.xml'
) AS access_role
CROSS APPLY access_role.xml_data.nodes('access_roles/access_role') AS elem(xmldata)



-- сортировка в union allSELECT 
SELECT 
	my_group.id
	,my_group.name
	,my_group.sort
	,my_group.num
FROM (
	SELECT 
		gs.id AS id
		,gs.name AS name
		,g.data.value('(group/custom_elems/custom_elem[name="sort"]/value)[1]', 'integer') AS sort
		,ROW_NUMBER() OVER (order BY g.data.value('(group/custom_elems/custom_elem[name="sort"]/value)[1]', 'integer')) AS num
	FROM groups AS gs 
	LEFT JOIN [group] AS g ON g.id = gs.id
	WHERE	is_dynamic = 1 AND g.data.value('(group/custom_elems/custom_elem[name="sort"]/value)[1]', 'integer') IS NOT NULL
	
	union all
	
	SELECT 
		gs.id AS id
		,gs.name AS name
		,g.data.value('(group/custom_elems/custom_elem[name="sort"]/value)[1]', 'integer') AS sort
		,NULL AS num
	FROM groups AS gs 
	LEFT JOIN [group] AS g ON g.id = gs.id
	WHERE	is_dynamic = 1 AND g.data.value('(group/custom_elems/custom_elem[name="sort"]/value)[1]', 'integer') IS NULL
) AS my_group



-- вытягиваем роль из курса
select 
       roles.xmldata.query('.').value('.', 'varchar(max)')
from courses as cs
join course as c on c.id=cs.id
CROSS APPLY c.data.nodes('course/role_id') AS roles(xmldata)
where cs.id = 5371650452201307123




-- вырезать вставить строку
SELECT STUFF(YEAR(GETDATE()), 1, 2, '19') 


-- проблемы конвертации дат в поле дата платформы WT
with tbl_modif (id, [len], value, modif_date) AS (
	SELECT
		cs.id
		,LEN(c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)'))
		,c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
		,CASE	WHEN LEN( 
					c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
				) <= 19 
				THEN convert(
					datetime
					,REPLACE(
						c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
						,'T'
						,' '					
					)
					,104
				)
				WHEN LEN( 
					c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
				) = 25
				THEN CAST(
					SUBSTRING(
						REPLACE(
							c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
							,'T'
							,' '					
						), 0, 20
					)
					AS datetime
				)
				WHEN LEN( 
					c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)')
				) = 10
				THEN convert(
					datetime
					,c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]','nvarchar(max)')
					,104
				)
				ELSE NULL
		END modif_date
	FROM collaborators AS cs
	LEFT JOIN collaborator AS c ON c.id=cs.id
	WHERE	c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)') IS NOT NULL
			OR c.data.value('(collaborator/custom_elems/custom_elem[name="date_accept_candidate"]/value)[1]', 'nvarchar(max)') <> ''	
)
SELECT *
FROM tbl_modif
WHERE	1=1
		AND DATEDIFF(
			day
			,modif_date
			,getdate()
		) >= 1


-- Создать представление
CREATE VIEW view_statuses_for_pp AS   
    SELECT 
		id AS code, 
		[name]
    FROM [esbdsm.gksm.local].[E_STAFF_SM].[dbo].view_vacancy_states
	UNION ALL
	SELECT 
		states.xmldata.query('code').value('.', 'nvarchar(max)') AS code
		,states.xmldata.query('name').value('.', 'nvarchar(max)') AS [name]
	FROM WTSM_UNICODE.dbo.request_type AS r
	LEFT JOIN WTSM_UNICODE.dbo.workflow AS w ON w.id=r.data.value('(request_type/workflow_id)[1]', 'bigint')
	CROSS APPLY w.data.nodes('workflow/states/state') AS states(xmldata)
	WHERE r.id=6808761893877526589



CREATE VIEW view_selection_uis AS 
	SELECT 
		rs.id
		,CASE 
			WHEN rs.workflow_state = '4' THEN es_vi.state_id
			ELSE rs.workflow_state
		END workflow_state
		,r.data.value('(request/custom_elems/custom_elem[name="pp_id"]/value)[1]', 'varchar(max)') AS pp_id
	FROM WTSM_UNICODE.dbo.requests AS rs
	LEFT JOIN WTSM_UNICODE.dbo.request AS r ON r.id=rs.id
	LEFT JOIN [esbdsm.gksm.local].[E_STAFF_SM].[dbo].[view_vacancies] AS es_vi ON es_vi.eid=CAST(rs.id AS varchar(max))
	WHERE request_type_id=6808761893877526589


CREATE VIEW view_vacancies AS   
    SELECT vs.id,vs.eid,vs.state_id
    FROM [vacancies] AS vs
    
CREATE VIEW view_vacancy_states AS   
    SELECT id, name, is_active
    FROM [vacancy_states]


-- Удалить представление
DROP VIEW PP


-- объединить все записи в одну строку с разделителем запятая
DECLARE @result varchar(max);
WITH #rs AS (
	SELECT id
	FROM requests
	WHERE request_type_id in (6940262955464261649, 6808761893877526589)
)
SELECT @result = isnull(@result + ',' ,'') + CAST(id AS varchar(max))
FROM #rs
SELECT @result


-- поиск вакансии/детализации в estaff
DECLARE @code varchar(max)
SET @code = '7016347108477900417'  -- SET @code = '16007'          
SELECT
    vs.id
    ,vs.name
    ,vs.code
FROM vacancies AS vs
WHERE vs.code=@code           
union all           
SELECT 
    vs.id
    ,vs.name
    ,vs.code
FROM vacancy_instances AS vis
LEFT JOIN vacancies AS vs ON vs.id=vis.vacancy_id
WHERE CAST(vis.id AS varchar(max)) = @code
​
--SELECT CAST(0x60F96DD34EFE0234 AS bigint)


-- порционный вывод значений 
WITH #sel AS (
	SELECT 
		row_number() over(ORDER BY id) AS num
		,id
		,fullname
	FROM persons
) 
SELECT *
FROM #sel
WHERE num > 40 AND num <= 60


-- регистро зависимый LIKESELECT *
SELECT *
FROM collaborators c
WHERE fullname collate SQL_Latin1_General_CP1_CS_AS like 'Пололин%'

-- поиск непосредственных и функциональных руководителей ТРЕБУЮТСЯ ДОРАБОТКИ
DECLARE @user_id varchar(max);
SET @user_id = '6070757881612237509';
WITH #pos_boss AS (
	SELECT fms.object_id AS sub_id
    FROM func_managers AS fms
	LEFT JOIN collaborators AS cs ON cs.id=fms.person_id
	LEFT JOIN positions AS ps ON ps.id=cs.position_id
    WHERE fms.catalog IN ('subdivision') 
        AND fms.boss_type_id= 6148914691236517290 
        AND fms.person_id = @user_id
		AND ps.is_boss = '0'
),
#divisions AS (
	SELECT *
	FROM (
		SELECT cs.position_parent_id AS sub_id
		FROM collaborators AS cs
		LEFT JOIN positions as ps ON ps.id=cs.position_id
		WHERE cs.id = @user_id AND ps.is_boss = '1'

		UNION ALL

		SELECT sub_id
		FROM #pos_boss

	) AS result
),
#subdivisions AS (
	SELECT subdivisions.*, 0 [level]
	FROM subdivisions
	WHERE id in (SELECT sub_id FROM #divisions)
	UNION ALL
	SELECT subdivisions.*, (#subdivisions.level+1) [level]
	FROM subdivisions
	INNER JOIN #subdivisions ON #subdivisions.id = subdivisions.parent_object_id 
)
SELECT sub.id, sub.code, sub.[name], sub_parent.[name] AS parent_name FROM subdivisions AS sub
LEFT JOIN subdivisions AS sub_parent  ON sub_parent.id=sub.parent_object_id 
WHERE	sub.is_disbanded = 0 
		AND sub.[name] IS NOT NULL 
		AND sub.id in (SELECT id FROM #subdivisions)
        
DECLARE @user_id varchar(max);
SET @user_id = '6807538711954282890';

WITH #pos_boss AS (
	SELECT fms.object_id AS sub_id
    FROM func_managers AS fms
	LEFT JOIN collaborators AS cs ON cs.id=fms.person_id
	LEFT JOIN positions AS ps ON ps.id=cs.position_id
    WHERE fms.catalog IN ('subdivision') 
        AND fms.boss_type_id= 6148914691236517290 
        AND fms.person_id = @user_id
		AND ps.is_boss = '0'
),
#divisions AS (
	SELECT *
	FROM (
		SELECT cs.position_parent_id AS sub_id
		FROM collaborators AS cs
		LEFT JOIN positions as ps ON ps.id=cs.position_id
		WHERE cs.id = @user_id AND ps.is_boss = '1'

		UNION ALL

		SELECT sub_id
		FROM #pos_boss

	) AS result
),
#subdivisions AS (
	SELECT subdivisions.*, 0 [level]
	FROM subdivisions
	WHERE id in (SELECT sub_id FROM #divisions)
	UNION ALL
	SELECT subdivisions.*, (#subdivisions.level+1) [level]
	FROM subdivisions
	INNER JOIN #subdivisions ON #subdivisions.id = subdivisions.parent_object_id 
)
SELECT * 
FROM collaborators AS cs
WHERE cs.is_dismiss = 0 AND cs.position_parent_id in (SELECT id FROM #subdivisions)


-- Создание и удаление хранимых процедур
CREATE PROCEDURE Zhora
    @LastName nvarchar(50),   
    @FirstName nvarchar(50)   
AS   
    SELECT @LastName AS LastName, @FirstName AS FirstName
GO
EXECUTE Zhora N'777', N'888'; 
DROP PROCEDURE Zhora;


-- Создание и удаление функции
CREATE FUNCTION Zhora (@storeid nvarchar(max))
RETURNS TABLE
AS
RETURN
(
    SELECT @storeid AS test
);
GO
SELECT test
FROM Zhora('789')
DROP FUNCTION Zhora


-- insert в переменную
DECLARE @career_reserve TABLE(
    career_reserve_id bigint
);
INSERT INTO @career_reserve (
    career_reserve_id
)
SELECT DISTINCT career_reserve_id
FROM career_reserve_tutors AS crts
WHERE crts.tutor_id=7147583355778132228 AND crts.career_reserve_id in (SELECT id FROM career_reserves AS crs WHERE crs.code in ('razum_cpk_person', 'razum_cpk_boss'))

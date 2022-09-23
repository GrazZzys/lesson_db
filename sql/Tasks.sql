# 1 Составление/получение расписания экзаменов/зачётов для определенных
#   групп/кафедр/преподавателей/студентов/аудиторий/времени
### Добавлени зачёта группе
INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 5, 2, false, 'Матан', CURRENT_DATE, CURRENT_TIME);

INSERT INTO session_group (session_id, group_id)
VALUES (2, 1),
       (2, 2),
       (2, 3);

INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 3, 2, false, 'Не матан', '2022-03-14', CURRENT_TIME);

INSERT INTO session_group (session_id, group_id)
VALUES (3, 1),
       (3, 2),
       (3, 3);

INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 3, 2, true, 'Албебра', '2022-02-14', CURRENT_TIME);

INSERT INTO session_group (session_id, group_id)
VALUES (7, 1),
       (7, 2),
       (7, 3);

### Получение расписания сессии у конкретной ГРУППЫ
SELECT s.type                                          as type,
       s.title                                         as title,
       a.number                                        as audience,
       d.title                                         as department,
       g.title                                         as group_tite,
       CONCAT_WS(' ', l.surname, l.name, l.patronymic) as lector,
       s.date                                          as date,
       s.time                                          as time
FROM sessions s
         JOIN audiences a on s.audience_id = a.id
         JOIN session_group sg on s.id = sg.session_id
         JOIN `groups` g on sg.group_id = g.id
         JOIN lectors l on s.lector_id = l.id
         JOIN departments d on d.id = g.department_id
WHERE g.id = 1;

### Получение расписания сессии у конкретного СТУДЕНТА
SELECT s.type                                             as type,
       s.title                                            as title,
       a.number                                           as audience,
       d.title                                            as department,
       g.title                                            as group_tite,
       CONCAT_WS(' ', l.surname, l.name, l.patronymic)    as lector,
       CONCAT_WS(' ', s2.surname, s2.name, s2.patronymic) as student,
       s.date                                             as date,
       s.time                                             as time
FROM sessions s
         JOIN audiences a on s.audience_id = a.id
         JOIN session_group sg on s.id = sg.session_id
         JOIN `groups` g on sg.group_id = g.id
         JOIN lectors l on s.lector_id = l.id
         JOIN departments d on d.id = g.department_id
         JOIN students s2 on g.id = s2.group_id
WHERE s2.id = 1;

### Получение расписания ЗАЧЁТОВ у конкретной КАФЕДРЫ
SELECT s.type                                          as type,
       s.title                                         as title,
       a.number                                        as audience,
       d.title                                         as department,
       g.title                                         as group_tite,
       CONCAT_WS(' ', l.surname, l.name, l.patronymic) as lector,
       s.date                                          as date,
       s.time                                          as time
FROM sessions s
         JOIN audiences a on s.audience_id = a.id
         JOIN session_group sg on s.id = sg.session_id
         JOIN `groups` g on sg.group_id = g.id
         JOIN lectors l on s.lector_id = l.id
         JOIN departments d on d.id = g.department_id
WHERE s.type = 0
  and d.id = 2;

# 2 Составление/получение ведомости для групп по определённым экзаменам/зачётам
### Выставление результата ЗАЧЁТА
INSERT INTO test_results (session_id, student_id, mark)
VALUES (1, 2, true);

INSERT INTO test_results (session_id, student_id, mark)
VALUES (2, 2, true);

INSERT INTO exam_results (session_id, student_id, mark)
VALUES (7, 1, 3);

### Проверка корректности оценки
INSERT INTO exam_results (session_id, student_id, mark)
VALUES (7, 2, 10);

### Получение результатов сессии конкретного СТУДЕНТА
SELECT type,
       title,
       date,
       time,
       CONCAT_WS(' ', s2.name, s2.surname, s2.patronymic) as student,
       mark
FROM test_results
         JOIN sessions s on s.id = test_results.session_id
         join students s2 on s2.id = test_results.student_id
WHERE student_id = 2;

# 3 Проверка корректости расписания зачётов/экзаменов
# (уникальность комбинации "время – дата – аудитория", между экзаменами/зачётами
# в одной группе должно пройти не менее трёх дней)
### Проверка уникальности ЗАЧЁТА
INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 5, 2, false, 'Физика', '2022-03-14', '12:00:00');
INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 5, 2, false, 'Химия', '2022-03-14', '12:00:00');

### Проверка на промежуток экзаменов для одной группы
INSERT INTO session_group (session_id, group_id)
VALUES (4, 1);

INSERT INTO sessions (lector_id, audience_id, department_id, type, title, date, time)
VALUES (2, 5, 2, false, 'Химия', '2022-03-18', '12:00:00');
INSERT INTO session_group (session_id, group_id)
VALUES (6, 1);
INSERT INTO audiences (number)
VALUES (101),
       (201),
       (301),
       (401),
       (101),
       (202),
       (302),
       (402);

INSERT INTO departments (title)
VALUES ('кафедра1'),
       ('кафедра2'),
       ('кафедра3');

INSERT INTO `groups` (department_id, title)
VALUES (1, 'МП-101'),
       (1, 'МП-102'),
       (2, 'МТ-101'),
       (2, 'МТ-102'),
       (3, 'МН-101');

INSERT INTO lectors (name, surname, patronymic)
VALUES ('Иван', 'Иванович', 'Иванов'),
       ('Пётр', 'Петрович', 'Ы');

INSERT INTO lector_department (lector_id, department_id)
VALUES (1, 1),
       (1, 3),
       (2, 2);

INSERT INTO sessions (lector_id, audience_id, department_id,type, title, date, time)
VALUES (1, 1, 1, false, 'История', CURRENT_DATE, CURRENT_TIME);

INSERT INTO session_group (session_id, group_id)
VALUES (1, 1);

INSERT INTO students (group_id, name, surname)
VALUES (1, 'Саня', 'Саневич'),
       (3, 'Ибрагим', 'Ак');

INSERT INTO test_results (session_id, student_id, mark) VALUE (1, 1, NULL);

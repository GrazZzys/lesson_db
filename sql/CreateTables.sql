CREATE TABLE audiences
(
    id     INT AUTO_INCREMENT,
    number INT NOT NULL COMMENT 'Номер аудитории',

    PRIMARY KEY (id)
) COMMENT 'Аудитории';

CREATE TABLE lectors
(
    id         INT AUTO_INCREMENT,
    name       VARCHAR(256) NOT NULL COMMENT 'Имя',
    surname    VARCHAR(256) NOT NULL COMMENT 'Фамилия',
    patronymic VARCHAR(256) NOT NULL DEFAULT '' COMMENT 'Отчество',

    PRIMARY KEY (id)
) COMMENT 'Преподаватели';

CREATE TABLE departments
(
    id    INT AUTO_INCREMENT,
    title VARCHAR(265) NOT NULL COMMENT 'Название кафедры',

    PRIMARY KEY (id)
) COMMENT 'Кафедры';

CREATE TABLE `groups`
(
    id            INT AUTO_INCREMENT,
    department_id INT          NOT NULL COMMENT 'Кафедра на которой находится группа',
    title         VARCHAR(256) NOT NULL COMMENT 'Название группы',

    PRIMARY KEY (id),

    FOREIGN KEY (department_id) REFERENCES departments (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) COMMENT 'Группы';

CREATE TABLE lector_department
(
    lector_id     INT NOT NULL COMMENT 'Лектор',
    department_id INT COMMENT 'Кафедра на которой находится лектор',

    PRIMARY KEY (lector_id, department_id),

    FOREIGN KEY (lector_id) REFERENCES lectors (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (department_id) REFERENCES departments (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT 'Связи лекторов и кафедры к котором они относятся';

CREATE TABLE sessions
(
    id            INT AUTO_INCREMENT,
    lector_id     INT          NOT NULL COMMENT 'Назначенный лектор',
    audience_id   INT          NOT NULL COMMENT 'Назначенная аудитория',
    department_id INT          NOT NULL COMMENT 'Кафедра',
    type          BOOLEAN      NOT NULL DEFAULT false COMMENT 'false - зачёт, true - экзамен',
    title         VARCHAR(256) NOT NULL COMMENT 'Предмет',
    date          DATE         NOT NULL COMMENT 'Дата проведения',
    time          TIME         NOT NULL COMMENT 'Время проведения',

    CONSTRAINT UNIQUE (audience_id, date, time),

    PRIMARY KEY (id),

    FOREIGN KEY (lector_id) REFERENCES lectors (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (department_id) REFERENCES departments (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    FOREIGN KEY (audience_id) REFERENCES audiences (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) COMMENT 'Сессии';

CREATE TABLE session_group
(
    session_id INT NOT NULL COMMENT 'Сессия(экзамен/зачёт)',
    group_id   INT NOT NULL COMMENT 'Сдающая группа',

    PRIMARY KEY (session_id, group_id),

    FOREIGN KEY (session_id) REFERENCES sessions (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (group_id) REFERENCES `groups` (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT 'Связи сессий и групп';

CREATE TABLE students
(
    id         INT AUTO_INCREMENT,
    group_id   INT          NOT NULL COMMENT 'Группа в которой находится студент',
    name       VARCHAR(256) NOT NULL COMMENT 'Имя',
    surname    VARCHAR(256) NOT NULL COMMENT 'Фамилия',
    patronymic VARCHAR(256) NOT NULL DEFAULT '' COMMENT 'Отчество',

    PRIMARY KEY (id),

    FOREIGN KEY (group_id) REFERENCES `groups` (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) COMMENT 'Студенты';

CREATE TABLE exam_results
(
    session_id INT NOT NULL COMMENT 'Экзамен',
    student_id INT NOT NULL COMMENT 'Студент',
    mark       SMALLINT COMMENT 'Оцнека 2-5, NULL - н/я',

    PRIMARY KEY (session_id, student_id),

    FOREIGN KEY (session_id) REFERENCES sessions (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (student_id) REFERENCES students (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT 'Экзамены';

CREATE TABLE test_results
(
    session_id INT NOT NULL COMMENT 'Зачёт',
    student_id INT NOT NULL COMMENT 'Студент',
    mark       boolean COMMENT ' NULL - н/я, false - н/з, true - з',

    PRIMARY KEY (session_id, student_id),

    FOREIGN KEY (session_id) REFERENCES sessions (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (student_id) REFERENCES students (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) COMMENT 'Зачёты';

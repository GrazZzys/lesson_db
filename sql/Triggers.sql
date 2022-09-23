# Проверка что экзамены/зачёты для одной группы идут с перерывом в 3 дня
CREATE TRIGGER check_session_date_for_groups
    BEFORE INSERT
    ON session_group
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT *
              FROM sessions s
                       JOIN session_group sg ON s.id = sg.session_id AND s.id != NEW.session_id
              WHERE sg.group_id = NEW.group_id
                and ABS(DATEDIFF(s.date, (SELECT date FROM sessions WHERE sessions.id = NEW.session_id LIMIT 1))) <= 3)
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Между экзаменами/зачётами в одной группе должно пройти не менее трёх дней';
    END IF;
END;

# Проверка на наличие у студента экзамена при выставлении оценки и её кореектность
CREATE TRIGGER check_exam_mark
    BEFORE INSERT
    ON exam_results
    FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT *
               FROM sessions
                        JOIN session_group sg ON sessions.id = sg.session_id
                        JOIN `groups` g on g.id = sg.group_id
                        JOIN students s on g.id = s.group_id
               WHERE sessions.id = NEW.session_id AND s.id = NEW.student_id)
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'У выбранного ученика не было данного экзамена';
    END IF;

    IF NEW.mark > 5 OR NEW.mark < 2
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Максимальная оценка за экзамен - 5';
    END IF;
END;

# Проверка наличия зачёта у студента при выставлении оценки
CREATE TRIGGER check_test_mark
    BEFORE INSERT
    ON test_results
    FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT *
               FROM sessions
                        JOIN session_group sg ON sessions.id = sg.session_id
                        JOIN `groups` g on g.id = sg.group_id
                        JOIN students s on g.id = s.group_id
               WHERE sessions.id = NEW.session_id AND s.id = NEW.student_id)
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'У выбранного ученика не было данного зачёта';
    END IF;
END;
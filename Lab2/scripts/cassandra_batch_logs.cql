CREATE KEYSPACE IF NOT EXISTS streaming_lab
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE streaming_lab;

DROP TABLE IF EXISTS watch_logs_by_day;

CREATE TABLE watch_logs_by_day (
    log_date date,
    user_id uuid,
    event_time timestamp,
    content_id text,
    content_title text,
    action text,
    device text,
    watch_seconds int,
    PRIMARY KEY ((log_date), user_id, event_time)
) WITH CLUSTERING ORDER BY (user_id ASC, event_time DESC);

BEGIN BATCH
INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440001, '2026-03-28 18:05:00+0000', 'MOV001', 'Inception', 'play', 'Smart TV', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440001, '2026-03-28 18:47:12+0000', 'MOV001', 'Inception', 'pause', 'Smart TV', 2532);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440002, '2026-03-28 19:01:09+0000', 'MOV004', 'Interstellar', 'play', 'Web', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440002, '2026-03-28 20:11:14+0000', 'MOV004', 'Interstellar', 'seek', 'Web', 4214);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440003, '2026-03-28 21:22:33+0000', 'MOV006', 'Titanic', 'play', 'Mobile', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440003, '2026-03-28 21:58:40+0000', 'MOV006', 'Titanic', 'stop', 'Mobile', 2170);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440004, '2026-03-28 17:15:08+0000', 'MOV007', 'Oppenheimer', 'play', 'Web', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440004, '2026-03-28 18:44:55+0000', 'MOV007', 'Oppenheimer', 'pause', 'Web', 5387);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440005, '2026-03-28 16:20:41+0000', 'MOV008', 'The Wolf of Wall Street', 'play', 'Mobile', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440005, '2026-03-28 17:31:10+0000', 'MOV008', 'The Wolf of Wall Street', 'seek', 'Mobile', 4230);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440006, '2026-03-28 22:02:17+0000', 'MOV013', 'The Dark Knight', 'play', 'Smart TV', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-28', 550e8400-e29b-41d4-a716-446655440006, '2026-03-28 23:28:42+0000', 'MOV013', 'The Dark Knight', 'stop', 'Smart TV', 5185);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-29', 550e8400-e29b-41d4-a716-446655440007, '2026-03-29 09:10:00+0000', 'MOV004', 'Interstellar', 'play', 'Tablet', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-29', 550e8400-e29b-41d4-a716-446655440007, '2026-03-29 10:01:19+0000', 'MOV004', 'Interstellar', 'pause', 'Tablet', 3079);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-29', 550e8400-e29b-41d4-a716-446655440008, '2026-03-29 11:45:23+0000', 'MOV010', 'Vanilla Sky', 'play', 'Web', 0);

INSERT INTO watch_logs_by_day (log_date, user_id, event_time, content_id, content_title, action, device, watch_seconds)
VALUES ('2026-03-29', 550e8400-e29b-41d4-a716-446655440008, '2026-03-29 12:33:07+0000', 'MOV010', 'Vanilla Sky', 'stop', 'Web', 2864);
APPLY BATCH;

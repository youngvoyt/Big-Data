USE streaming_lab;

SELECT * FROM watch_logs_by_day
WHERE log_date = '2026-03-28';

SELECT user_id, event_time, content_title, action, watch_seconds
FROM watch_logs_by_day
WHERE log_date = '2026-03-28'
  AND user_id = 550e8400-e29b-41d4-a716-446655440001;

SELECT action, content_title, watch_seconds
FROM watch_logs_by_day
WHERE log_date = '2026-03-28'
  AND user_id = 550e8400-e29b-41d4-a716-446655440002;

SELECT * FROM watch_logs_by_day
WHERE log_date = '2026-03-29';

/*
Ожидаемый бизнес-вывод:
- пакетная вставка позволяет атомарно записать группу логов одной пользовательской сессии;
- модель таблицы оптимизирована под чтение логов за день и по конкретному пользователю;
- Cassandra подходит для write-heavy сценария стриминга.
- в тестовом наборе подготовлено более 10 логов, что достаточно для демонстрации сценария варианта.
*/

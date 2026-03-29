# Пример результатов для отчета

## Cassandra `BATCH`

```text
cqlsh> SOURCE 'scripts/cassandra_batch_logs.cql';
cqlsh> SELECT * FROM streaming_lab.watch_logs_by_day WHERE log_date='2026-03-28';

 log_date   | user_id                              | event_time                       | action | content_id | content_title | device    | watch_seconds
------------+--------------------------------------+----------------------------------+--------+------------+---------------+-----------+---------------
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440001 | 2026-03-28 18:47:12.000000+0000 |  pause |     MOV001 |     Inception |  Smart TV |          2532
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440001 | 2026-03-28 18:05:00.000000+0000 |   play |     MOV001 |     Inception |  Smart TV |             0
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440002 | 2026-03-28 20:11:14.000000+0000 |   seek |     MOV004 |  Interstellar |       Web |          4214
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440002 | 2026-03-28 19:01:09.000000+0000 |   play |     MOV004 |  Interstellar |       Web |             0
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440003 | 2026-03-28 21:58:40.000000+0000 |   stop |     MOV006 |       Titanic |    Mobile |          2170
 2026-03-28 | 550e8400-e29b-41d4-a716-446655440003 | 2026-03-28 21:22:33.000000+0000 |   play |     MOV006 |       Titanic |    Mobile |             0
```

## GraphDB / SPARQL

### Фильмы режиссеров на `C`

| filmTitle | directorName |
|---|---|
| Almost Famous | Cameron Crowe |
| Vanilla Sky | Cameron Crowe |
| Mystic River | Clint Eastwood |
| Inception | Christopher Nolan |
| Interstellar | Christopher Nolan |
| Oppenheimer | Christopher Nolan |

### Фильмы с Leonardo DiCaprio и Christopher Nolan

| filmTitle |
|---|
| Inception |

### Подсчет вклада

| personName | filmCount |
|---|---:|
| Leonardo DiCaprio | 4 |
| Christopher Nolan | 3 |

## Готовый аналитический вывод

На рассматриваемом графе знаний Леонардо Ди Каприо представлен в большем числе фильмов, чем Кристофер Нолан, однако фильмы Нолана формируют более компактную и узнаваемую подборку для рекомендательной системы. Для рекомендаций это означает, что имя актера хорошо подходит для расширения охвата контента, а имя режиссера - для построения более точных тематических цепочек.

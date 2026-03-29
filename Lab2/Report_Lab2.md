# Лабораторная работа №2

**Дисциплина:** Большие данные  
**Тема:** Полиглотное хранение данных для стриминговой платформы  
**Студент:** Войт Иван Иванович  
**Группа:** БД-251м  
**Вариант:** 10

## Структура репозитория

```text
.
|-- docker-compose.yml
|-- README.md
|-- data
|   |-- movies_sample.ttl
|   `-- sample_results.md
|-- screenshots
|   |-- cql_batch_result.png
|   |-- docker_ps.png
|   |-- graphdb_query_1.png
|   `-- graphdb_query_2.png
`-- scripts
    |-- cassandra_batch_logs.cql
    |-- cassandra_queries.cql
    |-- graph_query_contribution.sparql
    |-- graph_query_dicaprio_nolan.sparql
    |-- graph_query_directors_c.sparql
    |-- mongo_crud.js
    `-- mongo_seed.js
```

## Введение

В этой лабораторной работе я разбирал подход `Polyglot Persistence` на примере стриминговой платформы, похожей на Netflix или Кинопоиск. Идея в том, что для разных типов данных не всегда удобно использовать одну и ту же СУБД. У платформы есть каталог фильмов, профили пользователей, история просмотров и граф связей между фильмами, актерами и режиссерами. Под такие задачи логичнее брать разные базы данных.

В своей работе я использовал:

- `MongoDB` для хранения пользователей и каталога контента;
- `Cassandra` для логов действий пользователей;
- `GraphDB` для RDF-графа и SPARQL-запросов;
- `Docker Compose` для запуска всей среды.

Почему именно так:

- `MongoDB` удобна для документов, где структура может меняться;
- `Cassandra` хорошо подходит под потоковую запись логов;
- `GraphDB` удобна, когда нужно искать связи между сущностями, а не просто строки в таблице.

## Развертывание

Для запуска окружения я использовал файл `docker-compose.yml`.

Команда запуска:

```bash
docker compose up -d
```

После запуска были доступны сервисы:

| Сервис | Адрес |
|---|---|
| Mongo Express | `http://localhost:28203` |
| Admin Mongo | `http://localhost:28204` |
| Cassandra-Web | `http://localhost:28200` |
| Cassandra CQL | `localhost:9042` |
| GraphDB | `http://localhost:7200` |
| Redis Commander | `http://localhost:28119` |

### Контейнеры

![docker ps](screenshots/docker_ps.png)

### Cassandra

![cql batch](screenshots/cql_batch_result.png)

### GraphDB

![graphdb query 1](screenshots/graphdb_query_1.png)

![graphdb query 2](screenshots/graphdb_query_2.png)

## Задание 1. Cassandra

По моему варианту нужно было выполнить `BATCH`-вставку нескольких логов одновременно.

### Модель данных

Для логов я сделал таблицу:

```sql
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
```

Я выбрал такую структуру потому что:

- удобно получать события за конкретный день;
- внутри дня можно смотреть действия конкретного пользователя;
- Cassandra в целом лучше подходит под такие write-heavy данные, чем документная или графовая БД.

### Скрипт

Файл: `scripts/cassandra_batch_logs.cql`

```sql
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
```

### Проверка

Файл: `scripts/cassandra_queries.cql`

```sql
USE streaming_lab;

SELECT * FROM watch_logs_by_day
WHERE log_date = '2026-03-28';

SELECT user_id, event_time, content_title, action, watch_seconds
FROM watch_logs_by_day
WHERE log_date = '2026-03-28'
  AND user_id = 550e8400-e29b-41d4-a716-446655440001;
```

В итоге у меня получилось 16 логов за две даты. Этого достаточно, чтобы показать пакетную вставку, чтение по дате и чтение по конкретному пользователю.

## MongoDB

Хотя основное задание по моему варианту было на Cassandra, я все равно подготовил и MongoDB-часть, потому что она нужна для общей архитектуры решения.

Файлы:

- `scripts/mongo_seed.js`
- `scripts/mongo_crud.js`

В MongoDB у меня:

- 12 документов в коллекции `users`;
- 12 документов в коллекции `content`.

Пример CRUD:

```javascript
use("streaming_lab");

db.content.find({ director: "Christopher Nolan" });

db.users.updateOne(
  { _id: "USR002" },
  { $set: { plan: "premium" } }
);

db.users.find({ plan: "premium" });
```

Для этой части MongoDB удобна тем, что карточки фильмов и профили пользователей можно хранить в документном виде без жесткой схемы.

## Задание 2. GraphDB / SPARQL

Для графовой части я создал репозиторий `movies_repo` и загрузил туда файл `data/movies_sample.ttl`.

Пример RDF-данных:

```turtle
@prefix ex: <http://example.org/movies#> .

ex:ChristopherNolan a ex:Director ;
    ex:name "Christopher Nolan" .

ex:LeonardoDiCaprio a ex:Actor ;
    ex:name "Leonardo DiCaprio" .

ex:Film_Inception a ex:Film ;
    ex:title "Inception" ;
    ex:directedBy ex:ChristopherNolan ;
    ex:hasActor ex:LeonardoDiCaprio .
```

### Запрос 1. Фильмы режиссеров на букву C

Файл: `scripts/graph_query_directors_c.sparql`

```sparql
PREFIX ex: <http://example.org/movies#>

SELECT ?filmTitle ?directorName
WHERE {
  ?film a ex:Film ;
        ex:title ?filmTitle ;
        ex:directedBy ?director .
  ?director ex:name ?directorName .
  FILTER regex(?directorName, "^C", "i")
}
ORDER BY ?directorName ?filmTitle
```

Результат:

| filmTitle | directorName |
|---|---|
| Almost Famous | Cameron Crowe |
| Vanilla Sky | Cameron Crowe |
| Mystic River | Clint Eastwood |
| Inception | Christopher Nolan |
| Interstellar | Christopher Nolan |
| Oppenheimer | Christopher Nolan |

### Запрос 2. Фильмы с участием Leonardo DiCaprio и Christopher Nolan

Файл: `scripts/graph_query_dicaprio_nolan.sparql`

```sparql
PREFIX ex: <http://example.org/movies#>

SELECT ?filmTitle
WHERE {
  ?film a ex:Film ;
        ex:title ?filmTitle ;
        ex:directedBy ?director ;
        ex:hasActor ?actor .
  ?director ex:name "Christopher Nolan" .
  ?actor ex:name "Leonardo DiCaprio" .
}
ORDER BY ?filmTitle
```

Результат:

| filmTitle |
|---|
| Inception |

Мне понравилось, что в GraphDB такие запросы выглядят намного естественнее, чем если бы те же связи пришлось собирать через несколько таблиц и join-операции.

## Задание 3. Бизнес-аналитика

Для аналитической части я отдельно посчитал, сколько фильмов связано с Кристофером Ноланом и сколько с Леонардо Ди Каприо.

Файл: `scripts/graph_query_contribution.sparql`

```sparql
PREFIX ex: <http://example.org/movies#>

SELECT ?personName (COUNT(DISTINCT ?film) AS ?filmCount)
WHERE {
  VALUES ?personName { "Christopher Nolan" "Leonardo DiCaprio" }

  ?film a ex:Film .

  {
    ?film ex:directedBy ?person .
  }
  UNION
  {
    ?film ex:hasActor ?person .
  }

  ?person ex:name ?personName .
}
GROUP BY ?personName
ORDER BY DESC(?filmCount)
```

Результат:

| personName | filmCount |
|---|---:|
| Leonardo DiCaprio | 4 |
| Christopher Nolan | 3 |

### Мой вывод

По этому набору данных видно, что Леонардо Ди Каприо связан с большим числом фильмов, чем Кристофер Нолан. Значит, если строить рекомендации через актера, можно получить более широкий охват контента.

У Кристофера Нолана фильмов меньше, но они более цельно воспринимаются как режиссерская подборка. Поэтому его логичнее использовать для более точных рекомендаций внутри конкретного стиля или жанрового сегмента.

Отдельно важен фильм `Inception`, потому что он оказался точкой пересечения: здесь есть и Кристофер Нолан, и Леонардо Ди Каприо. Для рекомендательной системы это хороший “якорный” фильм, от которого можно строить дальнейшие подборки.

То есть в практическом смысле я бы использовал обе стратегии:

- через актера для расширения выдачи;
- через режиссера для более точной персонализации.

## Выводы

В этой работе я собрал полиглотную систему хранения данных для стриминговой платформы и разделил данные по типам:

- `MongoDB` для каталога и профилей;
- `Cassandra` для логов;
- `GraphDB` для графа знаний и рекомендательных запросов.

По итогу могу сделать такой вывод:

- `Cassandra` лучше всего подошла для логов и batch-вставки;
- `GraphDB` оказалась самой удобной для поиска связей и рекомендаций;
- `MongoDB` хорошо подходит для хранения контента и пользователей.

На мой взгляд, в этом и есть главный плюс полиглотного подхода: не пытаться решить все задачи одной базой, а использовать ту модель, которая лучше подходит под конкретный тип данных.

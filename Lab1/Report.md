# Отчет по лабораторной работе №1

## Сведения о студенте

- Студент: Войт Иван Иванович
- Вуз: МГПУ
- Группа: Бд-251м
- Дисциплина: Инструменты хранения и анализа больших данных

## Введение

Цель лабораторной работы заключается в освоении приемов обработки и анализа больших данных с использованием Apache Spark. В рамках варианта №10 рассматривается задача ценообразования: необходимо исследовать, как изменение цены товара влияет на объем спроса.

Работа выполняется в `Google Colab`, что допускается методическими указаниями как альтернативный вариант среды выполнения. Для анализа выбран открытый датасет с Kaggle, содержащий сведения о ценах, количестве продаж и категориях товаров.

## Постановка бизнес-задачи

Компании необходимо понять, как цена влияет на спрос. Это важно для принятия решений о скидках, корректировке прайс-листа и выборе ценовой стратегии. Основной аналитический вопрос: существует ли связь между ценой товара и объемом продаж, и насколько она выражена в различных категориях товаров.

## Описание датасета

Для выполнения лабораторной работы используется датасет:

- Kaggle: [Retail Price Optimization](https://www.kaggle.com/datasets/suddharshan/retail-price-optimization)

Почему датасет подходит:

- содержит поле `unit_price`, отражающее цену товара;
- содержит поле `qty`, отражающее объем продаж;
- содержит поле `month_year`, позволяющее анализировать данные во времени;
- содержит поле `product_category_name`, позволяющее сравнивать категории товаров.

Основные поля, используемые в работе:

- `product_id`
- `product_category_name`
- `month_year`
- `qty`
- `unit_price`
- `total_price`
- `freight_price`
- `customers`
- `month`
- `year`

## Используемое окружение

- Google Colab
- Python 3
- PySpark
- pandas
- matplotlib
- numpy
- kagglehub

## Ход работы

### 1. Подготовка среды

В Google Colab устанавливались необходимые библиотеки:

```python
!pip install pyspark pandas matplotlib numpy kagglehub
```

После этого датасет загружался напрямую с Kaggle:

```python
import kagglehub
from pathlib import Path

dataset_path = kagglehub.dataset_download("suddharshan/retail-price-optimization")
csv_path = str(next(Path(dataset_path).rglob("*.csv")))
```

### 2. Загрузка и предварительный просмотр данных

На этом этапе создавалась Spark-сессия и CSV-файл считывался в `Spark DataFrame`:

```python
raw_df = spark.read.option("header", "true").option("inferSchema", "true").csv(csv_path)
raw_df.printSchema()
raw_df.show(5, truncate=False)
```

В отчет рекомендуется вставить:

- скриншот схемы данных `printSchema()`;
- скриншот первых строк `show(5)`.

### 3. Предобработка данных

Для решения задачи были выбраны только необходимые поля. Затем выполнялись:

- приведение типов столбцов;
- удаление `NULL` в ключевых полях;
- фильтрация некорректных значений;
- удаление дубликатов;
- расчет поля `estimated_revenue`.

Код предобработки:

```python
df = (
    raw_df.select(
        col("product_id"),
        col("product_category_name").alias("category"),
        col("month_year"),
        col("qty").cast("double").alias("units_sold"),
        col("unit_price").cast("double").alias("price"),
        col("total_price").cast("double").alias("total_price"),
        col("freight_price").cast("double").alias("freight_price"),
        col("customers").cast("double").alias("customers"),
        col("month").cast("int").alias("month"),
        col("year").cast("int").alias("year")
    )
    .dropna(subset=["product_id", "category", "units_sold", "price"])
    .filter((col("price") > 0) & (col("units_sold") > 0))
    .dropDuplicates()
    .withColumn("estimated_revenue", spark_round(col("price") * col("units_sold"), 2))
)
```

Проверка пропусков:

```python
null_check.show()
```

В отчет рекомендуется вставить:

- скриншот проверки `NULL`;
- скриншот очищенной схемы датафрейма.

### 4. Анализ данных

#### 4.1 Корреляционный анализ

Для ответа на основной вопрос варианта рассчитывалась корреляция между ценой и объемом продаж:

```python
overall_corr = df.stat.corr("price", "units_sold")
```

Если коэффициент отрицательный, это означает, что с ростом цены объем продаж снижается, то есть спрос чувствителен к изменению цены.

#### 4.2 Анализ по категориям

Дополнительно был выполнен анализ по категориям:

```python
elasticity_df = (
    df.groupBy("category")
      .agg(
          count("*").alias("observations"),
          spark_round(avg("price"), 2).alias("avg_price"),
          spark_round(avg("units_sold"), 2).alias("avg_units_sold"),
          spark_round(corr("price", "units_sold"), 4).alias("price_qty_corr"),
          spark_round(spark_sum("estimated_revenue"), 2).alias("estimated_revenue")
      )
      .orderBy("price_qty_corr")
)
```

Этот этап показывает, какие категории наиболее чувствительны к изменению цены.

#### 4.3 Spark SQL

Для бизнес-аналитики использовался `Spark SQL`:

```sql
SELECT
    category,
    COUNT(*) AS observations,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    ROUND(CORR(price, units_sold), 4) AS price_qty_corr,
    ROUND(SUM(estimated_revenue), 2) AS estimated_revenue
FROM pricing_data
GROUP BY category
ORDER BY price_qty_corr ASC
```

В отчет рекомендуется вставить:

- текст SQL-запроса;
- таблицу с результатами `sql_result.show()`.

## Визуализация

Для наглядного представления зависимости между ценой и объемом продаж строится `scatter plot` с линией регрессии.

Интерпретация графика:

- каждая точка соответствует отдельному наблюдению;
- ось `X` показывает цену товара;
- ось `Y` показывает объем продаж;
- линия регрессии показывает общий тренд зависимости.

Если линия направлена вниз, это означает, что при росте цены объем продаж в среднем уменьшается.

Пример бизнес-интерпретации:

`График показывает обратную зависимость между ценой и объемом продаж. Это означает, что повышение цены может приводить к снижению спроса. Такие результаты полезны для формирования скидочной политики и выбора оптимального уровня цены.`

## Выводы

В ходе лабораторной работы был выполнен анализ данных о ценах и продажах в среде `Google Colab` с использованием `PySpark`. Были загружены данные из Kaggle, выполнены очистка и предобработка, рассчитана корреляция между ценой и объемом спроса, проведен SQL-анализ по категориям и построена визуализация.

Практическая ценность работы состоит в том, что компания может использовать такой подход для оценки ценовой эластичности спроса. Использование Apache Spark позволяет масштабировать подобный анализ на большие объемы данных, а Google Colab обеспечивает удобную среду для выполнения учебной лабораторной работы.

## Что добавить перед сдачей

- Скриншот установки библиотек и загрузки датасета в Colab.
- Скриншот `printSchema()` и `show(5)`.
- Скриншот проверки `NULL`.
- Скриншот таблицы `Spark SQL`.
- Скриншот графика `Цена vs Объем продаж`.
- Ссылку на публичный репозиторий GitHub или GitVerse.

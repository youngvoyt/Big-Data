# Лабораторная работа №1

## Общая информация

- Студент: Войт Иван Иванович
- Вуз: МГПУ
- Группа: Бд-251м
- Дисциплина: Инструменты хранения и анализа больших данных
- Вариант: `10. Ценообразование`
- Формат выполнения: `Google Colab`

## Введение

Цель лабораторной работы заключается в освоении приемов обработки и анализа больших данных с использованием Apache Spark. В рамках варианта №10 рассматривается задача ценообразования: необходимо исследовать, как изменение цены товара влияет на объем спроса.

Работа выполняется в `Google Colab`, что допускается методическими указаниями как альтернативный вариант среды выполнения. Для анализа выбран открытый датасет с Kaggle, содержащий сведения о ценах, количестве продаж и категориях товаров.

## Постановка задачи

Необходимо исследовать ценовую эластичность спроса, то есть определить, как изменение цены влияет на объем продаж. Для этого выполняются загрузка данных, предобработка, аналитика средствами `PySpark` и `Spark SQL`, а затем строится визуализация `Цена vs Объем продаж` с линией регрессии.

Основной бизнес-вопрос: существует ли связь между ценой товара и объемом продаж, и насколько эта связь выражена в различных категориях товаров.

## Выбранный датасет

Для выполнения работы используется открытый датасет с Kaggle:

- [Retail Price Optimization](https://www.kaggle.com/datasets/suddharshan/retail-price-optimization)

Почему он подходит:

- содержит `unit_price` — цену товара;
- содержит `qty` — объем продаж;
- содержит `month_year` — временной срез;
- содержит `product_category_name` — категорию товара.

CSV-файл, который используется в работе: `retail_price.csv`.

### Основные поля датасета

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

## Структура репозитория

- `README.md` — единый файл с описанием проекта и отчетом.
- `lab_01.ipynb` — основной ноутбук для Google Colab.

## Используемое окружение

- Google Colab
- Python 3
- PySpark
- pandas
- matplotlib
- numpy
- kagglehub

## Инструкция по запуску

### В Google Colab

1. Загрузите файл `lab_01.ipynb` в Google Colab.
2. Выполните ячейки сверху вниз.
3. Дождитесь загрузки датасета, обработки данных и построения графика.

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

## Что получится в результате

- очищенный Spark DataFrame;
- результат корреляционного анализа;
- таблица `Spark SQL` по категориям;
- график `Цена vs Объем продаж` с линией регрессии;
- готовая база для отчета.

## Выводы

В ходе лабораторной работы был выполнен анализ данных о ценах и продажах в среде `Google Colab` с использованием `PySpark`. Были загружены данные из Kaggle, выполнены очистка и предобработка, рассчитана корреляция между ценой и объемом спроса, проведен SQL-анализ по категориям и построена визуализация.

Практическая ценность работы состоит в том, что компания может использовать такой подход для оценки ценовой эластичности спроса. Использование Apache Spark позволяет масштабировать подобный анализ на большие объемы данных, а Google Colab обеспечивает удобную среду для выполнения учебной лабораторной работы.

## Источник данных

- Kaggle: [Retail Price Optimization](https://www.kaggle.com/datasets/suddharshan/retail-price-optimization)

## Примечание

Работа выполняется в `Google Colab`, что допускается условием задания как альтернативный формат. Поэтому основной акцент в оформлении сделан на `PySpark`, `Spark SQL`, визуализации и интерпретации результатов.

# Лабораторная работа №1

## Общая информация

- Студент: Войт Иван Иванович
- Вуз: МГПУ
- Группа: Бд-251м
- Дисциплина: Инструменты хранения и анализа больших данных
- Вариант: `10. Ценообразование`
- Формат выполнения: `Google Colab`

## Описание задачи

Необходимо исследовать ценовую эластичность спроса, то есть определить, как изменение цены влияет на объем продаж. Для этого выполняются загрузка данных, предобработка, аналитика средствами `PySpark` и `Spark SQL`, а затем строится визуализация `Цена vs Объем продаж` с линией регрессии.

## Выбранный датасет

Для выполнения работы используется открытый датасет с Kaggle:

- [Retail Price Optimization](https://www.kaggle.com/datasets/suddharshan/retail-price-optimization)

Почему он подходит:

- содержит `unit_price` — цену товара;
- содержит `qty` — объем продаж;
- содержит `month_year` — временной срез;
- содержит `product_category_name` — категорию товара.

CSV-файл, который используется в работе: `retail_price.csv`.

## Структура репозитория

- `README.md` — описание проекта, инструкция по запуску и ссылка на датасет.
- `lab_01.ipynb` — основной ноутбук для Google Colab.
- `lab1_pricing_analysis.py` — альтернативная версия решения в виде Python-скрипта.
- `Report.md` — отчет по лабораторной работе.

## Ход работы

### 1. Подготовка среды

В Google Colab устанавливаются библиотеки:

```python
!pip install pyspark pandas matplotlib numpy kagglehub
```

### 2. Загрузка датасета

```python
import kagglehub
from pathlib import Path

dataset_path = kagglehub.dataset_download("suddharshan/retail-price-optimization")
csv_path = str(next(Path(dataset_path).rglob("*.csv")))
```

### 3. Загрузка данных в Spark

После инициализации `SparkSession` CSV считывается в `Spark DataFrame`, затем выводятся схема и первые строки.

### 4. Очистка и предобработка

Выполняются:

- выбор нужных полей;
- приведение типов данных;
- удаление `NULL`;
- фильтрация некорректных значений;
- удаление дубликатов;
- расчет `estimated_revenue`.

### 5. Анализ средствами PySpark и Spark SQL

Выполняются:

- расчет общей корреляции между ценой и объемом продаж;
- анализ по категориям товаров;
- SQL-запрос с агрегацией, сортировкой и расчетом корреляции.

### 6. Визуализация

Строится `scatter plot` с линией регрессии:

- ось `X` — цена товара;
- ось `Y` — объем продаж;
- линия регрессии показывает общий тренд зависимости.

## Инструкция по запуску

### В Google Colab

1. Загрузите файл `lab_01.ipynb` в Google Colab.
2. Выполните ячейки сверху вниз.
3. Дождитесь загрузки датасета, обработки данных и построения графика.
4. Сохраните скриншоты результатов для отчета.

### Через Python-скрипт

```python
!pip install pyspark pandas matplotlib numpy kagglehub
```

```python
import kagglehub
from pathlib import Path

dataset_path = kagglehub.dataset_download("suddharshan/retail-price-optimization")
csv_path = str(next(Path(dataset_path).rglob("*.csv")))
```

```python
!python lab1_pricing_analysis.py --input "$csv_path" --master "local[*]"
```

## Что получится в результате

- очищенный Spark DataFrame;
- результат корреляционного анализа;
- таблица `Spark SQL` по категориям;
- график `Цена vs Объем продаж` с линией регрессии;
- готовая база для отчета.

## Источник данных

- Kaggle: [Retail Price Optimization](https://www.kaggle.com/datasets/suddharshan/retail-price-optimization)

## Примечание

Работа выполняется в `Google Colab`, что допускается условием задания как альтернативный формат. Поэтому основной акцент в оформлении сделан на `PySpark`, `Spark SQL`, визуализации и интерпретации результатов.

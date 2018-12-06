import pyspark
import pandas as pd
import numpy as np
context = pyspark.SparkContext('local[*]')

from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()

pandasdf = pd.DataFrame(np.random.random(10))
sparkdf = spark.createDataFrame(pandasdf)
sparkdf.createOrReplaceTempView("random")

sparkdf.printSchema()
sparkdf.show(2,truncate=True)

filepath = '/opt/conda/lib/python3.6/site-packages/'
filepath += 'bokeh/sampledata/_data/us_marriages_divorces.csv'
divorces = spark.read.csv(filepath, header=True)
divorces.show(n=5)
filtered = divorces.filter('Year >= 1960')
print("FIRST STUDENT DELIVERABLE")
print("DIVORSES ", type(divorces))
print("FILTERED ", type(filtered))

words = context.parallelize('one fish two fish red fish blue fish'.split())

print("SECOND STUDENT DELIVERABLE")
length_three = words.filter(lambda word: len(word) == 3)
smallWords = length_three.map(lambda word: word.upper())
print(smallWords.collect())

from pyspark.sql import Row
customerList = [
(10010,'Ramas' ,'Alfred'),
(10011,'Dunne' ,'Leona' ),
(10012,'Smith' ,'Kathy' ),
(10013,'Olowski' ,'Paul' ),
(10014,'Orlando' ,'Myron' ),
(10015,'O''Brian','Amy' ),
(10016,'Brown' ,'James' ),
(10017,'Williams','George'),
(10018,'Farriss' ,'Anne' ),
(10019,'Smith' ,'Olette')
]
customerRdd = context.parallelize(customerList)
print("THIRD STUDENT DELIVERABLE")
customersRowsRdd = customerRdd.map(lambda x: Row(cust_name=x[1] + " " + x[2], cust_id=x[0]))
customersdf = spark.createDataFrame(customersRowsRdd)
customersdf.printSchema()
customersdf.show()

bachelorsWomen = spark.read.csv("/opt/conda/lib/python3.6/site-packages/bokeh/sampledata/_data/percent-bachelors-degrees-women-usa.csv",header=True, inferSchema=True)
bachelorsWomen.printSchema()
print(bachelorsWomen.columns)

print("FOURTH STUDENT DELIVERABLE")
print('Rows: %d' % bachelorsWomen.count())
print('Columns: %d' % len(bachelorsWomen.columns))

bachelorsWomen.describe('Computer Science').show()
bachelorsWomen.registerTempTable('bw')
bachelorsWomenTech = spark.sql(
 'select `Computer Science`, `Engineering`, `Physical Sciences`'
 ' from bw'
)
bachelorsWomenTech.filter('Year > 2000').agg({x: "avg" for x in bachelorsWomenTech.columns}).show()

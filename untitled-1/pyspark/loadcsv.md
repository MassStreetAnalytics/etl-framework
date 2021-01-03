# LoadCSV

Getting a CSV into Spark.

```text
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .master("spark://spark://[YourServerIP]") \
    .getOrCreate()

from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession, SQLContext
sc = SparkContext()
sqlq = SQLContext(sc)

tnpdf = sqlq.read.format("csv").option("header","true").option("delimiter","|").load("[Path To Your CSV]")

rdf.count()
```




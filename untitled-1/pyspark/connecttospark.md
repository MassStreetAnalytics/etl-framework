# ConnectToSpark

Setting up a connection to your Spark server.

```text
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .master("spark://[YourServerIP]") \
    .getOrCreate()

from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession, SQLContext
sc = SparkContext()
sqlq = SQLContext(sc)
```


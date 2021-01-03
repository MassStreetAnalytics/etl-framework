# ExampleDataProcessing

This notebook shows various methods for working with Spark using Spark SQL and DataFrames. I will discuss what each line is doing.

All the imports necessary to connect to Spark and work with Spark SQL.

```text
from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession, SQLContext
import pyspark.sql.functions as func
from pyspark.sql.types import *
sc = SparkContext()
sqlq = SQLContext(sc)
import os
```

This pulls a CSV onto the Spark cluster. The .option\("quote","^"\) method is the result of a quirk. If you don't specify a value for quote, it will default to ". If you're trying to escape things, we don't want to use " as an escape character. So use something funky that would rarely show up in text like the carrot symbol.

We are actually going to load two files here and then bump them together later.

```text
rdf = sqlq.read.format("csv").option("header","true").option("delimiter","|").option("quote","^").load("[Path To Your File]")
tnpdf = sqlq.read.format("csv").option("header","true").option("delimiter","|").option("quote","^").load("[Path To Your File]")
```

This is how to do a record count.

```text
rdf.count()
```

Filtering on one column.

```text
rdf = rdf.filter(rdf.[YourColumn] != '')
```

Filtering on more than one column.

```text
rdf = rdf.filter(rdf.[YourColumn1] != 'SomeValue').filter(rdf.[YourColumn2] != 'SomeOtherValue')
```

Filtering on more than one value.

```text
ExcludeList = ['Value1','Value2',...'ValueN']
rdf = rdf.filter(rdf.[YourColumnName].isin(ExcludeList) == False)
```

Joining data frames.

```text
joined = rdf.join(tnpdf,func.lower(rdf.[YourJoinColumn]) == func.lower(tnpdf.[YourJoinColumn]), how="left")
```

Dropping a column out of your dataset.

```text
no[YourBooleanColumn] = joined.drop('[YourBooleanColumn]')
```

Show only 20 records of one column.

```text
no[YourBooleanColumn].select(no[YourBooleanColumn].[YourColumnName]).show(n=20)
```

Create a lambda function.

```text
CheckFor[YourBooleanColumn] = func.udf(lambda x: 'No' if x is None else 'Yes', StringType())
```

I have no idea what this is doing. I wrote this a year ago. See! This is why we document!

But seriously. There is a course planned called Advanced Data Systems Design And Implementation. In that class, I'll take time out of my precious dwindling existence to break this line of code down.

For now, these are not the droids you're looking for. Move along.

```text
with[YourBooleanColumn] = no[YourBooleanColumn].withColumn('[YourBooleanColumn]',func.lit(CheckFor[YourBooleanColumn](joined.[YourColumnName])))
```

Display columns in a dataset.

```text
with[YourBooleanColumn].columns
```

Show all columns, filter on one column, show only 20 records.

```text
CleanedResults.select('*').where(CleanedResults.[YourColumnName]=='FilterValue').show(n=20)
```

This is a really important line. I work with data in and data out. Spark does not really have a nice "data out" function which is SUPER WEIRD. I had to do a lot of research to figure out how to spit the results of my work back out as a CSV.

The challenge here is in how Spark works. It is a distributed system. Without boring you with the ins and outs of MapReduce, what essentially happens is that your data is split up among all the machines in the cluster. So its not like you can just to\_csv\(\) and call it a day. The system has to collect all the parts and put Humpty back together. 

Anyway, enjoy the fruits of my labor. I should charge you like $2,000 just to give you this one line of code.

```text
CleanedResults.repartition(1).write.option('nullValue',None).csv('[Path To Your Output File]', sep='|',header='true',mode='overwrite')
```


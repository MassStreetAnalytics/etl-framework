# Data Model View Creation Helper

For some models, the number of columns in the two dimensional view can get up there. Sometimes you can pick and choose which columns to display especially in the case of the role play dimension. Other times, nope, you gotta show all fifty columns out of one dimension.

To make matters worse, there may be like 15 dimensions connected to the fact table which means a monstrous join. Do this a few times and you would have created this tab yourself.

The theory here is to create a select statement with little muss or fuss. You build it up one table at a time.

Here is how you use this tab.

1. Place every tabled involved in column A.
2. Give each table an alias and place it in column B.
3. Place the table primary key in column C.
4. Place the columns of a single table in column G.
5. Copy down the table you are currently working with in column E.
6. Everything else fills in.

Once you have all of your columns aliased, you can use the information in column C to create your complex join. Or you can do that first. There is no right way.

![](../.gitbook/assets/data-model-view-creation-helper.png)


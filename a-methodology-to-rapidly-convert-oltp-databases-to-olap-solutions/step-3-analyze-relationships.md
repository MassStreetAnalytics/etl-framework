# Step 3: Analyze Relationships

At this point, our work has all been high level. Now we need to step into the weeds and look for details that might have been missed in previous steps so we can refine our model.

A lot of information is captured in the relationships of tables. This information can be used to uncover additional dimensions, or facts that we didn't see the first time around.

In this specific instance, we notice that a film can be in more than one language and category. That means we can't have film and category in the same dimension table. 

We also see that store has only one address but an address can be assigned to more than one customer. The implication here is that address can be it's own dimension, but it also makes sense to have geographic information stored in the store dimension.

Once you analyze and mark up your ERD, it turns into a standard dimensional modeling exercise.


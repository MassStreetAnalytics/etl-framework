# Handling Calculated Values

![](../.gitbook/assets/4rdkfl.jpg)

In general, there should be no math in the pipeline. You should not be storing the results of calculations. instead, you should be storing the components of calculations. The reason for this is because the definitions of values often change. This is particularly true of greenfield projects as the business negotiates with various internal factions and consensus is built around the definition of various KPIs. Even after this process is complete, it is a poor assumption that the definition of a KPI is written in stone.

Having math in your pipeline is problematic. The question is, where does the calculation go?

1. Does it go in the pull?
2. Does it go in the cleansing process?
3. Does it go in the fact table load?
4. Do you have a published policy about where calculations go?
5. Are all your engineers familiar with the policy so they don't put calculations where they don't belong according to the policy?
6. Are you 100% certain of 5 because now there is a problem with numbers and you can't find where the calculation lives.

Having math in the pipeline is bad DataOps. It is one of the very many opportunities you will be given to shoot your organization's analytic efforts in the foot. Anything that slows down your ability to push code needs to be tossed aside in favor of something simpler, faster, and easier to manage.

Having all calculations handled in BI Reporting tools or processes in the Reporting database is a natural thought process that does not require a policy for everybody to memorize. Because of course that's where the math goes. Where else would it go but the end point where the value can be surfaced at runtime just like we all learned in college but somehow forgot when we hit the real world. I guess all this money made us forget a few fundamentals.

Having said all that, this is software engineering and edge cases are a thing. There are very good arguments to be had for having math in the pipeline if it makes sense to do so. The scenario that I run into most often is that the result of a calculation is itself a component of another calculation and we do not care one bit about the original components. In that case, it makes sense to put math in the pull.

The tl;dr version:

1. Put math in at the end points of your pipeline. Do not put them in the middle all helter skelter.
2. When deciding where to put calculations, use the following heuristic.
   1. Is it a day ending in "y"? Put the math in the report.
   2. There is no second rule.


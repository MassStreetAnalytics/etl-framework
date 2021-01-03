# Melding Kimball And Inmon

What is the difference between Kimball and Inmon data warehouse methodology?

Who cares?

Both approaches have pros and cons. I have found it best to mix and match the two into an optimal enterprise solution. Below is a high level approach to data warehouse development that favors neither methodology, and creates a third approach that combines the best of both worlds.

1. No matter what you do, always follow the rules of dimensional modeling which are orthogonal to either approach.
2. The enterprise data warehouse is the central repository for ALL historical data in the entire organization.
3. However, do not try to boil the ocean. Do not try to build the entire data warehouse at once by modeling every transactional system in the enterprise. Do not even try to build the EDW by modeling the whole of a single transactional system.
4. Build the data warehouse one dataset at a time. Find a data set that is high value and easy to implement and do that. I would recommend some report or dashboard that is currently running off a transactional system. Financial reporting is always high value as is marketing data.
5. Since the data warehouse is being built using the same source systems, it will not matter that you do things one at a time. Everything will shake out and integrate in the future with minimal adjustment to the data model. As an example, if you need to create a customer dimension and connect it to a fact table, if you create another fact table that needs customers in the future, it will connect right in because it is the same customers.
6. Expose that data set through the various means outlined in this framework.
7. Get on a cycle of producing a valuable data set once every 3 weeks.
8. Rinse and repeat and soon you will have successfully modeled everything without a big creaky unmanageable project that may not even deliver what was asked.


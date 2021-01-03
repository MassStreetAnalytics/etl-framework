# The Semantic Layer

The data warehouse should be incredibly intuitive. Table names and column names should be so obvious that a person brand new to the organization can sit down and start asking question off the database without and knowledge of the business, reading documentation, or get assistance from IT.

That's the dream right there. Totally frictionless business analytics.

However, even though your object names are obvious, they are still awkward for business users to work with in their original form. DimCustomer.FirstName? Bleh.

What users need is something that will look nice in a reporting tool like Tableau. That's where the semantic layer comes in. 

The semantic layer exist in the Reporting database. The Reporting database is filled with a bunch of de-normalized 2 dimensional datasets. Technically they have a bunch of columns so obviously there are more than 2 dimensions, however, in this context, datasets are built simply using the x and y axis.

These datasets, rather they be views, or physical tables, are build with pretty names. DimCustomer.FirstName becomes Customer.\[First Name\]. This is so when the user connects to Reporting with their BI tool, they can simply click and drag ready made easy to read columns for their reports.

**Pro tip: There should be practically NO logic in the Semantic Layer.**

The semantic layer is there to make known datasets available to business or otherwise non-technical users. These data sets frequently comprise canned reporting requirements. 

The creation of these datasets should be nothing more than the joins and filters necessary to pull the data from the data warehouse. There should be no complex transformations, no complex math, no hanky panky or funny business. That is what the BI tool is for. Let the reports writer shape the data. You just provide it in an simple two dimensional format.

**Pro tip: BI tool = hanky panky.**


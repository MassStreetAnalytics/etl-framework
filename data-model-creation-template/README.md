# Data Model Creation Tool

The data model creation tool is the MOAB \(mother of all bombs\) of all the tools in here. This is the thing that lets you create OLAP solutions quickly by automating a lot of the script creation necessary to process data. The template can be found in: etl-framework\Rapid Development Tools.

The tool is not set in stone. Feel free to alter it to your needs. I frequently have to make customizations in each client engagement.

The data model creation tool is designed to help you build one model at a time. A model is defined as a single fact table and all the dimensions attached to it. It may be the case that the full model actually requires more than one fact table. In that case, it is recommended that you use different sheets for different fact tables.

**Pro Tip: A model is defined as a single fact table and all the dimensions attached to it.**

The first step in its usage is to enable content. This spreadsheet uses a user defined function called AddSpaces\(\) which we will see in action later. Since it's a macro, you have to arm the sheet for the function to fire.

This section goes into the sheet tab by tab explaining its use in great detail.






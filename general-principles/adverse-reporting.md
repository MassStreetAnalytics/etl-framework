# Adverse Reporting

The ETL Framework only reports adverse events. This is in contrast to other systems that report all warehouse events.

Since we are building a system with six nines of reliability, the assumption is that the warehouse successfully processes everyday. This assumption does two things:

1. Significantly reduces email traffic so EDW stakeholders do not get numb to daily emails.
2. Makes it easier to spot emails that are reporting errors.

While some executives may want daily completion emails, we strongly urge you to resist this request, or develop a system by where the people that are responsible for the care and feeding of the data warehouse are not getting daily completion emails.


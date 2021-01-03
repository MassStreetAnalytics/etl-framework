# The Mechanics Of Checking For Unprocessed Records

Before we get to the rocket science, there are some simple things we can do to make sure things are going smoothly. The basic feedback system is checking to see if everything in a stage table processed correctly.

This is done by matching UniqueDim and/or UniqueRow hash values. This process is normally done with fact tables as loads are usually designed to stop processing if there are missing dimension records.

Below is a diagram of how the hash comparison works. Hashes in EDW and the common model in ODS are calculated automatically.

![](../../.gitbook/assets/unprocessedrecords%20%281%29.png)

1. The fact table is loaded. In that process, unique dims are passed back to the stage table.
2. Unique dims from the fact table and stage table are compared and where there is a match, that record is marked as processed.
3. The stage table is checked for the existence of unprocessed records.
4. If unprocessed records are found, an email alert is sent to the engineers.


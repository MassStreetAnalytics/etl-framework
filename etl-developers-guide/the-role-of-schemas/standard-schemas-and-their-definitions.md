# Standard Schemas And Their Definitions

The framework comes with standard schemas. If these schemas are not created, certain scripts may fail. You will create these schemas in the environment set up section.

<table>
  <thead>
    <tr>
      <th style="text-align:left">Schema</th>
      <th style="text-align:left">Database</th>
      <th style="text-align:left">Description</th>
      <th style="text-align:left">Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">dw</td>
      <td style="text-align:left">EDW</td>
      <td style="text-align:left">Data Warehouse</td>
      <td style="text-align:left">
        <p>All base data warehouse tables that are physically implemented belong
          in the dw schema.</p>
        <p></p>
        <p>This is an opinionated approach. The whole point of an EDW is that it
          is all supposed to be one integrated thing. I have seen data warehouses
          implemented in a manner that uses schemas to group logically related objects.</p>
        <p></p>
        <p>Mediocre.</p>
        <p></p>
        <p>There is no law that says you can&apos;t do that, but it violates the
          spirit of a data warehouse.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">cm</td>
      <td style="text-align:left">ODS</td>
      <td style="text-align:left">Common Model</td>
      <td style="text-align:left">All common model tables go in the WAIT FOR IT.....the common model schema.</td>
    </tr>
    <tr>
      <td style="text-align:left">rpt</td>
      <td style="text-align:left">ODS</td>
      <td style="text-align:left">Report</td>
      <td style="text-align:left">Any table that records de-normalized reporting information in support
        of load management goes in the rpt schema.</td>
    </tr>
    <tr>
      <td style="text-align:left">vol</td>
      <td style="text-align:left">ODS</td>
      <td style="text-align:left">Volumetrics</td>
      <td style="text-align:left">
        <p>Tables that are involved in statistical control processes used to manage
          the EDW load go in the vol schema.</p>
        <p></p>
        <p>The difference between vol and rpt is that vol tables are normalized in
          support of small applications that perform statistical analysis. rpt tables
          are just flat tables to dump de-normalized data into.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">mdm</td>
      <td style="text-align:left">ODS</td>
      <td style="text-align:left">Master Data Management</td>
      <td style="text-align:left">Any tables that are involved in the processing of mdm data but are not
        staging tables go in the mdm schema.</td>
    </tr>
    <tr>
      <td style="text-align:left">ms</td>
      <td style="text-align:left">ODS</td>
      <td style="text-align:left">Multi-System</td>
      <td style="text-align:left">Stage tables that combine data from more than one system go in the ms
        schema.</td>
    </tr>
  </tbody>
</table>




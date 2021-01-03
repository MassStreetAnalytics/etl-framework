# Security Access Model

The below matrix explains the security access model in terms of who has access to what database and schema.

<table>
  <thead>
    <tr>
      <th style="text-align:left">User/Database</th>
      <th style="text-align:left">
        <p>EDW</p>
        <p>(dw schema)</p>
      </th>
      <th style="text-align:left">
        <p>EDW</p>
        <p>(dbo schema)</p>
      </th>
      <th style="text-align:left">
        <p>ODS</p>
        <p>(all schemas)</p>
      </th>
      <th style="text-align:left">
        <p>Reporting</p>
        <p>(all schemas)</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">Data Engineer</td>
      <td style="text-align:left">rwx</td>
      <td style="text-align:left">rwx</td>
      <td style="text-align:left">rwx</td>
      <td style="text-align:left">rwx</td>
    </tr>
    <tr>
      <td style="text-align:left">Data Analyst</td>
      <td style="text-align:left">no access</td>
      <td style="text-align:left">r</td>
      <td style="text-align:left">no access</td>
      <td style="text-align:left">r</td>
    </tr>
    <tr>
      <td style="text-align:left">Business User</td>
      <td style="text-align:left">no access</td>
      <td style="text-align:left">no access</td>
      <td style="text-align:left">no access</td>
      <td style="text-align:left">r</td>
    </tr>
  </tbody>
</table>




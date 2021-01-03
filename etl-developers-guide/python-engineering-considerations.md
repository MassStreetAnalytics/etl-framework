# Python Software Engineering Considerations

So you decided not to use SSIS. Jolly good show mate! Making the switch to code over point and click will not be that big a deal, but there are a few things you need to be aware of.

**Common Configurations**

There are currently two different ways to get configuration data into your Python ETL scripts. Either with the framework configuration table, or with YAML files. There are pros and cons to both. 

<table>
  <thead>
    <tr>
      <th style="text-align:left">Method</th>
      <th style="text-align:left">Pro</th>
      <th style="text-align:left">Con</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">Configuration Table</td>
      <td style="text-align:left">The configuration table puts all your configuration data into a single
        place.</td>
      <td style="text-align:left">
        <p>All your configuration in a single place means centralized control which
          sounds great until it&apos;s one poor sod that&apos;s responsible for global
          configurations for the entire enterprise.</p>
        <p></p>
        <p>The way the table is managed is by keeping configs in a SQL file. When
          you have a new config, you just wipe and reload the config table with the
          script.</p>
        <p></p>
        <p>This is problematic for various reasons not the least of which is one
          person trying to manage hundreds of configuration settings using nothing
          but a glorified text file.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">YAML files</td>
      <td style="text-align:left">YAML files are human readable and easy to parse compared to XML, or JSON.
        YAML files are managed in a decentralized fashion in line with current
        source control methodology.</td>
      <td style="text-align:left">
        <p>File are managed in a decentralized fashion which means they are harder
          to keep track of.</p>
        <p></p>
        <p>You have to rely on your engineers strictly following protocol which means
          review of the YAML file becomes part of code review. Basically it&apos;s
          extra administration.</p>
      </td>
    </tr>
  </tbody>
</table>

 

We leave it to you to decide how you want to implement configurations. I recommend you use YAML files, but I provide instructions and sample code for using the config table.

**Directory Permissions**

You should use a Proxy to run Python just like you would SSIS. The Windows account that is being used for the credential has to be explicitly named in the folder permissions. For me, I was in dev and was confused because I was an administrator and administrator was named. It had to be my specific login.

**Absolute File Paths**

When executing from SQL Server Agent, your script actually executes at C:\WINDOWS\system32. That means you can't use os.getcwd\(\) as the base of file paths. Instead, if you use absolute paths, everything works fine.


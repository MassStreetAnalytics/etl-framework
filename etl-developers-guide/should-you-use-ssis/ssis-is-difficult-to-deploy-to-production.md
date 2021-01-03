# SSIS Is Difficult To Deploy To Production

The key to easy deployment actually has nothing to do with code versus point and click. The key is server configuration. Five things need to happen.

1. A DSN needs set up on all boxes that are for data warehouse work. This DSN needs to be identical on all boxes.
2. Linked servers need to be set up between the data warehouse box and all internal sources of data.
3. SQL Server Aliases need to be set up. The alias names should all be the same across all boxes.
4. Create global environment in the Integration Services Catalog.
5. All data warehouse related databases should have the exact same name on all boxes.

Are you catching the theme here? Do stuff so that you do not have to make changes to code or packages as you promote things from dev to production. Do that, and you are halfway there living on a prayer that your ETL process is easy to deploy.

Ease of deployment is critical to meeting service level agreements \(SLAs\). I frequently work under the SLA of, “It’s broken. Fix it yesterday”, so I cannot mess around with difficult to deploy code. Deploying T-SQL and Python is much easier than deploying a package.

First of all, there is no ease of deployment with SSIS even if you do everything I mentioned above. In order to deploy SSIS packages, you have to configure the IDE to deploy your package to the proper server. That is not fun. You have to set up different profiles for each box and the entire process is a pain.

Actually deploying your package is an equal pain. You have to make sure you are in the right profile, then you have to navigate to the proper catalogue. All that is cool if you are pushing to prod one time. If you have to push to dev or test multiple times before things start working right, you will wind up pulling your hair out. People think I shave my head. Nope. Just years of developing ETL with SSIS.

Why do you need to push to dev/test so many times? Fun fact. Your package may run fine in the IDE, but bomb on the server. There are several reasons this might happen so it is not just like you can make a configuration change to the server and fix it. No, you have to wait till it happens, then you have to solve your particular scenario. Mostly, it is a permissions issue. Mostly.

You know how you push changes to existing T-SQL and Python code through different servers?

Python Deployment Process

1. Copy scripts to proper folder on server.
2. There is no step 2.

T-SQL Deployment Process 

1. Change connection in SSMS.
2. Hit F5.
3. Make a video on TikTok because you have that kind of free time now.

It is not even an argument. Python and T-SQL are orders of magnitude easier to deploy than SSIS packages.


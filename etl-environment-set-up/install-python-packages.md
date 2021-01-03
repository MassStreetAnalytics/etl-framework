# Install Python Packages

Installing the packages required for the framework requires Microsoft Visual C++ 14.0. Before you run the process below, make sure you have that build tool. You can download it at.

{% embed url="https://visualstudio.microsoft.com/visual-cpp-build-tools/" %}

The install process requires a reboot. It is ok to continue the rest of the framework installation process, reboot, then come back and finish up this step.

Once you have the build tools installed. Proceed with the following steps.

1. Open Anaconda Prompt as administrator.
2. cd into etl-framework\Framework Deployment Scripts\04 Python Package Installation
3. Run the script by typing: python InstallFrameworkPackages.py.
4. At the end of the run you will get a report of packages that did not install. Scroll up until you find the issue.
5. Once you have remedied the problem go back to step 2 and keep running 2-4 till you get a clean run.

\*\*\*\*


import sys
import subprocess

FailedInstalls = {}
Packages = ['fuzzywuzzy','python-Levenshtein','pyunpack','pyodbc', 'yaml', 'smtplib']

for package in Packages:
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])
    except Exception as e:
        FailedInstalls[package] = e

for PackageName, ErrorMessage in FailedInstalls.items():
    print('Package ' + PackageName + ' failed to install because ' + str(ErrorMessage))


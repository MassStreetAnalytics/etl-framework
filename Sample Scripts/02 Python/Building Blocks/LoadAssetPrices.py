import os
import shutil
import smtplib
from email.message import EmailMessage
import yaml
import pypyodbc as db

with open('config\config.yaml') as settings:
    cfg = yaml.load(settings)

local_root_directory = 'LocalFolder/'
#Add more enteries to this dict if you want to work through more directories
remote_directories = ['EODData/']

connection_string = cfg['dns']
remote_root_directory = cfg['remote_root_directory'] + cfg['eod_directory']
from_address = (cfg['from_address'])
to_address = (cfg['to_address'])
password = (cfg['password'])
smtp_server = (cfg['smtp_server'])
smtp_port = (cfg['smtp_port'])


def move_file(source_directory, destination_directory):
    for path, directories, files in os.walk(source_directory):
        for fn in files:
            source = os.path.join(source_directory, fn)
            destination = os.path.join(destination_directory, fn)
            if os.path.isfile(source) and fn.endswith('.csv'):
                shutil.move(source, destination)


def load_file(file_path, exchange):

    local_archive_folder = file_path.replace('In/','Archive/')

    try:
        conn = db.connect(connection_string)
        csr = conn.cursor()
        csr.execute("DELETE FROM eod.EODPrices WHERE Processed = 1")

        for path, directories, files in os.walk(file_path):
            for fn in files:

                sql = "BULK INSERT eod.EODPricesPreStaging FROM '" + os.path.join(file_path,fn) + "' WITH (FIELDTERMINATOR = ',',ROWTERMINATOR = '\n')"
                csr.execute(sql)
                conn.commit()

        sql2 = "EXEC sp_LoadEODPricesFromPreStaging " + "'" + exchange + "'"
        csr.execute(sql2)
        conn.commit()
        csr.close()
        conn.close()
        move_file(file_path, local_archive_folder)
    except db.Error as e:
        print(str(e))


def send_exception_email(exchange_directory):
    msg = EmailMessage()
    msg['From'] = from_address
    msg['To'] = to_address
    msg['Subject'] = 'Empty Directory In EOD Data'
    msg.set_content('There are no files in ' + exchange_directory)

    try:
        server = smtplib.SMTP_SSL(smtp_server, smtp_port)
        server.login(from_address, password)
        server.send_message(msg)
        server.quit()
    except TimeoutError as e:
        print(str(e))


def main():
    for ed in remote_directories:
        remote_directory = remote_root_directory + ed
        local_in_folder = local_root_directory + ed.replace('/','Prices/') + 'In/'
        exchange_name = ed.replace('/', '')

        for path, directories, files in os.walk(remote_directory):
            for fn in files:
                if files and fn.endswith('.csv'):
                    move_file(remote_directory, local_in_folder)
                else:
                    send_exception_email(ed)

        for path, directories, files in os.walk(local_in_folder):
            if files:
                load_file(local_in_folder, exchange_name)


main()
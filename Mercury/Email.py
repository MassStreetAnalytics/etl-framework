import os
import yaml
import smtplib
from email.message import EmailMessage

with open(os.getcwd() + '\\config\\config.yaml') as settings:
    cfg = yaml.load(settings)

from_address = (cfg['from_address'])
to_address = (cfg['to_address'])
password = (cfg['password'])
smtp_server = (cfg['smtp_server'])
smtp_port = (cfg['smtp_port'])


class Email:

    def __init__(self, subject, message):
        self.subject = subject
        self.message = message

    def send_email(self):
        print(self.message)
        msg = EmailMessage()
        msg['From'] = from_address
        msg['To'] = to_address
        msg['Subject'] = self.subject
        msg.set_content(self.message)

        try:
            server = smtplib.SMTP_SSL(smtp_server, smtp_port)
            server.login(from_address, password)
            server.send_message(msg)
            server.quit()
        except TimeoutError as e:
            print(str(e))
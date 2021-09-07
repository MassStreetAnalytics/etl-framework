import smtplib
from email.message import EmailMessage


with open('global_config/config.yaml') as settings:
    cfg = yaml.load(settings)


from_address = (cfg['from_address'])
to_address = (cfg['to_address'])
password = (cfg['password'])
smtp_server = (cfg['smtp_server'])
smtp_port = (cfg['smtp_port'])


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
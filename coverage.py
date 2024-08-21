import os
import requests
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# SonarCloud Configuration
SONARCLOUD_TOKEN = '855ae7ba2578403df9432ce8d7ea914b75d03601'
SONARCLOUD_ORG = 'octobit8-scm'
SONARCLOUD_PROJECT = 'Octobit8-scm_roadrolls-fe'
SONARCLOUD_API_URL = f'https://sonarcloud.io/api/measures/component?component={SONARCLOUD_PROJECT}&metricKeys=coverage'

# Email Configuration
SMTP_SERVER = 'smtp.gmail.com'
SMTP_PORT = 587
SENDER_EMAIL = 'shourywardhan24@gmail.com'
SENDER_PASSWORD = 'ozfsvokg qgbn  esqk'
RECIPIENTS = ['Khusheel26@gmail.com', 'shourywardhan24@gmail.com']
SUBJECT = f'SonarCloud Code Coverage Report for {SONARCLOUD_PROJECT}'

def get_sonarcloud_coverage():
    """Fetches the code coverage data from SonarCloud."""
    headers = {
        'Authorization': f'Bearer {SONARCLOUD_TOKEN}'
    }
    response = requests.get(SONARCLOUD_API_URL, headers=headers)
    if response.status_code == 200:
        data = response.json()
        
        if 'component' in data and 'measures' in data['component']:
            measures = data['component']['measures']
            if measures:
                coverage = measures[0]['value']
                return coverage
            else:
                print('No measures available for this project.')
                return None
        else:
            print('Unexpected data structure or no component/measures in response.')
            return None
    else:
        print(f'Failed to retrieve data from SonarCloud. Status Code: {response.status_code}')
        return None

def send_email(subject, body):
    """Sends an email with the code coverage report."""
    msg = MIMEMultipart()
    msg['From'] = SENDER_EMAIL
    msg['To'] = ", ".join(RECIPIENTS)
    msg['Subject'] = subject

    # Email body
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()  # Secure the connection
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        server.sendmail(SENDER_EMAIL, RECIPIENTS, msg.as_string())
        server.quit()
        print(f'Successfully sent email to: {", ".join(RECIPIENTS)}')
    except smtplib.SMTPAuthenticationError:
        print("Failed to authenticate with the SMTP server. Check your username/password.")
    except smtplib.SMTPConnectError:
        print("Failed to connect to the SMTP server. Check your server address and port.")
    except smtplib.SMTPException as e:
        print(f"Failed to send email. SMTP error: {str(e)}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")

def main():
    # Fetch coverage from SonarCloud
    coverage = get_sonarcloud_coverage()
    
    if coverage:
        body = f"Hi Team,\n\nThe current code coverage for project {SONARCLOUD_PROJECT} on SonarCloud is {coverage}%.\n\nRegards,\nCI/CD Pipeline"
        send_email(SUBJECT, body)
    else:
        print("No coverage data available.")

if __name__ == '__main__':
    main()

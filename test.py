import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


sender_email = "Shourywardhan24@gmail.com"
receiver_email = "prathambaliyan012@gmail.com"
smtp_server = "smtp.gmail.com"
smtp_port = 587
smtp_username = "Shourywardhan24@gmail.com"
smtp_password = "ozfsvokg qgbn  esq"

def send_error_email(stage_name, error_log, recipient_email):
    sender_email = "shourywardhan24@gmail.com"
    sender_password = "ozfsvokg qgbn  esqk"
    
    subject = f"Jenkins Pipeline Error in Stage: {stage_name}"
    body = f"""
    An error occurred in the Jenkins pipeline during the stage: {stage_name}.
    
    Error Log:
    {error_log}

    Please check the Jenkins console output for more details.
    """
    
    # Create the email message
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    
    # Send the email
    try:
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(smtp_username, smtp_password)
        text = msg.as_string()
        server.sendmail(sender_email, receiver_email, text)
        server.quit()
        print("Error report sent successfully")
    except Exception as e:
        print(f"Failed to send email: {e}")


if __name__ == "__main__":
    # These environment variables will be set by Jenkins
    stage_name = os.getenv('STAGE_NAME', 'Unknown Stage')
    build_status = os.getenv('BUILD_STATUS', 'UNKNOWN')
    error_log = os.getenv('ERROR_LOG', 'No error log available')
    recipient_email = os.getenv('DEVELOPER_EMAIL', 'prathambaliyan012@gmail.com')
    
    if build_status == "FAILURE":
        send_error_email(stage_name, error_log, recipient_email)

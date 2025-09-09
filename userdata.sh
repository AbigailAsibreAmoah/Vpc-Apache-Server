#!/bin/bash

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create the main HTML page
cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web Server Status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 { 
            font-size: 3em; 
            margin-bottom: 20px; 
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .info { 
            margin: 20px 0; 
            font-size: 1.2em; 
        }
        .status { 
            color: #00ff88; 
            font-weight: bold; 
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }
        .server-info {
            background: rgba(255, 255, 255, 0.05);
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .timestamp {
            font-size: 0.9em;
            opacity: 0.8;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Web Server Online</h1>
        <div class="server-info">
            <div class="info">
                <p><strong>Status:</strong> <span class="status">✅ Running</span></p>
                <p><strong>Server Time:</strong> $(date)</p>
                <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null || echo "N/A")</p>
                <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null || echo "N/A")</p>
                <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null || echo "N/A")</p>
            </div>
        </div>
        <p>This web server was deployed automatically using Terraform with user data script!</p>
        <div class="timestamp">
            <p>Server deployed: $(date)</p>
        </div>
    </div>
</body>
</html>
HTML

# Set proper permissions
chown apache:apache /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Create a health check endpoint
echo "OK" > /var/www/html/health
chown apache:apache /var/www/html/health
chmod 644 /var/www/html/health

# Create a simple API endpoint
cat <<JSON > /var/www/html/api.json
{
    "status": "healthy",
    "timestamp": "$(date -Iseconds)",
    "server": "Apache/$(httpd -v | head -n1 | awk '{print $3}')",
    "instance_id": "$(curl -s http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null || echo 'N/A')"
}
JSON

chown apache:apache /var/www/html/api.json
chmod 644 /var/www/html/api.json

# Restart Apache to ensure everything is loaded
systemctl restart httpd

# Log completion
echo "User data script completed successfully at $(date)" >> /var/log/userdata.log
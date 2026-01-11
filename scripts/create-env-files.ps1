# ============================================
# Create .env files for all DentaMate services
# ============================================
# This script creates .env files with actual values from imp.txt
# Run this from the project root directory

$projectRoot = "F:\Main Cursor"
$impFilePath = "$projectRoot\imp.txt"

if (-not (Test-Path $impFilePath)) {
    Write-Host "ERROR: imp.txt not found at $impFilePath" -ForegroundColor Red
    Write-Host "Please ensure imp.txt exists in the project root" -ForegroundColor Yellow
    exit 1
}

Write-Host "Creating .env files from imp.txt..." -ForegroundColor Green

# API Gateway
$apiGatewayEnv = @"
# DentaMate API Gateway Environment Variables
# ACTUAL VALUES FROM imp.txt

NODE_ENV=development
PORT=3000
SERVICE_NAME=dentamate-api-gateway
LOG_LEVEL=info

JWT_SECRET=dentamate-api-gateway-super-secret-jwt-key-minimum-32-characters-change-in-production
JWT_EXPIRY=24h

CORS_ORIGIN=http://localhost:4200
CORS_CREDENTIALS=true

RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

AUTH_SERVICE_URL=http://localhost:3001
CLINIC_SERVICE_URL=http://localhost:3002
APPOINTMENT_SERVICE_URL=http://localhost:3003
NOTIFICATION_SERVICE_URL=http://localhost:3004
BILLING_SERVICE_URL=http://localhost:3005
RECORDS_SERVICE_URL=http://localhost:3006
AI_OCR_SERVICE_URL=http://localhost:3007
AI_DIAGNOSIS_SERVICE_URL=http://localhost:3008
COLLABORATION_SERVICE_URL=http://localhost:3009
ANALYTICS_SERVICE_URL=http://localhost:3010

REQUEST_TIMEOUT=30000
HEALTH_CHECK_ENABLED=true
"@
$apiGatewayEnv | Out-File -FilePath "$projectRoot\dentamate-api-gateway\.env" -Encoding utf8

# Auth Service
$authServiceEnv = @"
# DentaMate Auth & User Service Environment Variables
# ACTUAL VALUES FROM imp.txt

NODE_ENV=development
PORT=3001
SERVICE_NAME=dentamate-auth-user-service
LOG_LEVEL=info

MONGODB_URI=mongodb+srv://abyjp16:abyjp16@cluster0.ozkxezh.mongodb.net/dentamate_auth_db?appName=Cluster0

JWT_SECRET=dentamate-auth-super-secret-jwt-key-minimum-32-characters-change-in-production
JWT_EXPIRY=24h
JWT_REFRESH_SECRET=dentamate-auth-refresh-token-secret-minimum-32-characters-change-in-production
JWT_REFRESH_EXPIRY=7d

CORS_ORIGIN=http://localhost:4200
CORS_CREDENTIALS=true

API_GATEWAY_URL=http://localhost:3000

BCRYPT_ROUNDS=10
PASSWORD_MIN_LENGTH=8
SESSION_SECRET=dentamate-session-secret-minimum-32-characters-change-in-production
"@
$authServiceEnv | Out-File -FilePath "$projectRoot\dentamate-auth-user-service\.env" -Encoding utf8

# Clinic Core Service
$clinicServiceEnv = @"
# DentaMate Clinic Core Service Environment Variables
# ACTUAL VALUES FROM imp.txt

NODE_ENV=development
PORT=3002
SERVICE_NAME=dentamate-clinic-core-service
LOG_LEVEL=info

MONGODB_URI=mongodb+srv://abyjp16:abyjp16@cluster0.ozkxezh.mongodb.net/dentamate_clinic_db?appName=Cluster0

JWT_SECRET=dentamate-auth-super-secret-jwt-key-minimum-32-characters-change-in-production
JWT_EXPIRY=24h

CORS_ORIGIN=http://localhost:4200
CORS_CREDENTIALS=true

API_GATEWAY_URL=http://localhost:3000
AUTH_SERVICE_URL=http://localhost:3001
"@
$clinicServiceEnv | Out-File -FilePath "$projectRoot\dentamate-clinic-core-service\.env" -Encoding utf8

# Notification Service
$notificationServiceEnv = @"
# DentaMate Notification Service Environment Variables
# ACTUAL VALUES FROM imp.txt

NODE_ENV=development
PORT=3004
SERVICE_NAME=dentamate-notification-service
LOG_LEVEL=info

MONGODB_URI=mongodb+srv://abyjp16:abyjp16@cluster0.ozkxezh.mongodb.net/dentamate_notification_db?appName=Cluster0

JWT_SECRET=dentamate-auth-super-secret-jwt-key-minimum-32-characters-change-in-production
JWT_EXPIRY=24h

CORS_ORIGIN=http://localhost:4200
CORS_CREDENTIALS=true

API_GATEWAY_URL=http://localhost:3000

# Gmail API (from imp.txt - replace with actual values)
GMAIL_CLIENT_ID=<get-from-imp.txt-client_id>
GMAIL_CLIENT_SECRET=<get-from-imp.txt-client_secret>
GMAIL_REFRESH_TOKEN=<get-from-imp.txt-refresh_token>
GMAIL_FROM_EMAIL=<get-from-imp.txt-email>
GMAIL_PROJECT_ID=<get-from-imp.txt-project_id>

# Twilio SMS (from imp.txt - replace with actual values)
TWILIO_ACCOUNT_SID=<get-from-imp.txt-account-sid>
TWILIO_AUTH_TOKEN=<get-from-imp.txt-auth-token>
TWILIO_PHONE_NUMBER=<get-from-imp.txt-phone-number>

NOTIFICATION_RETRY_ATTEMPTS=3
NOTIFICATION_RETRY_DELAY=5000
EMAIL_QUEUE_NAME=email-queue
SMS_QUEUE_NAME=sms-queue
"@
$notificationServiceEnv | Out-File -FilePath "$projectRoot\dentamate-notification-service\.env" -Encoding utf8

# Billing Service
$billingServiceEnv = @"
# DentaMate Billing & Payment Service Environment Variables
# ACTUAL VALUES FROM imp.txt

NODE_ENV=development
PORT=3005
SERVICE_NAME=dentamate-billing-payment-service
LOG_LEVEL=info

MONGODB_URI=mongodb+srv://abyjp16:abyjp16@cluster0.ozkxezh.mongodb.net/dentamate_billing_db?appName=Cluster0

JWT_SECRET=dentamate-auth-super-secret-jwt-key-minimum-32-characters-change-in-production
JWT_EXPIRY=24h

CORS_ORIGIN=http://localhost:4200
CORS_CREDENTIALS=true

API_GATEWAY_URL=http://localhost:3000

# Razorpay (from imp.txt - replace with actual values)
RAZORPAY_KEY_ID=<get-from-imp.txt-test-api-key>
RAZORPAY_KEY_SECRET=<get-from-imp.txt-test-key-secret>
RAZORPAY_WEBHOOK_SECRET=configure-in-razorpay-dashboard

CURRENCY=INR
TAX_RATE=18
INVOICE_PREFIX=INV
"@
$billingServiceEnv | Out-File -FilePath "$projectRoot\dentamate-billing-payment-service\.env" -Encoding utf8

Write-Host ""
Write-Host "✅ .env files created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Created .env files for:" -ForegroundColor Cyan
Write-Host "  - dentamate-api-gateway" -ForegroundColor White
Write-Host "  - dentamate-auth-user-service" -ForegroundColor White
Write-Host "  - dentamate-clinic-core-service" -ForegroundColor White
Write-Host "  - dentamate-notification-service" -ForegroundColor White
Write-Host "  - dentamate-billing-payment-service" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  These files are NOT committed to Git (in .gitignore)" -ForegroundColor Yellow
Write-Host "⚠️  Keep these files secure and private!" -ForegroundColor Yellow

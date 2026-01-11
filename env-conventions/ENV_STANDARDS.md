# DentaMate Environment Variable Standards

## 🎯 Purpose
This document defines the standard environment variable naming conventions for all DentaMate microservices.

**📝 Note:** All actual credentials are provided in `imp.txt` at the project root. This document references those values.

---

## 📋 Universal Variables (ALL Services)

Every service MUST have these variables:

```bash
# Application
NODE_ENV=production              # or development, staging
PORT=3000                        # Render will override this
SERVICE_NAME=dentamate-xxx-service

# Logging
LOG_LEVEL=info                   # debug, info, warn, error
```

---

## 🔐 Authentication & Security

### JWT Configuration
```bash
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
JWT_EXPIRY=24h                   # Token expiration time
JWT_REFRESH_SECRET=your-refresh-token-secret
JWT_REFRESH_EXPIRY=7d
```

### CORS Configuration
```bash
CORS_ORIGIN=https://dentamate-app.onrender.com
CORS_CREDENTIALS=true
```

---

## 🗄️ Database Configuration

### MongoDB (Standard for all services)
```bash
# ⚠️ IMPORTANT: Get MongoDB URI from imp.txt "MongoDB" section
# Base URI format: mongodb+srv://username:password@cluster.mongodb.net/?appName=Cluster0

# For each service, append the database name to the base URI:
# - dentamate_auth_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_auth_db?appName=Cluster0

# - dentamate_clinic_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_clinic_db?appName=Cluster0

# - dentamate_appointment_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_appointment_db?appName=Cluster0

# - dentamate_billing_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_billing_db?appName=Cluster0

# - dentamate_records_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_records_db?appName=Cluster0

# - dentamate_analytics_db
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_analytics_db?appName=Cluster0
```

### Redis (For caching and queues)
```bash
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=your-redis-password
REDIS_DB=0
```

---

## 🌐 Service URLs (Inter-service communication)

```bash
# API Gateway
API_GATEWAY_URL=https://dentamate-api-gateway.onrender.com

# Auth Service
AUTH_SERVICE_URL=https://dentamate-auth-user-service.onrender.com

# Clinic Core Service
CLINIC_SERVICE_URL=https://dentamate-clinic-core-service.onrender.com

# Appointment Service
APPOINTMENT_SERVICE_URL=https://dentamate-appointment-queue-service.onrender.com

# Notification Service
NOTIFICATION_SERVICE_URL=https://dentamate-notification-service.onrender.com

# Billing Service
BILLING_SERVICE_URL=https://dentamate-billing-payment-service.onrender.com

# Medical Records Service
RECORDS_SERVICE_URL=https://dentamate-medical-records-service.onrender.com

# AI OCR Chatbot Service
AI_OCR_SERVICE_URL=https://dentamate-ai-ocr-chatbot-service.onrender.com

# AI Diagnosis Service
AI_DIAGNOSIS_SERVICE_URL=https://dentamate-ai-diagnosis-service.onrender.com

# Collaboration Service
COLLABORATION_SERVICE_URL=https://dentamate-collaboration-service.onrender.com

# Analytics Service
ANALYTICS_SERVICE_URL=https://dentamate-analytics-ai-service.onrender.com
```

---

## 📧 Email Configuration (Gmail API)

**⚠️ IMPORTANT: Actual credentials are stored in `imp.txt` at project root.**
**This file is NOT committed to Git for security. Copy values from there.**

Format from imp.txt (Gmail OAuth 2.0 section):
```bash
GMAIL_CLIENT_ID=<from imp.txt - client_id value>
GMAIL_CLIENT_SECRET=<from imp.txt - client_secret value>
GMAIL_REFRESH_TOKEN=<from imp.txt - Refresh token value>
GMAIL_FROM_EMAIL=<from imp.txt - Email value>
GMAIL_PROJECT_ID=<from imp.txt - project_id value>
```

---

## 📱 SMS Configuration (Twilio)

**⚠️ IMPORTANT: Actual credentials are stored in `imp.txt` at project root.**
**This file is NOT committed to Git for security. Copy values from there.**

Format from imp.txt (Twilio SMS section):
```bash
TWILIO_ACCOUNT_SID=<from imp.txt - Account SID value>
TWILIO_AUTH_TOKEN=<from imp.txt - Auth Token value>
TWILIO_PHONE_NUMBER=<from imp.txt - My Twilio phone number value>
```

---

## 💳 Payment Configuration (Razorpay)

**⚠️ IMPORTANT: Actual test credentials are stored in `imp.txt` at project root.**
**This file is NOT committed to Git for security. Copy values from there.**

Format from imp.txt (Razorpay section):
```bash
RAZORPAY_KEY_ID=<from imp.txt - Test API Key value>
RAZORPAY_KEY_SECRET=<from imp.txt - Test Key Secret value>

# Webhook secret (configure in Razorpay dashboard)
RAZORPAY_WEBHOOK_SECRET=your-webhook-secret-from-razorpay-dashboard
```

---

## 🤖 AI/ML Configuration

```bash
# AI Model paths (for AI services)
AI_MODEL_PATH=/app/models/diagnosis_model.h5
AI_CONFIDENCE_THRESHOLD=0.75

# OCR Configuration
OCR_LANGUAGE=eng
OCR_DPI=300
```

---

## 📁 File Storage Configuration

```bash
# For medical records and file uploads
STORAGE_TYPE=local                    # or s3, cloudinary
MAX_FILE_SIZE=10485760               # 10MB in bytes
ALLOWED_FILE_TYPES=pdf,jpg,jpeg,png,dcm

# If using AWS S3
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_S3_BUCKET=dentamate-medical-records
AWS_REGION=us-east-1
```

---

## 🔔 WebSocket Configuration

```bash
WEBSOCKET_PORT=3001
WEBSOCKET_PATH=/ws
```

---

## 📊 Rate Limiting

```bash
RATE_LIMIT_WINDOW_MS=900000          # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100          # Max requests per window
```

---

## 🎯 Service-Specific Variables

### API Gateway
```bash
RATE_LIMIT_ENABLED=true
REQUEST_TIMEOUT=30000                # 30 seconds
```

### Auth Service
```bash
BCRYPT_ROUNDS=10
SESSION_SECRET=your-session-secret
PASSWORD_MIN_LENGTH=8
```

### Appointment Service
```bash
QUEUE_REFRESH_INTERVAL=5000          # 5 seconds
TOKEN_PREFIX=DM
```

### Notification Service
```bash
NOTIFICATION_RETRY_ATTEMPTS=3
NOTIFICATION_RETRY_DELAY=5000        # 5 seconds
EMAIL_QUEUE_NAME=email-queue
SMS_QUEUE_NAME=sms-queue
```

### Billing Service
```bash
CURRENCY=INR
TAX_RATE=18                          # GST percentage
INVOICE_PREFIX=INV
```

---

## 📝 .env.example Template

Create this in each service repo:

```bash
# Application
NODE_ENV=development
PORT=3000
SERVICE_NAME=dentamate-xxx-service

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/database_name

# JWT
JWT_SECRET=your-jwt-secret-here
JWT_EXPIRY=24h

# API Gateway
API_GATEWAY_URL=http://localhost:3000

# Add service-specific variables below
```

---

## 🚨 Security Best Practices

1. **NEVER commit .env files to Git**
   - Add `.env` to `.gitignore`
   - Use `.env.example` as template

2. **Use strong secrets**
   - Minimum 32 characters for JWT secrets
   - Use random generation tools

3. **Rotate secrets regularly**
   - Change production secrets every 90 days
   - Update Render environment variables

4. **Separate environments**
   - Different secrets for dev/staging/prod
   - Never use production secrets in development

---

## 🔧 Setting Up in Render

1. Go to your service in Render dashboard
2. Navigate to **Environment** tab
3. Add variables one by one or use **Add from .env**
4. Mark sensitive variables as **Secret**
5. Save changes (will trigger redeploy)

---

## ✅ Checklist for New Service

- [ ] Copy `.env.example` to `.env`
- [ ] Fill in all required variables
- [ ] Add `.env` to `.gitignore`
- [ ] Configure variables in Render dashboard
- [ ] Test locally with Docker Compose
- [ ] Verify deployment on Render

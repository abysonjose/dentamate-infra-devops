# Where is the .env File?

## 📍 Location of .env Files

The `.env` files with **actual MongoDB URI and OAuth credentials** should be created in **each service directory**.

---

## 📁 File Locations

```
F:\Main Cursor\
├── dentamate-api-gateway\
│   ├── .env                    ← HERE (with actual values)
│   └── env.example             ← Template (committed to Git)
│
├── dentamate-auth-user-service\
│   ├── .env                    ← HERE (with MongoDB URI)
│   └── env.example             ← Template
│
├── dentamate-clinic-core-service\
│   ├── .env                    ← HERE (with MongoDB URI)
│   └── env.example             ← Template
│
├── dentamate-notification-service\
│   ├── .env                    ← HERE (with Gmail OAuth + Twilio)
│   └── env.example             ← Template
│
└── dentamate-billing-payment-service\
    ├── .env                    ← HERE (with Razorpay)
    └── env.example             ← Template
```

---

## 🔧 How to Create .env Files

### Option 1: Use the Script (Recommended)

Run this PowerShell script from project root:

```powershell
# Navigate to project root
cd "F:\Main Cursor"

# Run the script
.\dentamate-infra-devops\scripts\create-env-files.ps1
```

This will automatically create all `.env` files with values from `imp.txt`.

### Option 2: Manual Creation

For each service:

1. **Copy the template:**
   ```powershell
   cd dentamate-api-gateway
   cp env.example .env
   ```

2. **Edit .env file** and replace placeholders with actual values from `imp.txt`:
   ```bash
   # MongoDB (from imp.txt)
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dentamate_auth_db?appName=Cluster0
   
   # Gmail OAuth (from imp.txt - copy actual values)
   GMAIL_CLIENT_ID=<copy-from-imp.txt>
   GMAIL_CLIENT_SECRET=<copy-from-imp.txt>
   GMAIL_REFRESH_TOKEN=<copy-from-imp.txt>
   
   # Twilio (from imp.txt - copy actual values)
   TWILIO_ACCOUNT_SID=<copy-from-imp.txt>
   TWILIO_AUTH_TOKEN=<copy-from-imp.txt>
   TWILIO_PHONE_NUMBER=<copy-from-imp.txt>
   
   # Razorpay (from imp.txt - copy actual values)
   RAZORPAY_KEY_ID=<copy-from-imp.txt>
   RAZORPAY_KEY_SECRET=<copy-from-imp.txt>
   ```

---

## ✅ Values from imp.txt

### MongoDB URI
```
mongodb+srv://username:password@cluster.mongodb.net/?appName=Cluster0
```

**For each service, append database name:**
- Auth Service: `/dentamate_auth_db`
- Clinic Service: `/dentamate_clinic_db`
- Notification Service: `/dentamate_notification_db`
- Billing Service: `/dentamate_billing_db`

### Gmail OAuth 2.0
**⚠️ Get actual values from imp.txt:**
- **Client ID:** `<from-imp.txt-client_id>`
- **Client Secret:** `<from-imp.txt-client_secret>`
- **Refresh Token:** `<from-imp.txt-refresh_token>`
- **Email:** `<from-imp.txt-email>`
- **Project ID:** `<from-imp.txt-project_id>`

### Twilio SMS
**⚠️ Get actual values from imp.txt:**
- **Account SID:** `<from-imp.txt-account-sid>`
- **Auth Token:** `<from-imp.txt-auth-token>`
- **Phone Number:** `<from-imp.txt-phone-number>`

### Razorpay
**⚠️ Get actual values from imp.txt:**
- **Test API Key:** `<from-imp.txt-test-api-key>`
- **Test Key Secret:** `<from-imp.txt-test-key-secret>`

---

## 🚨 Important Notes

1. **`.env` files are NOT committed to Git**
   - They're in `.gitignore`
   - This is for security!

2. **`.env.example` files ARE committed**
   - Templates only (no real secrets)
   - Shows what variables are needed

3. **Keep `.env` files secure**
   - Don't share them
   - Don't commit them
   - Use different values for production

---

## 📋 Quick Checklist

- [ ] `.env` file exists in each service directory
- [ ] MongoDB URI includes service-specific database name
- [ ] Gmail OAuth credentials added (notification service)
- [ ] Twilio credentials added (notification service)
- [ ] Razorpay credentials added (billing service)
- [ ] `.env` is in `.gitignore` (verify it's NOT committed)

---

## 🎯 Service-Specific Requirements

| Service | Required Variables |
|---------|-------------------|
| **API Gateway** | JWT_SECRET, Service URLs |
| **Auth Service** | MONGODB_URI, JWT_SECRET, JWT_REFRESH_SECRET |
| **Clinic Service** | MONGODB_URI, JWT_SECRET |
| **Notification Service** | MONGODB_URI, GMAIL_*, TWILIO_* |
| **Billing Service** | MONGODB_URI, RAZORPAY_* |

---

**All `.env` files should be in their respective service directories with actual values from `imp.txt`!**

# Docker Compose Guide for DentaMate

## 🎯 Available Compose Files

### 1. `docker-compose.minimal.yml` (Recommended for Development)
**Use this when:** You're developing services and running them directly (not in Docker)

**Includes:**
- MongoDB
- Redis
- Mongo Express (DB Admin UI)
- Redis Commander (Redis Admin UI)

**Start:**
```bash
docker-compose -f docker-compose.minimal.yml up -d
```

**Access:**
- MongoDB: `mongodb://admin:admin123@localhost:27017`
- Redis: `redis://localhost:6379`
- Mongo Express: http://localhost:8081 (admin/admin)
- Redis Commander: http://localhost:8082

---

### 2. `docker-compose.local.yml` (Full Stack)
**Use this when:** You want to run all services in Docker

**Includes:**
- All infrastructure (MongoDB, Redis)
- API Gateway
- Auth Service
- Clinic Service
- Appointment Service
- Admin UIs

**Start:**
```bash
docker-compose -f docker-compose.local.yml up -d
```

**Access:**
- API Gateway: http://localhost:3000
- Auth Service: http://localhost:3001
- Clinic Service: http://localhost:3002
- Appointment Service: http://localhost:3003

---

## 🚀 Quick Start Guide

### Step 1: Start Infrastructure Only
```bash
cd F:\Main Cursor\dentamate-infra-devops\docker-compose
docker-compose -f docker-compose.minimal.yml up -d
```

### Step 2: Verify Services
```bash
docker-compose -f docker-compose.minimal.yml ps
```

### Step 3: Check Logs
```bash
docker-compose -f docker-compose.minimal.yml logs -f mongodb
docker-compose -f docker-compose.minimal.yml logs -f redis
```

### Step 4: Access Admin UIs
- **Mongo Express:** http://localhost:8081
  - Username: `admin`
  - Password: `admin`
  
- **Redis Commander:** http://localhost:8082

---

## 🛠️ Common Commands

### Start services
```bash
docker-compose -f docker-compose.minimal.yml up -d
```

### Stop services
```bash
docker-compose -f docker-compose.minimal.yml down
```

### Stop and remove volumes (⚠️ deletes data)
```bash
docker-compose -f docker-compose.minimal.yml down -v
```

### View logs
```bash
docker-compose -f docker-compose.minimal.yml logs -f
```

### Restart a specific service
```bash
docker-compose -f docker-compose.minimal.yml restart mongodb
```

### Rebuild services
```bash
docker-compose -f docker-compose.minimal.yml up -d --build
```

---

## 📊 Database Connection Strings

### Local Development (Services running outside Docker)
```bash
MONGODB_URI=mongodb://admin:admin123@localhost:27017/dentamate_auth_db?authSource=admin
REDIS_URL=redis://localhost:6379
```

### Docker to Docker (Services running inside Docker)
```bash
MONGODB_URI=mongodb://admin:admin123@mongodb:27017/dentamate_auth_db?authSource=admin
REDIS_URL=redis://redis:6379
```

---

## 🔍 Troubleshooting

### MongoDB connection refused
```bash
# Check if MongoDB is running
docker-compose -f docker-compose.minimal.yml ps

# Check MongoDB logs
docker-compose -f docker-compose.minimal.yml logs mongodb

# Restart MongoDB
docker-compose -f docker-compose.minimal.yml restart mongodb
```

### Port already in use
```bash
# Find process using port 27017
netstat -ano | findstr :27017

# Kill the process (replace PID)
taskkill /PID <PID> /F

# Or change the port in docker-compose file
ports:
  - "27018:27017"  # Changed from 27017:27017
```

### Reset everything
```bash
# Stop all services
docker-compose -f docker-compose.minimal.yml down

# Remove volumes (deletes data)
docker-compose -f docker-compose.minimal.yml down -v

# Remove all DentaMate containers
docker ps -a | grep dentamate | awk '{print $1}' | xargs docker rm -f

# Start fresh
docker-compose -f docker-compose.minimal.yml up -d
```

---

## 🎯 Recommended Development Workflow

1. **Start infrastructure:**
   ```bash
   docker-compose -f docker-compose.minimal.yml up -d
   ```

2. **Run your service locally:**
   ```bash
   cd ../dentamate-auth-user-service
   npm install
   npm run dev
   ```

3. **Access databases via Admin UIs:**
   - Mongo Express: http://localhost:8081
   - Redis Commander: http://localhost:8082

4. **When done, stop infrastructure:**
   ```bash
   docker-compose -f docker-compose.minimal.yml down
   ```

---

## 📝 Notes

- **Data Persistence:** Data is stored in Docker volumes and persists across restarts
- **Network:** All services are on the same Docker network for inter-service communication
- **Health Checks:** Services have health checks to ensure they're ready before dependent services start
- **Auto-restart:** Services automatically restart unless stopped manually

---

## ✅ Verification Checklist

After starting services, verify:

- [ ] MongoDB is accessible at localhost:27017
- [ ] Redis is accessible at localhost:6379
- [ ] Mongo Express loads at http://localhost:8081
- [ ] Redis Commander loads at http://localhost:8082
- [ ] All 6 databases are created in MongoDB
- [ ] Can connect from your service to MongoDB

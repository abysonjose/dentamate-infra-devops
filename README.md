# 🏗️ DentaMate Infrastructure & DevOps

> **Phase 0 Foundation** - Reusable templates and standards for all DentaMate microservices

---

## 📋 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Dockerfile Templates](#dockerfile-templates)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Environment Variables](#environment-variables)
- [Docker Compose](#docker-compose)
- [Deployment to Render](#deployment-to-render)
- [Best Practices](#best-practices)

---

## 🎯 Overview

This repository contains **infrastructure templates and DevOps standards** for the entire DentaMate ecosystem. It is **NOT deployed** itself but serves as the foundation for all other services.

### Why This Repo Exists

- ✅ **Consistency** - All services follow the same Docker and CI/CD patterns
- ✅ **Speed** - Copy templates instead of writing from scratch
- ✅ **Maintainability** - Update once, apply everywhere
- ✅ **Best Practices** - Production-ready configurations out of the box

---

## 📁 Repository Structure

```
dentamate-infra-devops/
├── dockerfiles/                    # Dockerfile templates
│   ├── Dockerfile.nodejs          # Node.js services
│   ├── Dockerfile.python          # Python/FastAPI services
│   ├── Dockerfile.java            # Java/Spring Boot services
│   ├── Dockerfile.angular         # Angular frontend
│   └── nginx.conf                 # Nginx config for Angular
│
├── github-actions/                 # CI/CD workflow templates
│   ├── docker-render-deploy.yml   # Basic deploy workflow
│   └── docker-render-deploy-with-tests.yml  # With testing
│
├── env-conventions/                # Environment variable standards
│   ├── ENV_STANDARDS.md           # Complete documentation
│   ├── env.example                # Universal .env template
│   └── .gitignore                 # Protect secrets
│
├── docker-compose/                 # Local development
│   ├── docker-compose.minimal.yml # Infrastructure only
│   ├── docker-compose.local.yml   # Full stack
│   ├── mongo-init/                # MongoDB initialization
│   │   └── init-databases.js
│   └── DOCKER_COMPOSE_GUIDE.md    # Usage guide
│
└── README.md                       # This file
```

---

## 🚀 Quick Start

### For New Service Setup

1. **Choose the right Dockerfile template:**
   ```bash
   # For Node.js service
   cp dockerfiles/Dockerfile.nodejs ../dentamate-xxx-service/Dockerfile
   
   # For Python service
   cp dockerfiles/Dockerfile.python ../dentamate-xxx-service/Dockerfile
   
   # For Java service
   cp dockerfiles/Dockerfile.java ../dentamate-xxx-service/Dockerfile
   ```

2. **Setup GitHub Actions:**
   ```bash
   mkdir -p ../dentamate-xxx-service/.github/workflows
   cp github-actions/docker-render-deploy.yml ../dentamate-xxx-service/.github/workflows/
   ```

3. **Setup environment variables:**
   ```bash
   cp env-conventions/env.example ../dentamate-xxx-service/.env.example
   # Edit .env.example with service-specific variables
   ```

4. **Add .gitignore:**
   ```bash
   echo ".env" >> ../dentamate-xxx-service/.gitignore
   echo ".env.local" >> ../dentamate-xxx-service/.gitignore
   ```

---

## 🐳 Dockerfile Templates

### Node.js Template (`Dockerfile.nodejs`)

**Features:**
- Based on `node:20-alpine` (lightweight)
- Production dependencies only
- Health check included
- Optimized for Render deployment

**Usage:**
```dockerfile
# Copy to your Node.js service root
# Modify CMD if your entry point is different
CMD ["node", "index.js"]  # or server.js, app.js, etc.
```

### Python Template (`Dockerfile.python`)

**Features:**
- Based on `python:3.11-slim`
- Multi-stage build for smaller images
- Uvicorn for FastAPI
- Health check included

**Usage:**
```dockerfile
# Copy to your Python service root
# Modify if your main file is different
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
```

### Java Template (`Dockerfile.java`)

**Features:**
- Based on `openjdk:21-slim`
- Multi-stage build (Maven + Runtime)
- Spring Boot optimized
- Smaller final image

**Usage:**
```dockerfile
# Copy to your Java/Spring Boot service root
# Ensure pom.xml is in the root
```

### Angular Template (`Dockerfile.angular`)

**Features:**
- Multi-stage build (Build + Nginx)
- Production optimized
- Custom nginx.conf included
- Gzip compression enabled

**Usage:**
```dockerfile
# Copy both Dockerfile.angular and nginx.conf
# Update dist path if different:
COPY --from=build /app/dist/your-app-name /usr/share/nginx/html
```

---

## ⚙️ GitHub Actions CI/CD

### Basic Workflow (`docker-render-deploy.yml`)

**What it does:**
1. ✅ Builds Docker image
2. ✅ Pushes to GitHub Container Registry (GHCR)
3. ✅ Triggers Render deployment

**Setup:**
1. Copy workflow to `.github/workflows/`
2. Add `RENDER_DEPLOY_HOOK` secret to GitHub repo
3. Push to `main` branch → auto-deploy

### With Tests (`docker-render-deploy-with-tests.yml`)

**Additional features:**
- Runs tests before building
- Supports Node.js and Python tests
- Only deploys if tests pass
- Works with pull requests

---

## 🔐 Environment Variables

See [`env-conventions/ENV_STANDARDS.md`](env-conventions/ENV_STANDARDS.md) for complete documentation.

### Quick Reference

**Universal Variables (All Services):**
```bash
NODE_ENV=production
PORT=3000
SERVICE_NAME=dentamate-xxx-service
MONGODB_URI=mongodb+srv://...
JWT_SECRET=your-secret-here
```

**Database Names:**
- `dentamate_auth_db`
- `dentamate_clinic_db`
- `dentamate_appointment_db`
- `dentamate_billing_db`
- `dentamate_records_db`
- `dentamate_analytics_db`

**Service URLs:**
```bash
API_GATEWAY_URL=https://dentamate-api-gateway.onrender.com
AUTH_SERVICE_URL=https://dentamate-auth-user-service.onrender.com
# ... etc
```

---

## 🐳 Docker Compose

### Minimal Setup (Recommended)

**Start infrastructure only:**
```bash
cd docker-compose
docker-compose -f docker-compose.minimal.yml up -d
```

**Includes:**
- MongoDB (port 27017)
- Redis (port 6379)
- Mongo Express (port 8081)
- Redis Commander (port 8082)

**Use this when:** Running services directly (not in Docker)

### Full Stack Setup

**Start all services:**
```bash
cd docker-compose
docker-compose -f docker-compose.local.yml up -d
```

**Includes:**
- All infrastructure
- API Gateway
- Auth Service
- Clinic Service
- Appointment Service

**Use this when:** Testing full microservices locally

See [`docker-compose/DOCKER_COMPOSE_GUIDE.md`](docker-compose/DOCKER_COMPOSE_GUIDE.md) for detailed guide.

---

## 🚀 Deployment to Render

### Step-by-Step Process

#### 1. Create Render Service

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **New → Web Service**
3. Select **Docker** as runtime
4. Enter image URL:
   ```
   ghcr.io/abysonjose/dentamate-xxx-service:latest
   ```

#### 2. Configure Registry Access

Since GHCR images are private:

- **Registry:** `ghcr.io`
- **Username:** `abysonjose`
- **Password:** GitHub Personal Access Token with `read:packages` scope

#### 3. Set Environment Variables

In Render → Environment tab, add:
```bash
PORT=3000
NODE_ENV=production
MONGODB_URI=mongodb+srv://...
JWT_SECRET=...
# Add all required variables
```

#### 4. Get Deploy Hook

1. Render → Settings → Deploy Hook
2. Copy the webhook URL
3. Add to GitHub Secrets as `RENDER_DEPLOY_HOOK`

#### 5. Push to GitHub

```bash
git add .
git commit -m "Initial setup with CI/CD"
git push origin main
```

**Result:** GitHub Actions builds image → Pushes to GHCR → Triggers Render deployment

---

## 📚 Best Practices

### Docker

✅ **DO:**
- Use multi-stage builds for smaller images
- Use Alpine/Slim base images
- Add health checks
- Bind to `PORT` environment variable
- Use `.dockerignore` to exclude unnecessary files

❌ **DON'T:**
- Hardcode ports
- Include secrets in Dockerfile
- Use `latest` tag in production
- Run as root user (add non-root user)

### Environment Variables

✅ **DO:**
- Use `.env.example` as template
- Add `.env` to `.gitignore`
- Use strong secrets (32+ characters)
- Separate dev/staging/prod secrets

❌ **DON'T:**
- Commit `.env` files
- Use production secrets in development
- Hardcode secrets in code
- Share secrets via chat/email

### CI/CD

✅ **DO:**
- Run tests before deploying
- Use caching for faster builds
- Tag images with commit SHA
- Monitor deployment logs

❌ **DON'T:**
- Skip tests in CI
- Deploy broken builds
- Ignore failed deployments
- Use `--force` flags

### Git

✅ **DO:**
- Use meaningful commit messages
- Create feature branches
- Review code before merging
- Keep commits small and focused

❌ **DON'T:**
- Commit directly to `main`
- Push untested code
- Include large binary files
- Commit sensitive data

---

## 🔧 Troubleshooting

### Docker Build Fails

**Check:**
- Dockerfile syntax
- Base image availability
- File paths in COPY commands
- Network connectivity

**Fix:**
```bash
docker build --no-cache -t test .
docker logs <container-id>
```

### GitHub Actions Fails

**Check:**
- Secrets are set correctly
- Dockerfile exists in repo
- GHCR permissions
- Render deploy hook URL

**Fix:**
- Check Actions tab for detailed logs
- Verify secrets in repo settings
- Test Docker build locally first

### Render Deployment Fails

**Check:**
- Image URL is correct
- Registry credentials are valid
- Environment variables are set
- Service is listening on PORT env var

**Fix:**
- Check Render logs
- Verify image exists in GHCR
- Test image locally: `docker pull ghcr.io/...`

---

## 📞 Support

For issues or questions:
1. Check documentation in this repo
2. Review Render logs
3. Check GitHub Actions logs
4. Verify environment variables

---

## 📝 Version History

- **v1.0.0** (2026-01-11) - Initial Phase 0 templates
  - Dockerfile templates for Node.js, Python, Java, Angular
  - GitHub Actions workflows
  - Environment variable standards
  - Docker Compose for local development

---

## 🎯 Next Steps

After setting up infrastructure:

1. **Phase 1:** Deploy API Gateway
2. **Phase 1:** Deploy Auth Service
3. **Phase 2:** Deploy Clinic Core Service
4. **Phase 2:** Deploy Frontend
5. Continue through phases as per build order

See [`flow.txt`](../flow.txt) for complete build order.

---

## ✅ Checklist for New Service

- [ ] Copy appropriate Dockerfile
- [ ] Copy GitHub Actions workflow
- [ ] Create `.env.example`
- [ ] Add `.env` to `.gitignore`
- [ ] Set up Render service
- [ ] Add environment variables in Render
- [ ] Get deploy hook from Render
- [ ] Add `RENDER_DEPLOY_HOOK` to GitHub secrets
- [ ] Push to GitHub
- [ ] Verify deployment on Render

---

**Built with ❤️ for DentaMate**

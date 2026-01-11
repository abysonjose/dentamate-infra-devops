// ============================================
// MongoDB Database Initialization Script
// ============================================
// This script creates all DentaMate databases
// and sets up initial indexes
// ============================================

// Switch to admin database for authentication
db = db.getSiblingDB('admin');
db.auth('admin', 'admin123');

// Create databases and collections
const databases = [
  'dentamate_auth_db',
  'dentamate_clinic_db',
  'dentamate_appointment_db',
  'dentamate_billing_db',
  'dentamate_records_db',
  'dentamate_analytics_db'
];

databases.forEach(dbName => {
  print(`Creating database: ${dbName}`);
  const database = db.getSiblingDB(dbName);
  
  // Create a dummy collection to initialize the database
  database.createCollection('_init');
  
  print(`✅ Database ${dbName} created successfully`);
});

// Auth Database - Create indexes
print('Setting up auth database indexes...');
const authDb = db.getSiblingDB('dentamate_auth_db');
authDb.users.createIndex({ email: 1 }, { unique: true });
authDb.users.createIndex({ clinicId: 1 });
authDb.users.createIndex({ role: 1 });
authDb.sessions.createIndex({ userId: 1 });
authDb.sessions.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// Clinic Database - Create indexes
print('Setting up clinic database indexes...');
const clinicDb = db.getSiblingDB('dentamate_clinic_db');
clinicDb.clinics.createIndex({ name: 1 });
clinicDb.clinics.createIndex({ status: 1 });
clinicDb.branches.createIndex({ clinicId: 1 });
clinicDb.staff.createIndex({ clinicId: 1 });
clinicDb.staff.createIndex({ userId: 1 });

// Appointment Database - Create indexes
print('Setting up appointment database indexes...');
const appointmentDb = db.getSiblingDB('dentamate_appointment_db');
appointmentDb.appointments.createIndex({ clinicId: 1, date: 1 });
appointmentDb.appointments.createIndex({ patientId: 1 });
appointmentDb.appointments.createIndex({ doctorId: 1 });
appointmentDb.appointments.createIndex({ status: 1 });
appointmentDb.queue.createIndex({ clinicId: 1, date: 1 });
appointmentDb.tokens.createIndex({ tokenNumber: 1 }, { unique: true });

// Billing Database - Create indexes
print('Setting up billing database indexes...');
const billingDb = db.getSiblingDB('dentamate_billing_db');
billingDb.invoices.createIndex({ clinicId: 1 });
billingDb.invoices.createIndex({ patientId: 1 });
billingDb.invoices.createIndex({ invoiceNumber: 1 }, { unique: true });
billingDb.payments.createIndex({ invoiceId: 1 });
billingDb.payments.createIndex({ status: 1 });

// Records Database - Create indexes
print('Setting up records database indexes...');
const recordsDb = db.getSiblingDB('dentamate_records_db');
recordsDb.medicalRecords.createIndex({ patientId: 1 });
recordsDb.medicalRecords.createIndex({ clinicId: 1 });
recordsDb.prescriptions.createIndex({ patientId: 1 });
recordsDb.xrays.createIndex({ patientId: 1 });

// Analytics Database - Create indexes
print('Setting up analytics database indexes...');
const analyticsDb = db.getSiblingDB('dentamate_analytics_db');
analyticsDb.metrics.createIndex({ clinicId: 1, date: 1 });
analyticsDb.predictions.createIndex({ clinicId: 1 });

print('✅ All databases and indexes created successfully!');

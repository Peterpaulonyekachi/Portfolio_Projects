# 👋 Hello, I'm Charles Onyebuchi!

## 🌟 About Me
I'm a passionate **Data Engineer** and **Data Analyst** with 5+ years of experience in turning raw data into actionable insights. Transitioning from a background in **Materials and Metallurgical Engineering**, I've developed a deep love for building data-driven solutions and uncovering the stories behind the numbers.

- 🎓 **Background**: Materials & Metallurgical Engineering
- 💻 **Current Focus**: Data Engineering, Analytics, and Visualizations
- 🔍 **Skills**: Python, SQL, Power BI, MySQL, Azure Data Lake Storage (ADLS), and Databricks
- 🎶 **Fun Fact**: I'm a choirmaster in my parish, blending my passion for data with my love for music!

---
## Title
### Hospital Management System: Streamlining Healthcare Operations

## Description
The Hospital Management System is a comprehensive software solution designed to optimize and manage various hospital operations. It includes functionalities for patient registration, appointment scheduling, medical records management, billing, and admissions tracking.

The project utilizes MySQL for database management, Python for data handling, and Power BI for advanced data visualization and reporting. By integrating these technologies, the system provides healthcare administrators with insights into hospital trends, patient demographics, revenue streams, and resource allocation.

This project aims to enhance efficiency, improve patient care, and support data-driven decision-making within healthcare facilities.

## 💻Skills

### Programming & Scripting
Python (Data Analysis, Automation)
SQL (Queries, Database Management)
DAX (Power BI Calculations)

### Data Visualization
Power BI (Proficient)
Tableau (Intermediate)

### Cloud & Big Data
Azure Data Lake Storage (ADLS)
Databricks (Service Principal Integration, Workspaces)

### Database Management
MySQL (Schema Design, Query Optimization)
PostgreSQL (Data Queries)

### Tools & Platforms
Git & GitHub (Version Control)
Jupyter Notebooks (Data Exploration)
Power BI Service (Cloud Dashboards)

### Other Skills
Adaptive Dashboards & Reporting
ETL Processes
Data Cleaning and Transformation

### 📈 Soft Skills
Problem-Solving
Team Collaboration
Attention to Detail
Leadership (e.g., Choirmaster role, Lead Data Analyst)## 🗃️ Database Queries

### 1. Create Tables
Below are some SQL queries used to define the tables in the hospital management system.
```sql

---Table: Staff
CREATE TABLE Staff (
    staffid INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL,
    phonenumber VARCHAR(15),
    email VARCHAR(255) UNIQUE
);

--- Table: Rooms

CREATE TABLE Rooms (
    roomid INT AUTO_INCREMENT PRIMARY KEY,
    roomnumber VARCHAR(10) NOT NULL UNIQUE,
    departmentid INT,
    roomtype VARCHAR(50),
    availability ENUM('Occupied', 'Available') DEFAULT 'Available',
    FOREIGN KEY (departmentid) REFERENCES Department(departmentid)
);

--- Table: Prescription
CREATE TABLE Prescription (
    prescriptionid INT AUTO_INCREMENT PRIMARY KEY,
    recordid INT,
    medicationname VARCHAR(255),
    dosage VARCHAR(100),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    FOREIGN KEY (recordid) REFERENCES MedicalRecords(recordid)
);

--- Table: Patient
CREATE TABLE Patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    dateofbirth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    address TEXT,
    phonenumber VARCHAR(15),
    email VARCHAR(255) UNIQUE,
    insurancedetails TEXT
);
--- Table: MedicalRecords
CREATE TABLE MedicalRecords (
    recordid INT AUTO_INCREMENT PRIMARY KEY,
    patientid INT,
    doctorid INT,
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    dateofvisit DATE NOT NULL,
    FOREIGN KEY (patientid) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctorid) REFERENCES Doctors(doctorid)
);

--- Table: Doctors
CREATE TABLE Doctors (
    doctorid INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    specialty VARCHAR(100),
    phonenumber VARCHAR(15),
    email VARCHAR(255) UNIQUE,
    departmentid INT,
    FOREIGN KEY (departmentid) REFERENCES Department(departmentid)
);

--- Table: Department
CREATE TABLE Department (
    departmentid INT AUTO_INCREMENT PRIMARY KEY,
    departmentname VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255)
);

--- Table: Billing
CREATE TABLE Billing (
    billid INT AUTO_INCREMENT PRIMARY KEY,
    patientid INT,
    recordid INT,
    amount DECIMAL(10, 2) NOT NULL,
    paymentdate DATE,
    paymentstatus ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (patientid) REFERENCES Patient(patient_id),
    FOREIGN KEY (recordid) REFERENCES MedicalRecords(recordid)
);

--- Table: Appointment
CREATE TABLE Appointment (
    appointmentid INT AUTO_INCREMENT PRIMARY KEY,
    patientid INT,
    doctorid INT,
    appointmentdate DATE NOT NULL,
    appointmenttime TIME NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    appointmentmonth INT GENERATED ALWAYS AS (MONTH(appointmentdate)) STORED,
    FOREIGN KEY (patientid) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctorid) REFERENCES Doctors(doctorid)
);

--- Table: Admissions
CREATE TABLE Admissions (
    admissionid INT AUTO_INCREMENT PRIMARY KEY,
    patientid INT,
    roomid INT,
    admissiondate DATE NOT NULL,
    dischargedate DATE,
    reasonforadmission TEXT,
    days_spent INT GENERATED ALWAYS AS (DATEDIFF(dischargedate, admissiondate)) STORED,
    FOREIGN KEY (patientid) REFERENCES Patient(patient_id),
    FOREIGN KEY (roomid) REFERENCES Rooms(roomid)
);
```
### These queries demonstrates how to interact with the Database
```sql 

```
### Python Code 
To validate the efficiency and functionality of the database design, I populated the tables with realistic sample data. This allowed me to thoroughly test the relationships between the tables and ensure the database performed as expected under simulated conditions.

See below the python code i used in achieving this
import mysql.connector
from faker import Faker
import random
from datetime import datetime, timedelta

```python 

# Initialize Faker
fake = Faker()

# Connect to MySQL database
connection = mysql.connector.connect(
    host="localhost",  # MySQL host
    user="your-username",  # MySQL username
    password="your-password",  # MySQL password
    database="hospital_management_system"
)

cursor = connection.cursor()

# Function to generate and insert fake data into the Patient table

def insert_fake_patients(num_patients=10):
    for _ in range(num_patients):
        full_name = fake.name()
        date_of_birth = fake.date_of_birth(minimum_age=18, maximum_age=90).strftime("%Y-%m-%d")
        gender = random.choice(['Male', 'Female', 'Other'])
        address = fake.address().replace('\n', ', ')
        phone_number = fake.phone_number()
        email = fake.email()
        insurance_details = fake.text(max_nb_chars=100)

        insert_query = """
        INSERT INTO Patient (full_name, dateofbirth, gender, address, phonenumber, email, insurancedetails)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (full_name, date_of_birth, gender, address, phone_number, email, insurance_details))

# Function to generate and insert fake data into the Doctor table
def insert_fake_doctors(num_doctors=5):
    for _ in range(num_doctors):
        first_name = fake.first_name()
        last_name = fake.last_name()
        specialty = random.choice(['Cardiology', 'Neurology', 'Pediatrics', 'Orthopedics'])
        phone_number = fake.phone_number()
        email = fake.email()
        department_id = random.randint(1, 3)  # Assuming there are 3 departments in the Department table

        insert_query = """
        INSERT INTO Doctors (firstname, lastname, specialty, phonenumber, email, departmentid)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (first_name, last_name, specialty, phone_number, email, department_id))

# Function to generate and insert fake data into the Appointment table
def insert_fake_appointments(num_appointments=10):
    for _ in range(num_appointments):
        patient_id = random.randint(1, 10)  # Assuming there are 10 patients in the database
        doctor_id = random.randint(1, 5)  # Assuming there are 5 doctors
        appointment_date = fake.date_this_year(before_today=True, after_today=False)
        appointment_time = fake.time()

        status = random.choice(['Pending', 'Confirmed', 'Cancelled'])
        
        insert_query = """
        INSERT INTO Appointment (patientid, doctorid, appointmentdate, appointmenttime, status)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (patient_id, doctor_id, appointment_date, appointment_time, status))

# Function to generate and insert fake data into the Billing table
def insert_fake_billing(num_bills=10):
    for _ in range(num_bills):
        patient_id = random.randint(1, 10)  # Assuming there are 10 patients in the database
        record_id = random.randint(1, 10)  # Assuming there are 10 medical records
        amount = round(random.uniform(100, 1000), 2)  # Random amount between 100 and 1000
        payment_date = fake.date_this_year()
        payment_status = random.choice(['Pending', 'Completed', 'Failed'])

        insert_query = """
        INSERT INTO Billing (patientid, recordid, amount, paymentdate, paymentstatus)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (patient_id, record_id, amount, payment_date, payment_status))

# Function to generate and insert fake data into the Admissions table
def insert_fake_admissions(num_admissions=5):
    for _ in range(num_admissions):
        patient_id = random.randint(1, 10)  # Assuming there are 10 patients in the database
        room_id = random.randint(1, 5)  # Assuming there are 5 rooms in the database
        admission_date = fake.date_this_year(before_today=True, after_today=False)
        discharge_date = (datetime.strptime(admission_date, "%Y-%m-%d") + timedelta(days=random.randint(1, 7))).strftime("%Y-%m-%d")
        reason_for_admission = fake.text(max_nb_chars=50)

        insert_query = """
        INSERT INTO Admissions (patientid, roomid, admissiondate, dischargedate, reasonforadmission)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_query, (patient_id, room_id, admission_date, discharge_date, reason_for_admission))

# Generate and insert fake data
insert_fake_patients(10)
insert_fake_doctors(5)
insert_fake_appointments(10)
insert_fake_billing(10)
insert_fake_admissions(5)

# Commit the changes and close the connection
connection.commit()
cursor.close()
connection.close()

print("Fake data inserted successfully!")
```

The code successfully populated the hospital_management_system database with data, allowing me to perform in-depth analysis on the system. The following SQL queries demonstrate additional insights gained from the hospital management system analysis.

```sql

-- Patient admissions and discharges
-- How many patients were admitted and discharged in the last month
Select count(*) as last_month_discharged_patient
From admissions
where admissiondate between curdate() - interval 1 month and curdate()
and dischargedate is not null;

-- Which patients have had the most appointments in the past year?
Select count(ap.appointmentid) as total_appointments, p.firstname as first_name, p.lastname as last_name
from patients p
join appointments ap on p.patientid = ap.patientid
where ap.appointmentdate between curdate() - interval 1 year and curdate()
group by p.patientid
order by 1 desc
limit 10;

-- Doctors with the most scheduled appointments
Select count(ap.appointmentid) as total_appointments, d.firstname, d.lastname
from doctors d
join appointments ap on d.doctorid = ap.doctorid
where ap.status = 'Scheduled'
group by d.doctorid
order by 1 desc
limit 10;

-- What is the total revenue generated by the hospital in the last 6 months?
Select sum(b.amount) as total_revenue
from billing b
where b.paymentdate between curdate() - interval 6 month and curdate() and b.paymentstatus = 'Paid';

-- Which department have admitted the most patients?
Select d.departmentname, count(ad.admissionid) as total_admissions
from departments d
join rooms r on d.departmentid = r.departmentid
join admissions ad on r.roomid = ad.roomid
group by d.departmentid
order by total_admissions desc;

-- What is the average duration of patient stays in the hospital?
select avg(datediff(dischargedate, admissiondate)) as avg_stay_duration
from admissions ad
where ad.dischargedate is not null;

-- How many patients have unpaid payment
select count(b.patientid) as Unpaid_payment
from billing b
where b.paymentstatus = 'Unpaid';

-- Also find the department of this unpaid payment
select count(b.billid) as Unpaid_bills, de.departmentname as department, sum(b.amount) as total_unpaid_amount
from departments de
join rooms r on de.departmentid = r.departmentid
join admissions a on r.roomid = a.roomid
join billing b on a.patientid = b.patientid
where b.paymentstatus = 'Unpaid'
group by 2
order by 3 desc;

-- Which medications are prescribed the most?
Select count(p.prescriptionid) as total_prescription, p.medicationname
from prescriptions p
group by medicationname
order by total_prescription;

-- What is the breakdown of appointment statuses (e.g Scheduled, Completed, Cancelled)?
Select count(ap.appointmentid) as total_appointment, ap.status
from appointments ap
group by 2
order by 1 desc;

-- Most common diagnoses in the hospital records
Select count(recordid) as total_diagnosed, diagnosis
from medicalrecords mr
group by diagnosis
order by 1 desc;

-- Average billing amount per patient
Select avg(amount) as average_billing
from billing;

-- How many patient are using insurance type
select count(patientid) as total_patient, insurancedetails
from patients
group by 2
order by 1 desc;

-- How many appointments were cancelled in the last three months
select count(ap.appointmentid) as total_appointment
from appointments ap
where ap.appointmentdate between curdate() - interval 3 month and curdate()
and ap.status = 'Cancelled';

-- Which medical specialities are in the highest demand based on appointments?
select count(ap.appointmentid) as total_appointment, d.specialty
from appointments ap
join doctors d on ap.doctorid = d.doctorid
group by 2
order by 1 desc;

-- Average length of stay (ALOS)
select mr.diagnosis, AVG(DATEDIFF(a.dischargedate, a.admissiondate)) AS average_length_of_stay
FROM admissions a
join medicalrecords mr on a.patientid = mr.patientid
GROUP BY mr.diagnosis
order by 2 desc;


-- Readmission rate
SELECT 
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    mr.diagnosis,
    COUNT(DISTINCT a.admissionid) AS readmitted_patients,
    COUNT(a.admissionid) AS total_admissions,
    (COUNT(DISTINCT a.admissionid) / COUNT(a.admissionid) * 100) AS readmission_rate
FROM 
    admissions a
JOIN 
    medicalrecords mr ON a.patientid = mr.patientid
JOIN 
    patients p ON a.patientid = p.patientid
WHERE 
    a.patientid IN (
        SELECT a2.patientid 
        FROM admissions a2 
        JOIN medicalrecords mr2 ON a2.patientid = mr2.patientid
        GROUP BY a2.patientid, mr2.diagnosis
        HAVING COUNT(*) > 1
    )
GROUP BY 
    patient_name, mr.diagnosis
ORDER BY 
    mr.diagnosis, patient_name;
```

After conducting analysis on the data in MySQL, I decided to visualize the insights using Power BI. This enables stakeholders to monitor key trends and activities within the hospital, providing valuable support for informed decision-making. The visualizations are designed to assist the hospital management in making strategic decisions that will drive the hospital's growth.


### Power BI Report

This report provides key insights into various aspects of hospital operations, including patient demographics, doctor performance, admission trends, appointment scheduling, and financial metrics. These findings, visualized in the linked Power BI dashboard, highlight critical indicators that can guide decision-making and strategic planning within the hospital.

#### Key Insights:

Total Patients: 1,000

Gender Breakdown: 502 male, 498 female

Insurance Distribution: Insurer B had the highest number of patients (377), while Insurer D had the lowest (97)

Age Distribution: The 81+ age group was the largest (146 patients), and the 1–20 age group was the smallest (38 patients)

Geographic Distribution: Montana had the highest patient count (26 patients)

Revenue by Gender: Male patients contributed $2,625,915 in revenue

#### Doctor Performance:

Top Specialties: Neurology had the most appointments, totaling 268 (26.8% of all appointments)

Consultation Time: Dr. Judith Garcia (Pediatrics) had the highest consultation time (103.08 minutes)
Highest Number of Appointments: Dr. Matthew Day recorded 30 appointments

#### Admission Trends:

Top Reasons for Admission: Quadriplegia and Jaundice had the longest hospital stays (36 days)

Admission Peaks: Highest single-day admissions occurred on Sunday, Sep 22, 2024

Room Type Utilization: Semi-private rooms had 282 admissions, with heart attacks being the most common reason (34 admissions)
Appointment Scheduling and Financial Metrics:

#### Monthly Trends:
October had more appointments than November

Status: Cancellations outnumbered scheduled and completed appointments, totaling 356

Day-wise Trends: Friday was the busiest day, with 186 appointments

Departmental Revenue: The Emergency Department led with $1,180,281 in revenue

Revenue by Gender: Female patients contributed $548,936, and male patients $631,345

#### Room Utilization and Scheduling:

Semi-private Room Trends: Patients spent 6,186 days in semi-private rooms, with Wednesday recording the highest occupancy (50 days)

This dashboard offers a comprehensive view of hospital operations, emphasizing key patient demographics, high-performing doctors, admission trends, and financial performance by department and insurance type. By monitoring these metrics, the hospital can enhance resource allocation, improve appointment scheduling, and strengthen financial planning.

#### Recommendations for Improvement:

Optimize Staffing in High-Demand Specialties: Reduce wait times and improve doctor utilization.

Outreach and Insurance-Based Patient Acquisition: Expand the insurance coverage mix to increase patient inflow.

Expand Semi-Private Room Facilities: Increase bed availability and reduce wait times.
Improve Financial Recovery in Emergency 

Department: Enhance revenue collection rates and improve cash flow.

Enhanced Patient Scheduling: Reduce missed appointments and minimize revenue loss.
Admission Adjustments for High-Frequency 

Conditions: Allocate resources efficiently and reduce re-admissions.

Enhance Age-Specific Care Services: Improve outcomes for elderly patients and expand services.


[Link to Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiYThjNzA1MjEtM2ExNi00Y2NlLTk1N2MtMTMzYjMyNjA3MmEzIiwidCI6IjA1MmE5NDA1LTY0MTItNGUyNy1hZTBjLWRiMTZhY2E1ZGViZCJ9)

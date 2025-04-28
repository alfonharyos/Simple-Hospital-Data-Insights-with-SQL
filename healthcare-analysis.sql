/******************************************************************************* 
   1. Hospital Revenue Analysis
********************************************************************************/
WITH AppointmentHospital AS (
    SELECT 
        appointments.appointment_id,
        hospitals.hospital_name
    FROM 
        appointments
    JOIN 
        hospitals ON appointments.hospital_id = hospitals.hospital_id
)
SELECT 
    AppointmentHospital.hospital_name, 
    SUM(bills.total_amount) AS total_revenue
FROM 
    AppointmentHospital
JOIN 
    bills ON AppointmentHospital.appointment_id = bills.appointment_id
WHERE 
    bills.payment_status = 'Paid'
GROUP BY 
    AppointmentHospital.hospital_name
ORDER BY 
    total_revenue DESC;

/******************************************************************************* 
   2. Number of Appointments by Specialization
********************************************************************************/
WITH AppointmentDoctorCount AS (
    SELECT 
        doctor_id,
        COUNT(appointment_id) AS appointment_count
    FROM 
        appointments 
    GROUP BY 
        doctor_id
)
SELECT 
    doctors.specialty,
    SUM(AppointmentDoctorCount.appointment_count) AS total_appointment_specialty
FROM 
    AppointmentDoctorCount
JOIN 
    doctors ON doctors.doctor_id = AppointmentDoctorCount.doctor_id
GROUP BY 
    doctors.specialty
ORDER BY 
    total_appointment_specialty DESC;

/*******************************************************************************
   3. Top 5 Doctors with the Most Appointments
********************************************************************************/
SELECT 
	doctors.name,
	COUNT(appointments.appointment_id) AS appointment_count
FROM 
	doctors
JOIN 
	appointments ON appointments.doctor_id = doctors.doctor_id
WHERE
	appointments.status = 'completed'
GROUP BY 
	doctors.name
ORDER BY 
	appointment_count DESC
LIMIT 5;

/*******************************************************************************
   4. Most Common Insurance Providers for Patients
********************************************************************************/
SELECT
	insurance_providers.provider_name,
	COUNT(patients.patient_id) AS patient_count
FROM
	insurance_providers
JOIN 
	patients ON patients.insurance_id = insurance_providers.insurance_id 
GROUP BY
	insurance_providers.provider_name
ORDER BY 
	patient_count DESC;

/*******************************************************************************
   5. Payment Status
********************************************************************************/
SELECT 
    bills.payment_status,
    appointments.status,
    COUNT(bills.bill_id) AS bill_count,
    ROUND(
        (COUNT(bills.bill_id) * 100.0) / 
        SUM(COUNT(bills.bill_id)) OVER(), 2
    ) AS payment_percentage
FROM 
    bills
JOIN 
    appointments ON bills.appointment_id = appointments.appointment_id 
GROUP BY 
    bills.payment_status, appointments.status
ORDER BY 
    bill_count DESC;




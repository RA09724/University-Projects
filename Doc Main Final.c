//DOCTOR CODE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_DOCTORS 100
#define MAX_NAME_LEN 50
#define MAX_SPECIALITY_LEN 50
#define MAX_APPOINTMENTS 6
#define MAX_STATUS_LEN 4  // To store "IN" or "OUT" status for Doctor
#define MAX_LICENSE_LEN 10
#define MAX_APPT_DETAIL_LEN 30 // To store "Available", "Unavailable", or "Booked(PXX)"
#define MAX_PATIENTS 100
#define MAX_BUFFER 512

// Struct to store doctor Information
typedef struct {
    char firstName[MAX_NAME_LEN];
    char lastName[MAX_NAME_LEN];
    char medicalLicense[MAX_LICENSE_LEN];
    char speciality[MAX_SPECIALITY_LEN];
    char status[MAX_STATUS_LEN]; // To store IN or OUT status
    char appointments[MAX_APPOINTMENTS][MAX_APPT_DETAIL_LEN]; // To store appointment details
    int availability[MAX_APPOINTMENTS]; // To store availability (0 = unavailable, 1 = available, 2 = booked)
} Doctor;

// Struct to store patient Information
typedef struct {
    char patientID[10];
    char firstName[50];
    char lastName[50];
    char gender[10];
    char idNumber[20];
    char state[50];
    char country[50];
    char phoneNumber[20];
    char medicalHistory[100];
    char allergies[50];
    char medications[50];
    char pastProcedures[100];
    char xRayScans[100];
    float bloodSugarLevel;
    int heartRate;
    char physicalExamination[100];
    char doctorsNote[200];
    char treatmentDetails[200];
} Patientdoc;

Doctor doctors[MAX_DOCTORS];
int numDoctors = 0;

Patientdoc patients[MAX_PATIENTS];
int patientCount = 0;

int loggedInDoctorIndex = -1; // Index of the logged-in doctor


void clearInputBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

// Function for Doctor Login
void doctor_login()
{
    FILE *doctor_file;
    char input_lastname[MAX_NAME_LEN];
    char input_license[MAX_LICENSE_LEN];
    char stored_firstname[MAX_NAME_LEN], stored_lastname[MAX_NAME_LEN], stored_specialization[MAX_SPECIALITY_LEN], stored_state[MAX_NAME_LEN], stored_country[MAX_NAME_LEN];
    char stored_license[MAX_LICENSE_LEN], stored_phone_number[MAX_NAME_LEN];
    int found = 0;
    char buffer[MAX_BUFFER];


    while (!found) {
        // Open the file in read mode
        doctor_file = fopen("doctor.txt", "r");
        if (doctor_file == NULL) {
            printf("Error opening file\n");
            return;
        }

        printf("========================================\n");
        printf("         Doctor Login Page\n");
        printf("========================================\n");

        // Get last name
        do {
            printf("Enter Last Name: ");
            clearInputBuffer();
            if (fgets(input_lastname, sizeof(input_lastname), stdin) != NULL) {
                input_lastname[strcspn(input_lastname, "\n")] = '\0';  // Remove newline character
            } else {
                printf("Error reading last name\n");
                fclose(doctor_file);
                return;
            }

            if (strcmp(input_lastname, "exit") == 0) {
                fclose(doctor_file);
                return;
            }

            if (strlen(input_lastname) == 0) {
                printf("Input cannot be empty. Please enter your last name.\n");
            }
        } while (strlen(input_lastname) == 0);

        // Get license number
        do {
            printf("Enter Medical License Number: ");
            if (fgets(input_license, sizeof(input_license), stdin) != NULL) {
                input_license[strcspn(input_license, "\n")] = '\0';  // Remove newline character
            } else {
                printf("Error reading license number\n");
                fclose(doctor_file);
                return;
            }

            if (strcmp(input_license, "exit") == 0) {
                fclose(doctor_file);
                return;
            }

            if (strlen(input_license) == 0) {
                printf("Input cannot be empty. Please enter your medical license number.\n");
            }
        } while (strlen(input_license) == 0);

        // Read and check each line in the file
        while (fgets(buffer, sizeof(buffer), doctor_file) != NULL) {
            sscanf(buffer, " %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^\n]",
                   stored_firstname, stored_lastname, stored_license,
                   stored_specialization, stored_state, stored_country, stored_phone_number);

            if (strcmp(input_lastname, stored_lastname) == 0 && strcmp(input_license, stored_license) == 0) {
                printf("Login Successful!\n");
                printf("========================================\n");
                printf("Welcome back, Dr. %s %s!\n", stored_firstname, stored_lastname);
                found = 1;
                printf("========================================\n");

                // Find the doctor index and set loggedInDoctorIndex
                for (int i = 0; i < numDoctors; i++) {
                    if (strcmp(doctors[i].lastName, stored_lastname) == 0 && strcmp(doctors[i].medicalLicense, stored_license) == 0) {
                        loggedInDoctorIndex = i;
                        break;
                    }
                }

                fclose(doctor_file);
                // Call the doctor menu function
                doctor_menu();
                return;
            }
        }

        if (!found) {
            printf("Incorrect Last Name or Medical License Number. Please try again.\n");
        }

        fclose(doctor_file);
    }
}

// Function to display doctor menu
void doctor_menu()
{
    int choice;
    char id[10];

    loadDoctors(doctors, &numDoctors); // Load doctors from text file
    loadDoctorSchedules(doctors, numDoctors); // Load doctor schedules from text file
    loadPatientsintoEHR(); // Load patients from text file and convert to EHR
    loadPatients(); // Load patients from EHR file

    doctor_login();

    while (1) {
        printf("\n========================================\n");
        printf("       Doctor Management Menu\n");
        printf("========================================\n");
        printf("1. Doctor Scheduler System\n");
        printf("2. Patient Records System\n");
        printf("3. Reporting and Analytics System\n");
        printf("4. Exit\n");
        printf("========================================\n");
        printf("Enter your choice: ");
        if (scanf("%d", &choice) != 1) {
            clearInputBuffer();
            printf("Invalid choice. Please try again.\n");
            continue;
        }
        clearInputBuffer();

        if (choice == 4) {
            printf("Exiting the system.\n");
            break;
        }

        switch (choice) {
            case 1: {
                // Doctor scheduler menu
                int schedulerChoice;
                while (1) {
                    printf("\n----------------------------------------\n");
                    printf("          Doctor Scheduling Menu\n");
                    printf("----------------------------------------\n");
                    printf("1. Display schedule\n");
                    printf("2. Update doctor status\n");
                    printf("3. Update appointment status\n");
                    printf("4. Return to main menu\n");
                    printf("----------------------------------------\n");
                    printf("Enter your choice: ");
                    if (scanf("%d", &schedulerChoice) != 1) {
                        clearInputBuffer();
                        printf("Invalid input. Please enter a number between 1 and 4.\n");
                        continue;
                    }
                    clearInputBuffer();

                    if (schedulerChoice == 4) {
                        break;
                    }

                    switch (schedulerChoice) {
                        case 1:
                            displaySchedule(doctors, numDoctors);
                            break;
                        case 2:
                            updateDoctorStatus(doctors, numDoctors);
                            displaySchedule(doctors, numDoctors);
                            break;
                        case 3:
                            updateAppointmentStatus(doctors, numDoctors);
                            displaySchedule(doctors, numDoctors);
                            break;
                        default:
                            printf("Invalid choice. Please enter a number between 1 and 4.\n");
                    }
                }
                break;
            }
            case 2: {
                // Patient Records Menu
                int recordsChoice;
                while (1) {
                    printf("\n----------------------------------------\n");
                    printf("          Patient Records Menu\n");
                    printf("----------------------------------------\n");
                    printf("1. Electronic Health Record\n");
                    printf("2. Patient Diagnosis\n");
                    printf("3. Return to main menu\n");
                    printf("----------------------------------------\n");
                    printf("Enter your choice: ");
                    if (scanf("%d", &recordsChoice) != 1) {
                        clearInputBuffer();
                        printf("Invalid choice. Please try again.\n");
                        continue;
                    }
                    clearInputBuffer();

                    if (recordsChoice == 3) {
                        break;
                    }

                    switch (recordsChoice) {
                        case 1: {
                            do {
                                printf("Enter patient ID to search (e.g., P01): ");
                                if (fgets(id, sizeof(id), stdin) == NULL) {
                                    clearInputBuffer();
                                    printf("Invalid ID input. Please try again.\n");
                                    continue;
                                }
                                trimNewline(id);

                                if (strlen(id) == 0) {
                                    printf("Input cannot be empty. Please enter a valid patient ID.\n");
                                }
                            } while (strlen(id) == 0);

                            int index = findPatientByID(id);
                            if (index != -1) {
                                patientEHR(index);
                            } else {
                                printf("Patient not found.\n");
                            }
                            break;
                        }
                        case 2: {
                            do {
                                printf("Enter patient ID (e.g., P01): ");
                                if (fgets(id, sizeof(id), stdin) == NULL) {
                                    clearInputBuffer();
                                    printf("Invalid ID input. Please try again.\n");
                                    continue;
                                }
                                trimNewline(id);

                                if (strlen(id) == 0) {
                                    printf("Input cannot be empty. Please enter a valid patient ID.\n");
                                }
                            } while (strlen(id) == 0);

                            int index = findPatientByID(id);
                            if (index != -1) {
                                addPatientMedicalInfo(index);
                            } else {
                                printf("Patient not found.\n");
                            }
                            break;
                        }
                        default:
                            printf("Invalid choice. Please try again.\n");
                    }
                }
                break;
            }
            case 3: {
                // Reporting and Analytics System
                int reportChoice;
                while (1) {
                    printf("\n----------------------------------------\n");
                    printf("      Reporting and Analytics Menu\n");
                    printf("----------------------------------------\n");
                    printf("1. Add Doctor's Note\n");
                    printf("2. Add Treatment Details\n");
                    printf("3. Generate Patient Report\n");
                    printf("4. Analyze Treatment Trends\n");
                    printf("5. Return to main menu\n");
                    printf("----------------------------------------\n");
                    printf("Enter your choice: ");
                    if (scanf("%d", &reportChoice) != 1) {
                        clearInputBuffer();
                        printf("Invalid choice. Please try again.\n");
                        continue;
                    }
                    clearInputBuffer();

                    if (reportChoice == 5) {
                        break;
                    }

                    switch (reportChoice) {
                        case 1: {
                            do {
                                printf("Enter patient ID to add doctor's note (e.g., P01): ");
                                if (fgets(id, sizeof(id), stdin) == NULL) {
                                    clearInputBuffer();
                                    printf("Invalid ID input. Please try again.\n");
                                    continue;
                                }
                                trimNewline(id);

                                if (strlen(id) == 0) {
                                    printf("Input cannot be empty. Please enter a valid patient ID.\n");
                                }
                            } while (strlen(id) == 0);

                            int index = findPatientByID(id);
                            if (index != -1) {
                                addDoctorsNote(index);
                            } else {
                                printf("Patient not found.\n");
                            }
                            break;
                        }
                        case 2: {
                            do {
                                printf("Enter patient ID to update treatment details (e.g., P01): ");
                                if (fgets(id, sizeof(id), stdin) == NULL) {
                                    clearInputBuffer();
                                    printf("Invalid ID input. Please try again.\n");
                                    continue;
                                }
                                trimNewline(id);

                                if (strlen(id) == 0) {
                                    printf("Input cannot be empty. Please enter a valid patient ID.\n");
                                }
                            } while (strlen(id) == 0);

                            int index = findPatientByID(id);
                            if (index != -1) {
                                addTreatmentDetails(index);
                            } else {
                                printf("Patient ID does not exist. Please enter a valid Patient ID\n");
                            }
                            break;
                        }
                        case 3: {
                            do {
                                printf("Enter patient ID to display report (e.g., P01): ");
                                if (fgets(id, sizeof(id), stdin) == NULL) {
                                    clearInputBuffer();
                                    printf("Invalid ID input. Please try again.\n");
                                    continue;
                                }
                                trimNewline(id);

                                if (strlen(id) == 0) {
                                    printf("Input cannot be empty. Please enter a valid patient ID.\n");
                                }
                            } while (strlen(id) == 0);

                            int index = findPatientByID(id);
                            if (index != -1) {
                                patientreport(index);
                            } else {
                                printf("Patient data does not exist. Unable to generate report!\n");
                            }
                            break;
                        }
                        case 4:
                            analyzeTreatmentTrends();
                            break;
                        default:
                            printf("Invalid choice. Please try again.\n");
                    }
                }
                break;
            }
            default:
                printf("Invalid choice. Please try again.\n");
        }
    }

    return;
}

// Function to load doctors from text file
void loadDoctors(Doctor doctors[], int *numDoctors) {
    FILE *file = fopen("doctor.txt", "r");
    if (!file) {
        perror("Failed to open doctor file");
        exit(EXIT_FAILURE);
    }

    *numDoctors = 0;
    char line[1024];

    int lineNumber = 0;
    while (fgets(line, sizeof(line), file) != NULL) {
        lineNumber++;
        if (*numDoctors >= MAX_DOCTORS) break;

        char firstName[MAX_NAME_LEN], lastName[MAX_NAME_LEN], license[MAX_LICENSE_LEN], speciality[MAX_SPECIALITY_LEN];
        char state[MAX_NAME_LEN], country[MAX_NAME_LEN], phone[MAX_NAME_LEN];

        int scanned = sscanf(line, " %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^\n]",
                             firstName, lastName, license, speciality, state, country, phone);

        if (scanned != 7) {
            fprintf(stderr, "Invalid data in doctor file (line %d): %s\n", lineNumber, line);
            continue;
        }

        strcpy(doctors[*numDoctors].firstName, firstName);
        strcpy(doctors[*numDoctors].lastName, lastName);
        strcpy(doctors[*numDoctors].medicalLicense, license);
        strcpy(doctors[*numDoctors].speciality, speciality);
        strcpy(doctors[*numDoctors].status, "OUT");
        for (int i = 0; i < MAX_APPOINTMENTS; i++) {
            strcpy(doctors[*numDoctors].appointments[i], "Unavailable");
            doctors[*numDoctors].availability[i] = 0; // Set initial availability to 0 (Unavailable)
        }

        (*numDoctors)++;
    }

    fclose(file);
}

// Function to load doctor schedules
void loadDoctorSchedules(Doctor doctors[], int numDoctors) {
    FILE *file = fopen("doctorschedule.txt", "r");
    if (!file) {
        perror("Failed to open doctor schedule file");
        exit(EXIT_FAILURE);
    }

    char line[1024];
    while (fgets(line, sizeof(line), file) != NULL) {
        char lastName[MAX_NAME_LEN], license[MAX_LICENSE_LEN], speciality[MAX_SPECIALITY_LEN], status[MAX_STATUS_LEN];
        char slots[MAX_APPOINTMENTS][MAX_APPT_DETAIL_LEN];

        // Initialize slots with empty spaces
        for (int i = 0; i < MAX_APPOINTMENTS; i++) {
            strcpy(slots[i], "Unavailable");
        }

        int scanned = sscanf(line, " %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^,], %[^\n]",
                             lastName, license, speciality, status,
                             slots[0], slots[1], slots[2], slots[3], slots[4], slots[5]);

        if (scanned < 4) {
            fprintf(stderr, "Invalid data in doctor schedule file: %s\n", line);
            continue;
        }

        for (int i = 0; i < numDoctors; i++) {
            if (strcmp(doctors[i].lastName, lastName) == 0 && strcmp(doctors[i].medicalLicense, license) == 0) {
                strcpy(doctors[i].status, status);

                for (int j = 0; j < MAX_APPOINTMENTS; j++) {
                    strcpy(doctors[i].appointments[j], slots[j]);
                }

                for (int j = 0; j < MAX_APPOINTMENTS; j++) {
                    if (strstr(doctors[i].appointments[j], "Unavailable") != NULL) {
                        doctors[i].availability[j] = 0;
                    } else if (strstr(doctors[i].appointments[j], "Available") != NULL) {
                        doctors[i].availability[j] = 1;
                    } else if (strstr(doctors[i].appointments[j], "Booked") != NULL) {
                        doctors[i].availability[j] = 2;
                    } else {
                        doctors[i].availability[j] = 1;
                    }
                }
                break;
            }
        }
    }

    fclose(file);
}

// Function to save changes made in doctor schedules to text file
void saveDoctorSchedule(Doctor doctors[], int numDoctors) {
    FILE *file = fopen("doctorschedule.txt", "w");
    if (!file) {
        perror("Failed to open doctor schedule file");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < numDoctors; i++) {
        fprintf(file, "%s, %s, %s, %s", doctors[i].lastName, doctors[i].medicalLicense, doctors[i].speciality, doctors[i].status);
        for (int j = 0; j < MAX_APPOINTMENTS; j++) {
            fprintf(file, ", %s", doctors[i].appointments[j]);
        }
        fprintf(file, "\n");
    }

    if (fclose(file) != 0) {
        perror("Failed to close doctor schedule file");
        exit(EXIT_FAILURE);
    }
}

// Function to display doctor schedule
void displaySchedule(Doctor doctors[], int numDoctors) {
    printf("-----------------------------------------------------------------------------------------------------------------------------------------------------\n");
    printf("| %-15s | %-10s | %-15s | %-6s | %-12s | %-12s | %-12s | %-12s | %-12s | %-12s |\n", "Doctor Name", "License", "Speciality", "IN/OUT", "9-10 am(1)", "10-11 am(2)", "11-12 pm(3)", "1-2 pm(4)", "2-3 pm(5)", "3-4 pm(6)");
    printf("-----------------------------------------------------------------------------------------------------------------------------------------------------\n");

    for (int i = 0; i < numDoctors; i++) {
        printf("| %-15.15s | %-10.10s | %-15.15s | %-6.6s", doctors[i].lastName, doctors[i].medicalLicense, doctors[i].speciality, doctors[i].status);
        for (int j = 0; j < MAX_APPOINTMENTS; j++) {
            printf(" | %-12.12s", doctors[i].appointments[j]);
        }
        printf(" |\n");
    }

    printf("-----------------------------------------------------------------------------------------------------------------------------------------------------\n");
}

// Function to change doctor status either IN/OUT
void updateDoctorStatus(Doctor doctors[], int numDoctors) {
    if (loggedInDoctorIndex == -1) {
        printf("No doctor is logged in.\n");
        return;
    }

    char status[MAX_STATUS_LEN];

    do {
        printf("Enter status (IN/OUT): ");
        if (fgets(status, sizeof(status), stdin) != NULL) {
            status[strcspn(status, "\n")] = '\0'; // Remove newline character
        } else {
            printf("Error reading status\n");
            return;
        }

        // Convert status input to uppercase
        for (int i = 0; status[i] != '\0'; i++) {
            status[i] = toupper(status[i]);
        }

        if (strlen(status) == 0) {
            printf("Input cannot be empty. Please enter 'IN' or 'OUT'.\n");
        }
    } while (strlen(status) == 0);

    if (strcmp(status, "IN") == 0 || strcmp(status, "OUT") == 0) {
        strcpy(doctors[loggedInDoctorIndex].status, status);
        if (strcmp(status, "IN") == 0) {
            for (int i = 0; i < MAX_APPOINTMENTS; i++) {
                if (doctors[loggedInDoctorIndex].availability[i] != 2) {
                    doctors[loggedInDoctorIndex].availability[i] = 1;
                    strcpy(doctors[loggedInDoctorIndex].appointments[i], "Available");
                }
            }
        } else {
            for (int i = 0; i < MAX_APPOINTMENTS; i++) {
                doctors[loggedInDoctorIndex].availability[i] = 0;
                strcpy(doctors[loggedInDoctorIndex].appointments[i], "Unavailable");
            }
        }
        saveDoctorSchedule(doctors, numDoctors); // Save changes to file
    } else {
        printf("Invalid status. Please enter 'IN' or 'OUT'.\n");
        return;
    }

    printf("Doctor status updated successfully!\n");
}

// Function to manage doctor appointments
void updateAppointmentStatus(Doctor doctors[], int numDoctors) {
    if (loggedInDoctorIndex == -1) {
        printf("No doctor is logged in.\n");
        return;
    }

    int appointmentIndex;
    char status[MAX_APPT_DETAIL_LEN];

    do {
        printf("Enter appointment slot (1-6): ");
        if (fgets(status, sizeof(status), stdin) != NULL) {
            status[strcspn(status, "\n")] = '\0'; // Remove newline character
        } else {
            printf("Error reading input\n");
            return;
        }

        // Check if the input is empty
        if (strlen(status) == 0) {
            printf("Input cannot be empty. Please enter a number between 1 and 6.\n");
        }
    } while (strlen(status) == 0);

    char* endptr;
    appointmentIndex = strtol(status, &endptr, 10);
    if (endptr == status || *endptr != '\0' || appointmentIndex < 1 || appointmentIndex > 6) {
        printf("Invalid appointment slot. Please enter a number between 1 and 6.\n");
        return;
    }
    appointmentIndex -= 1;

    do {
        printf("Enter status (Available/Unavailable/Booked(PXX)): ");
        if (fgets(status, sizeof(status), stdin) != NULL) {
            status[strcspn(status, "\n")] = '\0'; // Remove newline character
        } else {
            printf("Error reading input\n");
            return;
        }

        // Check if the input is empty
        if (strlen(status) == 0) {
            printf("Input cannot be empty. Please enter 'Available', 'Unavailable', or 'Booked(PXX)'.\n");
        }
    } while (strlen(status) == 0);

    // Update appointment status and availability
    if (strstr(status, "Available") != NULL) {
        doctors[loggedInDoctorIndex].availability[appointmentIndex] = 1;
        strcpy(doctors[loggedInDoctorIndex].appointments[appointmentIndex], status);
    } else if (strstr(status, "Unavailable") != NULL) {
        doctors[loggedInDoctorIndex].availability[appointmentIndex] = 0;
        strcpy(doctors[loggedInDoctorIndex].appointments[appointmentIndex], status);
    } else if (strstr(status, "Booked") != NULL) {
        doctors[loggedInDoctorIndex].availability[appointmentIndex] = 2;
        strcpy(doctors[loggedInDoctorIndex].appointments[appointmentIndex], status);
    } else {
        printf("Invalid status. Please enter 'Available', 'Unavailable', or 'Booked(PXX)'.\n");
        return;
    }

    saveDoctorSchedule(doctors, numDoctors); // Save changes to file
    printf("Appointment status updated successfully!\n");
}

// Function to remove new lines to avoid errors
void trimNewline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len-1] == '\n') {
        str[len-1] = '\0';
    }
}

// Function to load patients
void loadPatients() {
    FILE *file = fopen("patientehr.txt", "r");
    if (!file) {
        perror("Could not open file");
        exit(EXIT_FAILURE);
    }

    char buffer[MAX_BUFFER];
    while (fgets(buffer, MAX_BUFFER, file) && patientCount < MAX_PATIENTS) {
        trimNewline(buffer);

        // Clear fields before assigning new values
        memset(&patients[patientCount], 0, sizeof(Patientdoc));

        sscanf(buffer, "%9[^,], %49[^,], %49[^,], %9[^,], %19[^,], %49[^,], %49[^,], %19[^,], %99[^,], %49[^,], %49[^,], %99[^,], %99[^,], %f, %d, %99[^,], %199[^,], %[^\n]",
               patients[patientCount].patientID, patients[patientCount].firstName, patients[patientCount].lastName,
               patients[patientCount].gender, patients[patientCount].idNumber, patients[patientCount].state,
               patients[patientCount].country, patients[patientCount].phoneNumber, patients[patientCount].medicalHistory,
               patients[patientCount].allergies, patients[patientCount].medications, patients[patientCount].pastProcedures,
               patients[patientCount].xRayScans, &patients[patientCount].bloodSugarLevel, &patients[patientCount].heartRate,
               patients[patientCount].physicalExamination, patients[patientCount].doctorsNote, patients[patientCount].treatmentDetails);

        patientCount++;
    }

    fclose(file);
}

// Function to load patients from text file and update EHR
void loadPatientsintoEHR() {
    FILE *inputFile = fopen("patient.txt", "r");
    FILE *outputFile = fopen("patientehr.txt", "a+");

    if (!inputFile) {
        perror("Could not open patient.txt file");
        exit(EXIT_FAILURE);
    }

    if (!outputFile) {
        perror("Could not open patientehr.txt file");
        fclose(inputFile);
        exit(EXIT_FAILURE);
    }

    char buffer[MAX_BUFFER];
    char ehrLine[MAX_BUFFER];

    while (fgets(buffer, sizeof(buffer), inputFile) && patientCount < MAX_PATIENTS) {
        trimNewline(buffer);

        Patientdoc tempPatient;
        // Clear fields before assigning new values
        memset(&tempPatient, 0, sizeof(Patientdoc));

        char insuranceCompany[50]; // Temporary storage for the insurance company field

        sscanf(buffer, "%9[^,], %49[^,], %49[^,], %9[^,], %19[^,], %49[^,], %49[^,], %19[^,], %99[^,], %49[^,], %49[^,], %99[^,], %[^\n]",
               tempPatient.patientID, tempPatient.firstName, tempPatient.lastName, tempPatient.gender,
               tempPatient.idNumber, tempPatient.state, tempPatient.country, tempPatient.phoneNumber,
               tempPatient.medicalHistory, tempPatient.allergies, tempPatient.medications, tempPatient.pastProcedures, insuranceCompany);

        // Check if patient is already in the EHR file
        int exists = 0;
        rewind(outputFile);
        while (fgets(ehrLine, sizeof(ehrLine), outputFile)) {
            trimNewline(ehrLine);
            char existingID[10];
            sscanf(ehrLine, "%9[^,]", existingID);
            if (strcmp(existingID, tempPatient.patientID) == 0) {
                exists = 1;
                break;
            }
        }

        // If the patient does not exist, add them
        if (!exists) {
            // Initialize other fields with default values
            strcpy(tempPatient.xRayScans, "-");
            tempPatient.bloodSugarLevel = -1.0f;
            tempPatient.heartRate = -1;
            strcpy(tempPatient.physicalExamination, "-");
            strcpy(tempPatient.doctorsNote, "-");
            strcpy(tempPatient.treatmentDetails, "-");

            // Write to output file in the required format
            fprintf(outputFile, "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %.2f, %d, %s, %s, %s\n",
                    tempPatient.patientID, tempPatient.firstName, tempPatient.lastName, tempPatient.gender,
                    tempPatient.idNumber, tempPatient.state, tempPatient.country, tempPatient.phoneNumber,
                    tempPatient.medicalHistory, tempPatient.allergies, tempPatient.medications, tempPatient.pastProcedures,
                    tempPatient.xRayScans, tempPatient.bloodSugarLevel, tempPatient.heartRate, tempPatient.physicalExamination,
                    tempPatient.doctorsNote, tempPatient.treatmentDetails);

            // Add to patients array
            patients[patientCount++] = tempPatient;
        }
    }

    fclose(inputFile);
    fclose(outputFile);
}

// Function to find patients in array
int findPatientByID(const char *id) {
    for (int i = 0; i < patientCount; ++i) {
        if (strcmp(patients[i].patientID, id) == 0) {
            return i;
        }
    }
    return -1;
}

// Function to save patients to EHR file
void savePatientsToEHRFile() {
    FILE *file = fopen("patientehr.txt", "w");
    if (!file) {
        perror("Could not open file for writing");
        return;
    }

    for (int i = 0; i < patientCount; i++) {
        int result = fprintf(file, "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %.2f, %d, %s, %s, %s\n",
                patients[i].patientID, patients[i].firstName, patients[i].lastName, patients[i].gender,
                patients[i].idNumber, patients[i].state, patients[i].country, patients[i].phoneNumber,
                patients[i].medicalHistory, patients[i].allergies, patients[i].medications, patients[i].pastProcedures,
                patients[i].xRayScans, patients[i].bloodSugarLevel, patients[i].heartRate, patients[i].physicalExamination,
                patients[i].doctorsNote, patients[i].treatmentDetails);
        if (result < 0) {
            perror("Error writing to file");
            fclose(file);
            return;
        }
    }

    fclose(file);
}

// Function to add patient diagnosis
void addPatientMedicalInfo(int index) {
    if (index < 0 || index >= patientCount) {
        printf("Patient not found.\n");
        return;
    }

    do {
        printf("Enter x-ray scans (or '-' if none): ");
        if (fgets(patients[index].xRayScans, sizeof(patients[index].xRayScans), stdin)) {
            trimNewline(patients[index].xRayScans);
        } else {
            fprintf(stderr, "Error reading x-ray scans.\n");
            clearInputBuffer();
            return;
        }

        // Check if the input is empty
        if (strlen(patients[index].xRayScans) == 0) {
            printf("Input cannot be empty. Please enter x-ray scans or '-'.\n");
        }
    } while (strlen(patients[index].xRayScans) == 0);

    if (strcmp(patients[index].xRayScans, "-") == 0) {
        strcpy(patients[index].xRayScans, "-");
    }

    printf("Enter blood sugar level (or -1 if not available): ");
    if (scanf("%f", &patients[index].bloodSugarLevel) != 1) {
        fprintf(stderr, "Invalid input for blood sugar level.\n");
        clearInputBuffer();
        return;
    }
    clearInputBuffer(); // Clear input buffer

    if (patients[index].bloodSugarLevel < 0) {
        patients[index].bloodSugarLevel = -1.0f;
    }

    printf("Enter heart rate (or -1 if not available): ");
    if (scanf("%d", &patients[index].heartRate) != 1) {
        fprintf(stderr, "Invalid input for heart rate.\n");
        clearInputBuffer();
        return;
    }
    clearInputBuffer(); // Clear input buffer

    if (patients[index].heartRate < 0) {
        patients[index].heartRate = -1;
    }

    do {
        printf("Enter physical examination (or '-' if none): ");
        if (fgets(patients[index].physicalExamination, sizeof(patients[index].physicalExamination), stdin)) {
            trimNewline(patients[index].physicalExamination);
        } else {
            fprintf(stderr, "Error reading physical examination.\n");
            clearInputBuffer();
            return;
        }

        // Check if the input is empty
        if (strlen(patients[index].physicalExamination) == 0) {
            printf("Input cannot be empty. Please enter physical examination or '-'.\n");
        }
    } while (strlen(patients[index].physicalExamination) == 0);

    if (strcmp(patients[index].physicalExamination, "-") == 0) {
        strcpy(patients[index].physicalExamination, "-");
    }

    savePatientsToEHRFile(); // Save to EHR file automatically after adding medical info
    printf("Medical information updated and saved successfully.\n");
}

// Function to add treatment details to patient
void addTreatmentDetails(int index) {
    if (index < 0 || index >= patientCount) {
        printf("Patient not found.\n");
        return;
    }

    do {
        printf("Enter treatment details (or '-' if none): ");
        if (fgets(patients[index].treatmentDetails, sizeof(patients[index].treatmentDetails), stdin)) {
            trimNewline(patients[index].treatmentDetails);
        } else {
            fprintf(stderr, "Error reading treatment details.\n");
            clearInputBuffer();
            return;
        }

        // Check if the input is empty
        if (strlen(patients[index].treatmentDetails) == 0) {
            printf("Input cannot be empty. Please enter treatment details or '-'.\n");
        }
    } while (strlen(patients[index].treatmentDetails) == 0);

    if (strcmp(patients[index].treatmentDetails, "-") == 0) {
        strcpy(patients[index].treatmentDetails, "-");
    }

    savePatientsToEHRFile(); // Save to EHR file automatically after adding treatment details
    printf("Treatment details updated and saved successfully.\n");
}

// Function to add doctors note for report
void addDoctorsNote(int index) {
    if (index < 0 || index >= patientCount) {
        printf("Patient not found.\n");
        return;
    }

    printf("Enter doctor's note (or '-' if none): ");
    if (fgets(patients[index].doctorsNote, sizeof(patients[index].doctorsNote), stdin)) {
        trimNewline(patients[index].doctorsNote);
        if (strcmp(patients[index].doctorsNote, "-") == 0) {
            strcpy(patients[index].doctorsNote, "-");
        }
    } else {
        fprintf(stderr, "Error reading doctor's note.\n");
        clearInputBuffer();
        return;
    }

    savePatientsToEHRFile(); // Save to EHR file automatically after adding the doctor's note
    printf("Doctor's note updated and saved successfully.\n");
}

// Function to Display patients Electronic Health Records
void patientEHR(int index) {
    if (index >= 0 && index < patientCount) {
        printf("----------------------------------------------------------\n");
        printf("|    Patient %s Electronic Health Report              |\n", patients[index].firstName);
        printf("----------------------------------------------------------\n");
        printf("| Patient ID       : %-35s |\n", patients[index].patientID);
        printf("| First Name       : %-35s |\n", patients[index].firstName);
        printf("| Last Name        : %-35s |\n", patients[index].lastName);
        printf("| Gender           : %-35s |\n", patients[index].gender);
        printf("| ID Number        : %-35s |\n", patients[index].idNumber);
        printf("| State            : %-35s |\n", patients[index].state);
        printf("| Country          : %-35s |\n", patients[index].country);
        printf("| Phone Number     : %-35s |\n", patients[index].phoneNumber);
        printf("| Medical History  : %-35s |\n", patients[index].medicalHistory);
        printf("| Allergies        : %-35s |\n", patients[index].allergies);
        printf("| Medications      : %-35s |\n", patients[index].medications);
        printf("| Past Procedures  : %-35s |\n", patients[index].pastProcedures);
        printf("| X-Ray Scans      : %-35s |\n", patients[index].xRayScans);
        printf("| Blood Sugar Level: %-35.2f |\n", patients[index].bloodSugarLevel);
        printf("| Heart Rate       : %-35d |\n", patients[index].heartRate);
        printf("| Physical Exam    : %-35s |\n", patients[index].physicalExamination);
        printf("----------------------------------------------------------\n");
    } else {
        printf("Patient not found.\n");
    }
}

// Function to Display patients report
void patientreport(int index) {
    if (index >= 0 && index < patientCount) {
        printf("----------------------------------------------------------------------------------------\n");
        printf("|                     Patient %s Electronic Health Report                           |\n", patients[index].firstName);
        printf("----------------------------------------------------------------------------------------\n");
        printf("| Patient ID       : %-65s |\n", patients[index].patientID);
        printf("| First Name       : %-65s |\n", patients[index].firstName);
        printf("| Last Name        : %-65s |\n", patients[index].lastName);
        printf("| Gender           : %-65s |\n", patients[index].gender);
        printf("| ID Number        : %-65s |\n", patients[index].idNumber);
        printf("| State            : %-65s |\n", patients[index].state);
        printf("| Country          : %-65s |\n", patients[index].country);
        printf("| Phone Number     : %-65s |\n", patients[index].phoneNumber);
        printf("| Medical History  : %-65s |\n", patients[index].medicalHistory);
        printf("| Allergies        : %-65s |\n", patients[index].allergies);
        printf("| Medications      : %-65s |\n", patients[index].medications);
        printf("| Past Procedures  : %-65s |\n", patients[index].pastProcedures);
        printf("| X-Ray Scans      : %-65s |\n", patients[index].xRayScans);
        printf("| Blood Sugar Level: %-65.2f |\n", patients[index].bloodSugarLevel);
        printf("| Heart Rate       : %-65d |\n", patients[index].heartRate);
        printf("| Physical Exam    : %-65s |\n", patients[index].physicalExamination);
        printf("| Treatment Details: %-65s |\n", patients[index].treatmentDetails);
        printf("----------------------------------------------------------------------------------------\n");
        doctornotes(index);
    } else {
        printf("Patient not found.\n");
    }
}

// Function to display doctor note in report
void doctornotes(int index) {
    if (index >= 0 && index < patientCount) {
        printf("| Doctor's Note    : %-65s |\n", patients[index].doctorsNote);
        printf("----------------------------------------------------------------------------------------\n");
    } else {
        printf("Patient not found.\n");
    }
}

// Function to analyze treatment trends
void analyzeTreatmentTrends() {
    int totalPatients = patientCount;
    int treatmentsDone = 0;

    // Count treatments for each patient
    for (int i = 0; i < totalPatients; i++) {
        if (strcmp(patients[i].treatmentDetails, "-") != 0) {
            treatmentsDone++;
        }
    }

    // Display the analysis
    printf("\n");
    printf("Total Patients : %d\n", totalPatients);
    printf("Treatments Done: %d\n", treatmentsDone);
    printf("----------------------------------------------------------------------------------\n");
    printf("|                             Treatment Trends Analysis                          |\n");
    printf("----------------------------------------------------------------------------------\n");
    printf("| %-10s | %-65s |\n", "Patient ID", "Treatment Details");
    printf("----------------------------------------------------------------------------------\n");

    for (int i = 0; i < totalPatients; i++) {
        if (strcmp(patients[i].treatmentDetails, "-") != 0) {
            printf("| %-10s | %-65s |\n", patients[i].patientID, patients[i].treatmentDetails);
        }
    }

    printf("----------------------------------------------------------------------------------\n");
}

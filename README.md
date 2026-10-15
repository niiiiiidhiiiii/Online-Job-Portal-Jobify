# Jobify: Web-Based Online Job Portal

> **College Full-Stack Java Project**  
> Built from absolute scratch with **Jakarta EE 10, Jakarta Servlets, JSP & JSTL, JDBC, MySQL / MariaDB, Apache Tomcat 10.1, and JUnit 5**.  
> Features a modern aesthetic matching the **Warm Cream, Latte Beige, Cocoa Brown & Deep Espresso** palette.

---

## 1. Project Overview & Aesthetic Design

**Jobify** (CozyHire) is an online job marketplace that connects job seekers with employers through personalized skill matching, transparent application pipelines, and administrative oversight.

### Visual Design System
Inspired by modern cozy design aesthetics, Jobify moves away from generic corporate blue/gray themes:
- **Warm Cream & Light Surfaces (`#FAF5EF`, `#FFFDF9`)**: Softer on the eyes, highly readable.
- **Latte Beige Hero (`#D8BC9D`)**: Warm, inviting header and banner background.
- **Cocoa Brown (`#7E5B44`, `#583B29`)**: The signature pill search container, interactive elements, and badges.
- **Deep Espresso (`#382315`, `#25160D`)**: Contrast accents, typography, and footer.
- **Status Indicators**: Warm amber for *Pending*, teal for *Shortlisted*, emerald for *Accepted*, and warm coral for *Rejected*.

---

## 2. Technology Stack & Architecture

| Layer | Technology | Details |
|---|---|---|
| **Language & OOP** | Java 17+ (Java 26 compatible) | Clean object-oriented design, strong typing, domain models |
| **Build & Dependencies**| Apache Maven 3.10+ | Standard Maven layout with `mvnw.cmd` wrapper |
| **Web & Controllers** | Jakarta Servlets 6.0 (`@WebServlet`) | Request handling, session management, role routing |
| **Views & Frontend** | Jakarta Server Pages 3.1 & JSTL 3.0 | Clean server-rendered HTML5, responsive Vanilla CSS, zero bloated frameworks |
| **Database & Persistence**| JDBC (MySQL Connector/J 8.3) | `PreparedStatement`, transactional rollback, 3NF schema |
| **Database Server** | MySQL 8.0+ / MariaDB 10.4+ | Normalized tables, constraints, cascading FKs, indexes |
| **Application Server** | Apache Tomcat 10.1 | Standard WAR deployment + Zero-config Embedded Tomcat launcher |
| **Security & Cryptography**| BCrypt (`jbcrypt 0.4`) | Salted password hashing (work factor 12), XSS escaping, role filters |
| **Testing** | JUnit 5 (`junit-jupiter 5.10.2`) | 24 automated unit & logic validation tests |

### MVC Architecture Flow
```
[ Browser / Chrome Client ]
         │  HTTP GET / POST
         ▼
[ CharacterEncodingFilter & AuthFilter ] (Session validation & Role checks)
         │
         ▼
[ Jakarta Servlets / Controllers ]
  ├── HomeServlet (/home, /)
  ├── AuthServlet (/login, /register, /logout)
  ├── JobServlet (/jobs, /job-details)
  ├── CompanyServlet (/companies, /company-details)
  ├── JobSeekerServlet (/seeker/*)
  ├── EmployerServlet (/employer/*)
  └── AdminServlet (/admin/*)
         │
         ├──► [ Service Layer ] (RecommendationService, SecurityService)
         │
         ├──► [ DAO Layer ] (UserDAO, ProfileDAO, JobDAO, ApplicationDAO, StatsDAO)
         │         │
         │         ▼
         │    [ DBConnection (JDBC PreparedStatement) ]
         │         │
         │         ▼
         │    [ MySQL / MariaDB Database: jobify_db ]
         │
         ▼
[ JSP Views with JSTL & CSS Design System ] (WEB-INF/views/)
```

---

## 3. Project Structure

```
jobify/
├── pom.xml                                    # Maven configuration & dependencies
├── mvnw.cmd                                   # Windows Maven wrapper
├── .gitignore                                 # Git ignore (protects passwords and targets)
├── README.md                                  # Complete documentation & college viva guide
├── database/
│   └── schema.sql                             # Normalized schema, constraints & demo seeds
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/jobify/
│   │   │       ├── config/
│   │   │       │   ├── DBConfig.java          # Reads db.properties & environment variables
│   │   │       │   └── DBConnection.java      # JDBC manager, transactions & rollbacks
│   │   │       ├── controller/
│   │   │       │   ├── AdminServlet.java      # Admin dashboard, moderation, audit log
│   │   │       │   ├── AuthServlet.java       # Login, registration & logout
│   │   │       │   ├── CompanyServlet.java    # Company directory & profile viewer
│   │   │       │   ├── EmployerServlet.java   # Job creation, editing, applicant review
│   │   │       │   ├── HomeServlet.java       # Hero search, featured jobs, stats
│   │   │       │   ├── JobSeekerServlet.java  # Seeker dashboard, profile, applications
│   │   │       │   └── JobServlet.java        # Search, filters, pagination, details
│   │   │       ├── dao/
│   │   │       │   ├── ApplicationDAO.java    # Job applications & duplicate prevention
│   │   │       │   ├── JobDAO.java            # Job listings CRUD & search filters
│   │   │       │   ├── ProfileDAO.java        # Seeker & Employer profile storage
│   │   │       │   ├── StatsDAO.java          # Platform metrics & audit logs
│   │   │       │   └── UserDAO.java           # User auth & account management
│   │   │       ├── filter/
│   │   │       │   ├── AuthFilter.java        # Server-side authentication & RBAC
│   │   │       │   └── CharacterEncodingFilter.java # UTF-8 encoding enforcement
│   │   │       ├── launcher/
│   │   │       │   └── EmbeddedTomcatServer.java # 1-Click Embedded Tomcat 10.1 Runner
│   │   │       ├── model/
│   │   │       │   ├── ActivityLog.java       # Admin audit record
│   │   │       │   ├── Application.java       # Job application entity
│   │   │       │   ├── DashboardStats.java    # Metric counters
│   │   │       │   ├── EmployerProfile.java   # Company profile model
│   │   │       │   ├── Job.java               # Job opening model
│   │   │       │   ├── JobSeekerProfile.java  # Seeker candidate profile
│   │   │       │   ├── Role.java              # Enum: JOB_SEEKER, EMPLOYER, ADMIN
│   │   │       │   └── User.java              # Core user account
│   │   │       ├── service/
│   │   │       │   ├── RecommendationService.java # Tokenized AI skill-matching engine
│   │   │       │   └── SecurityService.java   # Session tokens & flash messages
│   │   │       └── util/
│   │   │           ├── PasswordUtil.java      # BCrypt password hashing & salt verification
│   │   │           └── ValidationUtil.java    # XSS sanitization, email & input validation
│   │   ├── resources/
│   │   │   ├── db.properties.example          # Database configuration template
│   │   │   └── db.properties                  # Local database credentials (ignored by git)
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                    # Deployment descriptor & error page mappings
│   │       │   └── views/
│   │       │       ├── admin/                 # Admin dashboard, users, jobs, applications
│   │       │       ├── auth/                  # login.jsp & register.jsp
│   │       │       ├── common/                # header.jsp, footer.jsp, messages.jsp
│   │       │       ├── company/               # company-list.jsp & company-detail.jsp
│   │       │       ├── employer/              # dashboard, profile, jobs, job-form, applicants
│   │       │       ├── error/                 # 403.jsp, 404.jsp, 500.jsp
│   │       │       ├── jobs/                  # job-list.jsp & job-detail.jsp
│   │       │       ├── seeker/                # dashboard, profile, applications, recommendations
│   │       │       └── index.jsp              # Main landing page matching mockup
│   │       ├── assets/
│   │       │   ├── css/style.css              # Custom Vanilla CSS design system
│   │       │   ├── js/main.js                 # Modal dialogs & client-side validation
│   │       │   └── images/logo.svg            # Jobify vector brand logo
│   │       └── index.jsp                      # Root web entry redirecting to /home
│   └── test/
│       └── java/com/jobify/
│           ├── JobModelTest.java              # Salary formatting, skill parsing & Role tests
│           ├── PasswordUtilTest.java          # BCrypt cryptographic hashing tests
│           ├── RecommendationServiceTest.java # Skill matching algorithm & ranking tests
│           └── ValidationUtilTest.java        # Email, password length & XSS sanitization tests
```

---

## 4. Database Setup & Schema

The database schema is stored in [`database/schema.sql`](file:///c:/Users/NIDHI/OneDrive/Desktop/jobify/database/schema.sql).

### Normalized Tables
1. **`users`**: Core credentials, BCrypt password hashes, role (`JOB_SEEKER`, `EMPLOYER`, `ADMIN`), active status flag.
2. **`seeker_profiles`**: Linked 1:1 to `users`, contains name, phone, headline, bio, skills, education, experience, resume link, resume summary.
3. **`employer_profiles`**: Linked 1:1 to `users`, contains company name, contact person, website, location, industry, size, description.
4. **`categories`**: Standardized industry categories.
5. **`jobs`**: Job postings with employer ID, title, category, type, location, salary range, description, requirements, skills required, vacancies, deadline, status (`ACTIVE`/`CLOSED`), approval status (`PENDING`/`APPROVED`/`REJECTED`).
6. **`applications`**: Job applications with job ID, seeker ID, cover letter, resume snapshot, status (`PENDING`, `SHORTLISTED`, `ACCEPTED`, `REJECTED`), employer feedback notes.  
   **Unique Constraint:** `CONSTRAINT unique_job_seeker UNIQUE (job_id, seeker_id)` strictly prevents duplicate applications.
7. **`activity_logs`**: System audit records for admin monitoring.

### How to Import Database Schema
Open MySQL / MariaDB command line or Workbench:
```bash
# If using MySQL / MariaDB CLI:
mysql -u root -p < database/schema.sql
```
Or in **MySQL Workbench**:
1. Open MySQL Workbench and connect to your local MySQL server.
2. Go to **File -> Open SQL Script...** and select `database/schema.sql`.
3. Click the **Execute (lightning bolt)** button to create `jobify_db` and insert initial demo data.

### Database Configuration
Edit [`src/main/resources/db.properties`](file:///c:/Users/NIDHI/OneDrive/Desktop/jobify/src/main/resources/db.properties):
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/jobify_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=your_mysql_password_here
```
*(Environment variables `DB_URL`, `DB_USERNAME`, and `DB_PASSWORD` can also be used)*

---

## 5. Seeded Demo Accounts (All Pre-Hashed with BCrypt)

All test passwords are encrypted using BCrypt work factor 12:

| Role | Email | Password | Description |
|---|---|---|---|
| **Administrator** | `admin@jobify.com` | `Admin@123` | Full administrative control, job approval queue, user controls |
| **Employer 1** | `techcorp@jobify.com` | `Employer@123` | TechCorp Solutions (Has jobs & applications) |
| **Employer 2** | `innovate@jobify.com` | `Employer@123` | Innovate Design Labs (Design agency) |
| **Job Seeker 1**| `alice@jobify.com` | `Seeker@123` | Alice Johnson (Junior Full-Stack Java Dev) |
| **Job Seeker 2**| `bob@jobify.com` | `Seeker@123` | Bob Smith (UI/UX Designer) |

> **College Evaluation Feature:** The login page includes 1-click **"Quick Demo Accounts"** buttons (`Admin`, `Employer`, `Seeker`) to automatically fill credentials for instant viva demonstrations!

---

## 6. How to Run & Deploy the Project

### Option A: One-Command Embedded Tomcat 10.1 (Recommended for Viva)
No separate Tomcat installation required!
```bash
# Run Maven build and start Embedded Tomcat on port 8080:
.\mvnw.cmd compile exec:java
```
Once started, open Google Chrome at:
👉 **`http://localhost:8080/`**

To specify a custom port (e.g. 8081 if port 8080 is occupied):
```bash
.\mvnw.cmd compile exec:java -Dexec.arguments="8081"
```

### Option B: Standalone Apache Tomcat 10.1 Deployment
1. Build the WAR archive:
   ```bash
   .\mvnw.cmd clean package -DskipTests
   ```
2. Copy the generated WAR file:
   `target/jobify.war` -> `C:\path\to\apache-tomcat-10.1.x\webapps\`
3. Start Tomcat via `bin\startup.bat`.
4. Open Google Chrome at:
   👉 **`http://localhost:8080/jobify/`**

### Option C: Eclipse / IntelliJ IDEA / VS Code
- **Eclipse:** Import as *Existing Maven Project*, right-click project -> *Run As* -> *Run on Server* (Tomcat 10.1).
- **IntelliJ IDEA:** Open project folder, add a Run Configuration for *Tomcat Server (Local)*, deploy artifact `jobify:war exploded`.
- **VS Code:** Open folder, use the *Community Server Connectors* or *Smart Tomcat* extension pointing to `src/main/webapp`.

---

## 7. Automated Tests Verification

Run all unit and validation tests anytime:
```bash
.\mvnw.cmd test
```
**Test Results:**
- `JobModelTest`: Salary formatting, range calculations, skill parsing.
- `PasswordUtilTest`: BCrypt cryptographic hashing and salted verification.
- `RecommendationServiceTest`: Skill matching algorithm, alias normalization, candidate ranking.
- `ValidationUtilTest`: Email regex validation, password length checks, XSS HTML escaping, safe numeric and date parsing.
- **24 Tests Run, 0 Failures, 0 Errors, BUILD SUCCESS.**

---

## 8. Viva Voce & College Rubric Guide

### 1. Core Java & OOP
- **Encapsulation:** All models (`User`, `Job`, `Application`, `JobSeekerProfile`, `EmployerProfile`) encapsulate data with private fields and clean getters/setters.
- **Enums:** `Role` enum provides type-safe role definitions (`JOB_SEEKER`, `EMPLOYER`, `ADMIN`) preventing invalid string errors.
- **Collections & Streams:** `RecommendationService` uses Java Streams and Sets for tokenized skill normalization and calculation.

### 2. JDBC & Database Integration
- **`PreparedStatement`:** All database queries utilize parameterized SQL statements to safeguard against SQL Injection attacks.
- **Resource Management:** `try-with-resources` statements ensure `Connection`, `PreparedStatement`, and `ResultSet` objects are safely closed to prevent connection pool starvation.
- **Integrity Constraints:** Database enforces referential integrity (`ON DELETE CASCADE`) and unique indexes (`unique_job_seeker`) to guarantee data correctness at the database level.

### 3. Servlets & Web Architecture
- **Jakarta Servlets 6.0:** `@WebServlet` annotations route HTTP requests cleanly according to RESTful path semantics.
- **Filters:** `AuthFilter` intercepts protected paths (`/seeker/*`, `/employer/*`, `/admin/*`), enforcing authentication and role-based access before execution reaches the controllers.
- **`CharacterEncodingFilter`:** Enforces UTF-8 encoding across all HTTP requests and responses.

### 4. Innovation: Skill-Matching Algorithm
Instead of simple keyword queries, `RecommendationService` performs tokenized skill normalization:
1. Splits applicant and job skills on commas, slashes, and semicolons.
2. Converts to lowercase and resolves common aliases (`js` $\rightarrow$ `javascript`, `reactjs` $\rightarrow$ `react`, `postgres` $\rightarrow$ `postgresql`).
3. Calculates an overlap score:
   $$\text{Match Score} = \left(\frac{\text{Matched Skills Count}}{\text{Total Required Skills Count}}\right) \times 100$$
4. Attaches personalized percentage badges to job cards for each logged-in candidate.

---

## 9. Next Steps for Evaluator
1. Import `database/schema.sql` into your local MySQL / MariaDB instance.
2. Verify credentials in `src/main/resources/db.properties`.
3. Launch via `.\mvnw.cmd compile exec:java`.
4. Open `http://localhost:8080/` in Chrome and test the demo accounts.

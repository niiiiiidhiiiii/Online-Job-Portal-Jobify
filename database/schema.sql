-- ====================================================================
-- CozyHire / Jobify Database Schema
-- College Project: Web-Based Online Job Portal
-- Target Database: MySQL 8.0+ / MariaDB 10.4+
-- Charset: UTF-8 (utf8mb4)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS jobify_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jobify_db;

-- --------------------------------------------------------------------
-- 1. Drop existing tables in reverse dependency order
-- --------------------------------------------------------------------
DROP TABLE IF EXISTS activity_logs;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS seeker_profiles;
DROP TABLE IF EXISTS employer_profiles;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- --------------------------------------------------------------------
-- 2. Users Table (Core Authentication & Authorization)
-- --------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('JOB_SEEKER', 'EMPLOYER', 'ADMIN') NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_role (role),
    INDEX idx_user_status (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 3. Job Seeker Profiles Table
-- --------------------------------------------------------------------
CREATE TABLE seeker_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    headline VARCHAR(200),
    location VARCHAR(150),
    bio TEXT,
    skills TEXT, -- Comma-separated list: "Java, Spring, MySQL, React"
    education TEXT,
    experience TEXT,
    resume_url VARCHAR(500),
    resume_summary TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_seeker_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 4. Employer Profiles Table
-- --------------------------------------------------------------------
CREATE TABLE employer_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(30),
    website VARCHAR(255),
    location VARCHAR(150),
    industry VARCHAR(100),
    company_size VARCHAR(50), -- e.g., '1-10', '11-50', '51-200', '500+'
    description TEXT,
    logo_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_employer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 5. Categories Table
-- --------------------------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    icon_class VARCHAR(50) DEFAULT 'bi-briefcase',
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 6. Jobs Table
-- --------------------------------------------------------------------
CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employer_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    job_type VARCHAR(50) NOT NULL, -- 'Full-Time', 'Part-Time', 'Remote', 'Internship', 'Contract'
    location VARCHAR(150) NOT NULL,
    salary_min DECIMAL(12, 2) DEFAULT 0,
    salary_max DECIMAL(12, 2) DEFAULT 0,
    description TEXT NOT NULL,
    requirements TEXT NOT NULL,
    skills_required TEXT NOT NULL, -- Comma-separated: "Java, MySQL, REST API"
    vacancies INT NOT NULL DEFAULT 1,
    deadline DATE,
    status ENUM('ACTIVE', 'CLOSED') NOT NULL DEFAULT 'ACTIVE',
    approval_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'APPROVED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_job_employer FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_job_status (status),
    INDEX idx_job_approval (approval_status),
    INDEX idx_job_type (job_type),
    INDEX idx_job_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 7. Applications Table (with unique constraint to prevent duplicate applications)
-- --------------------------------------------------------------------
CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    seeker_id INT NOT NULL,
    cover_letter TEXT,
    resume_summary TEXT,
    status ENUM('PENDING', 'SHORTLISTED', 'REJECTED', 'ACCEPTED') NOT NULL DEFAULT 'PENDING',
    employer_notes TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_app_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_app_seeker FOREIGN KEY (seeker_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT unique_job_seeker UNIQUE (job_id, seeker_id),
    INDEX idx_app_status (status),
    INDEX idx_app_seeker (seeker_id),
    INDEX idx_app_job (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- 8. Activity Logs Table (Admin activity monitoring)
-- --------------------------------------------------------------------
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_activity_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_activity_time (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- DEMO DATA SEEDING (All passwords hashed with BCrypt)
--
-- Account Credentials:
-- Admin:        admin@jobify.com     / Admin@123
-- Employer 1:   techcorp@jobify.com  / Employer@123
-- Employer 2:   innovate@jobify.com  / Employer@123
-- Seeker 1:     alice@jobify.com     / Seeker@123
-- Seeker 2:     bob@jobify.com       / Seeker@123
-- ====================================================================

-- Insert Default Categories
INSERT INTO categories (name, icon_class, description) VALUES
('Software & Technology', 'code-slash', 'Software engineering, web, cloud & DevOps roles'),
('Design & Creative', 'palette', 'UI/UX design, visual design and product styling'),
('Marketing & Growth', 'megaphone', 'Digital marketing, brand growth and SEO'),
('Finance & Banking', 'cash-coin', 'Financial analysis, accounting and wealth management'),
('Customer Support', 'headset', 'Customer success, support and client management'),
('Product Management', 'kanban', 'Product vision, sprint delivery and feature strategy');

-- Insert Users
-- Password hashes generated via BCrypt (work factor 12):
-- Admin@123:    $2a$12$r9Ol2WogG.Bltks/LNmO5.DHUwk1/vechbncyibm/mSH83c6epP22
-- Employer@123: $2a$12$NnOnIrQsw6PxTRYqe55.u.BlaRejF89/.XkLX6mC214D7oha1sJre
-- Seeker@123:   $2a$12$frWgX4/cYShvWGCCEGarkeO7y9zasIRH02D/5Au0pgZRo8ODT.FG6

INSERT INTO users (id, email, password_hash, role, is_active) VALUES
(1, 'admin@jobify.com', '$2a$12$r9Ol2WogG.Bltks/LNmO5.DHUwk1/vechbncyibm/mSH83c6epP22', 'ADMIN', TRUE),
(2, 'techcorp@jobify.com', '$2a$12$NnOnIrQsw6PxTRYqe55.u.BlaRejF89/.XkLX6mC214D7oha1sJre', 'EMPLOYER', TRUE),
(3, 'innovate@jobify.com', '$2a$12$NnOnIrQsw6PxTRYqe55.u.BlaRejF89/.XkLX6mC214D7oha1sJre', 'EMPLOYER', TRUE),
(4, 'alice@jobify.com', '$2a$12$frWgX4/cYShvWGCCEGarkeO7y9zasIRH02D/5Au0pgZRo8ODT.FG6', 'JOB_SEEKER', TRUE),
(5, 'bob@jobify.com', '$2a$12$frWgX4/cYShvWGCCEGarkeO7y9zasIRH02D/5Au0pgZRo8ODT.FG6', 'JOB_SEEKER', TRUE);

-- Insert Employer Profiles
INSERT INTO employer_profiles (user_id, company_name, contact_person, phone, website, location, industry, company_size, description, logo_url) VALUES
(2, 'TechCorp Solutions', 'Marcus Vance', '+1 (555) 234-5678', 'https://techcorp.example.com', 'San Francisco, CA', 'Software & Cloud', '51-200', 'TechCorp Solutions builds enterprise cloud platforms, developer tools, and scalable web solutions for global enterprises.', 'techcorp.svg'),
(3, 'Innovate Design Labs', 'Elena Rostova', '+1 (555) 876-5432', 'https://innovatelabs.example.com', 'New York, NY', 'Design & UI/UX', '11-50', 'Innovate Design Labs crafts human-centric digital interfaces, brand identities, and modern web applications with cozy aesthetics.', 'innovate.svg');

-- Insert Job Seeker Profiles
INSERT INTO seeker_profiles (user_id, full_name, phone, headline, location, bio, skills, education, experience, resume_url, resume_summary) VALUES
(4, 'Alice Johnson', '+1 (555) 345-6789', 'Junior Full-Stack Java Developer', 'Boston, MA', 'Passionate computer science graduate with solid foundational experience in Java, Jakarta EE, SQL, Spring Boot, and responsive web interfaces.', 'Java, Jakarta Servlets, JSP, MySQL, JDBC, HTML, CSS, JavaScript, Git', 'B.S. in Computer Science, Boston University (2025)', 'Software Engineering Intern at CodeCraft (6 months). Developed REST APIs and database connectors.', 'https://github.com/alicejohnson', 'Enthusiastic Java & Web Developer seeking full-time junior software engineer positions. Proficient in relational databases, MVC patterns, and clean code principles.'),
(5, 'Bob Smith', '+1 (555) 987-6543', 'Product Designer & UI/UX Specialist', 'Austin, TX', 'UI/UX designer focused on warm, accessible, and delightful digital user journeys with Figma, CSS design tokens, and modern typography.', 'UI/UX Design, Figma, CSS, HTML, Design Systems, Wireframing, Prototyping', 'B.A. in Digital Arts & Design, UT Austin (2024)', 'UI Design Freelancer (1.5 years). Redesigned landing pages for fintech and e-commerce startups.', 'https://dribbble.com/bobsmith', 'Creative UI/UX designer specialized in modern aesthetic interfaces with high usability, color theory, and micro-interactions.');

-- Insert Jobs
INSERT INTO jobs (id, employer_id, title, category, job_type, location, salary_min, salary_max, description, requirements, skills_required, vacancies, deadline, status, approval_status) VALUES
(1, 2, 'Junior Java Backend Developer', 'Software & Technology', 'Full-Time', 'San Francisco, CA (Hybrid)', 75000.00, 95000.00, 
'We are looking for a motivated Junior Java Backend Developer to join our Cloud Services team. You will build and optimize server-side components, collaborate with frontend engineers, and participate in database architecture design.',
'Bachelor’s degree in Computer Science or related field. Good understanding of OOP, JDBC, MVC architecture, SQL, and Git.',
'Java, JDBC, MySQL, Jakarta Servlets, Git, REST API',
2, '2026-11-30', 'ACTIVE', 'APPROVED'),

(2, 2, 'Senior Full-Stack Engineer', 'Software & Technology', 'Remote', 120000.00, 150000.00,
'Lead our core web portal engineering initiatives. Design distributed services, write performant database queries, and mentor junior engineers.',
'4+ years experience with Java, microservices, relational databases, and modern web frontends.',
'Java, Spring Boot, MySQL, JavaScript, Docker, AWS',
1, '2026-12-15', 'ACTIVE', 'APPROVED'),

(3, 3, 'UI/UX Visual Designer', 'Design & Creative', 'Full-Time', 'New York, NY', 70000.00, 90000.00,
'Join our boutique design agency to craft warm, cozy, and intuitive web experiences. You will design responsive page templates, design systems, and collaborate with frontend developers.',
'Strong portfolio demonstrating UI/UX case studies, design systems, wireframing, and Figma proficiency.',
'UI/UX Design, Figma, CSS, HTML, Design Systems, Prototyping',
2, '2026-11-20', 'ACTIVE', 'APPROVED'),

(4, 3, 'Frontend Developer (CSS / Vanilla JS)', 'Design & Creative', 'Remote', 65000.00, 85000.00,
'Looking for a frontend specialist who values clean Vanilla CSS, responsive layouts, accessibility, and smooth micro-interactions without bloated frameworks.',
'2+ years in responsive web design, semantic HTML5, modern CSS variables, and clean JavaScript.',
'HTML, CSS, JavaScript, Responsive Design, Web Accessibility',
1, '2026-12-05', 'ACTIVE', 'APPROVED'),

(5, 2, 'Database Administrator Intern', 'Software & Technology', 'Internship', 'San Francisco, CA', 35000.00, 45000.00,
'Exciting 6-month paid internship for aspiring database engineers. Learn database normalization, indexing, query optimization, and transaction safety in production.',
'Currently enrolled in or recently graduated with CS or IT degree. Solid knowledge of SQL queries, indexing, and relational database schemas.',
'MySQL, SQL, Database Normalization, Performance Tuning',
3, '2026-11-15', 'ACTIVE', 'APPROVED');

-- Insert Applications (Demonstrating different statuses and candidate tracking)
INSERT INTO applications (job_id, seeker_id, cover_letter, resume_summary, status, employer_notes) VALUES
(1, 4, 'Dear TechCorp Hiring Team,\n\nI am thrilled to apply for the Junior Java Backend Developer position. During my studies and internship, I gained hands-on experience building MVC applications using Jakarta Servlets, JDBC, and MySQL. I would love the opportunity to contribute to your cloud services team.\n\nBest regards,\nAlice Johnson',
'B.S. Computer Science. Skilled in Java, JDBC, MySQL, Jakarta Servlets, and Git.', 'SHORTLISTED', 'Strong academic background and clean sample code. Schedule technical interview.'),

(3, 5, 'Dear Innovate Design Labs,\n\nI love your focus on warm, human-centered digital experiences. With my design system background in Figma and CSS tokens, I can help your team deliver visually stunning web portals that users cherish.\n\nSincerely,\nBob Smith',
'B.A. Digital Arts. Portfolio with high-fidelity prototypes and warm aesthetic palettes.', 'ACCEPTED', 'Superb portfolio that matches our cozy visual guidelines perfectly. Offer extended and accepted!'),

(4, 4, 'Hello, I also have strong foundational skills in Vanilla CSS, HTML5 semantic layout, and modern JavaScript to build accessible and fast web applications.',
'B.S. Computer Science graduate with full-stack skills.', 'PENDING', 'Under initial review by tech lead.');

-- Insert Activity Logs (For Admin monitoring)
INSERT INTO activity_logs (user_id, action, details) VALUES
(1, 'SYSTEM_STARTUP', 'Jobify portal initialized with default categories and demo accounts.'),
(2, 'JOB_POSTED', 'TechCorp Solutions posted job listing #1: Junior Java Backend Developer.'),
(3, 'JOB_POSTED', 'Innovate Design Labs posted job listing #3: UI/UX Visual Designer.'),
(4, 'APPLICATION_SUBMITTED', 'Alice Johnson applied for job #1 (Junior Java Backend Developer).'),
(2, 'APPLICATION_STATUS_UPDATED', 'TechCorp Solutions marked Alice Johnson application as SHORTLISTED.'),
(5, 'APPLICATION_SUBMITTED', 'Bob Smith applied for job #3 (UI/UX Visual Designer).'),
(3, 'APPLICATION_STATUS_UPDATED', 'Innovate Design Labs accepted application from Bob Smith.');

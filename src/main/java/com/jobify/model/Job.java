package com.jobify.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

/**
 * Represents a job opening posted by an employer.
 */
public class Job implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int employerId;
    private String title;
    private String category;
    private String jobType; // Full-Time, Part-Time, Remote, Internship, Contract
    private String location;
    private BigDecimal salaryMin;
    private BigDecimal salaryMax;
    private String description;
    private String requirements;
    private String skillsRequired; // Comma-separated: "Java, MySQL, Spring"
    private int vacancies;
    private Date deadline;
    private String status; // ACTIVE, CLOSED
    private String approvalStatus; // PENDING, APPROVED, REJECTED
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined fields from employer profile
    private String companyName;
    private String companyWebsite;
    private String companyLocation;
    private String companyLogo;

    // Transient application stats and recommendation calculation
    private int applicationCount;
    private boolean userHasApplied;
    private int matchScore; // Skill match percentage (0 - 100)

    public Job() {
        this.status = "ACTIVE";
        this.approvalStatus = "APPROVED";
        this.vacancies = 1;
        this.salaryMin = BigDecimal.ZERO;
        this.salaryMax = BigDecimal.ZERO;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployerId() {
        return employerId;
    }

    public void setEmployerId(int employerId) {
        this.employerId = employerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public BigDecimal getSalaryMin() {
        return salaryMin != null ? salaryMin : BigDecimal.ZERO;
    }

    public void setSalaryMin(BigDecimal salaryMin) {
        this.salaryMin = salaryMin;
    }

    public BigDecimal getSalaryMax() {
        return salaryMax != null ? salaryMax : BigDecimal.ZERO;
    }

    public void setSalaryMax(BigDecimal salaryMax) {
        this.salaryMax = salaryMax;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getSkillsRequired() {
        return skillsRequired;
    }

    public void setSkillsRequired(String skillsRequired) {
        this.skillsRequired = skillsRequired;
    }

    public int getVacancies() {
        return vacancies;
    }

    public void setVacancies(int vacancies) {
        this.vacancies = vacancies;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCompanyName() {
        return companyName != null ? companyName : "Company #" + employerId;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyWebsite() {
        return companyWebsite;
    }

    public void setCompanyWebsite(String companyWebsite) {
        this.companyWebsite = companyWebsite;
    }

    public String getCompanyLocation() {
        return companyLocation;
    }

    public void setCompanyLocation(String companyLocation) {
        this.companyLocation = companyLocation;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public int getApplicationCount() {
        return applicationCount;
    }

    public void setApplicationCount(int applicationCount) {
        this.applicationCount = applicationCount;
    }

    public boolean isUserHasApplied() {
        return userHasApplied;
    }

    public void setUserHasApplied(boolean userHasApplied) {
        this.userHasApplied = userHasApplied;
    }

    public int getMatchScore() {
        return matchScore;
    }

    public void setMatchScore(int matchScore) {
        this.matchScore = matchScore;
    }

    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    public boolean isApproved() {
        return "APPROVED".equalsIgnoreCase(approvalStatus);
    }

    public List<String> getSkillList() {
        if (skillsRequired == null || skillsRequired.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.stream(skillsRequired.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());
    }

    public String getFormattedSalary() {
        NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.US);
        nf.setMaximumFractionDigits(0);
        if (salaryMin == null || salaryMin.compareTo(BigDecimal.ZERO) <= 0) {
            if (salaryMax == null || salaryMax.compareTo(BigDecimal.ZERO) <= 0) {
                return "Competitive";
            }
            return "Up to " + nf.format(salaryMax);
        }
        if (salaryMax == null || salaryMax.compareTo(BigDecimal.ZERO) <= 0 || salaryMax.compareTo(salaryMin) == 0) {
            return nf.format(salaryMin) + " / yr";
        }
        return nf.format(salaryMin) + " - " + nf.format(salaryMax) + " / yr";
    }
}

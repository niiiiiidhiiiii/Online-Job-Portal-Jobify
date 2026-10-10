package com.jobify.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Represents a job application submitted by a job seeker for a specific job.
 */
public class Application implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int jobId;
    private int seekerId;
    private String coverLetter;
    private String resumeSummary;
    private String status; // PENDING, SHORTLISTED, REJECTED, ACCEPTED
    private String employerNotes;
    private Timestamp appliedAt;
    private Timestamp updatedAt;

    // Joined Job Details
    private String jobTitle;
    private String jobCategory;
    private String jobType;
    private String jobLocation;
    private String companyName;

    // Joined Seeker Profile Details
    private String seekerName;
    private String seekerEmail;
    private String seekerPhone;
    private String seekerHeadline;
    private String seekerLocation;
    private String seekerSkills;
    private String seekerEducation;
    private String seekerExperience;
    private String seekerResumeUrl;

    public Application() {
        this.status = "PENDING";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getSeekerId() {
        return seekerId;
    }

    public void setSeekerId(int seekerId) {
        this.seekerId = seekerId;
    }

    public String getCoverLetter() {
        return coverLetter;
    }

    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }

    public String getResumeSummary() {
        return resumeSummary;
    }

    public void setResumeSummary(String resumeSummary) {
        this.resumeSummary = resumeSummary;
    }

    public String getStatus() {
        return status != null ? status : "PENDING";
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEmployerNotes() {
        return employerNotes;
    }

    public void setEmployerNotes(String employerNotes) {
        this.employerNotes = employerNotes;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(Timestamp appliedAt) {
        this.appliedAt = appliedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobCategory() {
        return jobCategory;
    }

    public void setJobCategory(String jobCategory) {
        this.jobCategory = jobCategory;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getSeekerName() {
        return seekerName;
    }

    public void setSeekerName(String seekerName) {
        this.seekerName = seekerName;
    }

    public String getSeekerEmail() {
        return seekerEmail;
    }

    public void setSeekerEmail(String seekerEmail) {
        this.seekerEmail = seekerEmail;
    }

    public String getSeekerPhone() {
        return seekerPhone;
    }

    public void setSeekerPhone(String seekerPhone) {
        this.seekerPhone = seekerPhone;
    }

    public String getSeekerHeadline() {
        return seekerHeadline;
    }

    public void setSeekerHeadline(String seekerHeadline) {
        this.seekerHeadline = seekerHeadline;
    }

    public String getSeekerLocation() {
        return seekerLocation;
    }

    public void setSeekerLocation(String seekerLocation) {
        this.seekerLocation = seekerLocation;
    }

    public String getSeekerSkills() {
        return seekerSkills;
    }

    public void setSeekerSkills(String seekerSkills) {
        this.seekerSkills = seekerSkills;
    }

    public String getSeekerEducation() {
        return seekerEducation;
    }

    public void setSeekerEducation(String seekerEducation) {
        this.seekerEducation = seekerEducation;
    }

    public String getSeekerExperience() {
        return seekerExperience;
    }

    public void setSeekerExperience(String seekerExperience) {
        this.seekerExperience = seekerExperience;
    }

    public String getSeekerResumeUrl() {
        return seekerResumeUrl;
    }

    public void setSeekerResumeUrl(String seekerResumeUrl) {
        this.seekerResumeUrl = seekerResumeUrl;
    }

    public String getBadgeClass() {
        if ("SHORTLISTED".equalsIgnoreCase(status)) return "badge-shortlisted";
        if ("ACCEPTED".equalsIgnoreCase(status)) return "badge-accepted";
        if ("REJECTED".equalsIgnoreCase(status)) return "badge-rejected";
        return "badge-pending";
    }
}

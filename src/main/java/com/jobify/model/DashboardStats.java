package com.jobify.model;

import java.io.Serializable;

/**
 * Encapsulates aggregated statistics for Admin and Employer dashboards.
 */
public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    // Platform-wide counts (Admin)
    private int totalUsers;
    private int totalJobSeekers;
    private int totalEmployers;
    private int totalAdmins;
    private int totalJobs;
    private int activeJobs;
    private int pendingApprovalJobs;
    private int totalApplications;

    // Employer-specific counts
    private int employerTotalJobs;
    private int employerActiveJobs;
    private int employerClosedJobs;
    private int employerTotalApplications;
    private int employerPendingApplications;
    private int employerShortlistedApplications;
    private int employerAcceptedApplications;
    private int employerRejectedApplications;

    // Seeker-specific counts
    private int seekerTotalApplications;
    private int seekerPendingApplications;
    private int seekerShortlistedApplications;
    private int seekerAcceptedApplications;
    private int seekerRejectedApplications;

    public DashboardStats() {
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalJobSeekers() {
        return totalJobSeekers;
    }

    public void setTotalJobSeekers(int totalJobSeekers) {
        this.totalJobSeekers = totalJobSeekers;
    }

    public int getTotalEmployers() {
        return totalEmployers;
    }

    public void setTotalEmployers(int totalEmployers) {
        this.totalEmployers = totalEmployers;
    }

    public int getTotalAdmins() {
        return totalAdmins;
    }

    public void setTotalAdmins(int totalAdmins) {
        this.totalAdmins = totalAdmins;
    }

    public int getTotalJobs() {
        return totalJobs;
    }

    public void setTotalJobs(int totalJobs) {
        this.totalJobs = totalJobs;
    }

    public int getActiveJobs() {
        return activeJobs;
    }

    public void setActiveJobs(int activeJobs) {
        this.activeJobs = activeJobs;
    }

    public int getPendingApprovalJobs() {
        return pendingApprovalJobs;
    }

    public void setPendingApprovalJobs(int pendingApprovalJobs) {
        this.pendingApprovalJobs = pendingApprovalJobs;
    }

    public int getTotalApplications() {
        return totalApplications;
    }

    public void setTotalApplications(int totalApplications) {
        this.totalApplications = totalApplications;
    }

    public int getEmployerTotalJobs() {
        return employerTotalJobs;
    }

    public void setEmployerTotalJobs(int employerTotalJobs) {
        this.employerTotalJobs = employerTotalJobs;
    }

    public int getEmployerActiveJobs() {
        return employerActiveJobs;
    }

    public void setEmployerActiveJobs(int employerActiveJobs) {
        this.employerActiveJobs = employerActiveJobs;
    }

    public int getEmployerClosedJobs() {
        return employerClosedJobs;
    }

    public void setEmployerClosedJobs(int employerClosedJobs) {
        this.employerClosedJobs = employerClosedJobs;
    }

    public int getEmployerTotalApplications() {
        return employerTotalApplications;
    }

    public void setEmployerTotalApplications(int employerTotalApplications) {
        this.employerTotalApplications = employerTotalApplications;
    }

    public int getEmployerPendingApplications() {
        return employerPendingApplications;
    }

    public void setEmployerPendingApplications(int employerPendingApplications) {
        this.employerPendingApplications = employerPendingApplications;
    }

    public int getEmployerShortlistedApplications() {
        return employerShortlistedApplications;
    }

    public void setEmployerShortlistedApplications(int employerShortlistedApplications) {
        this.employerShortlistedApplications = employerShortlistedApplications;
    }

    public int getEmployerAcceptedApplications() {
        return employerAcceptedApplications;
    }

    public void setEmployerAcceptedApplications(int employerAcceptedApplications) {
        this.employerAcceptedApplications = employerAcceptedApplications;
    }

    public int getEmployerRejectedApplications() {
        return employerRejectedApplications;
    }

    public void setEmployerRejectedApplications(int employerRejectedApplications) {
        this.employerRejectedApplications = employerRejectedApplications;
    }

    public int getSeekerTotalApplications() {
        return seekerTotalApplications;
    }

    public void setSeekerTotalApplications(int seekerTotalApplications) {
        this.seekerTotalApplications = seekerTotalApplications;
    }

    public int getSeekerPendingApplications() {
        return seekerPendingApplications;
    }

    public void setSeekerPendingApplications(int seekerPendingApplications) {
        this.seekerPendingApplications = seekerPendingApplications;
    }

    public int getSeekerShortlistedApplications() {
        return seekerShortlistedApplications;
    }

    public void setSeekerShortlistedApplications(int seekerShortlistedApplications) {
        this.seekerShortlistedApplications = seekerShortlistedApplications;
    }

    public int getSeekerAcceptedApplications() {
        return seekerAcceptedApplications;
    }

    public void setSeekerAcceptedApplications(int seekerAcceptedApplications) {
        this.seekerAcceptedApplications = seekerAcceptedApplications;
    }

    public int getSeekerRejectedApplications() {
        return seekerRejectedApplications;
    }

    public void setSeekerRejectedApplications(int seekerRejectedApplications) {
        this.seekerRejectedApplications = seekerRejectedApplications;
    }
}

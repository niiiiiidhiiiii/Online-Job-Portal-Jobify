package com.jobify.controller;

import com.jobify.dao.ApplicationDAO;
import com.jobify.dao.JobDAO;
import com.jobify.dao.ProfileDAO;
import com.jobify.dao.StatsDAO;
import com.jobify.model.Application;
import com.jobify.model.DashboardStats;
import com.jobify.model.EmployerProfile;
import com.jobify.model.Job;
import com.jobify.model.User;
import com.jobify.service.SecurityService;
import com.jobify.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

/**
 * Controller for Employer operations: Dashboard, Profile, Job Management, and Applicant Review.
 */
@WebServlet(name = "EmployerServlet", urlPatterns = {
        "/employer/dashboard",
        "/employer/profile",
        "/employer/jobs",
        "/employer/jobs/create",
        "/employer/jobs/edit",
        "/employer/jobs/delete",
        "/employer/jobs/status",
        "/employer/applications",
        "/employer/application/status"
})
public class EmployerServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User user = SecurityService.getCurrentUser(request);

        switch (path) {
            case "/employer/dashboard":
                showDashboard(request, response, user);
                break;
            case "/employer/profile":
                showProfile(request, response, user);
                break;
            case "/employer/jobs":
                showJobs(request, response, user);
                break;
            case "/employer/jobs/create":
                showJobForm(request, response, user, null);
                break;
            case "/employer/jobs/edit":
                handleEditJobGet(request, response, user);
                break;
            case "/employer/applications":
                showApplications(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User user = SecurityService.getCurrentUser(request);

        switch (path) {
            case "/employer/profile":
                updateProfile(request, response, user);
                break;
            case "/employer/jobs/create":
                createJob(request, response, user);
                break;
            case "/employer/jobs/edit":
                updateJob(request, response, user);
                break;
            case "/employer/jobs/delete":
                deleteJob(request, response, user);
                break;
            case "/employer/jobs/status":
                toggleJobStatus(request, response, user);
                break;
            case "/employer/application/status":
                updateApplicationStatus(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/employer/dashboard");
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        EmployerProfile profile = profileDAO.getEmployerProfile(user.getId());
        DashboardStats stats = statsDAO.getEmployerStats(user.getId());
        List<Job> myJobs = jobDAO.getByEmployerId(user.getId());
        List<Application> recentApplicants = applicationDAO.getByEmployerId(user.getId(), null);
        if (recentApplicants.size() > 5) {
            recentApplicants = recentApplicants.subList(0, 5);
        }

        request.setAttribute("profile", profile);
        request.setAttribute("stats", stats);
        request.setAttribute("myJobs", myJobs);
        request.setAttribute("recentApplicants", recentApplicants);

        request.getRequestDispatcher("/WEB-INF/views/employer/dashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        EmployerProfile profile = profileDAO.getEmployerProfile(user.getId());
        if (profile == null) {
            profile = new EmployerProfile();
            profile.setUserId(user.getId());
            profile.setCompanyName(user.getDisplayName());
        }

        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/WEB-INF/views/employer/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String companyName = request.getParameter("companyName");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String location = request.getParameter("location");
        String industry = request.getParameter("industry");
        String companySize = request.getParameter("companySize");
        String description = request.getParameter("description");
        String logoUrl = request.getParameter("logoUrl");

        if (!ValidationUtil.isNotEmpty(companyName)) {
            SecurityService.setErrorMessage(request, "Company Name cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/employer/profile");
            return;
        }

        EmployerProfile profile = new EmployerProfile();
        profile.setUserId(user.getId());
        profile.setCompanyName(companyName.trim());
        profile.setContactPerson(contactPerson != null ? contactPerson.trim() : "");
        profile.setPhone(phone != null ? phone.trim() : "");
        profile.setWebsite(website != null ? website.trim() : "");
        profile.setLocation(location != null ? location.trim() : "");
        profile.setIndustry(industry != null ? industry.trim() : "");
        profile.setCompanySize(companySize != null ? companySize.trim() : "");
        profile.setDescription(description != null ? description.trim() : "");
        profile.setLogoUrl(logoUrl != null ? logoUrl.trim() : "");

        boolean success = profileDAO.saveOrUpdateEmployerProfile(profile);

        if (success) {
            user.setDisplayName(companyName.trim());
            SecurityService.setSuccessMessage(request, "Company profile updated successfully!");
        } else {
            SecurityService.setErrorMessage(request, "Failed to update company profile.");
        }

        response.sendRedirect(request.getContextPath() + "/employer/profile");
    }

    private void showJobs(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        List<Job> jobs = jobDAO.getByEmployerId(user.getId());
        DashboardStats stats = statsDAO.getEmployerStats(user.getId());

        request.setAttribute("jobs", jobs);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/employer/jobs.jsp").forward(request, response);
    }

    private void showJobForm(HttpServletRequest request, HttpServletResponse response, User user, Job existingJob)
            throws ServletException, IOException {

        List<String> categories = jobDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.setAttribute("job", existingJob != null ? existingJob : new Job());
        request.setAttribute("isEdit", existingJob != null);

        request.getRequestDispatcher("/WEB-INF/views/employer/job-form.jsp").forward(request, response);
    }

    private void handleEditJobGet(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int jobId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        Job job = jobDAO.getById(jobId);

        // Security check: verify this job belongs to the logged-in employer
        if (job == null || job.getEmployerId() != user.getId()) {
            SecurityService.setErrorMessage(request, "You are not authorized to edit this job posting.");
            response.sendRedirect(request.getContextPath() + "/employer/jobs");
            return;
        }

        showJobForm(request, response, user, job);
    }

    private void createJob(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        Job job = extractJobFromRequest(request);
        job.setEmployerId(user.getId());

        if (!validateJob(job, request)) {
            showJobForm(request, response, user, job);
            return;
        }

        int jobId = jobDAO.create(job);
        if (jobId > 0) {
            statsDAO.logActivity(user.getId(), "JOB_CREATED", "Employer posted job #" + jobId + " (" + job.getTitle() + ")");
            SecurityService.setSuccessMessage(request, "Job listing created successfully!");
            response.sendRedirect(request.getContextPath() + "/employer/jobs");
        } else {
            SecurityService.setErrorMessage(request, "Failed to create job posting. Please try again.");
            showJobForm(request, response, user, job);
        }
    }

    private void updateJob(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int jobId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        Job existing = jobDAO.getById(jobId);

        // Security check
        if (existing == null || existing.getEmployerId() != user.getId()) {
            SecurityService.setErrorMessage(request, "Unauthorized action.");
            response.sendRedirect(request.getContextPath() + "/employer/jobs");
            return;
        }

        Job job = extractJobFromRequest(request);
        job.setId(jobId);
        job.setEmployerId(user.getId());

        if (!validateJob(job, request)) {
            showJobForm(request, response, user, job);
            return;
        }

        boolean updated = jobDAO.update(job, user.getId());
        if (updated) {
            statsDAO.logActivity(user.getId(), "JOB_UPDATED", "Employer updated job #" + jobId + " (" + job.getTitle() + ")");
            SecurityService.setSuccessMessage(request, "Job listing updated successfully!");
            response.sendRedirect(request.getContextPath() + "/employer/jobs");
        } else {
            SecurityService.setErrorMessage(request, "Failed to update job posting.");
            showJobForm(request, response, user, job);
        }
    }

    private void deleteJob(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int jobId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        boolean deleted = jobDAO.delete(jobId, user.getId());

        if (deleted) {
            statsDAO.logActivity(user.getId(), "JOB_DELETED", "Employer deleted job #" + jobId);
            SecurityService.setSuccessMessage(request, "Job listing deleted successfully.");
        } else {
            SecurityService.setErrorMessage(request, "Unable to delete job listing.");
        }

        response.sendRedirect(request.getContextPath() + "/employer/jobs");
    }

    private void toggleJobStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int jobId = ValidationUtil.parseInt(request.getParameter("id"), 0);
        String status = request.getParameter("status");

        if ("ACTIVE".equalsIgnoreCase(status) || "CLOSED".equalsIgnoreCase(status)) {
            boolean updated = jobDAO.updateJobStatus(jobId, user.getId(), status);
            if (updated) {
                SecurityService.setSuccessMessage(request, "Job status changed to " + status + ".");
            } else {
                SecurityService.setErrorMessage(request, "Could not update job status.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/employer/jobs");
    }

    private void showApplications(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        Integer jobIdFilter = null;
        String jobIdStr = request.getParameter("jobId");
        if (ValidationUtil.isNotEmpty(jobIdStr)) {
            jobIdFilter = ValidationUtil.parseInt(jobIdStr, 0);
            if (jobIdFilter <= 0) jobIdFilter = null;
        }

        List<Application> applicants = applicationDAO.getByEmployerId(user.getId(), jobIdFilter);
        List<Job> myJobs = jobDAO.getByEmployerId(user.getId());
        DashboardStats stats = statsDAO.getEmployerStats(user.getId());

        request.setAttribute("applicants", applicants);
        request.setAttribute("myJobs", myJobs);
        request.setAttribute("selectedJobId", jobIdFilter);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/employer/applicants.jsp").forward(request, response);
    }

    private void updateApplicationStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int appId = ValidationUtil.parseInt(request.getParameter("applicationId"), 0);
        String newStatus = request.getParameter("status");
        String notes = request.getParameter("notes");

        if (appId > 0 && ValidationUtil.isNotEmpty(newStatus)) {
            boolean updated = applicationDAO.updateStatus(appId, user.getId(), newStatus, notes);
            if (updated) {
                statsDAO.logActivity(user.getId(), "APP_STATUS_CHANGED",
                        "Employer updated application #" + appId + " to " + newStatus);
                SecurityService.setSuccessMessage(request, "Candidate status updated to " + newStatus + ".");
            } else {
                SecurityService.setErrorMessage(request, "Could not update candidate status.");
            }
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/employer/")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/employer/applications");
        }
    }

    private Job extractJobFromRequest(HttpServletRequest request) {
        Job j = new Job();
        j.setTitle(request.getParameter("title"));
        j.setCategory(request.getParameter("category"));
        j.setJobType(request.getParameter("jobType"));
        j.setLocation(request.getParameter("location"));
        j.setSalaryMin(ValidationUtil.parseBigDecimal(request.getParameter("salaryMin"), BigDecimal.ZERO));
        j.setSalaryMax(ValidationUtil.parseBigDecimal(request.getParameter("salaryMax"), BigDecimal.ZERO));
        j.setDescription(request.getParameter("description"));
        j.setRequirements(request.getParameter("requirements"));
        j.setSkillsRequired(request.getParameter("skillsRequired"));
        j.setVacancies(ValidationUtil.parseInt(request.getParameter("vacancies"), 1));
        Date deadline = ValidationUtil.parseDate(request.getParameter("deadline"));
        j.setDeadline(deadline);
        String status = request.getParameter("status");
        j.setStatus(ValidationUtil.isNotEmpty(status) ? status : "ACTIVE");
        return j;
    }

    private boolean validateJob(Job job, HttpServletRequest request) {
        if (!ValidationUtil.isNotEmpty(job.getTitle())) {
            request.setAttribute("error", "Job title is required.");
            return false;
        }
        if (!ValidationUtil.isNotEmpty(job.getCategory())) {
            request.setAttribute("error", "Job category is required.");
            return false;
        }
        if (!ValidationUtil.isNotEmpty(job.getLocation())) {
            request.setAttribute("error", "Location is required.");
            return false;
        }
        if (!ValidationUtil.isNotEmpty(job.getDescription())) {
            request.setAttribute("error", "Description is required.");
            return false;
        }
        if (!ValidationUtil.isNotEmpty(job.getSkillsRequired())) {
            request.setAttribute("error", "Skills / Requirements are required.");
            return false;
        }
        return true;
    }
}

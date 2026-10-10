package com.jobify.controller;

import com.jobify.dao.ApplicationDAO;
import com.jobify.dao.JobDAO;
import com.jobify.dao.ProfileDAO;
import com.jobify.dao.StatsDAO;
import com.jobify.model.Application;
import com.jobify.model.DashboardStats;
import com.jobify.model.Job;
import com.jobify.model.JobSeekerProfile;
import com.jobify.model.User;
import com.jobify.service.RecommendationService;
import com.jobify.service.SecurityService;
import com.jobify.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Job Seeker operations: Dashboard, Profile, Applications, Job Applying, and Recommendations.
 */
@WebServlet(name = "JobSeekerServlet", urlPatterns = {
        "/seeker/dashboard",
        "/seeker/profile",
        "/seeker/applications",
        "/seeker/apply",
        "/seeker/recommendations"
})
public class JobSeekerServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final StatsDAO statsDAO = new StatsDAO();
    private final RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User user = SecurityService.getCurrentUser(request);

        switch (path) {
            case "/seeker/dashboard":
                showDashboard(request, response, user);
                break;
            case "/seeker/profile":
                showProfile(request, response, user);
                break;
            case "/seeker/applications":
                showApplications(request, response, user);
                break;
            case "/seeker/recommendations":
                showRecommendations(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/seeker/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User user = SecurityService.getCurrentUser(request);

        if ("/seeker/profile".equals(path)) {
            updateProfile(request, response, user);
        } else if ("/seeker/apply".equals(path)) {
            handleApply(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/seeker/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        JobSeekerProfile profile = profileDAO.getSeekerProfile(user.getId());
        DashboardStats stats = statsDAO.getSeekerStats(user.getId());
        List<Application> recentApplications = applicationDAO.getBySeekerId(user.getId());
        if (recentApplications.size() > 5) {
            recentApplications = recentApplications.subList(0, 5);
        }

        List<Job> allActiveJobs = jobDAO.getAllActive(null, null, null, null, null, 0, 50);
        List<Job> recommendations = recommendationService.getRecommendedJobs(profile, allActiveJobs);
        if (recommendations.size() > 4) {
            recommendations = recommendations.subList(0, 4);
        }

        request.setAttribute("profile", profile);
        request.setAttribute("stats", stats);
        request.setAttribute("recentApplications", recentApplications);
        request.setAttribute("recommendations", recommendations);

        request.getRequestDispatcher("/WEB-INF/views/seeker/dashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        JobSeekerProfile profile = profileDAO.getSeekerProfile(user.getId());
        if (profile == null) {
            profile = new JobSeekerProfile();
            profile.setUserId(user.getId());
            profile.setFullName(user.getDisplayName());
        }

        request.setAttribute("profile", profile);
        request.getRequestDispatcher("/WEB-INF/views/seeker/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String headline = request.getParameter("headline");
        String location = request.getParameter("location");
        String bio = request.getParameter("bio");
        String skills = request.getParameter("skills");
        String education = request.getParameter("education");
        String experience = request.getParameter("experience");
        String resumeUrl = request.getParameter("resumeUrl");
        String resumeSummary = request.getParameter("resumeSummary");

        if (!ValidationUtil.isNotEmpty(fullName)) {
            SecurityService.setErrorMessage(request, "Full Name cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/seeker/profile");
            return;
        }

        JobSeekerProfile profile = new JobSeekerProfile();
        profile.setUserId(user.getId());
        profile.setFullName(fullName.trim());
        profile.setPhone(phone != null ? phone.trim() : "");
        profile.setHeadline(headline != null ? headline.trim() : "");
        profile.setLocation(location != null ? location.trim() : "");
        profile.setBio(bio != null ? bio.trim() : "");
        profile.setSkills(skills != null ? skills.trim() : "");
        profile.setEducation(education != null ? education.trim() : "");
        profile.setExperience(experience != null ? experience.trim() : "");
        profile.setResumeUrl(resumeUrl != null ? resumeUrl.trim() : "");
        profile.setResumeSummary(resumeSummary != null ? resumeSummary.trim() : "");

        boolean success = profileDAO.saveOrUpdateSeekerProfile(profile);

        if (success) {
            // Update session display name
            user.setDisplayName(fullName.trim());
            SecurityService.setSuccessMessage(request, "Your profile has been successfully updated!");
        } else {
            SecurityService.setErrorMessage(request, "Failed to update profile. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/seeker/profile");
    }

    private void showApplications(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        List<Application> applications = applicationDAO.getBySeekerId(user.getId());
        DashboardStats stats = statsDAO.getSeekerStats(user.getId());

        request.setAttribute("applications", applications);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/seeker/applications.jsp").forward(request, response);
    }

    private void handleApply(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String jobIdStr = request.getParameter("jobId");
        String coverLetter = request.getParameter("coverLetter");
        String resumeSummary = request.getParameter("resumeSummary");

        int jobId = ValidationUtil.parseInt(jobIdStr, 0);
        if (jobId <= 0) {
            SecurityService.setErrorMessage(request, "Invalid job opening.");
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        // Prevent duplicate application
        if (applicationDAO.hasApplied(jobId, user.getId())) {
            SecurityService.setWarningMessage(request, "You have already applied for this position.");
            response.sendRedirect(request.getContextPath() + "/job-details?id=" + jobId);
            return;
        }

        // Verify job is still active
        Job job = jobDAO.getById(jobId);
        if (job == null || !job.isActive()) {
            SecurityService.setErrorMessage(request, "This job posting is no longer accepting applications.");
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        // Auto-fill resume summary from profile if empty
        if (!ValidationUtil.isNotEmpty(resumeSummary)) {
            JobSeekerProfile profile = profileDAO.getSeekerProfile(user.getId());
            if (profile != null) {
                resumeSummary = profile.getResumeSummary();
            }
        }

        Application application = new Application();
        application.setJobId(jobId);
        application.setSeekerId(user.getId());
        application.setCoverLetter(coverLetter != null ? coverLetter.trim() : "");
        application.setResumeSummary(resumeSummary != null ? resumeSummary.trim() : "");
        application.setStatus("PENDING");

        int appId = applicationDAO.apply(application);

        if (appId > 0) {
            statsDAO.logActivity(user.getId(), "JOB_APPLIED",
                    "Seeker " + user.getEmail() + " applied for Job #" + jobId + " (" + job.getTitle() + ")");
            SecurityService.setSuccessMessage(request, "Application submitted successfully for " + job.getTitle() + "!");
            response.sendRedirect(request.getContextPath() + "/seeker/applications");
        } else {
            SecurityService.setErrorMessage(request, "Could not submit application. You may have already applied.");
            response.sendRedirect(request.getContextPath() + "/job-details?id=" + jobId);
        }
    }

    private void showRecommendations(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        JobSeekerProfile profile = profileDAO.getSeekerProfile(user.getId());
        List<Job> allActiveJobs = jobDAO.getAllActive(null, null, null, null, null, 0, 100);
        List<Job> recommendations = recommendationService.getRecommendedJobs(profile, allActiveJobs);

        request.setAttribute("profile", profile);
        request.setAttribute("recommendations", recommendations);

        request.getRequestDispatcher("/WEB-INF/views/seeker/recommendations.jsp").forward(request, response);
    }
}

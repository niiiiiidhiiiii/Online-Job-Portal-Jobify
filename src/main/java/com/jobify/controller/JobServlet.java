package com.jobify.controller;

import com.jobify.dao.ApplicationDAO;
import com.jobify.dao.JobDAO;
import com.jobify.dao.ProfileDAO;
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
 * Controller for Job Browsing, Filtering, and Viewing Job Details.
 */
@WebServlet(name = "JobServlet", urlPatterns = {"/jobs", "/job-details"})
public class JobServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9;

    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final ProfileDAO profileDAO = new ProfileDAO();
    private final RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/job-details".equals(path)) {
            handleJobDetails(request, response);
        } else {
            handleJobList(request, response);
        }
    }

    private void handleJobList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        String category = request.getParameter("category");
        String jobType = request.getParameter("jobType");
        String minSalaryStr = request.getParameter("minSalary");
        String pageStr = request.getParameter("page");

        Double minSalary = null;
        if (ValidationUtil.isNotEmpty(minSalaryStr)) {
            try {
                minSalary = Double.parseDouble(minSalaryStr);
            } catch (NumberFormatException ignored) {
            }
        }

        int page = 1;
        if (ValidationUtil.isNotEmpty(pageStr)) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {
            }
        }

        int offset = (page - 1) * PAGE_SIZE;

        int totalJobs = jobDAO.countActive(keyword, location, category, jobType, minSalary);
        int totalPages = (int) Math.ceil((double) totalJobs / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        List<Job> jobs = jobDAO.getAllActive(keyword, location, category, jobType, minSalary, offset, PAGE_SIZE);
        List<String> categories = jobDAO.getAllCategories();

        // If user is a logged in job seeker, calculate their skill match score for each job
        User user = SecurityService.getCurrentUser(request);
        if (user != null && user.isJobSeeker()) {
            JobSeekerProfile profile = profileDAO.getSeekerProfile(user.getId());
            if (profile != null && profile.getSkills() != null) {
                for (Job j : jobs) {
                    j.setMatchScore(recommendationService.calculateMatchScore(profile.getSkills(), j.getSkillsRequired()));
                }
            }
        }

        request.setAttribute("jobs", jobs);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("location", location);
        request.setAttribute("category", category);
        request.setAttribute("jobType", jobType);
        request.setAttribute("minSalary", minSalaryStr);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalJobs", totalJobs);

        request.getRequestDispatcher("/WEB-INF/views/jobs/job-list.jsp").forward(request, response);
    }

    private void handleJobDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        int jobId = ValidationUtil.parseInt(idStr, 0);

        if (jobId <= 0) {
            SecurityService.setErrorMessage(request, "Invalid job opening specified.");
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        Job job = jobDAO.getById(jobId);
        if (job == null) {
            SecurityService.setErrorMessage(request, "The requested job was not found.");
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        boolean hasApplied = false;
        int matchScore = 0;
        JobSeekerProfile seekerProfile = null;

        User user = SecurityService.getCurrentUser(request);
        if (user != null && user.isJobSeeker()) {
            hasApplied = applicationDAO.hasApplied(jobId, user.getId());
            seekerProfile = profileDAO.getSeekerProfile(user.getId());
            if (seekerProfile != null && seekerProfile.getSkills() != null) {
                matchScore = recommendationService.calculateMatchScore(seekerProfile.getSkills(), job.getSkillsRequired());
            }
        }

        job.setUserHasApplied(hasApplied);
        job.setMatchScore(matchScore);

        request.setAttribute("job", job);
        request.setAttribute("hasApplied", hasApplied);
        request.setAttribute("matchScore", matchScore);
        request.setAttribute("seekerProfile", seekerProfile);

        request.getRequestDispatcher("/WEB-INF/views/jobs/job-detail.jsp").forward(request, response);
    }
}

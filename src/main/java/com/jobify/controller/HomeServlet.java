package com.jobify.controller;

import com.jobify.dao.JobDAO;
import com.jobify.dao.StatsDAO;
import com.jobify.model.DashboardStats;
import com.jobify.model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Jobify Landing / Home Page.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch top featured active jobs
        List<Job> featuredJobs = jobDAO.getFeaturedJobs(6);

        // Fetch categories
        List<String> categories = jobDAO.getAllCategories();

        // Platform summary stats for landing counters
        DashboardStats stats = statsDAO.getAdminStats();

        request.setAttribute("featuredJobs", featuredJobs);
        request.setAttribute("categories", categories);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}

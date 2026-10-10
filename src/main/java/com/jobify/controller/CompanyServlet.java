package com.jobify.controller;

import com.jobify.dao.JobDAO;
import com.jobify.dao.ProfileDAO;
import com.jobify.model.EmployerProfile;
import com.jobify.model.Job;
import com.jobify.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Browsing Companies and viewing Employer Company Profiles.
 */
@WebServlet(name = "CompanyServlet", urlPatterns = {"/companies", "/company-details"})
public class CompanyServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();
    private final JobDAO jobDAO = new JobDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/company-details".equals(path)) {
            handleCompanyDetails(request, response);
        } else {
            handleCompanyList(request, response);
        }
    }

    private void handleCompanyList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<EmployerProfile> companies = profileDAO.getAllEmployers();
        request.setAttribute("companies", companies);
        request.getRequestDispatcher("/WEB-INF/views/company/company-list.jsp").forward(request, response);
    }

    private void handleCompanyDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        int employerUserId = ValidationUtil.parseInt(idStr, 0);

        if (employerUserId <= 0) {
            response.sendRedirect(request.getContextPath() + "/companies");
            return;
        }

        EmployerProfile company = profileDAO.getEmployerProfile(employerUserId);
        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/companies");
            return;
        }

        List<Job> companyJobs = jobDAO.getByEmployerId(employerUserId);

        request.setAttribute("company", company);
        request.setAttribute("companyJobs", companyJobs);

        request.getRequestDispatcher("/WEB-INF/views/company/company-detail.jsp").forward(request, response);
    }
}

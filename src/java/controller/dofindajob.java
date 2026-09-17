package controller;

import DAO.DaoJobs;
import model.Job;
import java.io.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class dofindajob extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ dofindajob servlet called.");

        List<Job> jobList = DaoJobs.getAllJobs();
        System.out.println("✅ Jobs fetched = " + jobList.size());

        request.setAttribute("jobs", jobList);
        request.getRequestDispatcher("findajob.jsp").forward(request, response);
    }
}


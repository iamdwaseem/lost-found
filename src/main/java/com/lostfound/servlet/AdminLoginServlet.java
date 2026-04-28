package com.lostfound.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lostfound.model.User;
import com.lostfound.dao.UserDAO;

/**
 * Admin login - authenticates user against DB and checks for admin role.
 */
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(email, password);

        if (user != null && "admin".equals(user.getRole())) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userId", user.getId());
            response.sendRedirect("admin.jsp");
        } else if (user != null) {
            // Valid user but not admin
            response.sendRedirect("admin-login.html?error=2");
        } else {
            response.sendRedirect("admin-login.html?error=1");
        }
    }
}

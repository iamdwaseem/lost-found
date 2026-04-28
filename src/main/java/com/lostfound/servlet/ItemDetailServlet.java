package com.lostfound.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lostfound.model.Item;
import com.lostfound.dao.ItemDAO;

public class ItemDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            ItemDAO dao = new ItemDAO();
            Item item = dao.getItemById(id);

            if (item == null) {
                response.sendRedirect("dashboard.jsp");
                return;
            }

            request.setAttribute("item", item);
            RequestDispatcher dispatcher = request.getRequestDispatcher("item-detail.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp");
        }
    }
}

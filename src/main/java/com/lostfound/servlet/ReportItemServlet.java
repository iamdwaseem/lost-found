package com.lostfound.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.lostfound.model.Item;
import com.lostfound.dao.ItemDAO;

/**
 * Servlet implementation class ReportItemServlet
 * Handles the multipart/form-data POST requests from the item submission form.
 */
@WebServlet("/ReportItemServlet") // Matches the action="ReportItemServlet" in submit.html
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB (File size above which it will be temporarily stored on disk)
    maxFileSize = 1024 * 1024 * 10,       // 10MB (Maximum size for a single uploaded file)
    maxRequestSize = 1024 * 1024 * 50     // 50MB (Maximum size for the entire multipart request)
)
public class ReportItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Directory where uploaded images will be saved, relative to the web application directory.
    private static final String UPLOAD_DIR = "uploads";

    /**
     * Handles the HTTP POST request for item submission.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Extract text fields from the request
        String itemName = request.getParameter("itemName");
        String category = request.getParameter("type"); // "lost" or "found"
        String date = request.getParameter("date");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        
        // 2. Extract and process the uploaded image file
        String relativeFilePath = null;
        Part filePart = request.getPart("imageFile"); // Matches the <input name="imageFile">
        
        if (filePart != null && filePart.getSize() > 0) {
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
            
            File fileSaveDir = new File(uploadFilePath);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs();
            }
            
            String submittedFileName = null;
            for (String cd : filePart.getHeader("content-disposition").split(";")) {
                if (cd.trim().startsWith("filename")) {
                    submittedFileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
            if (submittedFileName == null || submittedFileName.isEmpty()) {
                submittedFileName = "uploaded_image";
            }
            
            String fileName = Paths.get(submittedFileName).getFileName().toString();
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String savePath = uploadFilePath + File.separator + uniqueFileName;
            
            filePart.write(savePath);
            relativeFilePath = UPLOAD_DIR + "/" + uniqueFileName;
        }
        
        // 3. Instantiate Entity and pass to DAO
        try {
            String reporterName = request.getParameter("reporterName");
            String reporterEmail = request.getParameter("reporterEmail");

            Item item = new Item();
            item.setName(itemName);
            item.setCategory(category);
            item.setDate(date);
            item.setLocation(location);
            item.setDescription(description);
            item.setImagePath(relativeFilePath);
            item.setStatus("open");
            item.setReporterName(reporterName);
            item.setReporterEmail(reporterEmail);
            
            ItemDAO itemDAO = new ItemDAO();
            itemDAO.saveItem(item);
            
            // 4. Forward the user to result.jsp with a success message
            request.setAttribute("successMessage", "Your " + category + " item '" + itemName + "' has been successfully reported!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("result.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while saving your report: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("submit.html");
            dispatcher.forward(request, response);
        }
    }
}

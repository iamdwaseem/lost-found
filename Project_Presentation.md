# Lost & Found Portal - Presentation Report

## Problem Identification
In large communities, universities, and corporate campuses, people frequently lose or find personal belongings. Traditional lost and found systems often rely on physical logbooks or disparate communication channels (emails, notice boards), leading to inefficiencies, miscommunication, and a low recovery rate of valuable items. 

Our **Lost & Found Portal** solves this real-world problem by providing a centralized, digital platform. It allows users to instantly report lost items or log found items with comprehensive details (including images). This drastically reduces the time and effort required to match a lost item with its rightful owner, fostering a collaborative and trustworthy environment.

---

## System Design
**Users of the System:**
1. **Regular Users/Students:** Can report lost items, log found items, and browse the dashboard.
2. **Administrators (Optional):** Can moderate listings and manage user accounts.

**Key Features:**
- **User Authentication:** Secure registration and login.
- **Dashboard:** A dynamic grid displaying all active lost and found items.
- **Item Reporting:** A comprehensive form supporting text details and image uploads.
- **Client-Side Validation:** Ensures robust data entry before server submission.

**Overall Workflow:**
1. User logs into the portal.
2. User navigates to the Dashboard to search for an item or clicks "Report Item".
3. User fills out the report form (including an image) and submits it.
4. The system validates the input, processes the submission via a backend Servlet, and stores it.
5. The user is redirected to a Success/Result page.
6. The item becomes visible on the Dashboard.

---

## Technology Mapping
- **HTML (HyperText Markup Language):** Provides the structural foundation of the 5 pages (Login, Register, Dashboard, Submit, Result). It uses semantic tags to organize forms, inputs, navigation, and content blocks.
- **CSS (Cascading Style Sheets):** Responsible for the UI design. We utilized custom properties, glassmorphism techniques, modern typography (Inter font), and CSS animations to create a premium, visually engaging, and responsive layout.
- **JavaScript (Vanilla):** Handles interactivity and client-side validation. It prevents forms from submitting if data is missing, ensures passwords match, validates email formats, and restricts file uploads to image formats only.
- **XML (eXtensible Markup Language):** Used for data exchange or configuration. In traditional Java web applications, `web.xml` maps Servlet endpoints, or XML can be used as an intermediate data format to exchange object data with the database or external APIs.
- **Servlet (Java Servlet):** Acts as the controller. It receives the HTTP POST requests (e.g., `UploadItemServlet`), handles multipart form data (image uploads), processes the business logic, interacts with the database (Hibernate), and controls the application flow.
- **JSP (JavaServer Pages):** Generates dynamic HTML responses. After the Servlet processes the data and retrieves items from the database, JSP dynamically renders the dashboard content (grid of items) with the fetched data before sending it to the browser.
- **MySQL & Hibernate:** MySQL acts as the persistent relational database storing user and item records. Hibernate is the ORM (Object-Relational Mapping) framework used to map Java objects to MySQL tables, streamlining database operations.

---

## Architecture Flow (Request Lifecycle)
**Browser -> HTML + CSS + JS -> Servlet -> XML/Database -> JSP Response**

1. **Browser (HTML + CSS + JS):** 
   The user interacts with the `submit.html` page. They fill out the form and attach an image. JavaScript validates the input locally. Once validated, the browser sends an HTTP POST request with `enctype="multipart/form-data"` to the backend.

2. **Servlet (Request Processing):** 
   The web server (e.g., Tomcat) receives the request and routes it to `UploadItemServlet` (mapping configured via `web.xml` or annotations). The Servlet extracts the form parameters and the uploaded image file.

3. **XML/Database (Data Storage):** 
   The Servlet creates a Java Object representing the Item. Using Hibernate (configured via `hibernate.cfg.xml`), the Servlet saves this object to the **MySQL** database. If an API is involved, the data might be serialized/deserialized via XML/JSON during this step.

4. **JSP Response (Dynamic Page Generation):** 
   Upon successful insertion, the Servlet forwards the request to a JSP page (or `result.html` for static confirmation). For the Dashboard, a Servlet fetches the list of items from MySQL via Hibernate, sets them as request attributes, and forwards to a JSP. The JSP dynamically iterates through the items, generating the HTML grid, and sends the final HTML response back to the browser.

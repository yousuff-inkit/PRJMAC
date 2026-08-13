<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.connection.ClsConnection" %>
<%@ page import="com.dashboard.ClsDashBoardDAO,com.dashboard.ClsDashBoardBean" %>
<%@ page import="net.sf.json.JSONArray, net.sf.json.JSONObject" %>

<%
    String cPath = request.getContextPath();
    String roleId = (session.getAttribute("ROLEID") != null) ? session.getAttribute("ROLEID").toString() : "0";
    String userId = (session.getAttribute("USERID") != null) ? session.getAttribute("USERID").toString() : "";

    // =========================================================================
    // 1. AJAX HANDLER FOR DAO RIGHT PANEL (STATUS & UPDATES)
    // =========================================================================
    ClsDashBoardDAO tileDao = new ClsDashBoardDAO();
    String ajaxId = request.getParameter("ajaxId");
    if(ajaxId != null && !ajaxId.trim().isEmpty()) {
        out.clear(); 
        try {
            JSONArray jsonResult = tileDao.detailSearch(ajaxId, session);
            out.print((jsonResult == null || jsonResult.isEmpty()) ? "[]" : jsonResult.toString());
        } catch (Exception e) { out.print("[]"); }
        return; 
    }

    // =========================================================================
    // 2. FETCH DAO LEFT NAV MODULES (APPLICATION LIST)
    // =========================================================================
    JSONArray appDataArray = tileDao.masterSearch(session);
    if(appDataArray == null) appDataArray = new JSONArray();

    // =========================================================================
    // 3. ORIGINAL SQL MODULES & SVG DECLARATIONS
    // =========================================================================
    String svgBank      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M11.5 1L2 6v2h19V6l-9.5-5zM4 8v10h3V8H4zm5 0v10h3V8H9zm5 0v10h3V8h-3zM2 20v2h19v-2H2z'/></svg>";
    String svgCard      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z'/></svg>";
    String svgCash      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z'/></svg>";
    String svgFile      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z'/></svg>";
    String svgCar       = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z'/></svg>";
    String svgUser      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z'/></svg>";
    String svgHandshake = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M15.42 8.78l-3.23-2.91c-.48-.43-1.22-.38-1.65.11L10.3 6.22 8.5 4.6c-.39-.35-1-.35-1.39 0l-5.66 5.1c-.39.35-.39.91 0 1.26l.99.89-1.87 1.68c-.39.35-.39.91 0 1.26l2.83 2.55c.39.35 1.01.35 1.4 0l1.87-1.68.99.89c.39.35 1.01.35 1.4 0l6.36-5.72c.43-.49.38-1.23-.11-1.65z'/></svg>";
    String svgCalendar  = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z'/></svg>";
    String svgWrench    = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z'/></svg>";
    String svgBuilding  = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10zm-2-8h-2v2h2v-2zm0 4h-2v2h2v-2z'/></svg>";
    String svgSettings  = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.57 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z'/></svg>";
    
    String svgBullhorn  = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H6l-2 2V4h16v12z'/></svg>";
    String svgShield    = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z'/></svg>";
    String svgChart     = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z'/></svg>";
    String svgClipboard = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z'/></svg>";
    String svgCart      = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.08-.14.12-.31.12-.48 0-.55-.45-1-1-1H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z'/></svg>";
    String svgTraffic   = "<svg viewBox='0 0 24 24'><path fill='currentColor' d='M21.5 5.5l-2-2c-.39-.39-1.02-.39-1.41 0L17 4.59v-1.1C17 2.12 15.88 1 14.5 1h-5C8.12 1 7 2.12 7 3.49v1.1L5.91 3.5c-.39-.39-1.02-.39-1.41 0l-2 2c-.39.39-.39 1.02 0 1.41l2.58 2.58v6.02l-2.58 2.58c-.39.39-.39 1.02 0 1.41l2 2c.39.39 1.02.39 1.41 0L7 20.41v1.1c0 1.37 1.12 2.49 2.5 2.49h5c1.38 0 2.5-1.12 2.5-2.49v-1.1l1.09 1.09c.39.39 1.02.39 1.41 0l2-2c.39-.39.39-1.02 0-1.41l-2.58-2.58v-6.02l2.58-2.58c.39-.39.39-1.02 0-1.41zM9.5 5c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5S11.83 6.5 11 6.5 9.5 5.83 9.5 5zm0 7c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5-.67 1.5-1.5 1.5-1.5-.67-1.5-1.5zm0 7c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5-.67 1.5-1.5 1.5-1.5-.67-1.5-1.5z'/></svg>";

    String[][] moduleDefs = {
        {"Finance",          "Fin",     "Finance",   "#0056b3", "#e8f0fe", "bank",      "Manage accounts, payments, receipts and financial transactions"},
        {"Operations",       "Oper",    "Operation", "#1a7340", "#e8f5e9", "car",       "Handle bookings, movements, agreements and client workflows"},
        {"Fleet Management", "Fleet",   "Fleet",     "#b75d00", "#fff3e0", "car",       "Track vehicle assignments, maintenance and fleet utilization"},
        {"Fixed Assets",     "Asset",   "Asset",     "#4a148c", "#f3e5f5", "building", "Manage company assets, depreciation and asset tracking"},
        {"Human Resource",   "Hum",     "Human",     "#00695c", "#e0f2f1", "user",      "Employee management, attendance and payroll operations"},
        {"Control Centre",   "Control", "Control",   "#b71c1c", "#fce4ec", "settings", "System configuration, user roles and administrative controls"}
    };

    String selectedParam = request.getParameter("module");
    if (selectedParam == null || selectedParam.trim().isEmpty()) selectedParam = "Finance";
    int activeIdx = 0;
    for (int i = 0; i < moduleDefs.length; i++) {
        if (moduleDefs[i][2].equalsIgnoreCase(selectedParam)) { activeIdx = i; break; }
    }

    List<List<ClsDashBoardBean>> allTilesList = new ArrayList<List<ClsDashBoardBean>>();
    for (int i = 0; i < moduleDefs.length; i++) allTilesList.add(new ArrayList<ClsDashBoardBean>());

    // =========================================================================
    // 4. MASTER KPI BLOCK
    // =========================================================================
    int readyToRent = 0, inGarage = 0, regExpiry = 0, insExpiry = 0;
    int totalDueCount = 0, myTasks = 0, assignedTasks = 0;
    int laDueDate = 0, bookingFollowUp = 0, quotationFollowUp = 0, agreementCloseReview = 0;
    int invoicesToDispatch = 0, damageInvoices = 0, paymentFollowup = 0;
    int pdcOutstanding = 0, refundableSecurity = 0, collectionClosure = 0;
    int unallocatedFines = 0, staffFines = 0, salikPending = 0, toBeInvoicedTraffic = 0;
    int pendingLeaves = 0, pendingWps = 0, pendingPayroll = 0, empDocExpiries = 0;

    Connection kpiConn = null; Statement kpiStmt = null; ResultSet kpiRs = null;
    try {
        kpiConn = new ClsConnection().getMyConnection();
        kpiStmt = kpiConn.createStatement();

        try {
            String fleetSql = "SELECT " +
                "SUM(CASE WHEN tran_code = 'RR' THEN 1 ELSE 0 END) AS rtr, " +
                "SUM(CASE WHEN tran_code IN ('GM','GA','GS') THEN 1 ELSE 0 END) AS ig, " +
                "SUM(CASE WHEN reg_exp <= (CURDATE() + INTERVAL 10 DAY) THEN 1 ELSE 0 END) AS re, " +
                "SUM(CASE WHEN ins_exp <= (CURDATE() + INTERVAL 10 DAY) THEN 1 ELSE 0 END) AS ie " +
                "FROM gl_vehmaster";
            kpiRs = kpiStmt.executeQuery(fleetSql);
            if (kpiRs.next()) {
                readyToRent = kpiRs.getInt("rtr");
                inGarage = kpiRs.getInt("ig");
                regExpiry = kpiRs.getInt("re");
                insExpiry = kpiRs.getInt("ie");
            }
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS totalCount FROM gl_ragmt WHERE clstatus=0 AND dispute=0 AND ddate <= CURDATE()");
            if (kpiRs.next()) totalDueCount = kpiRs.getInt("totalCount");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_lagmt WHERE clstatus=0 AND ddate <= CURDATE()");
            if (kpiRs.next()) laDueDate = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_bookingm WHERE status=0");
            if (kpiRs.next()) bookingFollowUp = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_quotation WHERE status=0");
            if (kpiRs.next()) quotationFollowUp = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_ragmt WHERE clstatus=1 AND audit_status=0");
            if (kpiRs.next()) agreementCloseReview = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_invoice WHERE status=0"); 
            if (kpiRs.next()) invoicesToDispatch = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_invoice WHERE inv_type LIKE '%Damage%' AND status=0");
            if (kpiRs.next()) damageInvoices = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}
        
        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_invoice WHERE paid_status=0 AND due_date < CURDATE()");
            if (kpiRs.next()) paymentFollowup = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}
        
        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_pdc WHERE status=0 AND chq_date <= CURDATE()");
            if (kpiRs.next()) pdcOutstanding = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_trafficfines WHERE invoice_status=0 OR alloc_status=0");
            if (kpiRs.next()) unallocatedFines = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_trafficfines WHERE staff_allocated=1 AND status=0");
            if (kpiRs.next()) staffFines = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM gl_salik WHERE status=0");
            if (kpiRs.next()) salikPending = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM hr_leave WHERE status=0");
            if (kpiRs.next()) pendingLeaves = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM hr_wps WHERE status=0");
            if (kpiRs.next()) pendingWps = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        try {
            kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM im_employee WHERE visa_exp <= (CURDATE() + INTERVAL 30 DAY) OR pass_exp <= (CURDATE() + INTERVAL 30 DAY)");
            if (kpiRs.next()) empDocExpiries = kpiRs.getInt("cnt");
            kpiRs.close();
        } catch(Exception ignored){}

        if (!userId.isEmpty()) {
            try {
                kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM my_todolist WHERE status=3 AND userid='" + userId + "'");
                if (kpiRs.next()) myTasks = kpiRs.getInt("cnt");
                kpiRs.close();
            } catch(Exception ignored){}

            try {
                kpiRs = kpiStmt.executeQuery("SELECT COUNT(*) AS cnt FROM an_taskcreation WHERE ass_user='" + userId + "' AND act_status!='Confirmed' AND close_status=0");
                if (kpiRs.next()) assignedTasks = kpiRs.getInt("cnt");
                kpiRs.close();
            } catch(Exception ignored){}
        }
    } catch (Exception e) {
        System.out.println("Could not load Master KPIs: " + e.getMessage());
    } finally {
        if (kpiRs != null) try { kpiRs.close(); } catch(Exception e){}
        if (kpiStmt != null) try { kpiStmt.close(); } catch(Exception e){}
        if (kpiConn != null) try { kpiConn.close(); } catch(Exception e){}
    }

    Connection conn = null; Statement stmt = null; ResultSet rs = null;
    try {
        conn = new ClsConnection().getMyConnection();
        for (int mi = 0; mi < moduleDefs.length; mi++) {
            String st = moduleDefs[mi][1];
            stmt = conn.createStatement();
            String sql =
                "SELECT DISTINCT menu_name, func FROM ( " +
                "  SELECT m2.menu_name, m2.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  LEFT JOIN my_powr p ON p.mno = m2.mno " +
                "  WHERE (m1.menu_name LIKE '%" + st + "%' OR m1.doc_type LIKE '%" + st + "%') " +
                "  AND m2.GATE != 'N' AND m2.func IS NOT NULL AND m2.func <> '' " +
                "  AND p.roleid = '" + roleId + "' AND (p.add1<>0 OR p.edit<>0 OR p.del<>0 OR p.print<>0 OR p.attach<>0 OR p.excel<>0 OR p.view<>0) " +
                "  UNION " +
                "  SELECT m3.menu_name, m3.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  JOIN my_menu m3 ON m3.pmenu = m2.mno " +
                "  LEFT JOIN my_powr p ON p.mno = m3.mno " +
                "  WHERE (m1.menu_name LIKE '%" + st + "%' OR m1.doc_type LIKE '%" + st + "%') " +
                "  AND m3.GATE != 'N' AND m3.func IS NOT NULL AND m3.func <> '' " +
                "  AND p.roleid = '" + roleId + "' AND (p.add1<>0 OR p.edit<>0 OR p.del<>0 OR p.print<>0 OR p.attach<>0 OR p.excel<>0 OR p.view<>0) " +
                "  UNION " +
                "  SELECT m4.menu_name, m4.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  JOIN my_menu m3 ON m3.pmenu = m2.mno " +
                "  JOIN my_menu m4 ON m4.pmenu = m3.mno " +
                "  LEFT JOIN my_powr p ON p.mno = m4.mno " +
                "  WHERE (m1.menu_name LIKE '%" + st + "%' OR m1.doc_type LIKE '%" + st + "%') " +
                "  AND m4.GATE != 'N' AND m4.func IS NOT NULL AND m4.func <> '' " +
                "  AND p.roleid = '" + roleId + "' AND (p.add1<>0 OR p.edit<>0 OR p.del<>0 OR p.print<>0 OR p.attach<>0 OR p.excel<>0 OR p.view<>0) " +
                ") all_menus ORDER BY menu_name";
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                String title = rs.getString("menu_name");
                String dbLink = rs.getString("func");
                String fullUrl = "#";
                if (dbLink != null && !dbLink.trim().isEmpty()) {
                    fullUrl = (!dbLink.startsWith("/") ? cPath + "/" : cPath) + dbLink;
                    fullUrl += (fullUrl.contains("?") ? "&" : "?") + "menuname=" + title.replace(" ", "%20");
                }
                ClsDashBoardBean bean = new ClsDashBoardBean();
                bean.setTxttitle(title); bean.setTxtdescription(fullUrl);
                allTilesList.get(mi).add(bean);
            }
            rs.close(); stmt.close();
        }
    } catch (Exception e) { e.printStackTrace(); }
    finally { if (conn != null) conn.close(); }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="<%= cPath %>/scripts/jquery-1.11.1.min.js"></script>
<style>
    * { box-sizing: border-box; }
    body, html { margin: 0; padding: 0; font-family: "Segoe UI", Roboto, sans-serif; background: #f0f2f5; height: 100%; overflow: hidden; }
    ::-webkit-scrollbar { width: 4px; height: 4px; }
    ::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }

    .banner { height: 115px; background-image: url("<%= cPath %>/icons/banner_image.png"); background-size: cover; background-position: center; margin: 10px 15px 0; border-radius: 8px; position: relative; display: flex; align-items: center; padding: 0 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.15); flex-shrink: 0; }
    .banner::before { content: ""; position: absolute; inset: 0; background: rgba(0,0,0,0.22); border-radius: 8px; }
    .banner-inner { z-index: 2; color: #fff; display: flex; align-items: center; width: 100%; justify-content: space-between; }
    .banner-title { font-size: 22px; font-weight: 700; text-shadow: 1px 1px 4px rgba(0,0,0,0.4); }
    .banner-sub   { font-size: 13px; opacity: 0.9; margin-top: 2px; }

    .kpi-stat-card { background: #f8f9fb; border: 1px solid #eaecf0; border-radius: 8px; padding: 15px 20px; display: flex; flex-direction: column; justify-content: center; border-bottom: 4px solid transparent; transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; min-height: 95px; }
    .kpi-stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(0,0,0,0.08); border-color: #c0cfe8; background: #fff; }

    /* App Body layout */
    .app-body { display: flex; gap: 0; margin: 15px; height: calc(100vh - 145px); background: #fff; border-radius: 8px; border: 1px solid #e0e4ea; box-shadow: 0 1px 4px rgba(0,0,0,0.06); overflow: hidden; }

    /* Left Nav Flex Splitting exactly 50/50 */
    .left-nav { width: 250px; min-width: 250px; border-right: 1px solid #e8eaed; display: flex; flex-direction: column; background: #fafbfc; height: 100%; overflow: hidden; }
    .accordion-header { flex: 0 0 auto; padding: 14px 16px 10px; font-size: 10px; font-weight: 700; color: #999; letter-spacing: 1px; text-transform: uppercase; border-bottom: 1px solid #eee; background: #f4f6f9; cursor: pointer; display: flex; justify-content: space-between; align-items: center; user-select: none; }
    .accordion-header:hover { background: #eef1f6; color: #555; }
    .acc-arrow { font-size: 12px; transition: transform 0.2s; color: #bbb; }
    .accordion-header.collapsed .acc-arrow { transform: rotate(-90deg); }
    
    .nav-section-content { flex: 1; overflow-y: auto; display: block; min-height: 0; }
    .nav-section-content.collapsed { display: none; }
    
    .module-item { border-bottom: 1px solid #eef0f3; cursor: pointer; transition: background 0.15s; }
    .module-item:hover { background: #f0f4ff; }
    .module-item.active { background: #e8f0fe; border-left: 3px solid #0056b3; }
    .module-header { display: flex; align-items: center; gap: 10px; padding: 12px 14px; user-select: none; }
    .module-icon-wrap { width: 30px; height: 30px; border-radius: 7px; display: flex; align-items: center; justify-content: center; flex: 0 0 30px; }
    .module-icon-wrap svg { width: 16px; height: 16px; }
    .module-label { flex: 1; font-size: 13px; font-weight: 600; color: #3c3c3c; }
    .module-item.active .module-label { color: #0056b3; }
    
    .module-arrow { font-size: 18px; color: #ccc; transition: transform 0.2s; line-height: 1; opacity: 0; }
    .module-item.active .module-arrow { opacity: 1; transform: rotate(90deg); color: #0056b3; }
    
    .submenu { display: none; background: #fff; border-top: 1px solid #f0f0f0; cursor: default; }
    .module-item.active .submenu { display: block; }
    .submenu-link { display: flex; align-items: center; gap: 8px; padding: 8px 14px 8px 22px; font-size: 12px; color: #555; text-decoration: none; cursor: pointer; transition: background 0.12s, color 0.12s; border: none; background: none; width: 100%; text-align: left; }
    .submenu-link::before { content: "·"; color: #bbb; font-size: 16px; line-height: 1; }
    .submenu-link:hover { background: #f5f7ff; color: #0056b3; }
    .submenu-link:hover::before { color: #0056b3; }
    .submenu-empty { padding: 10px 22px; font-size: 12px; color: #bbb; font-style: italic; }

    .right-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; background: #fff;}
    .module-panel { display: none; flex-direction: column; height: 100%; }
    .module-panel.active-panel { display: flex; }
    .panel-header { flex: 0 0 auto; padding: 16px 20px 14px; border-bottom: 1px solid #eef0f3; display: flex; align-items: center; justify-content: space-between; gap: 14px; }
    .panel-header-left { display: flex; align-items: center; gap: 14px; }
    .panel-module-icon { width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex: 0 0 42px; }
    .panel-module-icon svg { width: 22px; height: 22px; }
    .panel-module-name { font-size: 17px; font-weight: 700; color: #222; line-height: 1.2; }
    .panel-meta { display: flex; align-items: center; gap: 10px; }
    .badge-count { font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 12px; white-space: nowrap; }
    .panel-search input { padding: 6px 14px; border: 1px solid #dde; border-radius: 16px; font-size: 12px; outline: none; width: 150px; background: #f8f9fb; transition: border-color 0.2s, box-shadow 0.2s, width 0.3s; }
    .panel-search input:focus { border-color: #0056b3; box-shadow: 0 0 0 3px rgba(0,86,179,0.1); width: 200px; background: #fff; }
    
    .tiles-area { flex: 1; overflow-y: auto; padding: 16px 20px; background: #f8f9fb; }
    .tiles-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 16px; }
    
    .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 200px; color: #bbb; width: 100%; grid-column: 1 / -1; }
    .empty-state svg { width: 48px; height: 48px; margin-bottom: 10px; opacity: 0.4; }
    .empty-state p { font-size: 13px; margin: 0; }
</style>
</head>
<body>

<div class="banner">
    <div class="banner-inner">
        <div>
            <div class="banner-title">Welcome, ${sessionScope.USERNAME}</div>
            <div class="banner-sub" id="greeting"></div>
        </div>
    </div>
</div>

<div id="kpiMasterTemplate" style="display: none;">
<%
    String[][] kpiDefinitions = {
        {"Ready to Rent",              String.valueOf(readyToRent),         "#28a745", "",                       "openParentMenu",        "Available Fleet",          "Fleet Management", "Ops,Super,Driver"},
        {"In Garage",                  String.valueOf(inGarage),            "#dc3545", "",                       "openParentMenu",        "Vehicle Master",           "Fleet Management", "Ops,Super"},
        {"RA Due Date",                String.valueOf(totalDueCount),       "#b75d00", "background:#fff3e0;",    "openDueDateDirectly",   "",                         "Operations",       "Ops,Super"},
        {"LA Due Date",                String.valueOf(laDueDate),           "#e67e22", "",                       "openParentMenu",        "Lease Agreement Create",   "Operations",       "Ops,Super"},
        {"Pending Bookings",           String.valueOf(bookingFollowUp),     "#8e44ad", "",                       "openParentMenu",        "Booking",                  "Operations",       "Ops,Super"},
        {"Pending Quotes",             String.valueOf(quotationFollowUp),   "#f39c12", "",                       "openParentMenu",        "Quote",                    "Operations",       "Ops,Super"},
        {"RA Close Review",            String.valueOf(agreementCloseReview),"#34495e", "",                       "openParentMenu",        "Rental Agreement Close",   "Operations",       "Super"},
        {"Un-Dispatched Inv",          String.valueOf(invoicesToDispatch),  "#4CAF50", "",                       "openParentMenu",        "Invoice",                  "Finance",          "Ops,Super"},
        {"Damage Invoices",            String.valueOf(damageInvoices),      "#f44336", "",                       "openParentMenu",        "Invoice",                  "Finance",          "Super"},
        {"Payment Followup",           String.valueOf(paymentFollowup),     "#e91e63", "",                       "openParentMenu",        "Cash Receipts",            "Finance",          "Ops,Super"},
        {"PDC Outstanding",            String.valueOf(pdcOutstanding),      "#9c27b0", "",                       "openParentMenu",        "PDC Posting - Receipts",   "Finance",          "Super"},
        {"Unallocated Fines",          String.valueOf(unallocatedFines),    "#FF5722", "",                       "openParentMenu",        "Traffic fine Entry",       "Operations",       "Ops,Super"},
        {"Staff Fines",                String.valueOf(staffFines),          "#FF9800", "",                       "openParentMenu",        "Traffic fine Entry",       "Operations",       "Super"},
        {"Salik Pending",              String.valueOf(salikPending),        "#795548", "",                       "openParentMenu",        "SAT Download",             "Operations",       "Ops,Super"},
        {"Pending Leaves",             String.valueOf(pendingLeaves),       "#00BCD4", "",                       "openParentMenu",        "Leave Request",            "Human Resource",   "Super"},
        {"Pending WPS",                String.valueOf(pendingWps),          "#3F51B5", "",                       "openParentMenu",        "Monthly Payroll",          "Human Resource",   "Super"},
        {"Staff Doc Expiries",         String.valueOf(empDocExpiries),      "#E91E63", "",                       "openParentMenu",        "Employee Master",           "Human Resource",   "Super"},
        {"Fleet Doc Expiries",         String.valueOf(regExpiry + insExpiry),"#6f42c1", "",                      "openParentMenu",        "Vehicle Master",           "Fleet Management", "Ops,Super"},
        {"My Pending Tasks",           String.valueOf(myTasks),             "#007bff", "",                       "openParentMenu",        "General",                  "Control Centre",   "Ops,Super,Driver"},
        {"Assigned to Me",             String.valueOf(assignedTasks),       "#17a2b8", "",                       "openParentMenu",        "General",                  "Control Centre",   "Ops,Super,Driver"}
    };

    String userType = "Ops"; 
    if ("SNDriver".equalsIgnoreCase(roleId)) {
        userType = "Driver";
    } else if ("1".equalsIgnoreCase(roleId) || "Super".equalsIgnoreCase(roleId)) { 
        userType = "Super";
    }

    for (String[] kpi : kpiDefinitions) {
        String kpiLabel    = kpi[0];
        String kpiValue    = kpi[1];
        String bColor      = kpi[2];
        String styleAttr   = kpi[3];
        String clickFunc   = kpi[4];
        String targetMenu  = kpi[5];
        String kpiCategory = kpi[6].replaceAll("\\s+", "").toUpperCase();
        String allowedRoles= kpi[7];

        if (allowedRoles.contains(userType)) {
            String clickAction = clickFunc + "('" + targetMenu + "')";
            if ("openDueDateDirectly".equals(clickFunc)) {
                clickAction = "openDueDateDirectly()";
            }
%>
            <div class="kpi-stat-card kpi-cat-<%= kpiCategory %>" style="border-bottom-color: <%= bColor %>; <%= styleAttr %>" onclick="<%= clickAction %>">
                <div class="kpi-title" style="font-size: 11px; color: #666; font-weight: 600; text-transform: uppercase; margin-bottom: 4px;"><%= kpiLabel %></div>
                <div style="font-size: 26px; font-weight: 800; color: <%= bColor %>; line-height: 1.1;"><%= kpiValue %></div>
            </div>
<%
        }
    }
%>
</div>

<div class="app-body">
    <div class="left-nav">
        
        <div class="accordion-header" onclick="toggleAccordion('coreModulesContent', this)">
            <span>Core Modules</span>
            <span class="acc-arrow">&#9660;</span>
        </div>
        
        <div class="nav-section-content" id="coreModulesContent">
            <%
                String[] navIcons = {svgBank, svgCar, svgCar, svgBuilding, svgUser, svgSettings};
                String[] navColors = {"#0056b3","#1a7340","#b75d00","#4a148c","#00695c","#b71c1c"};
                String[] navBgs    = {"#e8f0fe","#e8f5e9","#fff3e0","#f3e5f5","#e0f2f1","#fce4ec"};

                for (int mi = 0; mi < moduleDefs.length; mi++) {
                    String modName = moduleDefs[mi][0];
                    int tileCount = allTilesList.get(mi).size();
                    String color = navColors[mi];
                    String bg    = navBgs[mi];
                    String navIcon = navIcons[mi];
            %>
                <div class="module-item sql-module" data-idx="<%= mi %>" data-category="<%= modName.replaceAll("\\s+", "").toUpperCase() %>">
                    <div class="module-header" onclick="selectSqlModule(this, <%= mi %>)">
                        <div class="module-icon-wrap" style="background:<%= bg %>; color:<%= color %>;">
                            <%= navIcon %>
                        </div>
                        <span class="module-label"><%= modName %></span>
                        <span class="module-arrow">&#8250;</span>
                    </div>
                    <div class="submenu">
                        <% if (tileCount == 0) { %>
                            <div class="submenu-empty">No forms available</div>
                        <% } else { for (ClsDashBoardBean t : allTilesList.get(mi)) { %>
                            <button type="button" class="submenu-link" onclick="event.stopPropagation(); openParentMenu('<%= t.getTxttitle().replace("'", "\\'") %>')"><%= t.getTxttitle() %></button>
                        <% } } %>
                    </div>
                </div>
            <% } %>
        </div> 
        
        <div class="accordion-header" onclick="toggleAccordion('applicationsContent', this)">
            <span>Applications</span>
            <span class="acc-arrow">&#9660;</span>
        </div>
        
        <div class="nav-section-content" id="applicationsContent">
            <%
                String[] appColors = {"#0056b3", "#1a7340", "#b75d00", "#4a148c", "#00695c", "#b71c1c", "#d35400", "#2980b9", "#8e44ad", "#27ae60"};
                String[] appBgs    = {"#e8f0fe", "#e8f5e9", "#fff3e0", "#f3e5f5", "#e0f2f1", "#fce4ec", "#fbeee6", "#ebf5fb", "#f5eef8", "#e9f7ef"};

                for (int i = 0; i < appDataArray.size(); i++) {
                    JSONObject item = appDataArray.getJSONObject(i);
                    String docNo = item.optString("doc_no", "");
                    String description = item.optString("description", "Unknown");
                    
                    String appColor = appColors[i % appColors.length];
                    String appBg = appBgs[i % appBgs.length];

                    String listIcon = svgFile; 
                    String descLower = description.toLowerCase();
                    if(descLower.contains("vehicle")) { listIcon = svgCar; }
                    else if(descLower.contains("rental") || descLower.contains("lease")) { listIcon = svgHandshake; }
                    else if(descLower.contains("client") || descLower.contains("customer")) { listIcon = svgUser; }
                    else if(descLower.contains("invoice") || descLower.contains("finance") || descLower.contains("account")) { listIcon = svgBank; }
                    else if(descLower.contains("marketing")) { listIcon = svgBullhorn; }
                    else if(descLower.contains("setting") || descLower.contains("control")) { listIcon = svgSettings; }
                    else if(descLower.contains("traffic") || descLower.contains("fine")) { listIcon = svgTraffic; }
                    else if(descLower.contains("security")) { listIcon = svgShield; }
                    else if(descLower.contains("operation")) { listIcon = svgWrench; }
                    else if(descLower.contains("analysis")) { listIcon = svgChart; }
                    else if(descLower.contains("audit")) { listIcon = svgClipboard; }
                    else if(descLower.contains("asset")) { listIcon = svgBuilding; }
                    else if(descLower.contains("purchase")) { listIcon = svgCart; }
            %>
                <div class="module-item dao-module" data-docno="<%= docNo %>" data-desc="<%= description %>" data-color="<%= appColor %>" data-bg="<%= appBg %>">
                    <div class="module-header" onclick="triggerDaoModuleSelect(this)">
                        <div class="module-icon-wrap" style="background:<%= appBg %>; color:<%= appColor %>;">
                            <%= listIcon %>
                        </div>
                        <span class="module-label"><%= description %></span>
                        <span class="module-arrow">&#8250;</span>
                    </div>
                    <div class="submenu"></div>
                </div>
            <% } %>
        </div> 
        
    </div>

    <div class="right-content">
        
        <%
        for (int mi = 0; mi < moduleDefs.length; mi++) {
            String modName   = moduleDefs[mi][0];
            String modDesc   = moduleDefs[mi][6];
            String color     = navColors[mi];
            String bg        = navBgs[mi];
            String navIcon   = navIcons[mi];
            String safeId    = "sql_panel_" + mi;
        %>
        <div class="module-panel sql-panel" id="<%= safeId %>">
            <div class="panel-header">
                <div class="panel-header-left">
                    <div class="panel-module-icon" style="background:<%= bg %>; color:<%= color %>;">
                        <%= navIcon %>
                    </div>
                    <div>
                        <div class="panel-module-name" style="color:<%= color %>;"><%= modName %> Overview</div>
                        <div style="font-size: 12px; color: #888; margin-top: 2px;"><%= modDesc %></div>
                    </div>
                </div>
                <div class="panel-meta">
                    <span class="badge-count" style="background:<%= bg %>; color:<%= color %>;">0 KPIs</span>
                    <div class="panel-search">
                        <input type="text" class="localSearch" placeholder="Search KPIs..." oninput="filterTiles(this, '<%= safeId %>')">
                    </div>
                </div>
            </div>
            <div class="tiles-area">
                <div class="tiles-grid"></div>
            </div>
        </div>
        <% } %>

        <div class="module-panel" id="dao_panel">
            <div class="panel-header">
                <div class="panel-header-left">
                    <div class="panel-module-icon" id="dao_panel_icon">
                        <svg viewBox="0 0 24 24"><path fill="currentColor" d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                    </div>
                    <div>
                        <div class="panel-module-name" id="activeDaoName">Application Overview</div>
                        <div style="font-size: 12px; color: #888; margin-top: 2px;">Key Performance Indicators</div>
                    </div>
                </div>
                <div class="panel-meta">
                    <span class="badge-count" id="daoTileCounter" style="background:#e8f0fe; color:#0056b3;">0 KPIs</span>
                    <div class="panel-search">
                        <input type="text" class="localSearch" placeholder="Search KPIs..." oninput="filterTiles(this, 'dao_panel')">
                    </div>
                </div>
            </div>
            <div class="tiles-area">
                <div class="tiles-grid" id="daoTilesContainer"></div>
            </div>
        </div>

    </div>
</div>

<script>
    $(document).ready(function() {
        var h = new Date().getHours();
        $('#greeting').text(h < 12 ? 'Good Morning' : h < 18 ? 'Good Afternoon' : 'Good Evening');

        var activeIdxToLoad = <%= activeIdx %>;
        var $targetSqlModule = $('.sql-module[data-idx="' + activeIdxToLoad + '"]');
        
        if ($targetSqlModule.length > 0) {
            selectSqlModule($targetSqlModule.find('.module-header')[0], activeIdxToLoad);
        } else {
            var $firstSql = $('.sql-module').first();
            if ($firstSql.length > 0) selectSqlModule($firstSql.find('.module-header')[0], $firstSql.data('idx'));
        }
    });

    // Toggle Accordion Function
    function toggleAccordion(contentId, headerElement) {
        var $header = $(headerElement);
        var $content = $('#' + contentId);
        $header.toggleClass('collapsed');
        $content.toggleClass('collapsed');
    }

    // Main KPI injector function: pulls from hidden template and inserts into the right panel grid
    function injectKpisIntoGrid(categoryStr, $targetGrid) {
        $targetGrid.empty(); // Clear old KPIs
        var $matchedKpis = $('#kpiMasterTemplate .kpi-cat-' + categoryStr).clone();

        if ($matchedKpis.length > 0) {
            $targetGrid.append($matchedKpis);
            $targetGrid.closest('.module-panel').find('.badge-count').text($matchedKpis.length + " KPIs");
        } else {
            $targetGrid.html('<div class="empty-state" style="grid-column: 1 / -1;"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/></svg><p>No KPIs available for this category</p></div>');
            $targetGrid.closest('.module-panel').find('.badge-count').text("0 KPIs");
        }
    }

    // Handle clicking an Original Core Module
    function selectSqlModule(headerElement, idx) {
        var $parentItem = $(headerElement).closest('.module-item');
        
        if($parentItem.hasClass('active')) {
            $parentItem.removeClass('active');
            return;
        }

        $('.module-item').removeClass('active');
        $parentItem.addClass('active');
        $('.localSearch').val('');

        // Switch Panels
        $('.module-panel').removeClass('active-panel');
        $('#sql_panel_' + idx).addClass('active-panel');

        // Inject KPIs for this SQL panel category
        var category = $parentItem.data('category');
        var $grid = $('#sql_panel_' + idx + ' .tiles-grid');
        injectKpisIntoGrid(category, $grid);
    }

    // Handle clicking a New Application Item
    function triggerDaoModuleSelect(headerElement) {
        var $parentItem = $(headerElement).closest('.module-item');

        if($parentItem.hasClass('active')) {
            $parentItem.removeClass('active');
            return; 
        }

        $('.module-item').removeClass('active');
        $parentItem.addClass('active');
        $('.localSearch').val('');

        // Switch Panels
        $('.module-panel').removeClass('active-panel');
        $('#dao_panel').addClass('active-panel');

        var docNo = $parentItem.data('docno');
        var desc = $parentItem.data('desc');
        var appColor = $parentItem.data('color');
        var appBg = $parentItem.data('bg');

        $('#activeDaoName').text(desc + " Overview");
        $('#activeDaoName').css('color', appColor);

        // Map icons dynamically
        var currentIconHtml = $parentItem.find('.module-icon-wrap').html();
        var $daoPanelIcon = $('#dao_panel_icon');
        $daoPanelIcon.html(currentIconHtml);
        $daoPanelIcon.css({'background-color': appBg, 'color': appColor});
        
        $('#daoTileCounter').css({'background-color': appBg, 'color': appColor});

        // Smart Category mapping to match Application titles with KPI ribbon logic
        var category = desc.toUpperCase().replace(/\s+/g, '');
        if(category.indexOf('FLEET') > -1 || category.indexOf('VEHICLE') > -1) category = 'FLEETMANAGEMENT';
        else if(category.indexOf('FINANCE') > -1 || category.indexOf('INVOICE') > -1 || category.indexOf('ACCOUNT') > -1) category = 'FINANCE';
        else if(category.indexOf('OPERATIONS') > -1 || category.indexOf('RENTAL') > -1 || category.indexOf('LEASE') > -1 || category.indexOf('CLIENT') > -1 || category.indexOf('MARKETING') > -1 || category.indexOf('TRAFFIC') > -1 || category.indexOf('BOOKING') > -1) category = 'OPERATIONS';
        else if(category.indexOf('HUMAN') > -1) category = 'HUMANRESOURCE';
        else if(category.indexOf('ASSET') > -1) category = 'FIXEDASSETS';
        else if(category.indexOf('CONTROL') > -1 || category.indexOf('SETTING') > -1 || category.indexOf('SECURITY') > -1) category = 'CONTROLCENTRE';

        // Inject KPIs into right panel
        var $grid = $('#daoTilesContainer');
        injectKpisIntoGrid(category, $grid);

        // Fetch Submenu Application forms via AJAX
        $parentItem.find('.submenu').html('<div class="submenu-empty">Loading...</div>'); 

        $.ajax({
            url: window.location.href,
            type: "POST",
            data: { ajaxId: docNo },
            dataType: "json",
            success: function(response) {
                renderDaoSubmenuOnly(response, desc, $parentItem);
            },
            error: function() {
                $parentItem.find('.submenu').html('<div class="submenu-empty">Failed to load data</div>');
            }
        });
    }

    function renderDaoSubmenuOnly(data, parentDesc, $parentItem) {
        var $submenu = $parentItem.find('.submenu').empty(); 
        
        if (!data || data.length === 0) {
            $submenu.html('<div class="submenu-empty">No forms available</div>');
            return;
        }

        $.each(data, function(i, item) {
            var cleanDesc = item.description.replace(/'/g, "\\'");
            var cleanMainDesc = parentDesc.replace(/'/g, "\\'");
            
            var submenuLink = '<button type="button" class="submenu-link" onclick="event.stopPropagation(); openDetailLink(\'' + cleanDesc + '\', \'' + item.path + '\', \'' + item.doc_no + '\', \'' + cleanMainDesc + '\', \'' + item.value + '\')">' + item.description + '</button>';
            $submenu.append(submenuLink);
        });
    }

    // Filter now targets .kpi-stat-card and its internal .kpi-title class
    function filterTiles(input, panelId) {
        var val = input.value.toUpperCase().replace(/\s+/g, '');
        $('#' + panelId + ' .kpi-stat-card').each(function() {
            var name = $(this).find('.kpi-title').text().toUpperCase().replace(/\s+/g, '');
            $(this).css('display', name.indexOf(val) > -1 ? '' : 'none');
        });
    }

    function openDetailLink(detName, path, docno, mainDesc, val) {
        var fullUrl = window.location.href.split("com/")[0] + path + "?name=" + encodeURIComponent(detName) + "&main=" + encodeURIComponent(mainDesc) + "&docno=" + docno + "&value=" + val;
        if (typeof top.addTab === 'function') top.addTab(detName, fullUrl);
        else if (window.parent && window.parent.geturl) window.parent.geturl(detName); 
        else window.location.href = fullUrl;
    }

    function openDueDateDirectly() {
        var actionUrl = "<%= request.getContextPath() %>/com/dashboard/Rentalagreement/dueDate/duedateMaster.jsp?name=Due%20Date&main=Rental%20Agreement&docno=24&value=1087";
        if (typeof top.addTab === 'function') { top.addTab("Due Date", actionUrl); return; } 
        if (typeof window.parent.openTab === 'function') { window.parent.openTab("Due Date", actionUrl); return; }
        window.location.href = actionUrl;
    }

    function openParentMenu(title) {
        if (window.parent && window.parent.geturl) window.parent.geturl(title);
    }
</script>
</body>
</html>
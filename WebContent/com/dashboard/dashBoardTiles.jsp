<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.connection.ClsConnection" %>
<%@ page import="com.dashboard.ClsDashBoardDAO" %>
<%@ page import="com.dashboard.ClsDashBoardBean" %>

<%
    // ========================================================================
    // 1. DEFINE SVG ICONS (STRICTLY PRESERVED)
    // ========================================================================
    String svgBank      = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M11.5 1L2 6v2h19V6l-9.5-5zM4 8v10h3V8H4zm5 0v10h3V8H9zm5 0v10h3V8h-3zM2 20v2h19v-2H2z'/></svg>";
    String svgCard      = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z'/></svg>";
    String svgCash      = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z'/></svg>";
    String svgFile      = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z'/></svg>";
    String svgCar       = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.21.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z'/></svg>";
    String svgUser      = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z'/></svg>";
    String svgHandshake = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M15.42 8.78l-3.23-2.91c-.48-.43-1.22-.38-1.65.11L10.3 6.22 8.5 4.6c-.39-.35-1-.35-1.39 0l-5.66 5.1c-.39.35-.39.91 0 1.26l.99.89-1.87 1.68c-.39.35-.39.91 0 1.26l2.83 2.55c.39.35 1.01.35 1.4 0l1.87-1.68.99.89c.39.35 1.01.35 1.4 0l6.36-5.72c.43-.49.38-1.23-.11-1.65z'/></svg>";
    String svgCalendar  = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z'/></svg>";
    String svgWrench    = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z'/></svg>";
    String svgBuilding  = "<svg viewBox='0 0 24 24'><path fill='#005c97' d='M12 7V3H2v18h20V7H12zM6 19H4v-2h2v2zm0-4H4v-2h2v2zm0-4H4V9h2v2zm0-4H4V5h2v2zm4 12H8v-2h2v2zm0-4H8v-2h2v2zm0-4H8V9h2v2zm0-4H8V5h2v2zm10 12h-8v-2h2v-2h-2v-2h2v-2h-2V9h8v10zm-2-8h-2v2h2v-2zm0 4h-2v2h2v-2z'/></svg>";

    // Mapping icons
    Map<String, String> iconMap = new HashMap<String, String>();
    iconMap.put("Accounts Master", svgBuilding);
    iconMap.put("Bank Payments", svgCard);
    iconMap.put("Bank Receipts", svgBank);
    iconMap.put("Cash Payments", svgCash);
    iconMap.put("IB Bank Payment", svgCard);
    iconMap.put("IB Bank Receipt", svgBank);
    iconMap.put("Booking", svgCalendar);
    iconMap.put("Client", svgUser);
    iconMap.put("Movement", svgCar);
    iconMap.put("Maintenance Update", svgWrench);
    iconMap.put("Rental Agreement Create", svgHandshake);

    String cPath = request.getContextPath();
    String selectedModule = request.getParameter("module");
    String roleId = (session.getAttribute("ROLEID") != null) ? session.getAttribute("ROLEID").toString() : "0";

    // my_powr has no "view" column - these are the same six flags the top menu checks (ClsLogin.getMenuDetails)
    String powrCheck = " AND p.roleid = ? AND (p.add1<>0 OR p.edit<>0 OR p.del<>0 OR p.print<>0 OR p.attach<>0 OR p.excel<>0) ";

    // Every module (root menu) and its forms in one pass, so a module with no forms gets no tab
    Map<String, List<ClsDashBoardBean>> moduleTiles = new LinkedHashMap<String, List<ClsDashBoardBean>>();
    List<String> moduleList = new ArrayList<String>();
    List<ClsDashBoardBean> tileList = new ArrayList<ClsDashBoardBean>();
    Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;

    try {
        ClsConnection clsCon = new ClsConnection();
        conn = clsCon.getMyConnection();

        // Forms (up to 3 levels deep) under every root menu, same tree the top menu bar walks
        String rootFilter = " WHERE m1.pmenu = 0 AND m1.GATE != 'N' ";
        String sql =
                "SELECT rootno, root, menu_name, func FROM ( " +
                "  SELECT m1.mno AS rootno, m1.menu_name AS root, m2.menu_name, m2.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  JOIN my_powr p ON p.mno = m2.mno " + rootFilter +
                "  AND m2.GATE != 'N' AND m2.func IS NOT NULL AND m2.func <> '' " + powrCheck +
                "  UNION " +
                "  SELECT m1.mno, m1.menu_name, m3.menu_name, m3.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  JOIN my_menu m3 ON m3.pmenu = m2.mno " +
                "  JOIN my_powr p ON p.mno = m3.mno " + rootFilter +
                "  AND m2.GATE != 'N' AND m3.GATE != 'N' AND m3.func IS NOT NULL AND m3.func <> '' " + powrCheck +
                "  UNION " +
                "  SELECT m1.mno, m1.menu_name, m4.menu_name, m4.func FROM my_menu m1 " +
                "  JOIN my_menu m2 ON m2.pmenu = m1.mno " +
                "  JOIN my_menu m3 ON m3.pmenu = m2.mno " +
                "  JOIN my_menu m4 ON m4.pmenu = m3.mno " +
                "  JOIN my_powr p ON p.mno = m4.mno " + rootFilter +
                "  AND m2.GATE != 'N' AND m3.GATE != 'N' AND m4.GATE != 'N' AND m4.func IS NOT NULL AND m4.func <> '' " + powrCheck +
                ") all_menus ORDER BY rootno, menu_name";

        pstmt = conn.prepareStatement(sql);
        for(int i = 0; i < 3; i++) { pstmt.setString(i + 1, roleId); }
        rs = pstmt.executeQuery();
        while(rs.next()) {
            String root = rs.getString("root");
            String title = rs.getString("menu_name");
            if(root == null || title == null) continue;
            String dbLink = rs.getString("func");
            String fullUrl = "#";
            if(dbLink != null && !dbLink.trim().equals("")) {
                 if(!dbLink.startsWith("/")) fullUrl = cPath + "/" + dbLink;
                 else fullUrl = cPath + dbLink;
                 fullUrl += (fullUrl.contains("?") ? "&" : "?") + "menuname=" + title.replace(" ", "%20");
            }
            String icon = iconMap.get(title.trim());
            if(icon == null) { icon = svgFile; }
            ClsDashBoardBean bean = new ClsDashBoardBean();
            bean.setTxttitle(title); bean.setTxtdescription(fullUrl); bean.setMsg(icon);

            if(!moduleTiles.containsKey(root)) moduleTiles.put(root, new ArrayList<ClsDashBoardBean>());
            moduleTiles.get(root).add(bean);
        }

        moduleList.addAll(moduleTiles.keySet());
        if(selectedModule == null || !moduleTiles.containsKey(selectedModule)) {
            selectedModule = moduleList.isEmpty() ? "" : moduleList.get(0);
        }
        if(moduleTiles.containsKey(selectedModule)) tileList = moduleTiles.get(selectedModule);
    } catch(Exception e) { e.printStackTrace(); }
    finally {
        try { if(rs!=null) rs.close(); } catch(Exception ignore) {}
        try { if(pstmt!=null) pstmt.close(); } catch(Exception ignore) {}
        try { if(conn!=null) conn.close(); } catch(Exception ignore) {}
    }
%>
<%!
    private static String esc(String s) {
        if(s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript" src="<%= cPath %>/scripts/jquery-1.11.1.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body, html { min-height: 100vh; margin: 0; padding: 0; overflow-y: auto; font-family: "Segoe UI", Roboto, sans-serif; background-color: #f4f6f9; }
        ::-webkit-scrollbar { width: 4px; height: 4px; }
        ::-webkit-scrollbar-thumb { background: #bbb; border-radius: 10px; }

        .page-container { display: flex; flex-direction: column; width: 100%; min-height: 100vh; padding-bottom: 50px; }

        .banner { flex: 0 0 140px; background-image: url("<%= cPath %>/icons/banner_image.png"); background-size: cover; background-position: center; margin: 10px 15px; border-radius: 8px; position: relative; display: flex; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .banner::before { content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.2); border-radius: 8px; }
        .banner-content { z-index: 2; color: #fff; text-shadow: 1px 1px 3px rgba(0,0,0,0.5); }
        
        .welcome-main, #greeting { font-size: 26px; font-weight: 700; margin: 2px 0; }

        .dashboard-grid { display: grid; grid-template-columns: 1fr 1.6fr; gap: 15px; padding: 0 15px; margin-bottom: 15px; }

        .grid-box { background: #fff; border-radius: 6px; border: 1px solid #e0e0e0; display: flex; flex-direction: column; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }

        .header-bar { flex: 0 0 auto; padding: 12px 15px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; background: #fff; }
        .header-title { font-weight: 700; color: #444; font-size: 16px; text-transform: uppercase; }

        .header-search input { 
            padding: 6px 12px; border: 1px solid #ddd; border-radius: 15px; outline: none; width: 130px; font-size: 13px; 
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1), border-color 0.3s; background-color: #f9f9f9; 
        }
        .header-search input:hover { border-color: #007bff; }
        .header-search input:focus { 
            width: 220px; border-color: #007bff; background-color: #fff; 
            box-shadow: 0 0 8px rgba(0,123,255,0.2); 
        }

        .scrollable-content { flex: 1; overflow-y: auto; padding: 0; max-height: 192px; min-height: 192px; }
        .top-scrollable { max-height: 350px; min-height: 350px; padding: 12px; }

        .dashboard-tile-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(115px, 1fr)); gap: 12px; }
        .dashboard-tile { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 10px; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 95px; transition: 0.2s; cursor: pointer; text-decoration: none !important; }
        .dashboard-tile:hover { transform: translateY(-3px); box-shadow: 0 5px 10px rgba(0,0,0,0.05); border-color: #007bff; }
        .tile-icon-box { width: 28px; height: 28px; margin-bottom: 8px; }
        .tile-icon-box svg { width: 100%; height: 100%; }
        .tile-title { font-size: 11px; font-weight: 600; text-align: center; color: #555; }

        .ann-item { display: flex; gap: 12px; padding: 15px 0; border-bottom: 1px solid #f2f2f2; }
        .ann-img-box img { width: 100px; height: 70px; border-radius: 4px; object-fit: cover; display: block; }
        .ann-body { flex: 1; }
        .ann-body h4 { margin: 0 0 4px 0; font-size: 13px; color: #333; font-weight: 700; }
        .ann-body p { margin: 0; font-size: 11px; color: #666; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .ann-footer { padding: 12px 0; text-align: center; }
        .ann-footer a { font-size: 12px; font-weight: 700; color: #007bff; text-decoration: none; }
        
        .home-dropdown { position: relative; display: inline-block; margin-left: 20px; z-index: 1000; }
        .dropbtn { background-color: rgba(255, 255, 255, 0.2); color: white; padding: 8px 16px; font-size: 13px; font-weight: 600; border: 1px solid rgba(255, 255, 255, 0.4); border-radius: 4px; cursor: pointer; display: flex; align-items: center; gap: 8px; }
        .dropbtn:hover { background-color: rgba(255, 255, 255, 0.3); }
        .dropdown-content { display: none; position: absolute; background-color: #f9f9f9; min-width: 200px; box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2); border-radius: 4px; top: 40px; }
        .dropdown-content a { color: #333; padding: 12px 16px; text-decoration: none; display: block; font-size: 13px; border-bottom: 1px solid #eee; }
        .dropdown-content a:last-child { border-bottom: none; }
        .dropdown-content a:hover { background-color: #f1f1f1; color: #007bff; }
        .home-dropdown:hover .dropdown-content { display: block; }

        .tile-nav-container { background: #f8f9fa; border-bottom: 1px solid #eee; padding: 6px 12px; }
        .tile-nav-links { display: flex; gap: 8px; overflow-x: auto; padding-bottom: 2px; }
        .tile-nav-links a { font-size: 11px; font-weight: 700; color: #666; text-decoration: none; padding: 6px 12px; border-radius: 4px; white-space: nowrap; transition: 0.2s; }
        .tile-nav-links a.active { background: #007bff; color: #fff; }
    </style>
</head>
<body>

<div class="page-container">
<div class="banner">
    <div class="banner-content" style="display: flex; align-items: center; width: 100%; justify-content: space-between;">
        <div>
            <div class="welcome-main">Welcome ${sessionScope.USERNAME}</div>
            <div id="greeting"></div>
        </div>

        <div class="home-dropdown">
            <button class="dropbtn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 8px;">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
                <span>Switch Dashboard</span>
                <span style="font-size: 10px; margin-left: 8px;">▼</span>
            </button>
            <div class="dropdown-content">
                <a href="<%= cPath %>/com/dashboard/dashBoardTiles.jsp">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                        <div>
                            <strong>Standard View</strong><br>
                            <small style="color: #888;">Tile Dashboard</small>
                        </div>
                    </div>
                </a>
                
                <a href="<%= cPath %>/com/v2/dashBoardnew.jsp">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#007bff" stroke-width="2"><path d="M3 3h18v18H3z"></path><path d="M21 9H3"></path><path d="M21 15H3"></path><path d="M12 3v18"></path></svg>
                        <div>
                            <strong>My Dashboard</strong><br>
                            <small style="color: #888;">New Home Layout</small>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>

    <div class="dashboard-grid">
        <div class="grid-box">
            <div class="header-bar">
                <div class="header-title" style="display: flex; align-items: center; gap: 12px;">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11 5L6 9H2V15H6L11 19V5Z" stroke="#0056b3" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M15.54 8.46002C16.4774 9.39764 17.004 10.6692 17.004 11.995C17.004 13.3208 16.4774 14.5924 15.54 15.53" stroke="#0056b3" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    <span style="font-size: 14px; font-weight: 700; color: #444;">Announcements</span>
                </div>
            </div>
            <div class="scrollable-content top-scrollable">
                <div class="ann-item">
                    <div class="ann-img-box"><img src="<%=request.getContextPath()%>/com/dashboard/pics/1.jfif" alt="img"></div>
                    <div class="ann-body"><h4>Belonging & Diversity Town Hall</h4><p>Listen to our Chief Diversity Officer...</p></div>
                </div>
                <div class="ann-item">
                    <div class="ann-img-box"><img src="<%=request.getContextPath()%>/com/dashboard/pics/2.jfif" alt="img"></div>
                    <div class="ann-body"><h4>Good People Know Good People</h4><p>Refer a candidate today!</p></div>
                </div>
                <div class="ann-item">
                    <div class="ann-img-box"><img src="<%=request.getContextPath()%>/com/dashboard/pics/3.jfif" alt="img"></div>
                    <div class="ann-body"><h4>Company Picnic!</h4><p>You and your family are cordially invited...</p></div>
                </div>
                <div class="ann-item">
                    <div class="ann-img-box"><img src="<%=request.getContextPath()%>/com/dashboard/pics/1.jfif" alt="img"></div>
                    <div class="ann-body"><h4>Policy Updates</h4><p>Important updates regarding safety protocols.</p></div>
                </div>
                <div class="ann-footer" style="text-align:center; padding:10px;"><a href="#" style="color:#007bff; font-weight:700; font-size:12px;">View More</a></div>
            </div>
        </div>

        <div class="grid-box">
            <div class="header-bar">
                <div class="header-title">Module Tiles</div>
                <div class="header-search"><input type="text" onkeyup="filterTiles(this)" placeholder="Search..."></div>
            </div>
            <div class="tile-nav-container">
                <div class="tile-nav-links">
                    <% for(String mod : moduleList) { %>
                        <a href="?module=<%= URLEncoder.encode(mod, "UTF-8") %>" class="<%= mod.equals(selectedModule) ? "active" : "" %>"><%= esc(mod.trim()) %></a>
                    <% } %>
                </div>
            </div>
            <div class="scrollable-content top-scrollable">
                <div class="dashboard-tile-container">
                    <% for(ClsDashBoardBean t : tileList) { %>
                        <a href="javascript:void(0);" data-title="<%= esc(t.getTxttitle()) %>" onclick="openParentMenu(this.getAttribute('data-title'))" class="dashboard-tile">
                            <div class="tile-icon-box"><%= t.getMsg() %></div>
                            <div class="tile-title"><%= esc(t.getTxttitle()) %></div>
                        </a>
                    <% } %>
                    <% if(tileList.isEmpty()) { %>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #999; font-size: 13px;">No operations available for this module.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var h = new Date().getHours();
        $("#greeting").text((h < 12) ? "Good Morning" : (h < 18) ? "Good Afternoon" : "Good Evening");
    });

    function filterTiles(el) {
        var val = el.value.toUpperCase().replace(/\s+/g, '');
        $(".dashboard-tile").each(function() {
            var txt = $(this).find(".tile-title").text().toUpperCase().replace(/\s+/g, '');
            $(this).toggle(txt.indexOf(val) > -1);
        });
    }

    function openParentMenu(title) { 
        if(window.parent && window.parent.geturl) window.parent.geturl(title); 
    }
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dashboard.ClsDashBoardDAO" %>
<%@ page import="net.sf.json.JSONArray" %>

<%
    String cPath = request.getContextPath();
    String selectedModule = request.getParameter("module");
    if(selectedModule == null || selectedModule.trim().isEmpty()){ selectedModule = "Finance"; }

    ClsDashBoardDAO tileDao = new ClsDashBoardDAO();

    // Ajax handling logic for opening App Details
    String ajaxId = request.getParameter("ajaxId");
    if(ajaxId != null && !ajaxId.trim().isEmpty()) {
        out.clear(); 
        try {
            JSONArray jsonResult = tileDao.detailSearch(ajaxId, session);
            out.print((jsonResult == null || jsonResult.isEmpty()) ? "[]" : jsonResult.toString());
        } catch (Exception e) { out.print("[]"); }
        return; 
    }

    // Fetch initial grid and detail data
    JSONArray jsonArray = tileDao.masterSearch(session);
    String gridData = (jsonArray != null) ? jsonArray.toString() : "[]";
    JSONArray detailArray = tileDao.detail(session);
    String detailData = (detailArray != null) ? detailArray.toString() : "[]";
%>

<!DOCTYPE html>
<html>
<head>
    <script type="text/javascript" src="<%= cPath %>/scripts/jquery-1.11.1.min.js"></script>
    <style>
    * { box-sizing: border-box; }
    
    /* Make body take exact height and prevent outer scrolling */
    body, html { 
        height: 100%; 
        margin: 0; 
        padding: 0; 
        overflow: hidden; /* Stops the whole page from scrolling */
        font-family: "Segoe UI", Roboto, sans-serif; 
        background-color: #f4f6f9; 
    }
    
    ::-webkit-scrollbar { width: 4px; height: 4px; }
    ::-webkit-scrollbar-thumb { background: #bbb; border-radius: 10px; }

    /* Container fills the exact screen */
    .page-container { 
        height: 100%; 
        padding: 15px; 
        display: flex;
        flex-direction: column;
    }

    /* Grid fills available space */
    .bottom-grid { 
        display: grid; 
        grid-template-columns: 1fr 1fr 1fr; 
        gap: 15px; 
        flex: 1;
        min-height: 0; /* CRITICAL: Stops grid from growing past screen */
    }

    /* Boxes flex to fill grid cells, but don't grow past them */
    .grid-box { 
        background: #fff; 
        border-radius: 6px; 
        border: 1px solid #e0e0e0; 
        display: flex; 
        flex-direction: column; 
        box-shadow: 0 1px 2px rgba(0,0,0,0.05); 
        height: 100%;
        min-height: 0; /* CRITICAL: Forces scrollbar on child */
    }

    /* Keep headers static */
    .header-bar { 
        flex: 0 0 auto; 
        padding: 12px 15px; 
        border-bottom: 1px solid #f0f0f0; 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        background: #fff; 
    }
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

    /* Scrollable content inside the box */
    .scrollable-content { 
        flex: 1; 
        overflow-y: auto; 
        padding: 0; 
        min-height: 0; /* Ensures the container scrolls instead of growing */
    }

    .app-tile { display: flex; align-items: center; justify-content: space-between; padding: 0 15px; height: 48px; min-height: 48px; border-bottom: 1px solid #f9f9f9; cursor: pointer; transition: 0.2s; border-left: 3px solid transparent; }
    .app-tile:hover { background-color: #f8faff; transform: translateX(3px); color: #007bff; }
    .app-tile.active-selection { border-left-color: #007bff; background-color: #f0f7ff; color: #007bff; font-weight: 700; }
    .app-name { font-size: 14px; }
    .empty-label { padding: 20px; color: #999; text-align: center; font-size: 13px; }
</style>
</head>
<body>

<div class="page-container">
    <div class="bottom-grid">
        <div class="grid-box">
            <div class="header-bar">
                <div class="header-title">Application List</div>
                <div class="header-search"><input type="text" onkeyup="filterList(this, 'appListContainer')" placeholder="Search..."></div>
            </div>
            <div id="appListContainer" class="scrollable-content"></div>
        </div>

        <div class="grid-box">
            <div class="header-bar">
                <div class="header-title">Status & Updates</div>
                <div class="header-search"><input type="text" onkeyup="filterList(this, 'detailListContainer')" placeholder="Search..."></div>
            </div>
            <div id="detailListContainer" class="scrollable-content"></div>
        </div>

        <div class="grid-box">
            <div class="header-bar"><div class="header-title">Performance</div></div>
            <div class="scrollable-content"><div style="text-align:center; padding-top:40px; color:#bbb; font-weight:600;">SUMMARY</div></div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var appData = <%= gridData %>;
    var initialDetails = <%= detailData %>;
    var currentModuleDesc = '<%=selectedModule%>'; 

    $(document).ready(function () {
        var leftContainer = $("#appListContainer");
        $.each(appData, function(i, item) {
            var html = '<div class="app-tile" onclick="openAppDetail(' + i + ', this)">' +
                       '<div class="app-name">' + item.description + '</div>' +
                       '<div style="font-size:18px; opacity:0.3;">&#8250;</div></div>';
            leftContainer.append(html);
        });
        
        // Auto-select the first item on load if data exists
        if(appData.length > 0) {
            var firstTile = leftContainer.find(".app-tile").first();
            openAppDetail(0, firstTile);
        } else {
            renderRightPanel(initialDetails);
        }
    });

    function filterList(el, cont) {
        var val = el.value.toUpperCase().replace(/\s+/g, '');
        $("#" + cont + " .app-tile").each(function() {
            var txt = $(this).find(".app-name").text().toUpperCase().replace(/\s+/g, '');
            $(this).toggle(txt.indexOf(val) > -1);
        });
    }

    function openAppDetail(index, el) {
        var item = appData[index];
        $(".app-tile").removeClass("active-selection");
        $(el).addClass("active-selection");
        $("#detailListContainer").html("<div style='padding:20px; color:#999;'>Loading...</div>");
        
        // Perform an AJAX POST to itself
        $.ajax({
            url: window.location.href, type: "POST", data: { ajaxId: item.doc_no }, dataType: "json",
            success: function(response) { renderRightPanel(response, item.description); }
        });
    }

    function renderRightPanel(data, parentDesc) {
        var cont = $("#detailListContainer").empty();
        if (!data || data.length === 0) { cont.html("<div class='empty-label'>Select an app</div>"); return; }
        $.each(data, function(i, item) {
            var safeDetName = item.description.replace(/'/g, "\\'");
            var safeParentDesc = (parentDesc || currentModuleDesc).replace(/'/g, "\\'");
            var html = '<div class="app-tile" onclick="openDetailLink(\'' + safeDetName + '\', \'' + item.path + '\', \'' + item.doc_no + '\', \'' + safeParentDesc + '\', \'' + item.value + '\')">' +
                       '<div class="app-name">' + item.description + '</div><div style="font-size:18px; opacity:0.3;">&#8250;</div></div>';
            cont.append(html);
        });
    }

    function openDetailLink(detName, path, docno, mainDesc, val) {
        var url = window.location.href;
        var reurl = url.split("com/");
        var fullUrl = reurl[0] + "" + path + "?name=" + encodeURIComponent(detName) + "&main=" + encodeURIComponent(mainDesc) + "&docno=" + docno + "&value=" + val;
        
        if (typeof top.addTab === 'function') {
            top.addTab(detName, fullUrl);
        } else {
            window.parent.$('#tt').tabs('add', { title: detName, content: '<iframe scrolling="auto" frameborder="0" src="' + fullUrl + '" style="width:100%;height:100%;"></iframe>', closable: true });
        }
    }
</script>
</body>
</html>
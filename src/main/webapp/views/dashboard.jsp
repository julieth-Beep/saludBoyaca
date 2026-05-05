<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><fmt:message key='nav.dashboard'/> | SaludBoyacá</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --primary: #0D9488; --primary-dark: #0F766E; --primary-light: #14B8A6;
            --primary-soft: rgba(13,148,136,0.1); --primary-glow: rgba(13,148,136,0.2);
            --secondary: #6366F1; --secondary-soft: rgba(99,102,241,0.1);
            --success: #10B981; --success-soft: rgba(16,185,129,0.15);
            --warning: #F59E0B; --warning-soft: rgba(245,158,11,0.15);
            --danger: #EF4444; --danger-soft: rgba(239,68,68,0.15);
            --info: #3B82F6; --info-soft: rgba(59,130,246,0.15);
            --glass-bg: rgba(255,255,255,0.9); --glass-border: rgba(255,255,255,0.75);
            --glass-blur: blur(20px); --glass-shadow: 0 8px 32px rgba(0,0,0,0.1);
            --font-primary: 'Inter', sans-serif; --font-display: 'Plus Jakarta Sans', sans-serif;
            --text-primary: #0F172A; --text-secondary: #334155; --text-muted: #64748B;
            --bg-canvas: linear-gradient(135deg, #F0F9FF 0%, #F5F3FF 50%, #F0FDFA 100%);
            --border-subtle: rgba(148,163,184,0.3);
            --radius-sm: 10px; --radius-md: 16px; --radius-lg: 24px; --radius-xl: 32px;
            --shadow-sm: 0 4px 12px rgba(0,0,0,0.06); --shadow-md: 0 8px 24px rgba(0,0,0,0.08);
            --shadow-lg: 0 16px 48px rgba(0,0,0,0.12); --shadow-glow: 0 0 40px rgba(13,148,136,0.25);
            --transition-fast: 150ms cubic-bezier(0.4,0,0.2,1);
            --transition-normal: 250ms cubic-bezier(0.4,0,0.2,1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-primary); background: var(--bg-canvas); background-attachment: fixed; color: var(--text-secondary); line-height: 1.6; -webkit-font-smoothing: antialiased; min-height: 100vh; overflow-x: hidden; }

        .bg-decoration { position: fixed; pointer-events: none; z-index: 0; opacity: 0.4; }
        .bg-orb { border-radius: 50%; filter: blur(80px); animation: float 20s ease-in-out infinite; }
        .orb-1 { width: 500px; height: 500px; background: linear-gradient(135deg, #99F6E4, transparent); top: -150px; right: -100px; }
        .orb-2 { width: 400px; height: 400px; background: linear-gradient(135deg, #A5F3FC, transparent); bottom: -100px; left: 10%; animation-delay: -7s; }
        .bg-grid { position: fixed; inset: 0; background-image: linear-gradient(rgba(13,148,136,0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(13,148,136,0.03) 1px, transparent 1px); background-size: 60px 60px; pointer-events: none; z-index: 0; }
        @keyframes float { 0%,100% { transform: translate(0,0) scale(1); } 50% { transform: translate(40px,-40px) scale(1.1); } }

        .app-wrapper { display: flex; min-height: 100vh; position: relative; z-index: 1; }

        /* ===== SIDEBAR ===== */
        .sidebar { width: 280px; position: fixed; height: 100vh; z-index: 100; display: flex; flex-direction: column; background: var(--glass-bg); backdrop-filter: var(--glass-blur); border-right: 1px solid var(--border-subtle); box-shadow: 4px 0 24px rgba(0,0,0,0.06); transition: transform var(--transition-normal); }
        .sidebar-header { padding: 28px 24px; border-bottom: 2px solid var(--border-subtle); background: linear-gradient(135deg, rgba(13,148,136,0.05), transparent); }
        .brand { display: flex; align-items: center; gap: 16px; text-decoration: none; }
        .brand-logo { width: 52px; height: 52px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; box-shadow: 0 8px 24px var(--primary-glow); position: relative; overflow: hidden; }
        .brand-logo::after { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, rgba(255,255,255,0.3), transparent); }
        .brand-text h1 { font-family: var(--font-display); font-size: 1.5rem; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em; margin: 0; }
        .brand-text span { font-size: 0.8rem; color: var(--text-muted); font-weight: 500; display: block; margin-top: 2px; }
        .nav-container { flex: 1; padding: 24px 16px; overflow-y: auto; }
        .nav-section { margin-bottom: 28px; }
        .nav-section-title { font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.1em; padding: 0 20px 12px; display: flex; align-items: center; gap: 8px; }
        .nav-section-title::before { content: ''; width: 24px; height: 2px; background: linear-gradient(90deg, var(--primary), transparent); border-radius: 2px; }
        .nav-list { list-style: none; }
        .nav-item { margin: 4px 0; }
        .nav-link { display: flex; align-items: center; gap: 14px; padding: 14px 20px; margin: 0 8px; border-radius: var(--radius-md); color: var(--text-secondary); text-decoration: none; font-size: 0.95rem; font-weight: 500; transition: all var(--transition-fast); position: relative; overflow: hidden; }
        .nav-link::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 0; background: linear-gradient(180deg, var(--primary), var(--primary-light)); border-radius: 0 var(--radius-sm) var(--radius-sm) 0; transition: height var(--transition-fast); }
        .nav-link::after { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, var(--primary-soft), transparent); opacity: 0; transition: opacity var(--transition-fast); }
        .nav-link:hover { color: var(--primary); transform: translateX(4px); }
        .nav-link:hover::before { height: 60%; } .nav-link:hover::after { opacity: 1; }
        .nav-link.active { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; font-weight: 600; box-shadow: 0 4px 16px var(--primary-glow); }
        .nav-link.active::before { height: 70%; background: linear-gradient(180deg, white, rgba(255,255,255,0.8)); }
        .nav-link i { width: 22px; text-align: center; font-size: 1.1rem; position: relative; z-index: 1; }
        .nav-link span { position: relative; z-index: 1; }
        .sidebar-footer { padding: 20px; border-top: 2px solid var(--border-subtle); background: linear-gradient(to top, rgba(248,250,252,0.95), transparent); }
        .user-card { background: linear-gradient(135deg, rgba(13,148,136,0.1), rgba(99,102,241,0.1)); border: 2px solid var(--border-subtle); border-radius: var(--radius-lg); padding: 16px; transition: var(--transition-fast); }
        .user-card:hover { border-color: var(--primary); box-shadow: 0 4px 16px var(--primary-glow); }
        .user-info { display: flex; align-items: center; gap: 14px; margin-bottom: 14px; }
        .user-avatar { width: 48px; height: 48px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.1rem; box-shadow: 0 4px 16px var(--primary-glow); flex-shrink: 0; }
        .user-details { flex: 1; min-width: 0; }
        .user-name { font-weight: 600; color: var(--text-primary); font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role { font-size: 0.8rem; color: var(--text-muted); display: flex; align-items: center; gap: 6px; margin-top: 2px; }
        .user-role i { color: var(--success); font-size: 0.6rem; animation: pulse 2s ease-in-out infinite; }
        @keyframes pulse { 0%,100% { opacity:1; } 50% { opacity:0.5; } }
        .btn-logout { width: 100%; padding: 12px; background: white; border: 2px solid var(--border-subtle); border-radius: var(--radius-md); color: var(--danger); font-weight: 600; font-size: 0.9rem; cursor: pointer; transition: var(--transition-fast); text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-logout:hover { background: var(--danger); color: white; border-color: var(--danger); transform: translateY(-2px); box-shadow: 0 4px 16px rgba(239,68,68,0.3); }

        /* ===== MAIN CONTENT ===== */
        .main-content { flex: 1; margin-left: 280px; padding: 32px 40px; }

        /* ===== TOP BAR ===== */
        .top-bar { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); padding: 24px 32px; margin-bottom: 32px; box-shadow: var(--glass-shadow); display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
        .top-bar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--primary), var(--secondary), var(--primary)); background-size: 200% 100%; animation: shimmer 3s linear infinite; }
        @keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }
        .page-header { display: flex; align-items: center; gap: 16px; }
        .page-icon { width: 56px; height: 56px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; box-shadow: 0 8px 24px var(--primary-glow); }
        .page-title { font-family: var(--font-display); font-size: 1.8rem; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em; margin: 0; }
        .page-subtitle { font-size: 0.95rem; color: var(--text-muted); margin-top: 2px; font-weight: 500; }
        .top-actions { display: flex; align-items: center; gap: 12px; }
        .lang-switch { display: flex; gap: 4px; background: white; padding: 4px; border-radius: var(--radius-md); border: 2px solid var(--border-subtle); }
        .lang-btn { padding: 8px 14px; border: none; background: transparent; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; transition: var(--transition-fast); font-size: 0.82rem; text-decoration: none; color: var(--text-muted); display: flex; align-items: center; gap: 5px; }
        .lang-btn.active { background: var(--primary); color: white; box-shadow: 0 2px 8px var(--primary-glow); }
        .lang-btn:hover:not(.active) { background: var(--border-subtle); color: var(--text-primary); }

        /* ===== KPI CARDS ===== */
        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
        .kpi-card { position: relative; padding: 28px; border-radius: var(--radius-lg); background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); box-shadow: var(--glass-shadow); overflow: hidden; transition: var(--transition-normal); cursor: pointer; display: flex; align-items: flex-start; gap: 18px; }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg), var(--shadow-glow); }
        .kpi-icon { width: 56px; height: 56px; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; flex-shrink: 0; }
        .kpi-icon.appointments { background: linear-gradient(135deg, #22D3EE, #06B6D4); color: white; }
        .kpi-icon.patients { background: linear-gradient(135deg, #818CF8, #6366F1); color: white; }
        .kpi-icon.staff { background: linear-gradient(135deg, #4ADE80, #22C55E); color: white; }
        .kpi-icon.urgent { background: linear-gradient(135deg, #F87171, #EF4444); color: white; }
        .kpi-content { flex: 1; }
        .kpi-value { font-family: var(--font-display); font-size: 2.2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .kpi-label { font-size: 0.9rem; color: var(--text-muted); margin-top: 4px; font-weight: 500; }
        .kpi-trend { display: inline-flex; align-items: center; gap: 5px; font-size: 0.8rem; font-weight: 600; margin-top: 10px; padding: 5px 12px; border-radius: var(--radius-full); background: rgba(16,185,129,0.12); color: var(--success); }
        .kpi-trend.decrease { background: rgba(239,68,68,0.12); color: var(--danger); }

        /* ===== DASHBOARD GRID ===== */
        .dashboard-grid { display: grid; grid-template-columns: repeat(12, 1fr); gap: 20px; }
        .card { padding: 26px; background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); box-shadow: var(--glass-shadow); }
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 22px; padding-bottom: 18px; border-bottom: 1px solid var(--border-subtle); }
        .card-title { font-family: var(--font-display); font-size: 1.15rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 10px; }
        .card-title i { color: var(--primary); }
        .card-subtitle { font-size: 0.85rem; color: var(--text-muted); margin-top: 3px; }
        .btn-primary-btn { padding: 10px 18px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: all var(--transition-fast); display: flex; align-items: center; gap: 6px; box-shadow: 0 4px 16px var(--primary-glow); text-decoration: none; }
        .btn-primary-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow); color: white; }
        .col-span-5 { grid-column: span 5; }
        .col-span-7 { grid-column: span 7; }
        .col-span-8 { grid-column: span 8; }
        .col-span-12 { grid-column: span 12; }

        /* ===== APPOINTMENTS ===== */
        .appointments-list { display: flex; flex-direction: column; gap: 10px; max-height: 350px; overflow-y: auto; }
        .appointment-item { display: flex; align-items: center; gap: 14px; padding: 14px 16px; border-radius: var(--radius-md); background: var(--bg-surface-alt); border: 1px solid var(--border-subtle); transition: all var(--transition-fast); cursor: pointer; }
        .appointment-item:hover { background: white; border-color: var(--primary); transform: translateX(3px); }
        .appointment-time { min-width: 65px; text-align: center; padding: 8px 10px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; font-weight: 700; font-size: 0.85rem; }
        .appointment-info { flex: 1; }
        .appointment-patient { font-weight: 600; color: var(--text-primary); font-size: 0.9rem; }
        .appointment-meta { font-size: 0.8rem; color: var(--text-muted); margin-top: 2px; display: flex; align-items: center; gap: 8px; }
        .appointment-status { padding: 5px 12px; border-radius: var(--radius-full); font-size: 0.7rem; font-weight: 700; text-transform: uppercase; }
        .status-confirmed { background: rgba(16,185,129,0.12); color: var(--success); }
        .status-pending { background: rgba(245,158,11,0.12); color: var(--warning); }

        /* ===== QUICK ACTIONS ===== */
        .quick-actions { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
        .action-card { display: flex; flex-direction: column; align-items: center; gap: 10px; padding: 18px 14px; border-radius: var(--radius-md); background: var(--bg-surface-alt); border: 1px solid var(--border-subtle); text-decoration: none; color: var(--text-secondary); transition: all var(--transition-fast); text-align: center; }
        .action-card:hover { background: white; border-color: var(--primary); color: var(--primary); transform: translateY(-2px); }
        .action-icon { width: 48px; height: 48px; border-radius: var(--radius-md); background: white; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: var(--primary); box-shadow: var(--shadow-sm); transition: transform var(--transition-fast); }
        .action-card:hover .action-icon { transform: scale(1.1); background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; }

        /* ===== STAFF ===== */
        .staff-list { display: flex; flex-direction: column; gap: 10px; }
        .staff-item { display: flex; align-items: center; gap: 12px; padding: 12px; border-radius: var(--radius-md); background: var(--bg-surface-alt); transition: background var(--transition-fast); }
        .staff-item:hover { background: white; }
        .staff-avatar { width: 42px; height: 42px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.85rem; position: relative; flex-shrink: 0; }
        .staff-avatar::after { content: ''; position: absolute; bottom: 2px; right: 2px; width: 10px; height: 10px; border-radius: 50%; border: 2px solid white; background: var(--success); }
        .staff-avatar.busy::after { background: var(--warning); }
        .staff-info { flex: 1; }
        .staff-name { font-weight: 600; color: var(--text-primary); font-size: 0.9rem; }
        .staff-specialty { font-size: 0.75rem; color: var(--text-muted); }
        .staff-status { display: flex; align-items: center; gap: 6px; font-size: 0.75rem; color: var(--text-secondary); }
        .status-indicator { width: 8px; height: 8px; border-radius: 50%; background: var(--success); }
        .status-indicator.busy { background: var(--warning); }

        @media (max-width: 1400px) { .kpi-grid { grid-template-columns: repeat(2,1fr); } .col-span-5,.col-span-7,.col-span-8 { grid-column: span 6; } }
        @media (max-width: 1100px) { .sidebar { transform: translateX(-100%); } .sidebar.active { transform: translateX(0); } .main-content { margin-left: 0; padding: 20px; } .col-span-5,.col-span-7,.col-span-8,.col-span-12 { grid-column: span 12; } }
        @media (max-width: 768px) { .kpi-grid { grid-template-columns: 1fr; } .top-bar { flex-direction: column; gap: 16px; align-items: stretch; } }
        .mobile-toggle { display: none; position: fixed; bottom: 28px; right: 28px; width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; box-shadow: var(--shadow-lg); z-index: 999; cursor: pointer; font-size: 1.3rem; align-items: center; justify-content: center; }
        @media (max-width: 1100px) { .mobile-toggle { display: flex; } }
        ::-webkit-scrollbar { width: 6px; } ::-webkit-scrollbar-thumb { background: rgba(148,163,184,0.35); border-radius: 10px; }
        @keyframes fadeInUp { from { opacity:0; transform: translateY(20px); } to { opacity:1; transform: translateY(0); } }
        .animate-enter { animation: fadeInUp 0.5s ease forwards; opacity: 0; }
        .animate-enter:nth-child(1){animation-delay:0.05s}.animate-enter:nth-child(2){animation-delay:0.1s}.animate-enter:nth-child(3){animation-delay:0.15s}.animate-enter:nth-child(4){animation-delay:0.2s}
    </style>
</head>
<body>
    <div class="bg-grid"></div>
    <div class="bg-decoration bg-orb orb-1"></div>
    <div class="bg-decoration bg-orb orb-2"></div>

    <div class="app-wrapper">
        <!-- SIDEBAR -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <div class="brand-logo"><i class="fas fa-heart-pulse"></i></div>
                    <div class="brand-text"><h1>SaludBoyacá</h1><span>Sistema Clínico</span></div>
                </a>
            </div>
            <nav class="nav-container">
                <div class="nav-section">
                    <div class="nav-section-title"><fmt:message key='nav.principal'/></div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link active"><i class="fas fa-chart-pie"></i><span><fmt:message key='nav.dashboard'/></span></a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title"><fmt:message key='nav.gestion.clinica'/></div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/pacientes" class="nav-link"><i class="fas fa-users"></i><span><fmt:message key='nav.pacientes'/></span></a></li>
                        <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/citas" class="nav-link"><i class="fas fa-calendar-check"></i><span><fmt:message key='nav.citas'/></span></a></li>
                        </c:if>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/horarios" class="nav-link"><i class="fas fa-clock"></i><span><fmt:message key='nav.horarios'/></span></a></li>
                    </ul>
                </div>
            </nav>
            <div class="sidebar-footer">
                <div class="user-card">
                    <div class="user-info">
                        <div class="user-avatar"><c:choose><c:when test="${not empty sessionScope.usuarioNombre}">${sessionScope.usuarioNombre.charAt(0)}</c:when><c:otherwise>U</c:otherwise></c:choose></div>
                        <div class="user-details"><div class="user-name"><c:out value="${sessionScope.usuarioNombre}" default="Usuario"/></div><div class="user-role"><i class="fas fa-circle"></i> <c:out value="${sessionScope.usuarioRol}" default="Invitado"/></div></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> <fmt:message key='nav.salir'/></a>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- TOP BAR -->
            <div class="top-bar">
                <div class="page-header">
                    <div class="page-icon"><i class="fas fa-chart-pie"></i></div>
                    <div>
                        <h1 class="page-title"><fmt:message key='nav.dashboard'/></h1>
                        <p class="page-subtitle"><fmt:message key='dashboard.bienvenida'><fmt:param value="${sessionScope.usuarioNombre}"/></fmt:message></p>
                    </div>
                </div>
                <div class="top-actions">
                    <div class="lang-switch">
                        <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                        <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                        <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                    </div>
                </div>
            </div>

            <!-- KPI CARDS -->
            <div class="kpi-grid">
                <div class="kpi-card animate-enter">
                    <div class="kpi-icon appointments"><i class="fas fa-calendar-alt"></i></div>
                    <div class="kpi-content">
                        <div class="kpi-value"><c:out value="${citasHoy}" default="24"/></div>
                        <div class="kpi-label"><fmt:message key='dashboard.citas.hoy'/></div>
                        <span class="kpi-trend"><i class="fas fa-arrow-up"></i> 12% vs ayer</span>
                    </div>
                </div>
                <div class="kpi-card animate-enter">
                    <div class="kpi-icon urgent"><i class="fas fa-exclamation-triangle"></i></div>
                    <div class="kpi-content">
                        <div class="kpi-value"><c:out value="${citasPendientes}" default="8"/></div>
                        <div class="kpi-label"><fmt:message key='dashboard.citas.pendientes'/></div>
                        <span class="kpi-trend decrease">Requieren atención</span>
                    </div>
                </div>
                <div class="kpi-card animate-enter">
                    <div class="kpi-icon staff"><i class="fas fa-chart-bar"></i></div>
                    <div class="kpi-content">
                        <div class="kpi-value"><c:out value="${citasMes}" default="156"/></div>
                        <div class="kpi-label"><fmt:message key='dashboard.citas.mes'/></div>
                        <span class="kpi-trend"><i class="fas fa-arrow-up"></i> 8% este mes</span>
                    </div>
                </div>
                <div class="kpi-card animate-enter">
                    <div class="kpi-icon patients"><i class="fas fa-users"></i></div>
                    <div class="kpi-content">
                        <div class="kpi-value"><c:out value="${totalPacientes}" default="1250"/></div>
                        <div class="kpi-label"><fmt:message key='dashboard.pacientes.total'/></div>
                        <span class="kpi-trend"><fmt:message key='total.sistema'/></span>
                    </div>
                </div>
            </div>

            <!-- DASHBOARD GRID -->
            <div class="dashboard-grid">
                <div class="card col-span-7 animate-enter">
                    <div class="card-header">
                        <div><h3 class="card-title"><i class="fas fa-clock"></i> <fmt:message key='dashboard.proximas.citas'/></h3></div>
                        <a href="${pageContext.request.contextPath}/citas" class="btn-primary-btn">Ver todas <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <div class="appointments-list">
                        <div class="appointment-item"><div class="appointment-time">09:30</div><div class="appointment-info"><div class="appointment-patient">Luis Antonio Mora</div><div class="appointment-meta"><span><i class="fas fa-stethoscope"></i> Medicina General</span></div></div><span class="appointment-status status-confirmed"><fmt:message key='cita.estado.confirmada'/></span></div>
                        <div class="appointment-item"><div class="appointment-time">10:15</div><div class="appointment-info"><div class="appointment-patient">Rosa Elena Cárdenas</div><div class="appointment-meta"><span><i class="fas fa-tooth"></i> Odontología</span></div></div><span class="appointment-status status-pending"><fmt:message key='cita.estado.programada'/></span></div>
                    </div>
                </div>

                <!-- ACCIONES RÁPIDAS -->
                <div class="card col-span-5 animate-enter">
                    <c:if test="${sessionScope.usuarioRol == 'MEDICO'}">
                    <div class="card-header"><h3 class="card-title"><i class="fas fa-bolt"></i> <fmt:message key='dashboard.acciones.rapidas'/></h3></div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="action-card"><div class="action-icon"><i class="fas fa-plus-circle"></i></div><span class="action-label"><fmt:message key='cita.nueva'/></span></a>
                        <a href="${pageContext.request.contextPath}/horarios" class="action-card"><div class="action-icon"><i class="fas fa-clock"></i></div><span class="action-label"><fmt:message key='nav.horarios'/></span></a>
                    </div>
                    </c:if>
                    <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                    <div class="card-header"><h3 class="card-title"><i class="fas fa-bolt"></i> <fmt:message key='dashboard.acciones.rapidas'/></h3></div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="action-card"><div class="action-icon"><i class="fas fa-plus-circle"></i></div><span class="action-label"><fmt:message key='cita.nueva'/></span></a>
                        <a href="${pageContext.request.contextPath}/pacientes?accion=nuevo" class="action-card"><div class="action-icon"><i class="fas fa-user-plus"></i></div><span class="action-label"><fmt:message key='paciente.nuevo'/></span></a>
                    </div>
                    </c:if>
                    <c:if test="${sessionScope.usuarioRol == 'ENFERMERO'}">
                    <p style="color:var(--text-muted);text-align:center;padding:10px;"><i class="fas fa-eye"></i> Visualización de estadísticas</p>
                    </c:if>
                </div>

                <!-- ALERTAS -->
                <div class="card col-span-12 animate-enter">
                    <div class="card-header"><h3 class="card-title"><i class="fas fa-bell"></i> <fmt:message key='dashboard.alertas'/></h3></div>
                    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:14px;">
                        <div style="padding:16px;border-radius:12px;border-left:4px solid var(--danger);background:white;"><strong><fmt:message key='dashboard.alerta.sin.confirmar'/></strong><p style="font-size:0.8rem;color:var(--text-muted);"><fmt:message key='dashboard.alerta.sin.confirmar.desc'/></p></div>
                        <div style="padding:16px;border-radius:12px;border-left:4px solid var(--primary);background:white;"><strong><fmt:message key='dashboard.alerta.horarios'/></strong><p style="font-size:0.8rem;color:var(--text-muted);"><fmt:message key='dashboard.alerta.horarios.desc'/></p></div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <script>function toggleSidebar(){document.getElementById('sidebar').classList.toggle('active');}</script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>
</html>
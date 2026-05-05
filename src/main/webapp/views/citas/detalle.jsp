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
    <title><fmt:message key="cita.detalle"/> | SaludBoyacá</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
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

        .top-bar { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); padding: 24px 32px; margin-bottom: 24px; box-shadow: var(--glass-shadow); display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
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

        /* ===== DETAIL CARD GLASSMORPHISM ===== */
        .detail-card {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: var(--glass-shadow);
            overflow: hidden;
            max-width: 780px;
        }

        .detail-card-header {
            padding: 20px 28px;
            background: linear-gradient(135deg, rgba(13,148,136,0.08), rgba(99,102,241,0.05));
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .cita-id { font-family: var(--font-display); font-size: 1.2rem; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 8px; }

        .badge { display: inline-flex; align-items: center; gap: 6px; padding: 7px 16px; border-radius: var(--radius-full); font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.03em; }
        .badge-programada { background: var(--warning-soft); color: #B45309; border: 1px solid rgba(245,158,11,0.3); }
        .badge-confirmada { background: var(--success-soft); color: #065F46; border: 1px solid rgba(16,185,129,0.3); }
        .badge-atendida { background: var(--info-soft); color: #1E40AF; border: 1px solid rgba(59,130,246,0.3); }
        .badge-cancelada { background: var(--danger-soft); color: #991B1B; border: 1px solid rgba(239,68,68,0.3); }

        .detail-section { padding: 24px 28px; border-bottom: 1px solid var(--border-subtle); }
        .detail-section:last-child { border-bottom: none; }

        .section-title { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--primary); margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }

        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .detail-item { display: flex; flex-direction: column; gap: 4px; }
        .detail-label { font-size: 0.75rem; color: var(--text-muted); font-weight: 500; }
        .detail-value { font-size: 0.92rem; font-weight: 600; color: var(--text-primary); }
        .detail-value.muted { font-weight: 400; color: var(--text-muted); }

        .detail-actions {
            padding: 20px 28px;
            background: linear-gradient(135deg, rgba(13,148,136,0.03), transparent);
            border-top: 1px solid var(--border-subtle);
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 10px 20px; border-radius: var(--radius-md);
            font-size: 0.88rem; font-weight: 600; cursor: pointer;
            text-decoration: none; border: none; transition: var(--transition-fast);
            font-family: inherit;
        }
        .btn-ghost { background: white; border: 1px solid var(--border-subtle); color: var(--text-secondary); }
        .btn-ghost:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-soft); }
        .btn-success { background: var(--success-soft); color: #065F46; border: 1px solid rgba(16,185,129,0.3); }
        .btn-success:hover { background: var(--success); color: white; border-color: var(--success); }
        .btn-info { background: var(--info-soft); color: #1E40AF; border: 1px solid rgba(59,130,246,0.3); }
        .btn-info:hover { background: var(--info); color: white; border-color: var(--info); }
        .btn-danger { background: var(--danger-soft); color: #991B1B; border: 1px solid rgba(239,68,68,0.3); }
        .btn-danger:hover { background: var(--danger); color: white; border-color: var(--danger); }
        .btn-back {
            padding: 10px 20px;
            border-radius: var(--radius-md);
            background: var(--primary);
            color: white;
            font-size: 0.88rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition-fast);
            box-shadow: 0 4px 14px var(--primary-glow);
        }
        .btn-back:hover { background: var(--primary-dark); transform: translateY(-2px); color: white; }

        @media (max-width: 1100px) { .sidebar { transform: translateX(-100%); } .sidebar.active { transform: translateX(0); } .main-content { margin-left: 0; padding: 20px; } }
        @media (max-width: 768px) { .top-bar { flex-direction: column; gap: 16px; align-items: stretch; } .detail-grid { grid-template-columns: 1fr; } }
        .mobile-toggle { display: none; position: fixed; bottom: 28px; right: 28px; width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; box-shadow: var(--shadow-lg); z-index: 999; cursor: pointer; font-size: 1.3rem; align-items: center; justify-content: center; }
        @media (max-width: 1100px) { .mobile-toggle { display: flex; } }
        ::-webkit-scrollbar { width: 6px; } ::-webkit-scrollbar-thumb { background: rgba(148,163,184,0.35); border-radius: 10px; }
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
                    <div class="nav-section-title"><fmt:message key="nav.principal"/></div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-chart-pie"></i><span><fmt:message key="nav.dashboard"/></span></a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title"><fmt:message key="nav.gestion.clinica"/></div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/pacientes" class="nav-link"><i class="fas fa-users"></i><span><fmt:message key="nav.pacientes"/></span></a></li>
                        <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/citas" class="nav-link active"><i class="fas fa-calendar-check"></i><span><fmt:message key="nav.citas"/></span></a></li>
                        </c:if>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/horarios" class="nav-link"><i class="fas fa-clock"></i><span><fmt:message key="nav.horarios"/></span></a></li>
                    </ul>
                </div>
            </nav>
            <div class="sidebar-footer">
                <div class="user-card">
                    <div class="user-info">
                        <div class="user-avatar"><c:choose><c:when test="${not empty sessionScope.usuarioNombre}">${sessionScope.usuarioNombre.charAt(0)}</c:when><c:otherwise>U</c:otherwise></c:choose></div>
                        <div class="user-details"><div class="user-name"><c:out value="${sessionScope.usuarioNombre}" default="Usuario"/></div><div class="user-role"><i class="fas fa-circle"></i> <c:out value="${sessionScope.usuarioRol}" default="Invitado"/></div></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> <fmt:message key="nav.salir"/></a>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <div class="page-icon"><i class="fas fa-file-medical"></i></div>
                    <div>
                        <h1 class="page-title"><fmt:message key="cita.detalle"/></h1>
                        <p class="page-subtitle"><fmt:message key="cita.informacion"/></p>
                    </div>
                </div>
                <div class="top-actions">
                    <div class="lang-switch">
                        <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                        <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                        <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                    </div>
                    <a href="${pageContext.request.contextPath}/citas" class="btn-back"><i class="fas fa-arrow-left"></i> <fmt:message key="cita.volver"/></a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty cita}">
                    <div class="detail-card" style="text-align:center;padding:60px;">
                        <i class="fas fa-calendar-times" style="font-size:4rem;color:var(--border-subtle);display:block;margin-bottom:20px;"></i>
                        <h3 style="color:var(--text-primary);">Cita no encontrada</h3>
                        <a href="${pageContext.request.contextPath}/citas" class="btn-back" style="margin-top:20px;"><i class="fas fa-arrow-left"></i> <fmt:message key="cita.volver"/></a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="detail-card">
                        <!-- HEADER -->
                        <div class="detail-card-header">
                            <span class="cita-id"><i class="fas fa-hashtag"></i> Cita N° ${cita.id}</span>
                            <c:choose>
                                <c:when test="${cita.estado == 'PROGRAMADA'}"><span class="badge badge-programada"><i class="fas fa-clock"></i><fmt:message key='cita.estado.programada'/></span></c:when>
                                <c:when test="${cita.estado == 'CONFIRMADA'}"><span class="badge badge-confirmada"><i class="fas fa-check-circle"></i><fmt:message key='cita.estado.confirmada'/></span></c:when>
                                <c:when test="${cita.estado == 'ATENDIDA'}"><span class="badge badge-atendida"><i class="fas fa-check-double"></i><fmt:message key='cita.estado.atendida'/></span></c:when>
                                <c:when test="${cita.estado == 'CANCELADA'}"><span class="badge badge-cancelada"><i class="fas fa-times-circle"></i><fmt:message key='cita.estado.cancelada'/></span></c:when>
                            </c:choose>
                        </div>

                        <!-- DATOS DE LA CITA -->
                        <div class="detail-section">
                            <div class="section-title"><i class="fas fa-calendar-alt"></i> <fmt:message key="cita.informacion"/></div>
                            <div class="detail-grid">
                                <div class="detail-item"><span class="detail-label"><fmt:message key='cita.fecha'/></span><span class="detail-value">${cita.fechaCita}</span></div>
                                <div class="detail-item"><span class="detail-label"><fmt:message key='cita.hora'/></span><span class="detail-value">${cita.horaCita}</span></div>
                                <div class="detail-item"><span class="detail-label"><fmt:message key='cita.especialidad'/></span><span class="detail-value">${cita.especialidad.nombre}</span></div>
                                <div class="detail-item"><span class="detail-label"><fmt:message key='cita.estado'/></span><span class="detail-value">${cita.estado}</span></div>
                                <div class="detail-item" style="grid-column:1/-1;">
                                    <span class="detail-label"><fmt:message key='cita.motivo'/></span>
                                    <span class="detail-value ${empty cita.motivo ? 'muted' : ''}"><c:out value="${cita.motivo}" default="No especificado"/></span>
                                </div>
                            </div>
                        </div>

                        <!-- DATOS DEL PACIENTE -->
                        <div class="detail-section">
                            <div class="section-title"><i class="fas fa-user"></i> <fmt:message key='cita.paciente'/></div>
                            <div class="detail-grid">
                                <div class="detail-item"><span class="detail-label">Nombres y Apellidos</span><span class="detail-value">${cita.paciente.nombres} ${cita.paciente.apellidos}</span></div>
                                <div class="detail-item"><span class="detail-label"><fmt:message key='paciente.documento'/></span><span class="detail-value">${cita.paciente.documento}</span></div>
                            </div>
                        </div>

                        <!-- DATOS DEL MÉDICO -->
                        <div class="detail-section">
                            <div class="section-title"><i class="fas fa-user-md"></i> <fmt:message key='cita.medico'/></div>
                            <div class="detail-grid">
                                <div class="detail-item"><span class="detail-label">Nombres y Apellidos</span><span class="detail-value">Dr. ${cita.medico.nombres} ${cita.medico.apellidos}</span></div>
                                <div class="detail-item"><span class="detail-label"><fmt:message key='cita.especialidad'/></span><span class="detail-value">${cita.especialidad.nombre}</span></div>
                            </div>
                        </div>

                        <!-- ACCIONES -->
                        <c:if test="${sessionScope.usuarioRol != 'ENFERMERO' && cita.estado != 'ATENDIDA' && cita.estado != 'CANCELADA'}">
                        <div class="detail-actions">
                            <fmt:message key="cita.confirmar.accion" var="msgC"/>
                            <a href="${pageContext.request.contextPath}/citas?accion=cambiarEstado&id=${cita.id}&estado=CONFIRMADA" class="btn btn-success" onclick="return confirm('${msgC}')"><i class="fas fa-check"></i> <fmt:message key="cita.confirmar.btn"/></a>
                            
                            <fmt:message key="cita.marcar.atendida.confirm" var="msgA"/>
                            <a href="${pageContext.request.contextPath}/citas?accion=cambiarEstado&id=${cita.id}&estado=ATENDIDA" class="btn btn-info" onclick="return confirm('${msgA}')"><i class="fas fa-check-double"></i> <fmt:message key="cita.marcar.atendida"/></a>
                            
                            <fmt:message key="cita.cancelar.accion" var="msgX"/>
                            <a href="${pageContext.request.contextPath}/citas?accion=cambiarEstado&id=${cita.id}&estado=CANCELADA" class="btn btn-danger" onclick="return confirm('${msgX}')"><i class="fas fa-times"></i> <fmt:message key="cita.cancelar.btn"/></a>
                        </div>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <script>function toggleSidebar(){document.getElementById('sidebar').classList.toggle('active');}</script>
</body>
</html>
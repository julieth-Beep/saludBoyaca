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
    <title><fmt:message key='nav.horarios'/> | SaludBoyacá</title>
    
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

        /* ===== SIDEBAR PREMIUM ===== */
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
        .top-bar { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); padding: 24px 32px; margin-bottom: 24px; box-shadow: var(--glass-shadow); display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
        .top-bar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--primary), var(--secondary), var(--primary)); background-size: 200% 100%; animation: shimmer 3s linear infinite; }
        @keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }
        .page-header { display: flex; align-items: center; gap: 16px; }
        .page-icon { width: 56px; height: 56px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; box-shadow: 0 8px 24px var(--primary-glow); }
        .page-title { font-family: var(--font-display); font-size: 1.8rem; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em; margin: 0; }
        .page-subtitle { font-size: 0.95rem; color: var(--text-muted); margin-top: 2px; font-weight: 500; }
        .top-actions { display: flex; align-items: center; gap: 12px; }
        .lang-switch { display: flex; gap: 4px; background: white; padding: 4px; border-radius: var(--radius-md); border: 2px solid var(--border-subtle); }
        .lang-btn { padding: 8px 16px; border: none; background: transparent; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; transition: var(--transition-fast); font-size: 0.85rem; }
        .lang-btn.active { background: var(--primary); color: white; box-shadow: 0 2px 8px var(--primary-glow); }
        .lang-btn:hover:not(.active) { background: var(--border-subtle); }

        /* ===== FILTER BAR ===== */
        .filter-bar { background: white; border-radius: var(--radius-lg); border: 1px solid var(--border-subtle); padding: 16px 20px; margin-bottom: 24px; display: flex; align-items: center; gap: 14px; box-shadow: var(--shadow-sm); flex-wrap: wrap; }
        .filter-label { font-size: 0.9rem; font-weight: 600; color: var(--text-primary); display: flex; align-items: center; gap: 8px; white-space: nowrap; }
        .filter-label i { color: var(--primary); }
        .filter-select { padding: 10px 16px; border: 2px solid var(--border-subtle); border-radius: var(--radius-sm); font-size: 0.88rem; font-family: inherit; color: var(--text-primary); background: var(--bg-canvas); outline: none; transition: var(--transition-fast); cursor: pointer; min-width: 250px; }
        .filter-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-soft); }
        .filter-count { margin-left: auto; font-size: 0.85rem; color: var(--text-muted); background: var(--primary-soft); padding: 6px 14px; border-radius: var(--radius-full); font-weight: 600; }

        /* ===== HORARIOS GRID ===== */
        .horarios-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 18px; }

        .horario-card { background: white; border-radius: var(--radius-lg); border: 1px solid var(--border-subtle); overflow: hidden; transition: var(--transition-normal); box-shadow: var(--shadow-sm); }
        .horario-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-lg), var(--shadow-glow); }

        .card-header-h { padding: 16px 20px; color: white; display: flex; justify-content: space-between; align-items: center; }
        .horario-card.lunes .card-header-h     { background: linear-gradient(135deg, #0D9488, #0F766E); }
        .horario-card.martes .card-header-h    { background: linear-gradient(135deg, #0891B2, #0E7490); }
        .horario-card.miercoles .card-header-h { background: linear-gradient(135deg, #7C3AED, #6D28D9); }
        .horario-card.jueves .card-header-h    { background: linear-gradient(135deg, #D97706, #B45309); }
        .horario-card.viernes .card-header-h   { background: linear-gradient(135deg, #DC2626, #B91C1C); }

        .dia-info { display: flex; flex-direction: column; }
        .dia-nombre { font-family: var(--font-display); font-weight: 700; font-size: 1.1rem; }
        .dia-num { font-size: 0.75rem; opacity: 0.85; margin-top: 2px; }

        .card-body-h { padding: 20px; }
        .medico-badge { display: inline-flex; align-items: center; gap: 8px; background: var(--primary-soft); color: var(--primary-dark); padding: 8px 14px; border-radius: var(--radius-full); font-size: 0.82rem; font-weight: 600; margin-bottom: 16px; border: 1px solid rgba(13,148,136,0.2); }
        .medico-badge i { font-size: 0.9rem; }

        .hora-row { display: flex; align-items: center; gap: 10px; padding: 8px 0; font-size: 0.9rem; color: var(--text-secondary); }
        .hora-row i { color: var(--primary); width: 18px; text-align: center; font-size: 0.9rem; }
        .hora-row strong { color: var(--text-primary); margin-left: 4px; }

        .hora-divider { border-top: 1px dashed var(--border-subtle); margin: 8px 0; }

        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 80px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 5rem; color: var(--border-subtle); margin-bottom: 20px; display: block; opacity: 0.4; }
        .empty-state h4 { font-family: var(--font-display); font-size: 1.3rem; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
        .empty-state p { font-size: 0.95rem; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1200px) { .horarios-grid { grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); } }
        @media (max-width: 1100px) { .sidebar { transform: translateX(-100%); } .sidebar.active { transform: translateX(0); } .main-content { margin-left: 0; padding: 20px; } }
        @media (max-width: 768px) { .top-bar { flex-direction: column; gap: 16px; align-items: stretch; } .filter-bar { flex-direction: column; align-items: stretch; } .filter-select { width: 100%; } }
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
        <!-- SIDEBAR PREMIUM -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <div class="brand-logo"><i class="fas fa-heart-pulse"></i></div>
                    <div class="brand-text"><h1>SaludBoyacá</h1><span>Sistema Clínico</span></div>
                </a>
            </div>
            <nav class="nav-container">
                <div class="nav-section">
                    <div class="nav-section-title">Principal</div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fas fa-chart-pie"></i><span><fmt:message key='nav.dashboard'/></span></a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Gestión Clínica</div>
                    <ul class="nav-list">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/pacientes" class="nav-link"><i class="fas fa-users"></i><span><fmt:message key='nav.pacientes'/></span></a></li>
                        <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/citas" class="nav-link"><i class="fas fa-calendar-check"></i><span><fmt:message key='nav.citas'/></span></a></li>
                        </c:if>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/horarios" class="nav-link active"><i class="fas fa-clock"></i><span><fmt:message key='nav.horarios'/></span></a></li>
                    </ul>
                </div>
            </nav>
            <div class="sidebar-footer">
                <div class="user-card">
                    <div class="user-info">
                        <div class="user-avatar"><c:out value="${sessionScope.usuarioNombre}" default="U"/></div>
                        <div class="user-details"><div class="user-name"><c:out value="${sessionScope.usuarioNombre}" default="Usuario"/></div><div class="user-role"><i class="fas fa-circle"></i> <c:out value="${sessionScope.usuarioRol}" default="Invitado"/></div></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- TOP BAR -->
            <div class="top-bar">
                <div class="page-header">
                    <div class="page-icon"><i class="fas fa-clock"></i></div>
                    <div>
                        <h1 class="page-title"><fmt:message key='nav.horarios'/></h1>
                        <p class="page-subtitle">Horarios de atención médica del centro de salud</p>
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

            <!-- FILTRO POR MÉDICO (no-MEDICO) -->
            <c:if test="${sessionScope.usuarioRol != 'MEDICO'}">
            <div class="filter-bar">
                <span class="filter-label"><i class="fas fa-filter"></i> Filtrar por médico:</span>
                <select class="filter-select" onchange="window.location.href='${pageContext.request.contextPath}/horarios?idMedico='+this.value">
                    <option value="">— Todos los médicos —</option>
                    <c:forEach var="med" items="${medicos}">
                    <option value="${med.id}" ${medicoSeleccionado == med.id ? 'selected' : ''}>
                        Dr. ${med.nombres} ${med.apellidos} - ${med.especialidad}
                    </option>
                    </c:forEach>
                </select>
                <span class="filter-count"><i class="fas fa-list"></i> <c:out value="${empty horarios ? 0 : horarios.size()}"/> horario(s)</span>
            </div>
            </c:if>

            <!-- HORARIOS GRID -->
            <c:choose>
                <c:when test="${empty horarios}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h4>No hay horarios registrados</h4>
                        <p>Los horarios de atención médica aparecerán aquí una vez sean configurados</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="horarios-grid">
                        <c:forEach var="h" items="${horarios}">
                        <div class="horario-card ${h.diaSemana == 1 ? 'lunes' : h.diaSemana == 2 ? 'martes' : h.diaSemana == 3 ? 'miercoles' : h.diaSemana == 4 ? 'jueves' : 'viernes'}">
                            <div class="card-header-h">
                                <div class="dia-info">
                                    <span class="dia-nombre">${h.nombreDia}</span>
                                    <span class="dia-num">Día ${h.diaSemana} de la semana</span>
                                </div>
                                <i class="fas fa-calendar-day fa-lg" style="opacity:0.8;"></i>
                            </div>
                            <div class="card-body-h">
                                <c:if test="${not empty h.nombreMedico}">
                                <div class="medico-badge"><i class="fas fa-user-md"></i> Dr. ${h.nombreMedico}</div>
                                </c:if>
                                <div class="hora-row"><i class="fas fa-play-circle"></i> Inicio: <strong>${h.horaInicio}</strong></div>
                                <div class="hora-divider"></div>
                                <div class="hora-row"><i class="fas fa-stop-circle"></i> Fin: <strong>${h.horaFin}</strong></div>
                                <div class="hora-divider"></div>
                                <div class="hora-row"><i class="fas fa-users"></i> Máx. citas: <strong>${h.maxCitas} pacientes</strong></div>
                            </div>
                        </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>

    <script>
        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('active'); }
    </script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>
</html>
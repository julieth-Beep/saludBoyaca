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
    <title><fmt:message key="cita.nueva.breadcrumb"/> | SaludBoyacá</title>
    
    <!-- Premium Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            /* ===== PALETTE PREMIUM ===== */
            --primary: #0D9488;
            --primary-dark: #0F766E;
            --primary-light: #14B8A6;
            --primary-soft: rgba(13, 148, 136, 0.12);
            --primary-glow: rgba(13, 148, 136, 0.25);
            --secondary: #6366F1;
            --secondary-soft: rgba(99, 102, 241, 0.12);
            --success: #10B981;
            --success-soft: rgba(16, 185, 129, 0.15);
            --warning: #F59E0B;
            --warning-soft: rgba(245, 158, 11, 0.15);
            --danger: #EF4444;
            --danger-soft: rgba(239, 68, 68, 0.15);
            --info: #3B82F6;
            --info-soft: rgba(59, 130, 246, 0.15);
            
            /* ===== GLASSMORPHISM ===== */
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.7);
            --glass-blur: blur(24px);
            --glass-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            --glass-inset: inset 0 1px 0 rgba(255,255,255,0.6);
            --glass-highlight: rgba(255, 255, 255, 0.95);
            
            /* ===== TYPOGRAPHY ===== */
            --font-primary: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            --font-display: 'Plus Jakarta Sans', 'Inter', sans-serif;
            
            /* ===== COLORS ===== */
            --text-primary: #0F172A;
            --text-secondary: #334155;
            --text-muted: #64748B;
            --text-light: #94A3B8;
            --text-white: #FFFFFF;
            
            /* ===== BACKGROUNDS ===== */
            --bg-canvas: linear-gradient(135deg, #F0F9FF 0%, #F5F3FF 50%, #F0FDFA 100%);
            --bg-surface: rgba(255, 255, 255, 0.95);
            --bg-surface-alt: rgba(248, 250, 252, 0.9);
            
            /* ===== BORDERS & RADIUS ===== */
            --border-subtle: rgba(148, 163, 184, 0.25);
            --border-focus: rgba(13, 148, 136, 0.5);
            --radius-sm: 10px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --radius-xl: 32px;
            --radius-full: 9999px;
            
            /* ===== SHADOWS ===== */
            --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
            --shadow-sm: 0 4px 12px rgba(0, 0, 0, 0.06);
            --shadow-md: 0 8px 24px rgba(0, 148, 136, 0.08);
            --shadow-lg: 0 16px 48px rgba(0, 0, 0, 0.12);
            --shadow-glow: 0 0 40px rgba(13, 148, 136, 0.25);
            
            /* ===== TRANSITIONS ===== */
            --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-slow: 400ms cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ===== BASE RESET ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        
        body {
            font-family: var(--font-primary);
            background: var(--bg-canvas);
            background-attachment: fixed;
            color: var(--text-secondary);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* ===== BACKGROUND DECORATIONS ===== */
        .bg-decoration { position: fixed; pointer-events: none; z-index: 0; opacity: 0.5; }
        .bg-orb { border-radius: 50%; filter: blur(80px); animation: float 25s ease-in-out infinite; }
        .orb-1 { width: 600px; height: 600px; background: radial-gradient(circle, var(--primary-light), transparent); top: -200px; right: -100px; }
        .orb-2 { width: 400px; height: 400px; background: radial-gradient(circle, var(--secondary), transparent); bottom: -100px; left: -80px; animation-delay: -10s; }
        .orb-3 { width: 300px; height: 300px; background: radial-gradient(circle, var(--warning), transparent); top: 50%; left: 50%; animation-delay: -15s; }
        .bg-grid { position: fixed; inset: 0; pointer-events: none; z-index: 0; background-image: linear-gradient(rgba(13, 148, 136, 0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(13, 148, 136, 0.03) 1px, transparent 1px); background-size: 60px 60px; }
        @keyframes float { 0%, 100% { transform: translate(0, 0) scale(1); } 50% { transform: translate(40px, -40px) scale(1.1); } }

        /* ===== APP WRAPPER ===== */
        .app-wrapper { display: flex; min-height: 100vh; position: relative; z-index: 1; }

        /* ═══════════ SIDEBAR ORIGINAL - SIN CAMBIOS ═══════════ */
        .sidebar {
            width: 280px; position: fixed; height: 100vh; z-index: 100;
            display: flex; flex-direction: column;
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border-right: 1px solid var(--border-subtle);
            box-shadow: 4px 0 24px rgba(0,0,0,0.06);
            transition: transform var(--transition-normal);
        }
        .sidebar-header { padding: 28px 24px; border-bottom: 2px solid var(--border-subtle); background: linear-gradient(135deg, rgba(13, 148, 136, 0.05), transparent); }
        .brand { display: flex; align-items: center; gap: 16px; text-decoration: none; }
        .brand-logo {
            width: 52px; height: 52px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 1.5rem;
            box-shadow: 0 8px 24px var(--primary-glow);
            position: relative; overflow: hidden;
        }
        .brand-logo::after { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, rgba(255,255,255,0.3), transparent); }
        .brand-text h1 { font-family: var(--font-display); font-size: 1.5rem; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em; margin: 0; }
        .brand-text span { font-size: 0.8rem; color: var(--text-muted); font-weight: 500; display: block; margin-top: 2px; }
        .nav-container { flex: 1; padding: 24px 16px; overflow-y: auto; }
        .nav-section { margin-bottom: 28px; }
        .nav-section-title { font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.1em; padding: 0 20px 12px; display: flex; align-items: center; gap: 8px; }
        .nav-section-title::before { content: ''; width: 24px; height: 2px; background: linear-gradient(90deg, var(--primary), transparent); border-radius: 2px; }
        .nav-list { list-style: none; }
        .nav-item { margin: 4px 0; }
        .nav-link {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 20px; margin: 0 8px;
            border-radius: var(--radius-md);
            color: var(--text-secondary); text-decoration: none;
            font-size: 0.95rem; font-weight: 500;
            transition: all var(--transition-fast);
            position: relative; overflow: hidden;
        }
        .nav-link::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 0; background: linear-gradient(180deg, var(--primary), var(--primary-light)); border-radius: 0 var(--radius-sm) var(--radius-sm) 0; transition: height var(--transition-fast); }
        .nav-link::after { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, var(--primary-soft), transparent); opacity: 0; transition: opacity var(--transition-fast); }
        .nav-link:hover { color: var(--primary); transform: translateX(4px); }
        .nav-link:hover::before { height: 60%; } .nav-link:hover::after { opacity: 1; }
        .nav-link.active { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; font-weight: 600; box-shadow: 0 4px 16px var(--primary-glow); }
        .nav-link.active::before { height: 70%; background: linear-gradient(180deg, white, rgba(255,255,255,0.8)); }
        .nav-link i { width: 22px; text-align: center; font-size: 1.1rem; position: relative; z-index: 1; }
        .nav-link span { position: relative; z-index: 1; }
        .sidebar-footer { padding: 20px; border-top: 2px solid var(--border-subtle); background: linear-gradient(to top, rgba(248,250,252,0.95), transparent); }
        .user-card {
            background: linear-gradient(135deg, rgba(13, 148, 136, 0.1), rgba(99, 102, 241, 0.1));
            border: 2px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 16px;
            transition: var(--transition-fast);
        }
        .user-card:hover { border-color: var(--primary); box-shadow: 0 4px 16px var(--primary-glow); }
        .user-info { display: flex; align-items: center; gap: 14px; margin-bottom: 14px; }
        .user-avatar {
            width: 48px; height: 48px;
            border-radius: var(--radius-md);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 1.1rem;
            box-shadow: 0 4px 16px var(--primary-glow);
            flex-shrink: 0;
        }
        .user-details { flex: 1; min-width: 0; }
        .user-name { font-weight: 600; color: var(--text-primary); font-size: 0.95rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role { font-size: 0.8rem; color: var(--text-muted); display: flex; align-items: center; gap: 6px; margin-top: 2px; }
        .user-role i { color: var(--success); font-size: 0.6rem; animation: pulse 2s ease-in-out infinite; }
        @keyframes pulse { 0%,100% { opacity:1; } 50% { opacity:0.5; } }
        .btn-logout {
            width: 100%; padding: 12px;
            background: white; border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md);
            color: var(--danger); font-weight: 600; font-size: 0.9rem;
            cursor: pointer; transition: var(--transition-fast);
            text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-logout:hover { background: var(--danger); color: white; border-color: var(--danger); transform: translateY(-2px); box-shadow: 0 4px 16px rgba(239,68,68,0.3); }

        /* ═══════════ MAIN CONTENT ═══════════ */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        /* ═══════════ FORM CONTAINER GLASSMORPHISM ═══════════ */
        .form-container {
            width: 100%;
            max-width: 760px;
            animation: fadeInUp 0.7s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ===== FORM CARD PREMIUM ===== */
        .form-card {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: var(--glass-shadow), var(--shadow-lg);
            overflow: hidden;
            position: relative;
        }

        /* Gradient border effect - ESTÁTICO */
        .form-card::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: inherit;
            padding: 1px;
            background: linear-gradient(135deg, var(--primary), var(--secondary), var(--primary-light), var(--primary));
            -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            pointer-events: none;
            opacity: 0.7;
        }

        /* Decorative corner accents - ESTÁTICO */
        .form-card::after {
            content: '';
            position: absolute;
            top: -50%; right: -50%;
            width: 200px; height: 200px;
            background: radial-gradient(circle, var(--primary-soft), transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }

        /* ===== FORM HEADER ===== */
        .form-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 28px 36px;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(255,255,255,0.15), transparent 70%);
            border-radius: 50%;
        }

        .form-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .form-header-icon {
            width: 60px; height: 60px;
            border-radius: var(--radius-lg);
            background: rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }

        .form-header h3 {
            font-family: var(--font-display);
            font-size: 1.4rem;
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.02em;
        }

        .form-header p {
            font-size: 0.95rem;
            opacity: 0.95;
            margin: 6px 0 0 78px;
            font-weight: 400;
        }

        /* ===== FORM BODY ===== */
        .form-body { padding: 36px; }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        @media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }

        .form-group { display: flex; flex-direction: column; gap: 10px; position: relative; }
        .form-group.full { grid-column: 1 / -1; }

        .form-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 7px;
            letter-spacing: -0.01em;
        }

        .form-label i { color: var(--primary); font-size: 0.85rem; width: 16px; text-align: center; }
        .form-label .required { color: var(--danger); font-weight: 700; }

        /* ===== INPUT PREMIUM ===== */
        .input-wrapper { position: relative; }

        .form-control {
            width: 100%;
            padding: 14px 18px 14px 46px;
            border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--text-primary);
            background: var(--glass-highlight);
            transition: var(--transition-normal);
            position: relative;
            z-index: 1;
        }

        .form-control::placeholder { color: var(--text-muted); font-weight: 400; }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 5px var(--primary-soft), 0 4px 20px var(--primary-glow);
            background: white;
            transform: translateY(-1px);
        }

        .form-control[readonly] { background: var(--bg-surface-alt); cursor: not-allowed; opacity: 0.85; }
        .form-control[readonly]:focus { box-shadow: none; transform: none; }

        /* Select custom arrow */
        .form-control.select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2364748B' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px;
            padding-right: 42px;
        }

        /* Input icon - ESTÁTICO */
        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 0.95rem;
            pointer-events: none;
            transition: var(--transition-fast);
            z-index: 2;
        }

        .form-control:focus + i,
        .form-control:not(:placeholder-shown) + i { color: var(--primary); }

        /* ===== BUTTONS PREMIUM ===== */
        .form-actions {
            display: flex;
            gap: 14px;
            margin-top: 32px;
            padding-top: 28px;
            border-top: 1px solid var(--border-subtle);
        }

        .btn-primary {
            flex: 1;
            padding: 15px 28px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: var(--radius-md);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition-normal);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            box-shadow: 0 4px 16px var(--primary-glow);
            position: relative;
            overflow: hidden;
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent);
            opacity: 0;
            transition: opacity var(--transition-fast);
        }

        .btn-primary:hover { transform: translateY(-3px); box-shadow: 0 8px 28px var(--primary-glow); }
        .btn-primary:hover::before { opacity: 1; }
        .btn-primary:active { transform: translateY(-1px); }

        .btn-secondary {
            flex: 1;
            padding: 15px 28px;
            background: var(--glass-highlight);
            color: var(--text-secondary);
            border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-normal);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            position: relative;
            overflow: hidden;
        }

        .btn-secondary::before {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--primary-soft);
            opacity: 0;
            transition: opacity var(--transition-fast);
        }

        .btn-secondary:hover {
            border-color: var(--primary);
            color: var(--primary);
            transform: translateY(-3px);
            box-shadow: 0 4px 16px var(--primary-glow);
        }
        .btn-secondary:hover::before { opacity: 1; }

        /* ===== ALERTS ===== */
        .alert {
            padding: 16px 20px;
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease;
            border-left: 4px solid;
        }
        @keyframes slideIn { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }
        .alert-success { background: var(--success-soft); color: #065F46; border-color: var(--success); }
        .alert-danger { background: var(--danger-soft); color: #991B1B; border-color: var(--danger); }
        .alert i { font-size: 1.2rem; flex-shrink: 0; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 24px; }
            .form-card { max-width: 100%; }
        }
        @media (max-width: 480px) {
            .form-body { padding: 28px 24px; }
            .form-header { padding: 24px 28px; }
            .form-header h3 { font-size: 1.25rem; }
            .form-header p { margin-left: 70px; font-size: 0.9rem; }
            .form-actions { flex-direction: column; }
            .btn-primary, .btn-secondary { width: 100%; }
        }

        /* ===== MOBILE TOGGLE ===== */
        .mobile-toggle {
            display: none; position: fixed; bottom: 28px; right: 28px;
            width: 60px; height: 60px; border-radius: var(--radius-full);
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; border: none;
            box-shadow: var(--shadow-lg), var(--shadow-glow);
            z-index: 999; cursor: pointer; font-size: 1.3rem;
            align-items: center; justify-content: center;
            transition: var(--transition-fast);
        }
        .mobile-toggle:hover { transform: scale(1.1); box-shadow: var(--shadow-lg), 0 0 60px var(--primary-glow); }
        @media (max-width: 1024px) { .mobile-toggle { display: flex; } }

        /* ===== SCROLLBAR ===== */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: linear-gradient(180deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-full); }
        ::-webkit-scrollbar-thumb:hover { background: linear-gradient(180deg, var(--primary-dark), var(--primary)); }
    </style>
</head>
<body>
    <!-- Background Decorations -->
    <div class="bg-grid"></div>
    <div class="bg-decoration bg-orb orb-1"></div>
    <div class="bg-decoration bg-orb orb-2"></div>
    <div class="bg-decoration bg-orb orb-3"></div>

    <div class="app-wrapper">
        <!-- ═══════════ SIDEBAR ORIGINAL - SIN CAMBIOS ═══════════ -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <div class="brand-logo"><i class="fas fa-heart-pulse"></i></div>
                    <div class="brand-text">
                        <h1>SaludBoyacá</h1>
                        <span>Sistema Clínico</span>
                    </div>
                </a>
            </div>
            <nav class="nav-container">
                <div class="nav-section">
                    <div class="nav-section-title">Principal</div>
                    <ul class="nav-list">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                                <i class="fas fa-chart-pie"></i><span><fmt:message key="nav.dashboard"/></span>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title"><fmt:message key="nav.gestion.clinica"/></div>
                    <ul class="nav-list">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/pacientes" class="nav-link">
                                <i class="fas fa-users"></i><span><fmt:message key="nav.pacientes"/></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/citas" class="nav-link active">
                                <i class="fas fa-calendar-check"></i><span><fmt:message key="nav.citas"/></span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/medicos" class="nav-link">
                                <i class="fas fa-user-md"></i><span><fmt:message key="nav.personal.medico"/></span>
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="sidebar-footer">
                <div class="user-card">
                    <div class="user-info">
                        <div class="user-avatar">
                            <c:choose>
                                <c:when test="${not empty sessionScope.usuarioNombre}">${sessionScope.usuarioNombre.charAt(0)}</c:when>
                                <c:otherwise>U</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-details">
                            <div class="user-name"><c:out value="${sessionScope.usuarioNombre}" default="Usuario"/></div>
                            <div class="user-role"><c:out value="${sessionScope.usuarioRol}" default="Invitado"/></div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i> <fmt:message key="nav.salir"/>
                    </a>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            
            <!-- ═══════════ FORM CARD GLASSMORPHISM PREMIUM ═══════════ -->
            <div class="form-container">
                <div class="form-card">
                    
                    <!-- Header con gradiente y efectos -->
                    <div class="form-header">
                        <div class="form-header-content">
                            <div class="form-header-icon">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div>
                                <h3><fmt:message key='cita.nueva'/></h3>
                                <p>Programa una nueva cita médica</p>
                            </div>
                        </div>
                    </div>

                    <!-- Body del formulario -->
                    <div class="form-body">
                        <form action="${pageContext.request.contextPath}/citas" method="post">
                            
                            <div class="form-grid">
                                <!-- PACIENTE -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i>
                                        <fmt:message key='cita.paciente'/>
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <select name="idPaciente" class="form-control select" required>
                                            <option value=""><fmt:message key="cita.seleccionar.paciente"/></option>
                                            <c:forEach var="pac" items="${pacientes}">
                                            <option value="${pac.id}">${pac.apellidos}, ${pac.nombres} - ${pac.documento}</option>
                                            </c:forEach>
                                        </select>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                </div>

                                <!-- ESPECIALIDAD -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-stethoscope"></i>
                                        <fmt:message key='cita.especialidad'/>
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <select name="idEspecialidad" class="form-control select" required>
                                            <option value=""><fmt:message key="cita.seleccionar.especialidad"/></option>
                                            <c:forEach var="esp" items="${especialidades}">
                                            <option value="${esp.id}">${esp.nombre}</option>
                                            </c:forEach>
                                        </select>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                </div>

                                <!-- MÉDICO -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user-md"></i>
                                        <fmt:message key='cita.medico'/>
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <select name="idMedico" class="form-control select" required>
                                            <option value=""><fmt:message key="cita.seleccionar.medico"/></option>
                                            <c:forEach var="med" items="${medicos}">
                                            <option value="${med.id}">Dr. ${med.nombres} ${med.apellidos} - ${med.especialidad}</option>
                                            </c:forEach>
                                        </select>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                </div>

                                <!-- FECHA -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-calendar-alt"></i>
                                        <fmt:message key='cita.fecha'/>
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <input type="date" name="fechaCita" class="form-control" 
                                               required min="${hoy}">
                                        <i class="fas fa-calendar-day"></i>
                                    </div>
                                </div>

                                <!-- HORA -->
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-clock"></i>
                                        <fmt:message key='cita.hora'/>
                                        <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <input type="time" name="horaCita" class="form-control" 
                                               required min="07:00" max="17:00" step="1800">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <small style="color: var(--text-muted); font-size: 0.75rem;">
                                        <i class="fas fa-info-circle" style="font-size:0.7rem;"></i> 
                                        <fmt:message key="cita.horario.hint"/>
                                    </small>
                                </div>

                                <!-- MOTIVO -->
                                <div class="form-group full">
                                    <label class="form-label">
                                        <i class="fas fa-comment-medical"></i>
                                        <fmt:message key='cita.motivo'/>
                                    </label>
                                    <div class="input-wrapper">
                                        <textarea name="motivo" class="form-control" 
                                                  placeholder="<fmt:message key='cita.motivo.placeholder'/>"
                                                  style="padding-left:46px;min-height:100px;resize:vertical;"></textarea>
                                        <i class="fas fa-pen"></i>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/citas" class="btn-secondary">
                                    <i class="fas fa-times"></i>
                                    <fmt:message key='paciente.cancelar'/>
                                </a>
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-calendar-check"></i>
                                    <fmt:message key='paciente.guardar'/>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <!-- Mobile Toggle -->
    <button class="mobile-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <script>
        // Toggle Sidebar
        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('active'); }

        // Close sidebar on outside click (mobile)
        document.addEventListener('click', function(e) {
            const sidebar = document.getElementById('sidebar');
            const toggleBtn = document.querySelector('.mobile-toggle');
            if (window.innerWidth <= 1024 && 
                sidebar.classList.contains('active') && 
                !sidebar.contains(e.target) && 
                !toggleBtn.contains(e.target)) {
                sidebar.classList.remove('active');
            }
        });

        // Auto-focus first select
        document.addEventListener('DOMContentLoaded', function() {
            const firstSelect = document.querySelector('select[name="idPaciente"]');
            if (firstSelect) setTimeout(() => firstSelect.focus(), 300);
        });
    </script>
</body>
</html>
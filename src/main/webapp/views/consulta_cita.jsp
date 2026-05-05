<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key='consulta.titulo'/> | SaludBoyacá</title>
    
    <!-- Premium Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    
    <!-- Google reCAPTCHA -->
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    
    <style>
        :root {
            --primary: #0EA5E9;
            --primary-dark: #0284C7;
            --primary-light: #7DD3FC;
            --primary-soft: rgba(14, 165, 233, 0.1);
            --primary-glow: rgba(14, 165, 233, 0.2);
            --secondary: #06B6D4;
            --accent: #22D3EE;
            --success: #10B981;
            --success-soft: rgba(16, 185, 129, 0.15);
            --warning: #F59E0B;
            --warning-soft: rgba(245, 158, 11, 0.15);
            --danger: #EF4444;
            --danger-soft: rgba(239, 68, 68, 0.15);
            --info: #3B82F6;
            --info-soft: rgba(59, 130, 246, 0.15);
            
            --glass-bg: rgba(255, 255, 255, 0.9);
            --glass-border: rgba(255, 255, 255, 0.75);
            --glass-blur: blur(20px);
            --glass-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            
            --font-primary: 'Inter', sans-serif;
            --font-display: 'Plus Jakarta Sans', sans-serif;
            
            --text-primary: #0F172A;
            --text-secondary: #334155;
            --text-muted: #64748B;
            --text-white: #FFFFFF;
            
            --bg-canvas: linear-gradient(135deg, #F0F9FF 0%, #F5F3FF 50%, #F0FDFA 100%);
            --bg-surface: rgba(255, 255, 255, 0.95);
            --bg-surface-alt: rgba(248, 250, 252, 0.9);
            
            --border-subtle: rgba(148, 163, 184, 0.3);
            --border-focus: rgba(14, 165, 233, 0.5);
            
            --radius-sm: 10px;
            --radius-md: 16px;
            --radius-lg: 24px;
            --radius-xl: 32px;
            --radius-full: 9999px;
            
            --shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
            --shadow-sm: 0 4px 12px rgba(0, 0, 0, 0.06);
            --shadow-md: 0 8px 24px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 16px 48px rgba(0, 0, 0, 0.12);
            --shadow-glow: 0 0 40px rgba(14, 165, 233, 0.25);
            
            --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-slow: 400ms cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: var(--font-primary);
            background: var(--bg-canvas);
            background-attachment: fixed;
            color: var(--text-secondary);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* ===== BACKGROUND DECORATIONS ===== */
        .bg-decoration { position: fixed; pointer-events: none; z-index: 0; opacity: 0.5; }
        
        .bg-orb {
            border-radius: 50%;
            filter: blur(80px);
            animation: float 25s ease-in-out infinite;
        }
        
        .orb-1 {
            width: 600px; height: 600px;
            background: radial-gradient(circle, var(--primary-light), transparent);
            top: -200px; right: -100px;
        }
        
        .orb-2 {
            width: 400px; height: 400px;
            background: radial-gradient(circle, var(--accent), transparent);
            bottom: -100px; left: -80px;
            animation-delay: -10s;
        }
        
        .bg-grid {
            position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background-image: 
                linear-gradient(rgba(14, 165, 233, 0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(14, 165, 233, 0.03) 1px, transparent 1px);
            background-size: 60px 60px;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(40px, -40px) scale(1.1); }
        }

        /* ===== HEADER PREMIUM ===== */
        .page-header {
            position: relative;
            z-index: 10;
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border-bottom: 1px solid var(--glass-border);
            padding: 16px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .header-brand {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
        }
        
        .header-logo {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: var(--radius-md);
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 1.3rem;
            box-shadow: 0 4px 16px var(--primary-glow);
        }
        
        .header-title {
            font-family: var(--font-display);
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-primary);
        }
        
        .header-sub {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 2px;
        }
        
        .lang-bar {
            display: flex;
            gap: 6px;
            background: white;
            padding: 4px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-subtle);
        }
        
        .lang-btn {
            padding: 6px 14px;
            border: none;
            background: transparent;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            transition: var(--transition-fast);
            text-decoration: none;
        }
        
        .lang-btn.active,
        .lang-btn:hover {
            background: var(--primary);
            color: white;
            box-shadow: 0 2px 8px var(--primary-glow);
        }

        /* ===== MAIN CONTENT ===== */
        .main {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 48px 24px 64px;
            position: relative;
            z-index: 1;
        }

        /* ===== FORM CARD PREMIUM ===== */
        .form-card {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: var(--glass-shadow), var(--shadow-lg);
            width: 100%;
            max-width: 560px;
            overflow: hidden;
            margin-bottom: 32px;
            animation: fadeInUp 0.6s ease;
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 28px 32px;
            text-align: center;
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
        
        .form-header i {
            font-size: 3rem;
            margin-bottom: 12px;
            display: block;
            position: relative;
            z-index: 1;
        }
        
        .form-header h2 {
            font-family: var(--font-display);
            font-size: 1.4rem;
            font-weight: 800;
            margin-bottom: 6px;
            position: relative;
            z-index: 1;
        }
        
        .form-header p {
            font-size: 0.9rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
        }
        
        .form-body {
            padding: 32px;
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: var(--radius-md);
            font-size: 0.9rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.3s ease;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-4px); }
            75% { transform: translateX(4px); }
        }
        
        .alert-danger {
            background: var(--danger-soft);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.3);
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        .form-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .form-label i {
            color: var(--primary);
            font-size: 0.85rem;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--text-primary);
            background: white;
            transition: var(--transition-fast);
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-soft);
        }
        
        .form-control::placeholder {
            color: var(--text-muted);
        }
        
        /* ===== CAPTCHA VISUAL ===== */
        .captcha-wrapper {
            display: flex;
            gap: 14px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .captcha-display {
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        
        .captcha-img {
            position: relative;
            border-radius: var(--radius-md);
            overflow: hidden;
            cursor: pointer;
            border: 2px solid var(--border-subtle);
            transition: var(--transition-fast);
        }
        
        .captcha-img:hover {
            border-color: var(--primary);
            transform: scale(1.02);
        }
        
        .captcha-img img {
            height: 56px;
            display: block;
            background: linear-gradient(135deg, #f8fafc, #e2e8f0);
        }
        
        .captcha-refresh {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 0.8rem;
            color: var(--primary);
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition-fast);
        }
        
        .captcha-refresh:hover {
            color: var(--primary-dark);
            transform: rotate(180deg);
        }
        
        .captcha-input {
            flex: 1;
            min-width: 180px;
        }
        
        .captcha-input .form-control {
            text-transform: uppercase;
            letter-spacing: 4px;
            font-size: 1.1rem;
            font-weight: 600;
            text-align: center;
        }
        
        /* ===== reCAPTCHA Container ===== */
        .recaptcha-container {
            display: flex;
            justify-content: center;
            margin: 10px 0;
        }
        
        .helper-text {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-align: center;
            margin-top: 8px;
        }
        
        /* Submit Button */
        .btn-buscar {
            width: 100%;
            padding: 16px 24px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: var(--radius-md);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition-normal);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 8px;
            box-shadow: 0 4px 16px var(--primary-glow);
        }
        
        .btn-buscar:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px var(--primary-glow);
        }
        
        .btn-buscar:active {
            transform: translateY(-1px);
        }
        
        .btn-buscar i {
            font-size: 1.1rem;
        }

        /* ===== RESULTS CARD PREMIUM ===== */
        .results-card {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: var(--glass-shadow), var(--shadow-lg);
            width: 100%;
            max-width: 720px;
            overflow: hidden;
            animation: fadeInUp 0.6s ease 0.1s both;
        }
        
        .results-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 20px 28px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .results-header i {
            font-size: 1.5rem;
        }
        
        .results-header h3 {
            font-family: var(--font-display);
            font-size: 1.1rem;
            font-weight: 700;
        }
        
        .cita-list {
            padding: 8px 0;
        }
        
        .cita-item {
            padding: 20px 28px;
            border-bottom: 1px solid var(--border-subtle);
            transition: var(--transition-fast);
        }
        
        .cita-item:last-child {
            border-bottom: none;
        }
        
        .cita-item:hover {
            background: linear-gradient(135deg, rgba(14, 165, 233, 0.03), rgba(6, 182, 212, 0.03));
        }
        
        .cita-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .cita-info {
            flex: 1;
            min-width: 280px;
        }
        
        .cita-info h4 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .cita-info h4 i {
            color: var(--primary);
            font-size: 0.9rem;
        }
        
        .cita-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px 20px;
            font-size: 0.88rem;
            color: var(--text-secondary);
        }
        
        .cita-meta span {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .cita-meta i {
            color: var(--primary);
            font-size: 0.8rem;
            width: 16px;
            text-align: center;
        }
        
        .cita-motivo {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed var(--border-subtle);
            display: flex;
            align-items: flex-start;
            gap: 6px;
        }
        
        .cita-motivo i {
            color: var(--primary);
            margin-top: 2px;
            flex-shrink: 0;
        }
        
        .cita-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 12px;
            min-width: 140px;
        }
        
        /* State Badges Premium */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: var(--radius-full);
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            border: 1px solid transparent;
            transition: var(--transition-fast);
        }
        
        .badge i { font-size: 0.7rem; }
        
        .badge-programada {
            background: linear-gradient(135deg, #FEF3C7, #FDE68A);
            color: #92400E;
            border-color: #FCD34D;
        }
        
        .badge-confirmada {
            background: linear-gradient(135deg, #D1FAE5, #A7F3D0);
            color: #065F46;
            border-color: #6EE7B7;
        }
        
        .badge-atendida {
            background: linear-gradient(135deg, #DBEAFE, #BFDBFE);
            color: #1E40AF;
            border-color: #93C5FD;
        }
        
        .badge-cancelada {
            background: linear-gradient(135deg, #FEE2E2, #FECACA);
            color: #991B1B;
            border-color: #FCA5A5;
        }
        
        .cita-item:hover .badge {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        /* PDF Button Premium */
        .btn-pdf {
            padding: 10px 18px;
            background: linear-gradient(135deg, #10B981, #059669);
            color: white;
            border: none;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition-fast);
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
        }
        
        .btn-pdf:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }
        
        .btn-pdf i { font-size: 0.9rem; }

        /* No Results State */
        .no-results {
            text-align: center;
            padding: 48px 32px;
            color: var(--text-muted);
        }
        
        .no-results-icon {
            width: 80px; height: 80px;
            margin: 0 auto 20px;
            border-radius: var(--radius-lg);
            background: linear-gradient(135deg, var(--primary-soft), rgba(6, 182, 212, 0.15));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: var(--primary);
            animation: float-icon 3s ease-in-out infinite;
        }
        
        @keyframes float-icon {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        
        .no-results p {
            font-size: 1rem;
            color: var(--text-secondary);
        }

        /* Portal Link */
        .portal-link {
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        
        .portal-link a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition-fast);
            padding: 8px 16px;
            border-radius: var(--radius-full);
        }
        
        .portal-link a:hover {
            background: var(--primary-soft);
            color: var(--primary-dark);
        }

        /* Divider between captchas */
        .captcha-divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
        }
        
        .captcha-divider::before,
        .captcha-divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--border-subtle);
        }
        
        .captcha-divider span {
            padding: 0 12px;
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .page-header { padding: 14px 20px; flex-direction: column; gap: 16px; }
            .header-brand { gap: 10px; }
            .header-logo { width: 42px; height: 42px; font-size: 1.1rem; }
            .form-card, .results-card { max-width: 100%; margin: 0 8px; }
            .form-body, .form-header { padding: 24px; }
            .captcha-wrapper { flex-direction: column; align-items: stretch; }
            .captcha-input { min-width: auto; }
            .cita-row { flex-direction: column; align-items: stretch; }
            .cita-actions { align-items: stretch; }
            .btn-pdf { justify-content: center; }
            .recaptcha-container { transform: scale(0.9); }
        }

        @media (max-width: 480px) {
            .main { padding: 32px 16px 48px; }
            .form-header h2 { font-size: 1.2rem; }
            .form-header i { font-size: 2.5rem; }
            .cita-meta { gap: 8px 12px; font-size: 0.85rem; }
            .recaptcha-container { transform: scale(0.85); margin: -10px 0; }
        }
    </style>
</head>
<body>
    <!-- Background Decorations -->
    <div class="bg-grid"></div>
    <div class="bg-decoration bg-orb orb-1"></div>
    <div class="bg-decoration bg-orb orb-2"></div>

    <!-- HEADER -->
    <header class="page-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <div class="header-logo"><i class="fas fa-hospital"></i></div>
            <div>
                <div class="header-title"><fmt:message key='app.nombre'/></div>
                <div class="header-sub"><fmt:message key='app.institucion'/></div>
            </div>
        </a>
        <nav class="lang-bar">
            <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
            <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
            <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
        </nav>
    </header>

    <!-- MAIN CONTENT -->
    <main class="main">
        
        <!-- ═══════════ FORMULARIO DE BÚSQUEDA CON DOBLE CAPTCHA ═══════════ -->
        <div class="form-card">
            <div class="form-header">
                <i class="fas fa-search"></i>
                <h2><fmt:message key='consulta.titulo'/></h2>
                <p><fmt:message key='consulta.instruccion'/></p>
            </div>
            <div class="form-body">
                
                <!-- Error de reCAPTCHA -->
                <c:if test="${not empty errorRecaptcha}">
                <div class="alert alert-danger">
                    <i class="fab fa-google"></i>
                    ${errorRecaptcha}
                </div>
                </c:if>
                
                <!-- Error de CAPTCHA visual -->
                <c:if test="${not empty errorCaptcha}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${errorCaptcha}
                </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/consulta-cita" method="post" id="consultaForm">
                    
                    <!-- Documento Input -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-id-card"></i>
                            <fmt:message key='consulta.documento'/>
                        </label>
                        <input type="text" 
                               name="documento" 
                               class="form-control"
                               value="${documento}" 
                               placeholder="Ej: 1052400001" 
                               required
                               autocomplete="off">
                    </div>

                    <!-- ═══════════ PRIMER CAPTCHA: reCAPTCHA v2 de Google ═══════════ -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fab fa-google"></i>
                            Verificación 1: reCAPTCHA
                        </label>
                        <div class="recaptcha-container">
                            <div class="g-recaptcha" 
                                 data-sitekey="6LcNrtgsAAAAADCJJ1RBGSjzgGPBkXRPNWTDfexG"
                                 data-theme="light"
                                 data-size="normal">
                            </div>
                        </div>
                        <p class="helper-text">
                            <i class="fas fa-shield-alt"></i> Verificación anti-bots de Google
                        </p>
                    </div>

                    <!-- Separador visual -->
                    <div class="captcha-divider">
                        <span>+ VERIFICACIÓN ADICIONAL</span>
                    </div>

                    <!-- ═══════════ SEGUNDO CAPTCHA: CAPTCHA visual ═══════════ -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-shield-alt"></i>
                            Verificación 2: Código de seguridad
                        </label>
                        <div class="captcha-wrapper">
                            <div class="captcha-display">
                                <div class="captcha-img" title="Clic para recargar">
                                    <img src="${pageContext.request.contextPath}/captcha-imagen" 
                                         id="captchaImg" 
                                         alt="CAPTCHA">
                                </div>
                                <a href="javascript:void(0)" class="captcha-refresh" onclick="recargarCaptcha()">
                                    <i class="fas fa-sync-alt"></i> Recargar
                                </a>
                            </div>
                            <div class="captcha-input">
                                <input type="text" 
                                       name="captcha" 
                                       class="form-control"
                                       placeholder="CÓDIGO" 
                                       maxlength="6" 
                                       required
                                       autocomplete="off">
                            </div>
                        </div>
                        <p class="helper-text">
                            <i class="fas fa-info-circle"></i> Introduce el código que ves en la imagen
                        </p>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-buscar">
                        <i class="fas fa-search"></i>
                        <fmt:message key='consulta.buscar'/>
                    </button>
                    
                </form>
            </div>
        </div>

        <!-- ═══════════ RESULTADOS PREMIUM ═══════════ -->
        <c:if test="${not empty citas || (not empty documento && empty citas && empty errorRecaptcha && empty errorCaptcha)}">
        <div class="results-card">
            <div class="results-header">
                <i class="fas fa-calendar-check"></i>
                <h3>Citas para: <strong style="font-weight:700;">${documento}</strong></h3>
            </div>
            
            <div class="cita-list">
                <c:choose>
                    <c:when test="${empty citas}">
                        <!-- No Results -->
                        <div class="no-results">
                            <div class="no-results-icon">
                                <i class="fas fa-calendar-times"></i>
                            </div>
                            <p><fmt:message key='consulta.no.encontrado'/></p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Cita Items -->
                        <c:forEach var="c" items="${citas}">
                        <div class="cita-item">
                            <div class="cita-row">
                                <div class="cita-info">
                                    <h4>
                                        <i class="fas fa-user"></i>
                                        ${c.paciente.nombres} ${c.paciente.apellidos}
                                    </h4>
                                    <div class="cita-meta">
                                        <span><i class="fas fa-calendar-alt"></i> ${c.fechaCita}</span>
                                        <span><i class="fas fa-clock"></i> ${c.horaCita}</span>
                                        <span><i class="fas fa-user-md"></i> Dr. ${c.medico.nombres} ${c.medico.apellidos}</span>
                                        <span><i class="fas fa-stethoscope"></i> ${c.especialidad.nombre}</span>
                                    </div>
                                    <c:if test="${not empty c.motivo}">
                                    <div class="cita-motivo">
                                        <i class="fas fa-comment-medical"></i>
                                        ${c.motivo}
                                    </div>
                                    </c:if>
                                </div>
                                <div class="cita-actions">
                                    <!-- State Badge -->
                                    <c:choose>
                                        <c:when test="${c.estado == 'PROGRAMADA'}">
                                            <span class="badge badge-programada">
                                                <i class="fas fa-clock"></i>
                                                <fmt:message key='cita.estado.programada'/>
                                            </span>
                                        </c:when>
                                        <c:when test="${c.estado == 'CONFIRMADA'}">
                                            <span class="badge badge-confirmada">
                                                <i class="fas fa-check-circle"></i>
                                                <fmt:message key='cita.estado.confirmada'/>
                                            </span>
                                        </c:when>
                                        <c:when test="${c.estado == 'ATENDIDA'}">
                                            <span class="badge badge-atendida">
                                                <i class="fas fa-check-double"></i>
                                                <fmt:message key='cita.estado.atendida'/>
                                            </span>
                                        </c:when>
                                        <c:when test="${c.estado == 'CANCELADA'}">
                                            <span class="badge badge-cancelada">
                                                <i class="fas fa-times-circle"></i>
                                                <fmt:message key='cita.estado.cancelada'/>
                                            </span>
                                        </c:when>
                                    </c:choose>
                                    
                                    <!-- PDF Button -->
                                    <c:if test="${c.estado == 'PROGRAMADA' || c.estado == 'CONFIRMADA'}">
                                    <a href="${pageContext.request.contextPath}/consulta-cita?accion=pdf&id=${c.id}"
                                       class="btn-pdf" target="_blank">
                                        <i class="fas fa-file-pdf"></i>
                                        <fmt:message key='consulta.descargar'/>
                                    </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:if>

        <!-- Portal Link -->
        <div class="portal-link">
            <a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-lock"></i> Portal del personal de salud
            </a>
        </div>

    </main>

    <script>
        // ================================================
        // VALIDACIÓN FRONTEND: Ambos CAPTCHAs requeridos
        // ================================================
        const consultaForm = document.getElementById('consultaForm');
        
        if (consultaForm) {
            consultaForm.addEventListener('submit', function(e) {
                // 1. Verificar reCAPTCHA de Google
                const recaptchaResponse = document.querySelector('.g-recaptcha-response')?.value;
                if (!recaptchaResponse || recaptchaResponse === '') {
                    e.preventDefault();
                    alert('⚠️ Por favor completa la verificación reCAPTCHA (marca la casilla "No soy un robot").');
                    return false;
                }
                
                // 2. Verificar CAPTCHA visual
                const captchaInput = document.querySelector('input[name="captcha"]')?.value;
                if (!captchaInput || captchaInput.trim() === '') {
                    e.preventDefault();
                    alert('⚠️ Por favor ingresa el código de seguridad que ves en la imagen.');
                    return false;
                }
                
                return true;
            });
        }
        
        // ================================================
        // RECARGAR CAPTCHA VISUAL
        // ================================================
        function recargarCaptcha() {
            const img = document.getElementById('captchaImg');
            if (img) {
                img.src = '${pageContext.request.contextPath}/captcha-imagen?t=' + Date.now();
                img.style.opacity = '0.5';
                setTimeout(() => { img.style.opacity = '1'; }, 200);
            }
        }
        
        // Click en imagen para recargar
        document.getElementById('captchaImg')?.addEventListener('click', recargarCaptcha);
        
        // Auto-focus en input captcha si ya hay documento
        document.addEventListener('DOMContentLoaded', function() {
            const docInput = document.querySelector('input[name="documento"]');
            const captchaInput = document.querySelector('input[name="captcha"]');
            if (docInput?.value && captchaInput) {
                setTimeout(() => captchaInput.focus(), 300);
            }
        });
    </script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>
</html>
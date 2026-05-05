<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="app.nombre" /> | <fmt:message key="app.institucion" /></title>

    <!-- Premium Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        /* Mismo CSS que tenías (no cambia) */
        :root {
            --primary: #0EA5E9;
            --primary-dark: #0284C7;
            --primary-light: #7DD3FC;
            --primary-soft: rgba(14, 165, 233, 0.08);
            --secondary: #06B6D4;
            --accent: #22D3EE;
            --success: #10B981;
            --warning: #F59E0B;
            --bg-body: #FAFBFD;
            --bg-white: #FFFFFF;
            --bg-light: #F0F9FF;
            --bg-glass: rgba(255, 255, 255, 0.85);
            --text-primary: #0F172A;
            --text-secondary: #475569;
            --text-muted: #94A3B8;
            --text-white: #FFFFFF;
            --border-light: #E2E8F0;
            --border-focus: rgba(14, 165, 233, 0.3);
            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 12px rgba(14, 165, 233, 0.08);
            --shadow-lg: 0 10px 30px rgba(14, 165, 233, 0.12);
            --shadow-xl: 0 20px 50px rgba(14, 165, 233, 0.15);
            --shadow-glow: 0 0 40px rgba(14, 165, 233, 0.2);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 20px;
            --radius-xl: 28px;
            --radius-full: 9999px;
            --transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-body); color: var(--text-secondary); line-height: 1.6; overflow-x: hidden; }
        h1, h2, h3, h4, h5, h6 { font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 700; color: var(--text-primary); line-height: 1.2; }
        .container { max-width: 1280px; margin: 0 auto; padding: 0 24px; }
        .section { padding: 80px 0; }

        /* TOP BAR */
        .top-bar { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; padding: 12px 0; font-size: 0.875rem; }
        .top-bar-inner { display: flex; justify-content: space-between; align-items: center; }
        .top-bar-info { display: flex; gap: 32px; align-items: center; }
        .top-bar-item { display: flex; align-items: center; gap: 8px; }
        .top-bar-item i { font-size: 0.9rem; opacity: 0.9; }
        .top-bar-social { display: flex; gap: 16px; }
        .top-bar-social a { color: white; opacity: 0.9; transition: var(--transition); }
        .top-bar-social a:hover { opacity: 1; transform: translateY(-2px); }

        /* LANGUAGE SWITCH TOP */
        .lang-switch-top { display: flex; gap: 4px; background: rgba(255, 255, 255, 0.15); padding: 4px; border-radius: 50px; border: 1px solid rgba(255, 255, 255, 0.25); }
        .lang-btn-top { padding: 6px 14px; border: none; background: transparent; border-radius: 50px; font-weight: 600; font-size: 0.8rem; cursor: pointer; transition: all 0.3s ease; color: rgba(255, 255, 255, 0.85); display: flex; align-items: center; gap: 5px; text-decoration: none; }
        .lang-btn-top.active { background: white; color: var(--primary); box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15); }
        .lang-btn-top:hover:not(.active) { background: rgba(255, 255, 255, 0.2); color: white; }

        /* NAVBAR PREMIUM */
        .navbar-premium { position: sticky; top: 0; z-index: 1000; background: var(--bg-glass); backdrop-filter: blur(20px); border-bottom: 1px solid var(--border-light); padding: 1rem 0; transition: var(--transition); }
        .navbar-inner { display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { display: flex; align-items: center; gap: 12px; text-decoration: none; }
        .nav-logo { width: 44px; height: 44px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.25rem; box-shadow: var(--shadow-md); }
        .nav-brand-text { display: flex; flex-direction: column; }
        .nav-brand-name { font-size: 1.25rem; font-weight: 800; color: var(--primary); line-height: 1.2; }
        .nav-brand-subtitle { font-size: 0.7rem; color: var(--text-muted); font-weight: 500; }
        .nav-links { display: flex; gap: 32px; align-items: center; }
        .nav-link { font-size: 0.9rem; font-weight: 600; color: var(--text-secondary); text-decoration: none; position: relative; padding: 8px 0; transition: var(--transition); }
        .nav-link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: var(--primary); border-radius: 2px; transition: var(--transition); }
        .nav-link:hover { color: var(--primary); }
        .nav-link:hover::after { width: 100%; }
        .nav-actions { display: flex; gap: 12px; align-items: center; }
        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; border-radius: var(--radius-full); font-weight: 600; font-size: 0.9rem; border: none; cursor: pointer; transition: var(--transition); text-decoration: none; }
        .btn-outline { background: transparent; color: var(--primary); border: 2px solid var(--primary); }
        .btn-outline:hover { background: var(--primary); color: white; transform: translateY(-2px); box-shadow: var(--shadow-md); }
        .btn-primary { background: var(--primary); color: white; box-shadow: var(--shadow-sm); }
        .btn-primary:hover { background: var(--primary-dark); transform: translateY(-2px); box-shadow: var(--shadow-lg); }

        /* HERO SECTION */
        .hero-modern { position: relative; min-height: 100vh; display: flex; align-items: center; padding: 60px 0 80px; background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-body) 100%); overflow: hidden; }
        .hero-bg-shape { position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.5; pointer-events: none; }
        .hero-bg-shape-1 { width: 600px; height: 600px; background: radial-gradient(circle, var(--primary-light), transparent); top: -200px; right: -100px; animation: float 20s ease-in-out infinite; }
        .hero-bg-shape-2 { width: 400px; height: 400px; background: radial-gradient(circle, var(--accent), transparent); bottom: -100px; left: -80px; animation: float 25s ease-in-out infinite reverse; }
        @keyframes float { 0%, 100% { transform: translate(0, 0) scale(1); } 33% { transform: translate(30px, -30px) scale(1.1); } 66% { transform: translate(-20px, 20px) scale(0.9); } }
        .hero-grid { display: grid; grid-template-columns: 1fr 0.9fr; gap: 60px; align-items: center; position: relative; z-index: 2; }
        .hero-content { animation: fadeInUp 0.8s ease; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .hero-badge { display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background: white; border-radius: var(--radius-full); box-shadow: var(--shadow-md); margin-bottom: 24px; font-size: 0.875rem; font-weight: 600; color: var(--primary); border: 1px solid var(--border-light); }
        .hero-badge-icon { width: 28px; height: 28px; border-radius: 50%; background: linear-gradient(135deg, var(--success), #4ADE80); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; }
        .hero-title { font-size: clamp(2.5rem, 5vw, 4rem); font-weight: 800; line-height: 1.1; margin-bottom: 20px; letter-spacing: -0.02em; }
        .hero-title span { position: relative; display: inline-block; }
        .hero-title span::after { content: ''; position: absolute; bottom: 8px; left: 0; right: 0; height: 20px; background: var(--primary-light); opacity: 0.4; z-index: -1; border-radius: 4px; }
        .hero-text { font-size: 1.125rem; color: var(--text-secondary); line-height: 1.8; margin-bottom: 32px; max-width: 540px; }
        .hero-buttons { display: flex; gap: 12px; margin-bottom: 48px; flex-wrap: wrap; }
        .btn-hero-primary { padding: 14px 32px; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border-radius: var(--radius-full); font-weight: 600; font-size: 1rem; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; transition: var(--transition); box-shadow: 0 8px 24px rgba(14, 165, 233, 0.3); }
        .btn-hero-primary:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(14, 165, 233, 0.4); color: white; }
        .btn-hero-secondary { padding: 14px 32px; background: white; color: var(--primary); border-radius: var(--radius-full); font-weight: 600; font-size: 1rem; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; transition: var(--transition); border: 2px solid var(--border-light); }
        .btn-hero-secondary:hover { border-color: var(--primary); transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .hero-stats { display: flex; gap: 40px; padding-top: 32px; border-top: 1px solid var(--border-light); }
        .hero-stat { text-align: center; }
        .hero-stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; font-size: 1.25rem; }
        .hero-stat-icon.blue { background: rgba(14, 165, 233, 0.1); color: var(--primary); }
        .hero-stat-icon.green { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        .hero-stat-icon.amber { background: rgba(245, 158, 11, 0.1); color: var(--warning); }
        .hero-stat-number { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 2rem; font-weight: 800; color: var(--text-primary); line-height: 1; }
        .hero-stat-label { font-size: 0.875rem; color: var(--text-muted); font-weight: 500; margin-top: 4px; }
        .hero-visual { position: relative; animation: fadeInUp 0.8s ease 0.2s both; }
        .hero-image-wrapper { position: relative; border-radius: var(--radius-xl); overflow: hidden; box-shadow: var(--shadow-xl); }
        .hero-image-wrapper img { width: 100%; height: auto; display: block; }
        .hero-floating-card { position: absolute; background: white; border-radius: var(--radius-lg); padding: 16px 20px; box-shadow: var(--shadow-lg); display: flex; align-items: center; gap: 12px; z-index: 5; animation: floatCard 6s ease-in-out infinite; border: 1px solid var(--border-light); }
        @keyframes floatCard { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-15px); } }
        .hero-floating-card.top-right { top: -20px; right: -30px; }
        .hero-floating-card.bottom-left { bottom: -20px; left: -30px; animation-delay: -3s; }
        .float-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
        .float-icon.blue { background: rgba(14, 165, 233, 0.1); color: var(--primary); }
        .float-icon.green { background: rgba(16, 185, 129, 0.1); color: var(--success); }
        .float-info h5 { font-size: 1rem; font-weight: 700; margin: 0; color: var(--text-primary); }
        .float-info span { font-size: 0.75rem; color: var(--text-muted); font-weight: 500; }

        /* SERVICES SECTION */
        .services-section { background: var(--bg-white); }
        .section-header { text-align: center; max-width: 700px; margin: 0 auto 56px; }
        .section-badge { display: inline-flex; align-items: center; gap: 8px; padding: 6px 16px; background: var(--primary-soft); border-radius: var(--radius-full); font-size: 0.875rem; font-weight: 600; color: var(--primary); margin-bottom: 16px; }
        .section-title { font-size: clamp(2rem, 4vw, 2.75rem); font-weight: 800; margin-bottom: 12px; }
        .section-subtitle { font-size: 1.1rem; color: var(--text-secondary); line-height: 1.7; }
        .services-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; }
        .service-card { background: var(--bg-white); border-radius: var(--radius-xl); padding: 32px 24px; border: 1px solid var(--border-light); transition: var(--transition); cursor: pointer; position: relative; overflow: hidden; }
        .service-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--primary), var(--secondary)); transform: scaleX(0); transition: var(--transition); }
        .service-card:hover::before { transform: scaleX(1); }
        .service-card:hover { transform: translateY(-8px); box-shadow: var(--shadow-xl); border-color: transparent; }
        .service-icon { width: 64px; height: 64px; border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center; font-size: 1.75rem; margin-bottom: 20px; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; }
        .service-card h4 { font-size: 1.25rem; margin-bottom: 10px; }
        .service-card p { font-size: 0.95rem; color: var(--text-muted); margin: 0; line-height: 1.6; }

        /* ABOUT SECTION */
        .about-section { background: var(--bg-light); }
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center; }
        .about-image-wrapper { position: relative; border-radius: var(--radius-xl); overflow: hidden; box-shadow: var(--shadow-xl); }
        .about-image-wrapper img { width: 100%; height: 480px; object-fit: cover; }
        .about-experience-badge { position: absolute; bottom: 24px; right: 24px; background: white; border-radius: var(--radius-lg); padding: 20px 24px; text-align: center; box-shadow: var(--shadow-lg); }
        .about-experience-badge .number { font-family: 'Plus Jakarta Sans', sans-serif; font-size: 2.5rem; font-weight: 800; color: var(--primary); line-height: 1; }
        .about-experience-badge .label { font-size: 0.875rem; color: var(--text-muted); font-weight: 600; margin-top: 4px; }
        .about-content h2 { font-size: 2.5rem; margin-bottom: 20px; }
        .about-content > p { font-size: 1.05rem; color: var(--text-secondary); line-height: 1.8; margin-bottom: 32px; }
        .about-features { display: flex; flex-direction: column; gap: 20px; }
        .about-feature { display: flex; gap: 16px; padding: 16px; border-radius: var(--radius-lg); transition: var(--transition); background: white; border: 1px solid transparent; }
        .about-feature:hover { border-color: var(--border-light); box-shadow: var(--shadow-md); }
        .about-feature-icon { width: 48px; height: 48px; border-radius: var(--radius-md); background: var(--primary-soft); display: flex; align-items: center; justify-content: center; color: var(--primary); flex-shrink: 0; font-size: 1.25rem; }
        .about-feature h4 { font-size: 1.1rem; margin-bottom: 4px; }
        .about-feature p { font-size: 0.9rem; color: var(--text-muted); margin: 0; }

        /* INFO SECTION */
        .info-section { background: var(--bg-white); }
        .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        .info-card { background: linear-gradient(135deg, var(--bg-light), white); border-radius: var(--radius-xl); padding: 32px; border: 1px solid var(--border-light); transition: var(--transition); }
        .info-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-lg); }
        .info-icon { width: 56px; height: 56px; border-radius: var(--radius-lg); background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; margin-bottom: 20px; }
        .info-card h4 { font-size: 1.25rem; margin-bottom: 12px; }
        .info-card p, .info-card ul { font-size: 0.95rem; color: var(--text-secondary); line-height: 1.7; margin: 0; }
        .info-card ul { list-style: none; padding: 0; }
        .info-card ul li { margin-bottom: 8px; display: flex; align-items: center; gap: 8px; }
        .info-card ul li i { color: var(--primary); font-size: 0.8rem; }
        .schedule-table { margin-top: 16px; width: 100%; }
        .schedule-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-light); font-size: 0.9rem; }
        .schedule-row:last-child { border-bottom: none; }
        .schedule-row .day { font-weight: 600; color: var(--text-primary); }
        .schedule-row .time { color: var(--text-muted); }
        .status-badge { display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background: rgba(16, 185, 129, 0.1); border-radius: var(--radius-full); color: var(--success); font-size: 0.875rem; font-weight: 600; margin-top: 16px; }
        .status-badge .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--success); animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

        /* CTA SECTION */
        .cta-section { background: linear-gradient(135deg, var(--primary), var(--secondary)); padding: 80px 0; position: relative; overflow: hidden; }
        .cta-section::before { content: ''; position: absolute; top: -50%; right: -20%; width: 600px; height: 600px; background: radial-gradient(circle, rgba(255, 255, 255, 0.1), transparent 70%); border-radius: 50%; }
        .cta-content { position: relative; z-index: 2; text-align: center; max-width: 700px; margin: 0 auto; color: white; }
        .cta-content h2 { color: white; font-size: 2.5rem; margin-bottom: 16px; }
        .cta-content p { font-size: 1.15rem; opacity: 0.95; margin-bottom: 32px; }
        .btn-cta-white { padding: 16px 32px; background: white; color: var(--primary); border-radius: var(--radius-full); font-weight: 700; font-size: 1rem; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; transition: var(--transition); box-shadow: var(--shadow-lg); }
        .btn-cta-white:hover { transform: translateY(-3px); box-shadow: var(--shadow-xl); color: var(--primary); }

        /* FOOTER */
        .footer { background: var(--text-primary); color: var(--text-muted); padding: 64px 0 32px; }
        .footer-grid { display: grid; grid-template-columns: 1.5fr 1fr 1fr 1fr; gap: 40px; margin-bottom: 48px; }
        .footer h5 { color: white; font-size: 1rem; font-weight: 700; margin-bottom: 20px; }
        .footer a { color: var(--text-muted); text-decoration: none; transition: var(--transition); font-size: 0.9rem; }
        .footer a:hover { color: white; }
        .footer-links { list-style: none; padding: 0; }
        .footer-links li { margin-bottom: 10px; }
        .footer-links a { display: flex; align-items: center; gap: 8px; }
        .footer-links a i { font-size: 0.7rem; color: var(--primary); }
        .footer-social { display: flex; gap: 12px; margin-top: 20px; }
        .footer-social a { width: 40px; height: 40px; border-radius: 50%; background: rgba(255, 255, 255, 0.1); display: flex; align-items: center; justify-content: center; color: white; transition: var(--transition); }
        .footer-social a:hover { background: var(--primary); transform: translateY(-3px); }
        .footer-bottom { border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 24px; text-align: center; font-size: 0.875rem; }

        @media (max-width: 991px) {
            .hero-grid { grid-template-columns: 1fr; text-align: center; }
            .hero-content { max-width: 600px; margin: 0 auto; }
            .hero-buttons { justify-content: center; }
            .hero-stats { justify-content: center; }
            .hero-visual { display: none; }
            .about-grid { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
            .footer-grid { grid-template-columns: 1fr 1fr; }
            .top-bar-info { display: none; }
        }
        @media (max-width: 768px) {
            .nav-links { display: none; }
            .section { padding: 60px 0; }
            .footer-grid { grid-template-columns: 1fr; text-align: center; }
            .footer-links a { justify-content: center; }
            .footer-social { justify-content: center; }
        }
    </style>
</head>

<body>

    <!-- TOP BAR -->
    <div class="top-bar">
        <div class="container">
            <div class="top-bar-inner">
                <div class="top-bar-info">
                    <div class="top-bar-item"><i class="fas fa-clock"></i><span><fmt:message key="index.topbar.horario" /></span></div>
                    <div class="top-bar-item"><i class="fas fa-envelope"></i><span><fmt:message key="index.topbar.email" /></span></div>
                    <div class="top-bar-item"><i class="fas fa-phone"></i><span><fmt:message key="index.topbar.telefono" /></span></div>
                </div>
                
                <!-- LANGUAGE SELECTOR -->
                <div class="lang-switch-top">
                    <a href="?lang=es" class="lang-btn-top ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                    <a href="?lang=en" class="lang-btn-top ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                    <a href="?lang=it" class="lang-btn-top ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                </div>
                
                <div class="top-bar-social">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
    </div>

    <!-- NAVBAR -->
    <nav class="navbar-premium" id="navbar">
        <div class="container">
            <div class="navbar-inner">
                <a href="${pageContext.request.contextPath}/" class="nav-brand">
                    <div class="nav-logo"><i class="fas fa-hospital"></i></div>
                    <div class="nav-brand-text">
                        <span class="nav-brand-name"><fmt:message key="app.nombre" /></span>
                        <span class="nav-brand-subtitle"><fmt:message key="app.institucion" /></span>
                    </div>
                </a>
                <div class="nav-links">
                    <a href="#inicio" class="nav-link"><fmt:message key="index.nav.inicio" /></a>
                    <a href="#servicios" class="nav-link"><fmt:message key="index.nav.servicios" /></a>
                    <a href="#nosotros" class="nav-link"><fmt:message key="index.nav.nosotros" /></a>
                    <a href="#ubicacion" class="nav-link"><fmt:message key="index.nav.ubicacion" /></a>
                </div>
                <div class="nav-actions">
                    <a href="${pageContext.request.contextPath}/consulta-cita" class="btn btn-outline"><fmt:message key="index.nav.consultar" /></a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary"><fmt:message key="index.nav.portal" /></a>
                </div>
            </div>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="hero-modern" id="inicio">
        <div class="hero-bg-shape hero-bg-shape-1"></div>
        <div class="hero-bg-shape hero-bg-shape-2"></div>
        <div class="container">
            <div class="hero-grid">
                <div class="hero-content">
                    <div class="hero-badge">
                        <span class="hero-badge-icon">✓</span>
                        <fmt:message key="index.hero.badge" />
                    </div>
                    <h1 class="hero-title"><fmt:message key="index.hero.titulo" /></h1>
                    <p class="hero-text"><fmt:message key="index.hero.texto" /></p>
                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/consulta-cita" class="btn-hero-primary">
                            <i class="fas fa-calendar-check"></i> <fmt:message key="index.hero.btn.cita" />
                            <i class="fas fa-arrow-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/login" class="btn-hero-secondary">
                            <i class="fas fa-user-md"></i> <fmt:message key="index.hero.btn.portal" />
                        </a>
                    </div>
                    <div class="hero-stats">
                        <div class="hero-stat">
                            <div class="hero-stat-icon blue"><i class="fas fa-users"></i></div>
                            <div class="hero-stat-number">1,250+</div>
                            <div class="hero-stat-label"><fmt:message key="index.hero.stat.pacientes" /></div>
                        </div>
                        <div class="hero-stat">
                            <div class="hero-stat-icon green"><i class="fas fa-user-md"></i></div>
                            <div class="hero-stat-number">12</div>
                            <div class="hero-stat-label"><fmt:message key="index.hero.stat.medicos" /></div>
                        </div>
                        <div class="hero-stat">
                            <div class="hero-stat-icon amber"><i class="fas fa-stethoscope"></i></div>
                            <div class="hero-stat-number">5</div>
                            <div class="hero-stat-label"><fmt:message key="index.hero.stat.especialidades" /></div>
                        </div>
                    </div>
                </div>
                <div class="hero-visual">
                    <div class="hero-image-wrapper">
                        <img src="https://d2xsxph8kpxj0f.cloudfront.net/310519663561171191/ifFzi2hYf38gG6uTof7HxP/hero-doctor-team-MaPc2wePZXc4pxJCMykWi8.webp" alt="Medical Team">
                    </div>
                    <div class="hero-floating-card top-right">
                        <div class="float-icon green"><i class="fas fa-check-circle"></i></div>
                        <div class="float-info">
                            <h5>98.5%</h5>
                            <span><fmt:message key="index.hero.card.satisfaccion" /></span>
                        </div>
                    </div>
                    <div class="hero-floating-card bottom-left">
                        <div class="float-icon blue"><i class="fas fa-phone-volume"></i></div>
                        <div class="float-info">
                            <h5><fmt:message key="index.hero.card.emergencias" /></h5>
                            <span>(608) 785-1234</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SERVICES SECTION -->
    <section class="section services-section" id="servicios">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <div class="section-badge"><i class="fas fa-stethoscope"></i> <fmt:message key="index.servicios.badge" /></div>
                <h2 class="section-title"><fmt:message key="index.servicios.titulo" /></h2>
                <p class="section-subtitle"><fmt:message key="index.servicios.subtitulo" /></p>
            </div>
            <div class="services-grid">
                <div class="service-card" data-aos="fade-up" data-aos-delay="0">
                    <div class="service-icon"><i class="fas fa-heartbeat"></i></div>
                    <h4><fmt:message key="index.servicios.medicina" /></h4>
                    <p><fmt:message key="index.servicios.medicina.desc" /></p>
                </div>
                <div class="service-card" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-icon" style="background: linear-gradient(135deg, #10B981, #4ADE80);"><i class="fas fa-tooth"></i></div>
                    <h4><fmt:message key="index.servicios.odontologia" /></h4>
                    <p><fmt:message key="index.servicios.odontologia.desc" /></p>
                </div>
                <div class="service-card" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-icon" style="background: linear-gradient(135deg, #F59E0B, #FBBF24);"><i class="fas fa-child"></i></div>
                    <h4><fmt:message key="index.servicios.pediatria" /></h4>
                    <p><fmt:message key="index.servicios.pediatria.desc" /></p>
                </div>
                <div class="service-card" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-icon" style="background: linear-gradient(135deg, #EC4899, #F472B6);"><i class="fas fa-female"></i></div>
                    <h4><fmt:message key="index.servicios.ginecologia" /></h4>
                    <p><fmt:message key="index.servicios.ginecologia.desc" /></p>
                </div>
                <div class="service-card" data-aos="fade-up" data-aos-delay="400">
                    <div class="service-icon" style="background: linear-gradient(135deg, #8B5CF6, #A78BFA);"><i class="fas fa-eye"></i></div>
                    <h4><fmt:message key="index.servicios.optometria" /></h4>
                    <p><fmt:message key="index.servicios.optometria.desc" /></p>
                </div>
                <div class="service-card" data-aos="fade-up" data-aos-delay="500" style="background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border: none;">
                    <div class="service-icon" style="background: rgba(255,255,255,0.2);"><i class="fas fa-phone-volume"></i></div>
                    <h4 style="color: white;"><fmt:message key="index.servicios.urgencias" /></h4>
                    <p style="color: rgba(255,255,255,0.9);"><fmt:message key="index.servicios.urgencias.desc" /></p>
                </div>
            </div>
        </div>
    </section>

    <!-- ABOUT SECTION -->
    <section class="section about-section" id="nosotros">
        <div class="container">
            <div class="about-grid">
                <div class="about-image-wrapper" data-aos="fade-right">
                    <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600&h=480&fit=crop" alt="Health Center">
                    <div class="about-experience-badge">
                        <div class="number">15+</div>
                        <div class="label"><fmt:message key="index.nosotros.anos" /></div>
                    </div>
                </div>
                <div class="about-content" data-aos="fade-left">
                    <div class="section-badge" style="text-align: left; margin-bottom: 16px;"><i class="fas fa-award"></i> <fmt:message key="index.nosotros.badge" /></div>
                    <h2><fmt:message key="index.nosotros.titulo" /></h2>
                    <p><fmt:message key="index.nosotros.texto" /></p>
                    <div class="about-features">
                        <div class="about-feature">
                            <div class="about-feature-icon"><i class="fas fa-user-md"></i></div>
                            <div><h4><fmt:message key="index.nosotros.equipo" /></h4><p><fmt:message key="index.nosotros.equipo.desc" /></p></div>
                        </div>
                        <div class="about-feature">
                            <div class="about-feature-icon"><i class="fas fa-laptop-medical"></i></div>
                            <div><h4><fmt:message key="index.nosotros.tecnologia" /></h4><p><fmt:message key="index.nosotros.tecnologia.desc" /></p></div>
                        </div>
                        <div class="about-feature">
                            <div class="about-feature-icon"><i class="fas fa-hand-holding-heart"></i></div>
                            <div><h4><fmt:message key="index.nosotros.atencion" /></h4><p><fmt:message key="index.nosotros.atencion.desc" /></p></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- LOCATION/INFO SECTION -->
    <section class="section info-section" id="ubicacion">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <div class="section-badge"><i class="fas fa-map-marker-alt"></i> <fmt:message key="index.ubicacion.badge" /></div>
                <h2 class="section-title"><fmt:message key="index.ubicacion.titulo" /></h2>
                <p class="section-subtitle"><fmt:message key="index.ubicacion.subtitulo" /></p>
            </div>
            <div class="info-grid">
                <div class="info-card" data-aos="fade-up" data-aos-delay="0">
                    <div class="info-icon"><i class="fas fa-map-pin"></i></div>
                    <h4><fmt:message key="index.ubicacion.direccion" /></h4>
                    <p><fmt:message key="index.ubicacion.direccion.texto" /></p>
                    <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-light);">
                        <a href="https://maps.google.com" target="_blank" class="btn btn-outline" style="width: 100%; justify-content: center;">
                            <i class="fas fa-location-arrow"></i> <fmt:message key="index.ubicacion.mapa" />
                        </a>
                    </div>
                </div>
                <div class="info-card" data-aos="fade-up" data-aos-delay="100">
                    <div class="info-icon"><i class="fas fa-address-book"></i></div>
                    <h4><fmt:message key="index.ubicacion.contacto" /></h4>
                    <ul>
                        <li><i class="fas fa-phone"></i> (608) 785-1234</li>
                        <li><i class="fas fa-mobile-alt"></i> +57 310 123 4567</li>
                        <li><i class="fas fa-envelope"></i> info@saludboyaca.gov.co</li>
                        <li><i class="fas fa-fax"></i> (608) 785-1235</li>
                    </ul>
                </div>
                <div class="info-card" data-aos="fade-up" data-aos-delay="200">
                    <div class="info-icon"><i class="fas fa-clock"></i></div>
                    <h4><fmt:message key="index.ubicacion.horarios" /></h4>
                    <div class="schedule-table">
                        <div class="schedule-row"><span class="day"><fmt:message key="index.ubicacion.lv" /></span><span class="time">7:00 AM - 6:00 PM</span></div>
                        <div class="schedule-row"><span class="day"><fmt:message key="index.ubicacion.sabado" /></span><span class="time">8:00 AM - 2:00 PM</span></div>
                        <div class="schedule-row"><span class="day"><fmt:message key="index.ubicacion.domingo" /></span><span class="time"><fmt:message key="index.ubicacion.domingo.hora" /></span></div>
                        <div class="schedule-row"><span class="day"><fmt:message key="index.ubicacion.urgencias" /></span><span class="time" style="color: var(--success); font-weight: 600;">24/7</span></div>
                    </div>
                    <div class="status-badge"><span class="dot"></span> <fmt:message key="index.ubicacion.abierto" /></div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA SECTION -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content" data-aos="zoom-in">
                <h2><fmt:message key="index.cta.titulo" /></h2>
                <p><fmt:message key="index.cta.texto" /></p>
                <a href="${pageContext.request.contextPath}/login" class="btn-cta-white">
                    <i class="fas fa-user-md"></i> <fmt:message key="index.cta.btn" />
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div>
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                        <div style="width: 44px; height: 44px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem;"><i class="fas fa-hospital"></i></div>
                        <div><h4 style="color: white; margin: 0;">SaludBoyacá</h4></div>
                    </div>
                    <p style="font-size: 0.9rem; line-height: 1.7; margin-bottom: 20px;"><fmt:message key="index.footer.desc" /></p>
                    <div class="footer-social">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div>
                    <h5><fmt:message key="index.footer.enlaces" /></h5>
                    <ul class="footer-links">
                        <li><a href="#inicio"><i class="fas fa-chevron-right"></i> <fmt:message key="index.nav.inicio" /></a></li>
                        <li><a href="#servicios"><i class="fas fa-chevron-right"></i> <fmt:message key="index.nav.servicios" /></a></li>
                        <li><a href="#nosotros"><i class="fas fa-chevron-right"></i> <fmt:message key="index.nav.nosotros" /></a></li>
                        <li><a href="#ubicacion"><i class="fas fa-chevron-right"></i> <fmt:message key="index.nav.ubicacion" /></a></li>
                    </ul>
                </div>
                <div>
                    <h5><fmt:message key="index.footer.servicios" /></h5>
                    <ul class="footer-links">
                        <li><a href="#"><fmt:message key="index.servicios.medicina" /></a></li>
                        <li><a href="#"><fmt:message key="index.servicios.odontologia" /></a></li>
                        <li><a href="#"><fmt:message key="index.servicios.pediatria" /></a></li>
                        <li><a href="#"><fmt:message key="index.servicios.ginecologia" /></a></li>
                        <li><a href="#"><fmt:message key="index.servicios.optometria" /></a></li>
                    </ul>
                </div>
                <div>
                    <h5><fmt:message key="index.footer.contacto" /></h5>
                    <ul class="footer-links" style="list-style: none; padding: 0;">
                        <li><i class="fas fa-map-marker-alt" style="color: var(--primary); width: 20px;"></i> <fmt:message key="index.ubicacion.direccion.texto" /></li>
                        <li><i class="fas fa-phone" style="color: var(--primary); width: 20px;"></i> (608) 785-1234</li>
                        <li><i class="fas fa-envelope" style="color: var(--primary); width: 20px;"></i> info@saludboyaca.gov.co</li>
                        <li><i class="fas fa-clock" style="color: var(--primary); width: 20px;"></i> <fmt:message key="index.topbar.horario" /></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p><fmt:message key="app.footer" /> | <a href="#" style="color: var(--primary);"><fmt:message key="index.footer.privacidad" /></a></p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 700, once: true, offset: 50 });
        window.addEventListener('scroll', () => {
            document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 50);
        });
        document.querySelectorAll('a[href^="#"]').forEach(a => {
            a.addEventListener('click', e => {
                e.preventDefault();
                document.querySelector(a.getAttribute('href'))?.scrollIntoView({ behavior: 'smooth' });
            });
        });
    </script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>

</html>
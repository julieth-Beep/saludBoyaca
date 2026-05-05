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
    <title>Pacientes | SaludBoyacá</title>
    
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
            --bg-surface: rgba(255,255,255,0.95); --bg-surface-alt: rgba(248,250,252,0.9);
            --border-subtle: rgba(148,163,184,0.3);
            --radius-sm: 10px; --radius-md: 16px; --radius-lg: 24px; --radius-xl: 32px; --radius-full: 9999px;
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
        .orb-3 { width: 300px; height: 300px; background: linear-gradient(135deg, #DDD6FE, transparent); top: 50%; left: 50%; animation-delay: -14s; }
        .bg-grid { position: fixed; inset: 0; background-image: linear-gradient(rgba(13,148,136,0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(13,148,136,0.03) 1px, transparent 1px); background-size: 60px 60px; pointer-events: none; z-index: 0; }
        @keyframes float { 0%,100% { transform: translate(0,0) scale(1); } 50% { transform: translate(40px,-40px) scale(1.1); } }

        .app-wrapper { display: flex; min-height: 100vh; position: relative; z-index: 1; }

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

        .main-content { flex: 1; margin-left: 280px; padding: 32px 40px; }
        .top-bar { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); padding: 24px 32px; margin-bottom: 32px; box-shadow: var(--glass-shadow); display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
        .top-bar::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--primary), var(--secondary), var(--primary)); background-size: 200% 100%; animation: shimmer 3s linear infinite; }
        @keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }
        .page-header { display: flex; align-items: center; gap: 16px; }
        .page-icon { width: 56px; height: 56px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; box-shadow: 0 8px 24px var(--primary-glow); }
        .page-title { font-family: var(--font-display); font-size: 1.8rem; font-weight: 800; color: var(--text-primary); letter-spacing: -0.02em; margin: 0; }
        .page-subtitle { font-size: 0.95rem; color: var(--text-muted); margin-top: 2px; font-weight: 500; }
        .search-box { position: relative; width: 400px; }
        .search-box input { width: 100%; padding: 14px 20px 14px 52px; border: 2px solid var(--border-subtle); border-radius: var(--radius-lg); background: white; font-size: 0.95rem; font-family: inherit; transition: var(--transition-fast); }
        .search-box input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px var(--primary-soft); }
        .search-box i { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 1.1rem; }
        .top-actions { display: flex; align-items: center; gap: 12px; }
        .lang-switch { display: flex; gap: 4px; background: white; padding: 4px; border-radius: var(--radius-md); border: 2px solid var(--border-subtle); }
        .lang-btn { padding: 8px 14px; border: none; background: transparent; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; transition: var(--transition-fast); font-size: 0.82rem; text-decoration: none; color: var(--text-muted); display: flex; align-items: center; gap: 5px; }
        .lang-btn.active { background: var(--primary); color: white; box-shadow: 0 2px 8px var(--primary-glow); }
        .lang-btn:hover:not(.active) { background: var(--border-subtle); color: var(--text-primary); }

        /* ═══════════ STATS CARDS (TU DISEÑO ORIGINAL) ═══════════ */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card { position: relative; padding: 28px; border-radius: var(--radius-lg); background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); box-shadow: var(--glass-shadow); overflow: hidden; transition: var(--transition-normal); cursor: default; }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, transparent, var(--primary), transparent); opacity: 0; transition: opacity var(--transition-fast); }
        .stat-card:hover { transform: translateY(-8px); box-shadow: var(--shadow-lg), var(--shadow-glow); }
        .stat-card:hover::before { opacity: 1; }
        .stat-card::after { content: ''; position: absolute; width: 140px; height: 140px; border-radius: 50%; filter: blur(50px); opacity: 0.15; pointer-events: none; transition: all var(--transition-normal); }
        .stat-card:hover::after { opacity: 0.3; transform: scale(1.2); }
        .stat-card.total::after { background: linear-gradient(135deg, #22D3EE, #06B6D4); top: -50px; right: -50px; }
        .stat-card.active::after { background: linear-gradient(135deg, #4ADE80, #22C55E); top: -50px; right: -50px; }
        .stat-card.new::after { background: linear-gradient(135deg, #818CF8, #6366F1); top: -50px; right: -50px; }
        .stat-card.urgent::after { background: linear-gradient(135deg, #F87171, #EF4444); top: -50px; right: -50px; }
        .stat-card .pattern { position: absolute; top: 0; right: 0; width: 100px; height: 100px; opacity: 0.06; pointer-events: none; background-image: radial-gradient(circle at 2px 2px, currentColor 1px, transparent 0); background-size: 16px 16px; }
        .stat-content { position: relative; z-index: 2; display: flex; flex-direction: column; gap: 18px; }
        .stat-icon-wrapper { position: relative; width: 68px; height: 68px; display: flex; align-items: center; justify-content: center; }
        .stat-icon { position: relative; width: 60px; height: 60px; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.6rem; z-index: 2; transition: transform var(--transition-fast); }
        .stat-card:hover .stat-icon { transform: scale(1.15) rotate(5deg); }
        .stat-icon.total { background: linear-gradient(135deg, #22D3EE, #06B6D4); color: white; box-shadow: 0 6px 20px rgba(6,182,212,0.4), inset 0 2px 0 rgba(255,255,255,0.3); }
        .stat-icon.active { background: linear-gradient(135deg, #4ADE80, #22C55E); color: white; box-shadow: 0 6px 20px rgba(34,197,94,0.4), inset 0 2px 0 rgba(255,255,255,0.3); }
        .stat-icon.new { background: linear-gradient(135deg, #818CF8, #6366F1); color: white; box-shadow: 0 6px 20px rgba(99,102,241,0.4), inset 0 2px 0 rgba(255,255,255,0.3); }
        .stat-icon.urgent { background: linear-gradient(135deg, #F87171, #EF4444); color: white; box-shadow: 0 6px 20px rgba(239,68,68,0.4), inset 0 2px 0 rgba(255,255,255,0.3); }
        .stat-icon::after { content: ''; position: absolute; inset: -5px; border-radius: inherit; border: 2px solid transparent; border-top-color: rgba(255,255,255,0.7); border-right-color: rgba(255,255,255,0.3); animation: spin 3s linear infinite; opacity: 0.7; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .stat-card.urgent .stat-icon::after { animation: pulse-ring 2s ease-in-out infinite; }
        @keyframes pulse-ring { 0%,100% { transform: scale(1); opacity: 0.7; border-width: 2px; } 50% { transform: scale(1.2); opacity: 0.4; border-width: 1px; } }
        .stat-value-wrapper { display: flex; align-items: baseline; gap: 10px; }
        .stat-value { font-family: var(--font-display); font-size: 2.5rem; font-weight: 800; color: var(--text-primary); line-height: 1; letter-spacing: -0.03em; position: relative; }
        .stat-value::after { content: ''; position: absolute; bottom: -6px; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--primary), transparent); border-radius: 3px; transform: scaleX(0); transform-origin: left; transition: transform var(--transition-normal); }
        .stat-card:hover .stat-value::after { transform: scaleX(1); }
        .stat-value-suffix { font-size: 1rem; font-weight: 600; color: var(--text-muted); }
        .stat-label { font-size: 0.95rem; font-weight: 600; color: var(--text-secondary); display: flex; align-items: center; gap: 8px; }
        .stat-label i { font-size: 0.9rem; opacity: 0.7; }
        .stat-trend { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: var(--radius-full); font-size: 0.85rem; font-weight: 700; background: linear-gradient(135deg, rgba(16,185,129,0.2), rgba(16,185,129,0.05)); color: var(--success); border: 1px solid rgba(16,185,129,0.3); transition: var(--transition-fast); }
        .stat-trend.down { background: linear-gradient(135deg, rgba(239,68,68,0.2), rgba(239,68,68,0.05)); color: var(--danger); border-color: rgba(239,68,68,0.3); }
        .stat-sparkline { display: flex; align-items: flex-end; gap: 3px; height: 28px; margin-top: 10px; }
        .spark-bar { flex: 1; min-width: 4px; border-radius: 3px 3px 0 0; background: var(--primary); opacity: 0.6; transition: all var(--transition-fast); }
        .stat-card:hover .spark-bar { opacity: 1; }
        .stat-actions { position: absolute; bottom: 20px; right: 20px; display: flex; gap: 8px; opacity: 0; transform: translateY(10px); transition: var(--transition-fast); z-index: 3; }
        .stat-card:hover .stat-actions { opacity: 1; transform: translateY(0); }
        .stat-action-btn { width: 32px; height: 32px; border-radius: var(--radius-sm); border: none; background: white; display: flex; align-items: center; justify-content: center; color: var(--text-secondary); cursor: pointer; transition: var(--transition-fast); font-size: 0.8rem; box-shadow: var(--shadow-sm); }
        .stat-action-btn:hover { background: var(--primary); color: white; transform: scale(1.15); box-shadow: var(--shadow-md); }

        /* ═══════════ CONTENT SECTION ═══════════ */
        .content-section { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); box-shadow: var(--glass-shadow); overflow: hidden; margin-bottom: 32px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; padding: 24px 32px; border-bottom: 2px solid var(--border-subtle); background: linear-gradient(135deg, rgba(13,148,136,0.05), transparent); }
        .section-title { font-family: var(--font-display); font-size: 1.3rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 12px; }
        .section-title i { color: var(--primary); font-size: 1.4rem; }
        .btn-primary { padding: 12px 24px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: var(--transition-fast); display: inline-flex; align-items: center; gap: 10px; text-decoration: none; box-shadow: 0 4px 16px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-3px); box-shadow: 0 8px 24px var(--primary-glow); }

        /* ═══════════ FILTROS ═══════════ */
        .filters-bar { display: flex; align-items: center; gap: 12px; padding: 16px 24px; background: var(--bg-surface-alt); border-bottom: 1px solid var(--border-subtle); flex-wrap: wrap; }
        .filters-label { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; font-weight: 600; color: var(--text-secondary); margin-right: 8px; }
        .filters-label i { color: var(--primary); }
        .eps-pills { display: flex; gap: 8px; flex-wrap: wrap; flex: 1; }
        .eps-pill { padding: 8px 16px; border-radius: var(--radius-full); border: 2px solid transparent; background: white; font-size: 0.85rem; font-weight: 500; color: var(--text-secondary); cursor: pointer; transition: all var(--transition-fast); display: flex; align-items: center; gap: 6px; box-shadow: var(--shadow-xs); }
        .eps-pill:hover { transform: translateY(-2px); box-shadow: var(--shadow-sm); }
        .eps-pill.active { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border-color: var(--primary); box-shadow: 0 4px 16px var(--primary-glow); }
        .eps-pill .count { background: var(--primary-soft); color: var(--primary-dark); padding: 2px 8px; border-radius: var(--radius-full); font-size: 0.75rem; font-weight: 700; margin-left: 4px; }
        .eps-pill.active .count { background: rgba(255,255,255,0.25); color: white; }
        .btn-clear { padding: 8px 16px; border-radius: var(--radius-md); border: 1px solid var(--border-subtle); background: white; color: var(--text-muted); font-size: 0.85rem; font-weight: 500; cursor: pointer; transition: all var(--transition-fast); display: flex; align-items: center; gap: 6px; }
        .btn-clear:hover { background: var(--danger-soft); color: var(--danger); border-color: var(--danger); }
        .results-counter { margin-left: auto; font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 6px; padding: 8px 14px; background: white; border-radius: var(--radius-full); border: 1px solid var(--border-subtle); }
        .results-counter strong { color: var(--primary); font-weight: 700; }

        /* ═══════════ TABLA NUEVA (IGUAL QUE CITAS) ═══════════ */
        .table-wrapper { overflow-x: auto; }
        .patient-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .patient-table thead { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; }
        .patient-table th { padding: 18px 24px; text-align: left; font-weight: 700; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.08em; white-space: nowrap; }
        .patient-table th:first-child { border-top-left-radius: var(--radius-md); }
        .patient-table th:last-child { border-top-right-radius: var(--radius-md); text-align: center; }
        .patient-table td { padding: 20px 24px; border-bottom: 1px solid var(--border-subtle); font-size: 0.95rem; vertical-align: middle; }
        .patient-table td:last-child { text-align: center; }
        .patient-table tbody tr { background: white; transition: all var(--transition-normal); cursor: pointer; }
        .patient-table tbody tr:hover { background: linear-gradient(135deg, rgba(13,148,136,0.05), rgba(99,102,241,0.05)); transform: scale(1.01); box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .patient-table tbody tr:last-child td { border-bottom: none; }
        .patient-cell { display: flex; align-items: center; gap: 16px; }
        .patient-avatar { width: 48px; height: 48px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.1rem; box-shadow: 0 4px 12px var(--primary-glow); flex-shrink: 0; position: relative; overflow: hidden; }
        .patient-avatar::after { content: ''; position: absolute; inset: 0; background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent); }
        .patient-info { display: flex; flex-direction: column; gap: 4px; }
        .patient-name { font-weight: 700; color: var(--text-primary); font-size: 1rem; }
        .patient-location { font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 6px; }
        .patient-doc { font-family: monospace; background: var(--primary-soft); padding: 8px 14px; border-radius: var(--radius-sm); font-weight: 600; color: var(--primary-dark); display: inline-block; border: 1px solid rgba(13,148,136,0.2); }
        .eps-badge { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: var(--radius-full); font-size: 0.85rem; font-weight: 600; background: var(--success-soft); color: var(--success); border: 2px solid rgba(16,185,129,0.3); }
        .eps-badge.sanitas { background: linear-gradient(135deg, #0EA5E9, #0284C7); color: white; border: none; }
        .eps-badge.compensar { background: linear-gradient(135deg, #8B5CF6, #7C3AED); color: white; border: none; }
        .eps-badge.nueva { background: linear-gradient(135deg, #10B981, #059669); color: white; border: none; }
        .eps-badge.coosalud { background: linear-gradient(135deg, #F59E0B, #D97706); color: white; border: none; }
        .eps-badge.famisanar { background: linear-gradient(135deg, #EC4899, #DB2777); color: white; border: none; }
        .action-group { display: flex; gap: 6px; justify-content: center; opacity: 0; transform: translateX(15px); transition: all var(--transition-fast); }
        .patient-table tbody tr:hover .action-group { opacity: 1; transform: translateX(0); }
        .btn-action { width: 34px; height: 34px; border-radius: var(--radius-md); border: none; display: inline-flex; align-items: center; justify-content: center; font-size: 0.85rem; cursor: pointer; transition: all var(--transition-fast); text-decoration: none; position: relative; }
        .btn-action::before { content: attr(data-tooltip); position: absolute; bottom: 100%; left: 50%; transform: translateX(-50%) translateY(-8px); padding: 4px 10px; background: var(--text-primary); color: white; font-size: 0.7rem; border-radius: var(--radius-sm); white-space: nowrap; opacity: 0; pointer-events: none; transition: opacity var(--transition-fast), transform var(--transition-fast); z-index: 10; }
        .btn-action:hover::before { opacity: 1; transform: translateX(-50%) translateY(-12px); }
        .btn-action.view { background: var(--info-soft); color: var(--info); }
        .btn-action.view:hover { background: var(--info); color: white; transform: translateY(-2px); }
        .btn-action.edit { background: var(--warning-soft); color: var(--warning); }
        .btn-action.edit:hover { background: var(--warning); color: white; transform: translateY(-2px); }
        .btn-action.delete { background: var(--danger-soft); color: var(--danger); }
        .btn-action.delete:hover { background: var(--danger); color: white; transform: translateY(-2px); }
        .empty-state { text-align: center; padding: 80px 24px; color: var(--text-muted); }
        .empty-state i { font-size: 5rem; color: var(--border-subtle); margin-bottom: 24px; display: block; opacity: 0.5; }
        .empty-state h4 { font-family: var(--font-display); font-size: 1.3rem; font-weight: 700; color: var(--text-primary); margin-bottom: 12px; }
        .section-footer { padding: 18px 32px; border-top: 2px solid var(--border-subtle); background: linear-gradient(135deg, rgba(13,148,136,0.03), transparent); font-size: 0.9rem; color: var(--text-muted); display: flex; justify-content: space-between; align-items: center; }

        /* ═══════════ MODAL ═══════════ */
        .modal-backdrop { position: fixed; inset: 0; background: rgba(15,23,42,0.6); backdrop-filter: blur(8px); display: flex; align-items: center; justify-content: center; z-index: 1000; opacity: 0; visibility: hidden; transition: all var(--transition-normal); padding: 20px; }
        .modal-backdrop.active { opacity: 1; visibility: visible; }
        .modal-glass { background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: 1px solid var(--glass-border); border-radius: var(--radius-xl); box-shadow: var(--shadow-lg); width: 100%; max-width: 520px; max-height: 90vh; overflow: hidden; transform: scale(0.95) translateY(20px); transition: transform var(--transition-slow); }
        .modal-backdrop.active .modal-glass { transform: scale(1) translateY(0); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--border-subtle); background: var(--bg-surface-alt); }
        .modal-title { font-family: var(--font-display); font-size: 1.2rem; font-weight: 700; color: var(--text-primary); display: flex; align-items: center; gap: 10px; }
        .modal-close { width: 36px; height: 36px; border-radius: var(--radius-md); border: none; background: var(--bg-surface); display: flex; align-items: center; justify-content: center; color: var(--text-secondary); cursor: pointer; transition: all var(--transition-fast); font-size: 1rem; }
        .modal-close:hover { background: var(--danger); color: white; transform: rotate(90deg); }
        .modal-body { padding: 24px; overflow-y: auto; max-height: calc(90vh - 140px); }
        .detail-grid { display: grid; grid-template-columns: 1fr; gap: 16px; }
        .detail-item { display: flex; flex-direction: column; gap: 6px; padding: 14px 16px; background: var(--bg-surface-alt); border-radius: var(--radius-md); border: 1px solid var(--border-subtle); }
        .detail-label { font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; }
        .detail-value { font-size: 1rem; font-weight: 500; color: var(--text-primary); }
        .detail-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .patient-header { display: flex; align-items: center; gap: 16px; padding: 16px; background: linear-gradient(135deg, var(--primary-soft), var(--secondary-soft)); border-radius: var(--radius-md); margin-bottom: 20px; }
        .patient-header-avatar { width: 64px; height: 64px; border-radius: var(--radius-lg); background: linear-gradient(135deg, var(--primary), var(--secondary)); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.5rem; box-shadow: 0 4px 16px var(--primary-glow); }
        .patient-header-info h3 { font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
        .modal-actions { display: flex; gap: 10px; padding: 16px 24px; border-top: 1px solid var(--border-subtle); background: var(--bg-surface-alt); }
        .btn-modal { flex: 1; padding: 12px 16px; border-radius: var(--radius-md); border: none; font-size: 0.9rem; font-weight: 500; cursor: pointer; transition: all var(--transition-fast); display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; }
        .btn-modal.primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; box-shadow: 0 2px 8px var(--primary-glow); }
        .btn-whatsapp { background: #25D366; color: white; }
        .btn-call { background: var(--info); color: white; }

        @media (max-width: 1200px) { .stats-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width: 1024px) { .sidebar { transform: translateX(-100%); } .sidebar.active { transform: translateX(0); } .main-content { margin-left: 0; padding: 20px; } .search-box { width: 100%; } }
        @media (max-width: 768px) { .stats-grid { grid-template-columns: 1fr; } .top-bar { flex-direction: column; gap: 20px; align-items: stretch; } }
        .mobile-toggle { display: none; position: fixed; bottom: 28px; right: 28px; width: 60px; height: 60px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; box-shadow: var(--shadow-lg); z-index: 999; cursor: pointer; font-size: 1.3rem; align-items: center; justify-content: center; }
        @media (max-width: 1024px) { .mobile-toggle { display: flex; } }
        ::-webkit-scrollbar { width: 8px; } ::-webkit-scrollbar-thumb { background: linear-gradient(180deg, var(--primary), var(--primary-dark)); border-radius: var(--radius-full); }
    </style>
</head>
<body>
    <div class="bg-grid"></div>
    <div class="bg-decoration bg-orb orb-1"></div>
    <div class="bg-decoration bg-orb orb-2"></div>
    <div class="bg-decoration bg-orb orb-3"></div>

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
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/pacientes" class="nav-link active"><i class="fas fa-users"></i><span><fmt:message key="nav.pacientes"/></span></a></li>
                        <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/citas" class="nav-link"><i class="fas fa-calendar-check"></i><span><fmt:message key="nav.citas"/></span></a></li>
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
                    <div class="page-icon"><i class="fas fa-users"></i></div>
                    <div><h1 class="page-title"><fmt:message key="paciente.titulo"/></h1><p class="page-subtitle">Administra la información de los pacientes registrados</p></div>
                </div>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <fmt:message key="paciente.buscar.placeholder" var="pacBuscarPH"/>
                    <input type="text" id="searchInput" placeholder="${pacBuscarPH}">
                </div>
                <div class="top-actions">
                    <div class="lang-switch">
                        <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                        <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                        <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                    </div>
                </div>
            </div>

            <!-- ═══════════ STATS CARDS (TU DISEÑO ORIGINAL) ═══════════ -->
            <div class="stats-grid">
                <div class="stat-card total glass-card">
                    <div class="pattern"></div>
                    <div class="stat-content">
                        <div class="stat-icon-wrapper"><div class="stat-icon total"><i class="fas fa-users"></i></div></div>
                        <div class="stat-value-wrapper"><span class="stat-value"><c:out value="${totalPacientes}" default="0"/></span><span class="stat-value-suffix">pacientes</span></div>
                        <div class="stat-label"><i class="fas fa-database"></i> <fmt:message key="paciente.total.registrados"/></div>
                        <div class="stat-sparkline"><div class="spark-bar" style="height:40%"></div><div class="spark-bar" style="height:60%"></div><div class="spark-bar" style="height:45%"></div><div class="spark-bar" style="height:75%"></div><div class="spark-bar" style="height:55%"></div><div class="spark-bar" style="height:85%"></div><div class="spark-bar" style="height:70%"></div><div class="spark-bar" style="height:100%"></div></div>
                        <span class="stat-trend"><i class="fas fa-arrow-up"></i> +12 este mes</span>
                    </div>
                </div>
                <div class="stat-card active glass-card">
                    <div class="pattern"></div>
                    <div class="stat-content">
                        <div class="stat-icon-wrapper"><div class="stat-icon active"><i class="fas fa-user-check"></i></div></div>
                        <div class="stat-value-wrapper"><span class="stat-value"><c:out value="${pacientesActivos}" default="0"/></span><span class="stat-value-suffix">activos</span></div>
                        <div class="stat-label"><i class="fas fa-heartbeat"></i> Con Atención Reciente</div>
                        <div class="stat-sparkline"><div class="spark-bar" style="height:50%"></div><div class="spark-bar" style="height:70%"></div><div class="spark-bar" style="height:60%"></div><div class="spark-bar" style="height:80%"></div><div class="spark-bar" style="height:65%"></div><div class="spark-bar" style="height:90%"></div><div class="spark-bar" style="height:75%"></div><div class="spark-bar" style="height:100%"></div></div>
                        <span class="stat-trend"><i class="fas fa-check-circle"></i> Verificados</span>
                    </div>
                </div>
                <div class="stat-card new glass-card">
                    <div class="pattern"></div>
                    <div class="stat-content">
                        <div class="stat-icon-wrapper"><div class="stat-icon new"><i class="fas fa-user-plus"></i></div></div>
                        <div class="stat-value-wrapper"><span class="stat-value"><c:out value="${nuevosHoy}" default="0"/></span><span class="stat-value-suffix">nuevos</span></div>
                        <div class="stat-label"><i class="fas fa-clock"></i> Registrados Hoy</div>
                        <div class="stat-sparkline"><div class="spark-bar" style="height:30%"></div><div class="spark-bar" style="height:50%"></div><div class="spark-bar" style="height:40%"></div><div class="spark-bar" style="height:70%"></div><div class="spark-bar" style="height:55%"></div><div class="spark-bar" style="height:85%"></div><div class="spark-bar" style="height:65%"></div><div class="spark-bar" style="height:100%"></div></div>
                        <span class="stat-trend"><i class="fas fa-bolt"></i> En tiempo real</span>
                    </div>
                </div>
                <div class="stat-card urgent glass-card">
                    <div class="pattern"></div>
                    <div class="stat-content">
                        <div class="stat-icon-wrapper"><div class="stat-icon urgent"><i class="fas fa-exclamation-triangle"></i></div></div>
                        <div class="stat-value-wrapper"><span class="stat-value"><c:out value="${pendientes}" default="0"/></span><span class="stat-value-suffix">pendientes</span></div>
                        <div class="stat-label"><i class="fas fa-hourglass-half"></i> Requieren Atención</div>
                        <div class="stat-sparkline"><div class="spark-bar" style="height:60%"></div><div class="spark-bar" style="height:45%"></div><div class="spark-bar" style="height:70%"></div><div class="spark-bar" style="height:50%"></div><div class="spark-bar" style="height:80%"></div><div class="spark-bar" style="height:55%"></div><div class="spark-bar" style="height:90%"></div><div class="spark-bar" style="height:100%"></div></div>
                        <span class="stat-trend down"><i class="fas fa-exclamation-circle"></i> Atención prioritaria</span>
                    </div>
                </div>
            </div>

            <!-- ═══════════ TABLA NUEVA ═══════════ -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title"><i class="fas fa-list"></i> <fmt:message key="paciente.listado"/></h2>
                    <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                    <a href="${pageContext.request.contextPath}/pacientes?accion=nuevo" class="btn-primary"><i class="fas fa-user-plus"></i><fmt:message key='paciente.nuevo'/></a>
                    </c:if>
                </div>

                <div class="filters-bar">
                    <div class="filters-label"><i class="fas fa-filter"></i><span>Filtrar por EPS:</span></div>
                    <div class="eps-pills">
                        <button class="eps-pill all active" data-eps="" onclick="filtrarEPS('')"><i class="fas fa-layer-group"></i> Todas <span class="count"><c:out value="${empty pacientes ? 0 : pacientes.size()}"/></span></button>
                        <button class="eps-pill sanitas" data-eps="Sanitas" onclick="filtrarEPS('Sanitas')"><i class="fas fa-heart"></i> Sanitas</button>
                        <button class="eps-pill compensar" data-eps="Compensar" onclick="filtrarEPS('Compensar')"><i class="fas fa-shield-alt"></i> Compensar</button>
                        <button class="eps-pill nueva" data-eps="Nueva EPS" onclick="filtrarEPS('Nueva EPS')"><i class="fas fa-star"></i> Nueva EPS</button>
                        <button class="eps-pill coosalud" data-eps="Coosalud" onclick="filtrarEPS('Coosalud')"><i class="fas fa-users"></i> Coosalud</button>
                        <button class="eps-pill famisanar" data-eps="Famisanar" onclick="filtrarEPS('Famisanar')"><i class="fas fa-family"></i> Famisanar</button>
                    </div>
                    <button class="btn-clear" onclick="limpiarFiltros()"><i class="fas fa-times"></i> Limpiar</button>
                    <div class="results-counter">Mostrando <strong id="visibleCount"><c:out value="${empty pacientes ? 0 : pacientes.size()}"/></strong> pacientes</div>
                </div>

                <div class="table-wrapper">
                    <table class="patient-table">
                        <thead>
                            <tr>
                                <th>Paciente</th>
                                <th>Documento</th>
                                <th>EPS</th>
                                <th style="text-align:center;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="patientTableBody">
                            <c:choose>
                                <c:when test="${not empty pacientes}">
                                    <c:forEach var="p" items="${pacientes}" varStatus="status">
                                    <tr class="${status.index < 2 ? 'new-patient' : ''}"
                                        data-search="${p.nombres} ${p.apellidos} ${p.documento} ${p.eps} ${p.veredaBarrio}"
                                        data-eps="${p.eps}"
                                        onclick="openPatientModal(${p.id}, '<c:out value="${p.nombres} ${p.apellidos}"/>', '<c:out value="${p.documento}"/>', '<c:out value="${p.telefono}"/>', '<c:out value="${p.email}"/>', '<c:out value="${p.eps}"/>', '<c:out value="${p.veredaBarrio}"/>', '<c:out value="${p.fechaNacimiento}"/>')">
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar">${p.nombres.charAt(0)}${p.apellidos.charAt(0)}</div>
                                                <div class="patient-info">
                                                    <span class="patient-name"><c:out value="${p.nombres} ${p.apellidos}"/></span>
                                                    <span class="patient-location"><i class="fas fa-map-marker-alt"></i><c:out value="${p.veredaBarrio}"/></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="patient-doc"><c:out value="${p.documento}"/></span></td>
                                        <td>
                                            <c:set var="epsCss" value="default"/>
                                            <c:if test="${p.eps == 'Sanitas'}"><c:set var="epsCss" value="sanitas"/></c:if>
                                            <c:if test="${p.eps == 'Compensar'}"><c:set var="epsCss" value="compensar"/></c:if>
                                            <c:if test="${p.eps == 'Nueva EPS'}"><c:set var="epsCss" value="nueva"/></c:if>
                                            <c:if test="${p.eps == 'Coosalud'}"><c:set var="epsCss" value="coosalud"/></c:if>
                                            <c:if test="${p.eps == 'Famisanar'}"><c:set var="epsCss" value="famisanar"/></c:if>
                                            <span class="eps-badge ${epsCss}"><c:out value="${p.eps}"/></span>
                                        </td>
                                        <td style="text-align:center;">
                                            <div class="action-group" onclick="event.stopPropagation()">
                                                <button class="btn-action view" data-tooltip="Ver detalles" onclick="openPatientModal(${p.id}, '<c:out value="${p.nombres} ${p.apellidos}"/>', '<c:out value="${p.documento}"/>', '<c:out value="${p.telefono}"/>', '<c:out value="${p.email}"/>', '<c:out value="${p.eps}"/>', '<c:out value="${p.veredaBarrio}"/>', '<c:out value="${p.fechaNacimiento}"/>')"><i class="fas fa-eye"></i></button>
                                                <c:if test="${sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                                                <a href="${pageContext.request.contextPath}/pacientes?accion=editar&id=${p.id}" class="btn-action edit" data-tooltip="Editar" onclick="event.stopPropagation()"><i class="fas fa-edit"></i></a>
                                                </c:if>
                                                <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                                                <a href="${pageContext.request.contextPath}/pacientes?accion=eliminar&id=${p.id}" class="btn-action delete" data-tooltip="Eliminar" onclick="event.stopPropagation(); return confirm('¿Eliminar paciente?')"><i class="fas fa-trash"></i></a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4"><div class="empty-state"><i class="fas fa-inbox"></i><h4>No hay pacientes registrados</h4><p>Comienza agregando un nuevo paciente al sistema</p></div></td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="section-footer">
                    <span><i class="fas fa-info-circle"></i> <strong><c:out value="${empty pacientes ? 0 : pacientes.size()}"/></strong> pacientes registrados</span>
                    <span><i class="fas fa-clock"></i> Actualizado: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
            </div>
        </main>
    </div>

    <!-- MODAL -->
    <div class="modal-backdrop" id="patientModal" onclick="closeModal(event)">
        <div class="modal-glass" onclick="event.stopPropagation()">
            <div class="modal-header"><h3 class="modal-title"><i class="fas fa-user-injured"></i> Detalles del Paciente</h3><button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button></div>
            <div class="modal-body">
                <div class="patient-header"><div class="patient-header-avatar" id="modalAvatar">JP</div><div class="patient-header-info"><h3 id="modalName">Nombre Apellido</h3><span class="eps-badge" id="modalEps">EPS</span></div></div>
                <div class="detail-grid">
                    <div class="detail-row"><div class="detail-item"><span class="detail-label">Documento</span><span class="detail-value" id="modalDoc">0000000000</span></div><div class="detail-item"><span class="detail-label">Teléfono</span><span class="detail-value" id="modalPhone">+57 300 000 0000</span></div></div>
                    <div class="detail-item"><span class="detail-label">Correo Electrónico</span><span class="detail-value" id="modalEmail">correo@ejemplo.com</span></div>
                    <div class="detail-row"><div class="detail-item"><span class="detail-label">Fecha de Nacimiento</span><span class="detail-value" id="modalBirth">01/01/2000</span></div><div class="detail-item"><span class="detail-label">Vereda/Barrio</span><span class="detail-value" id="modalLocation">Centro</span></div></div>
                </div>
            </div>
            <div class="modal-actions">
                <a href="#" class="btn-modal btn-whatsapp" id="btnWhatsapp" target="_blank"><i class="fab fa-whatsapp"></i> WhatsApp</a>
                <a href="#" class="btn-modal btn-call" id="btnCall"><i class="fas fa-phone"></i> Llamar</a>
                <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}"><a href="#" class="btn-modal primary" id="btnEdit"><i class="fas fa-edit"></i> Editar</a></c:if>
            </div>
        </div>
    </div>

    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>

    <script>
        function toggleSidebar(){document.getElementById('sidebar').classList.toggle('active');}
        function filtrarEPS(v){
            document.querySelectorAll('.eps-pill').forEach(p=>p.classList.remove('active'));
            event.currentTarget.classList.add('active');
            const t=(document.getElementById('searchInput')?.value||'').toLowerCase().trim();
            const rows=document.querySelectorAll('#patientTableBody tr[data-search]');
            let c=0;
            rows.forEach(r=>{
                const s=(r.getAttribute('data-search')||'').toLowerCase();
                const e=r.getAttribute('data-eps')||'';
                const ok=(!t||s.indexOf(t)!==-1)&&(!v||e===v);
                r.style.display=ok?'':'none';if(ok)c++;
            });
            document.getElementById('visibleCount').textContent=c;
        }
        function limpiarFiltros(){
            document.getElementById('searchInput').value='';
            document.querySelectorAll('.eps-pill').forEach(p=>p.classList.remove('active'));
            document.querySelector('.eps-pill.all').classList.add('active');
            filtrar();
        }
        function filtrar(){
            const t=(document.getElementById('searchInput')?.value||'').toLowerCase().trim();
            const a=document.querySelector('.eps-pill.active');
            const v=a?.getAttribute('data-eps')||'';
            const rows=document.querySelectorAll('#patientTableBody tr[data-search]');
            let c=0;
            rows.forEach(r=>{
                const s=(r.getAttribute('data-search')||'').toLowerCase();
                const e=r.getAttribute('data-eps')||'';
                const ok=(!t||s.indexOf(t)!==-1)&&(!v||e===v);
                r.style.display=ok?'':'none';if(ok)c++;
            });
            document.getElementById('visibleCount').textContent=c;
        }
        document.getElementById('searchInput').addEventListener('input',filtrar);
        document.getElementById('visibleCount').textContent=document.querySelectorAll('#patientTableBody tr[data-search]').length;
        function openPatientModal(id,name,doc,phone,email,eps,location,birth){
            if(!name)return;
            const m=document.getElementById('patientModal');
            document.getElementById('modalAvatar').textContent=name.split(' ').map(n=>n.charAt(0)).join('').substring(0,2).toUpperCase();
            document.getElementById('modalName').textContent=name;
            document.getElementById('modalDoc').textContent=doc;
            document.getElementById('modalPhone').textContent=phone||'No registrado';
            document.getElementById('modalEmail').textContent=email||'No registrado';
            document.getElementById('modalEps').textContent=eps;
            document.getElementById('modalLocation').textContent=location||'No registrado';
            document.getElementById('modalBirth').textContent=birth?(function(d){var p=d.split('-');return p[2]+'/'+p[1]+'/'+p[0];})(birth):'No registrado';
            document.getElementById('btnWhatsapp').href='https://wa.me/57'+(phone||'').replace(/\D/g,'');
            document.getElementById('btnCall').href='tel:'+(phone||'');
            var be=document.getElementById('btnEdit');if(be)be.href=window.location.pathname+'?accion=editar&id='+id;
            m.classList.add('active');document.body.style.overflow='hidden';
        }
        function closeModal(e){if(!e||e.target===document.getElementById('patientModal')){document.getElementById('patientModal').classList.remove('active');document.body.style.overflow='';}}
        document.addEventListener('keydown',e=>{if(e.key==='Escape')closeModal();});
    </script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>
</html>
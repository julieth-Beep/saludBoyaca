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
    <title><fmt:message key='cita.titulo'/> | SaludBoyacá</title>
    
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

        /* ═══════════ SIDEBAR ORIGINAL - SIN CAMBIOS ═══════════ */
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

        /* ═══════════ MAIN CONTENT - DISEÑO PREMIUM ═══════════ */
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
        .lang-btn { padding: 8px 14px; border: none; background: transparent; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer; transition: var(--transition-fast); font-size: 0.82rem; text-decoration: none; color: var(--text-muted); display: flex; align-items: center; gap: 5px; }
        .lang-btn.active { background: var(--primary); color: white; box-shadow: 0 2px 8px var(--primary-glow); }
        .lang-btn:hover:not(.active) { background: var(--border-subtle); color: var(--text-primary); }
        .btn-primary { padding: 12px 24px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; border-radius: var(--radius-md); font-weight: 600; font-size: 0.95rem; cursor: pointer; transition: var(--transition-fast); display: inline-flex; align-items: center; gap: 10px; text-decoration: none; box-shadow: 0 4px 16px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow); color: white; }

        /* ===== FILTERS BAR PREMIUM ===== */
        .filters-bar {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-lg);
            padding: 16px 24px;
            margin-bottom: 24px;
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            align-items: center;
            box-shadow: var(--glass-shadow);
        }

        .filters-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
        }
        .filters-label i { color: var(--primary); }

        .filter-input, .filter-select {
            padding: 10px 16px;
            border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md);
            font-size: 0.88rem;
            font-family: inherit;
            color: var(--text-primary);
            background: white;
            outline: none;
            transition: var(--transition-fast);
            min-width: 160px;
        }
        .filter-input:focus, .filter-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-soft);
        }

        .btn-ghost {
            padding: 10px 16px;
            border-radius: var(--radius-md);
            border: 2px solid var(--border-subtle);
            background: white;
            color: var(--text-secondary);
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition-fast);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-ghost:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-soft); }

        /* Botón Exportar PDF */
        .btn-export {
            padding: 10px 18px;
            border-radius: var(--radius-md);
            background: linear-gradient(135deg, #EF4444, #DC2626);
            color: white;
            border: none;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-fast);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3);
            text-decoration: none;
        }
        .btn-export:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4); }
        .btn-export i { font-size: 0.9rem; }

        /* ===== CONTENT SECTION ===== */
        .content-section {
            background: var(--glass-bg);
            backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        .table-header {
            padding: 20px 24px;
            border-bottom: 2px solid var(--border-subtle);
            background: linear-gradient(135deg, rgba(13,148,136,0.05), transparent);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title {
            font-family: var(--font-display);
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .table-title i { color: var(--primary); }

        .table-count {
            font-size: 0.85rem;
            color: var(--text-muted);
            background: var(--primary-soft);
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-weight: 600;
        }

        /* ═══════════ TABLA ELEGANTE Y BIEN ESTRUCTURADA ═══════════ */
        .table-wrapper { overflow-x: auto; }

        .cita-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .cita-table thead {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        .cita-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 700;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            white-space: nowrap;
        }

        .cita-table th:first-child { border-top-left-radius: var(--radius-md); }
        .cita-table th:last-child { border-top-right-radius: var(--radius-md); }

        .cita-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border-subtle);
            font-size: 0.92rem;
            vertical-align: middle;
        }

        /* Filas con diseño elegante */
        .cita-table tbody tr {
            background: white;
            transition: all var(--transition-normal);
            cursor: pointer;
        }

        .cita-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(13,148,136,0.03), rgba(99,102,241,0.03));
            transform: translateX(4px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        .cita-table tbody tr:last-child td { border-bottom: none; }

        /* Info cells bien estructuradas */
        .info-cell { display: flex; flex-direction: column; gap: 4px; }
        .info-main {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
        }
        .info-sub {
            font-size: 0.82rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .info-sub i { font-size: 0.75rem; opacity: 0.8; }

        /* Badge de fecha/hora elegante */
        .datetime-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: var(--primary-soft);
            border: 1px solid rgba(13,148,136,0.3);
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--primary-dark);
        }

        /* ===== BADGES DE ESTADO PREMIUM ===== */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border-radius: var(--radius-full);
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            border: 1px solid transparent;
        }

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

        /* ===== ACTION BUTTONS ELEGANTES ===== */
        .action-group {
            display: flex;
            justify-content: center;
            gap: 6px;
            opacity: 0;
            transform: translateX(12px);
            transition: all var(--transition-fast);
        }

        .cita-table tbody tr:hover .action-group {
            opacity: 1;
            transform: translateX(0);
        }

        .btn-action {
            width: 36px; height: 36px;
            border-radius: var(--radius-md);
            border: none;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all var(--transition-fast);
            text-decoration: none;
            position: relative;
            background: var(--bg-surface);
            border: 1px solid var(--border-subtle);
        }

        .btn-action::before {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%; left: 50%;
            transform: translateX(-50%) translateY(-8px);
            padding: 5px 12px;
            background: var(--text-primary);
            color: white;
            font-size: 0.7rem;
            border-radius: var(--radius-sm);
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity var(--transition-fast), transform var(--transition-fast);
            z-index: 10;
            font-weight: 500;
            box-shadow: var(--shadow-md);
        }

        .btn-action:hover::before { opacity: 1; transform: translateX(-50%) translateY(-12px); }

        .btn-detail { color: var(--info); border-color: rgba(59,130,246,0.3); }
        .btn-detail:hover { background: var(--info); color: white; border-color: var(--info); transform: translateY(-2px); box-shadow: 0 4px 14px rgba(59,130,246,0.4); }

        .btn-estado { color: var(--success); border-color: rgba(16,185,129,0.3); }
        .btn-estado:hover { background: var(--success); color: white; border-color: var(--success); transform: translateY(-2px); box-shadow: 0 4px 14px rgba(16,185,129,0.4); }

        .btn-cancel { color: var(--danger); border-color: rgba(239,68,68,0.3); }
        .btn-cancel:hover { background: var(--danger); color: white; border-color: var(--danger); transform: translateY(-2px); box-shadow: 0 4px 14px rgba(239,68,68,0.4); }

        /* Empty state elegante */
        .empty-state { text-align: center; padding: 60px 24px; color: var(--text-muted); }
        .empty-state-icon {
            width: 72px; height: 72px; margin: 0 auto 20px;
            border-radius: var(--radius-lg);
            background: linear-gradient(135deg, var(--primary-soft), var(--secondary-soft));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; color: var(--primary);
            animation: float-icon 3s ease-in-out infinite;
        }
        @keyframes float-icon { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-6px); } }
        .empty-state h4 { font-family: var(--font-display); font-size: 1.2rem; font-weight: 700; color: var(--text-primary); margin-bottom: 10px; }
        .empty-state p { font-size: 0.95rem; margin-bottom: 24px; color: var(--text-muted); }

        /* Footer de sección */
        .section-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border-subtle);
            background: linear-gradient(135deg, rgba(13,148,136,0.02), transparent);
            font-size: 0.85rem;
            color: var(--text-muted);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .section-footer strong { color: var(--primary); font-weight: 700; }

        /* ===== MODAL PREMIUM ===== */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(15,23,42,0.6); backdrop-filter: blur(8px);
            z-index: 1000; align-items: center; justify-content: center; padding: 20px;
        }
        .modal-overlay.active { display: flex; }

        .modal {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-xl);
            padding: 28px; width: 100%; max-width: 420px;
            box-shadow: var(--shadow-lg), var(--glass-shadow);
            position: relative; overflow: hidden;
        }
        .modal::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary), var(--primary));
        }
        .modal h3 {
            font-family: var(--font-display); font-size: 1.2rem; font-weight: 700;
            color: var(--text-primary); margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .modal h3 i { color: var(--primary); font-size: 1.3rem; }

        .modal select {
            width: 100%; padding: 12px 16px; border: 2px solid var(--border-subtle);
            border-radius: var(--radius-md); font-size: 0.95rem; font-family: inherit;
            color: var(--text-primary); background: white; outline: none;
            transition: var(--transition-fast); margin-bottom: 24px; cursor: pointer;
        }
        .modal select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-soft); }

        .modal-actions { display: flex; gap: 12px; justify-content: flex-end; }

        .btn-modal-cancel {
            padding: 12px 20px; border-radius: var(--radius-md);
            border: 2px solid var(--border-subtle); background: white;
            color: var(--text-secondary); font-size: 0.9rem; font-weight: 500;
            cursor: pointer; transition: var(--transition-fast);
        }
        .btn-modal-cancel:hover { border-color: var(--danger); color: var(--danger); background: var(--danger-soft); }

        .btn-modal-save {
            padding: 12px 24px; border-radius: var(--radius-md);
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; border: none; font-size: 0.9rem; font-weight: 600;
            cursor: pointer; transition: var(--transition-fast);
            display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 4px 14px var(--primary-glow);
        }
        .btn-modal-save:hover { transform: translateY(-2px); box-shadow: 0 6px 20px var(--primary-glow); }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1100px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; padding: 20px; }
        }
        @media (max-width: 768px) {
            .top-bar { flex-direction: column; gap: 16px; align-items: stretch; }
            .filters-bar { flex-direction: column; align-items: stretch; }
            .cita-table th, .cita-table td { padding: 14px 16px; font-size: 0.88rem; }
            .action-group { opacity: 1; transform: none; }
        }

        .mobile-toggle {
            display: none; position: fixed; bottom: 28px; right: 28px;
            width: 60px; height: 60px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; border: none;
            box-shadow: var(--shadow-lg), var(--shadow-glow);
            z-index: 999; cursor: pointer; font-size: 1.3rem;
            align-items: center; justify-content: center;
            transition: var(--transition-fast);
        }
        .mobile-toggle:hover { transform: scale(1.1); box-shadow: var(--shadow-lg), 0 0 60px var(--primary-glow); }
        @media (max-width: 1100px) { .mobile-toggle { display: flex; } }

        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: rgba(148,163,184,0.35); border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(148,163,184,0.6); }

        @keyframes fadeInUp { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: translateY(0); } }
        .animate-enter { animation: fadeInUp 0.6s ease forwards; opacity: 0; }
        .animate-enter:nth-child(1) { animation-delay: 0.1s; }
        .animate-enter:nth-child(2) { animation-delay: 0.2s; }
    </style>
</head>
<body>
    <div class="bg-grid"></div>
    <div class="bg-decoration bg-orb orb-1"></div>
    <div class="bg-decoration bg-orb orb-2"></div>

    <div class="app-wrapper">
        <!-- ═══════════ SIDEBAR ORIGINAL - SIN CAMBIOS ═══════════ -->
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
                        <div class="user-avatar"><c:out value="${sessionScope.usuarioNombre}" default="U"/></div>
                        <div class="user-details"><div class="user-name"><c:out value="${sessionScope.usuarioNombre}" default="Usuario"/></div><div class="user-role"><i class="fas fa-circle"></i> <c:out value="${sessionScope.usuarioRol}" default="Invitado"/></div></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> <fmt:message key="nav.salir"/></a>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT - DISEÑO PREMIUM -->
        <main class="main-content">
            <!-- TOP BAR -->
            <div class="top-bar">
                <div class="page-header">
                    <div class="page-icon"><i class="fas fa-calendar-check"></i></div>
                    <div>
                        <h1 class="page-title"><fmt:message key='cita.titulo'/></h1>
                        <p class="page-subtitle"><fmt:message key="cita.subtitulo"/></p>
                    </div>
                </div>
                <div class="top-actions">
                    <div class="lang-switch">
                        <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                        <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                        <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                    </div>
                    <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                    <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="btn-primary">
                        <i class="fas fa-plus"></i> <fmt:message key='cita.nueva'/>
                    </a>
                    </c:if>
                </div>
            </div>

            <!-- ═══════════ FILTROS PREMIUM ═══════════ -->
            <div class="filters-bar">
                <div class="filters-label"><i class="fas fa-search"></i> <fmt:message key="cita.buscar"/></div>
                <fmt:message key="cita.buscar.placeholder" var="citaBuscarPH"/>
                <input type="text" id="searchInput" class="filter-input" placeholder="${citaBuscarPH}" style="flex:1; min-width:180px;">
                
                <div class="filters-label"><i class="fas fa-filter"></i> <fmt:message key="cita.estado"/></div>
                <select id="filtroEstado" class="filter-select">
                    <option value=""><fmt:message key="cita.todos.estados"/></option>
                    <option value="PROGRAMADA"><fmt:message key='cita.estado.programada'/></option>
                    <option value="CONFIRMADA"><fmt:message key='cita.estado.confirmada'/></option>
                    <option value="ATENDIDA"><fmt:message key='cita.estado.atendida'/></option>
                    <option value="CANCELADA"><fmt:message key='cita.estado.cancelada'/></option>
                </select>

                <div class="filters-label"><i class="fas fa-stethoscope"></i> <fmt:message key="cita.especialidad"/></div>
                <select id="filtroEspecialidad" class="filter-select">
                    <option value=""><fmt:message key="cita.todas.especialidades"/></option>
                    <option value="Medicina General">Medicina General</option>
                    <option value="Odontología">Odontología</option>
                    <option value="Pediatría">Pediatría</option>
                    <option value="Ginecología">Ginecología</option>
                    <option value="Optometría">Optometría</option>
                </select>

                <div class="filters-label"><i class="fas fa-calendar"></i> <fmt:message key="cita.fecha"/></div>
                <input type="date" id="filtroFecha" class="filter-input">

                <button class="btn-ghost" onclick="limpiarFiltros()">
                    <i class="fas fa-times"></i> <fmt:message key="cita.limpiar"/>
                </button>

                <!-- ═══════════ BOTÓN EXPORTAR PDF ═══════════ -->
                <a href="${pageContext.request.contextPath}/citas?accion=exportar&formato=pdf" class="btn-export" title="Exportar a PDF">
                    <i class="fas fa-file-pdf"></i> <fmt:message key="cita.exportar.pdf"/>
                </a>
            </div>

            <!-- ═══════════ TABLA ELEGANTE Y BIEN ESTRUCTURADA ═══════════ -->
            <div class="content-section animate-enter">
                <div class="table-header">
                    <h3 class="table-title"><i class="fas fa-list"></i> <fmt:message key="cita.listado"/></h3>
                    <span class="table-count" id="contadorCitas">0 citas</span>
                </div>

                <div class="table-wrapper">
                    <table class="cita-table">
                        <thead>
                            <tr>
                                <!-- ✅ SIN ID - Columnas bien estructuradas -->
                                <th><fmt:message key='cita.fecha'/> / <fmt:message key='cita.hora'/></th>
                                <th><fmt:message key='cita.paciente'/></th>
                                <th><fmt:message key='cita.medico'/></th>
                                <th><fmt:message key='cita.especialidad'/></th>
                                <th><fmt:message key='cita.estado'/></th>
                                <th style="text-align:center;"><fmt:message key='cita.acciones'/></th>
                            </tr>
                        </thead>
                        <tbody id="citaTableBody">
                            <c:choose>
                                <c:when test="${not empty citas}">
                                    <c:forEach var="c" items="${citas}">
                                    <tr data-estado="${c.estado}"
                                        data-especialidad="${c.especialidad.nombre}"
                                        data-search="${c.paciente.nombres} ${c.paciente.apellidos} ${c.medico.nombres} ${c.medico.apellidos} ${c.especialidad.nombre}"
                                        data-fecha="${c.fechaCita}"
                                        onclick="window.location.href='${pageContext.request.contextPath}/citas?accion=detalle&id=${c.id}'">
                                        
                                        <!-- Fecha/Hora con badge elegante -->
                                        <td>
                                            <div class="datetime-badge">
                                                <i class="far fa-calendar-alt"></i> ${c.fechaCita}
                                            </div>
                                            <div style="font-size:0.8rem;color:var(--text-muted);margin-top:4px;">
                                                <i class="far fa-clock"></i> ${c.horaCita}
                                            </div>
                                        </td>
                                        
                                        <!-- Paciente - bien estructurado -->
                                        <td>
                                            <div class="info-cell">
                                                <span class="info-main">${c.paciente.nombres} ${c.paciente.apellidos}</span>
                                                <span class="info-sub"><i class="fas fa-id-card"></i> ${c.paciente.documento}</span>
                                            </div>
                                        </td>
                                        
                                        <!-- Médico - bien estructurado -->
                                        <td>
                                            <div class="info-cell">
                                                <span class="info-main">Dr. ${c.medico.nombres} ${c.medico.apellidos}</span>
                                                <span class="info-sub"><i class="fas fa-user-md"></i> ${c.medico.especialidad}</span>
                                            </div>
                                        </td>
                                        
                                        <!-- Especialidad - destacada -->
                                        <td>
                                            <span style="font-weight:600;color:var(--primary);display:inline-flex;align-items:center;gap:6px;">
                                                <i class="fas fa-stethoscope" style="font-size:0.8rem;"></i>
                                                ${c.especialidad.nombre}
                                            </span>
                                        </td>
                                        
                                        <!-- Estado con badge premium -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.estado == 'PROGRAMADA'}">
                                                    <span class="badge badge-programada"><i class="fas fa-clock"></i> <fmt:message key='cita.estado.programada'/></span>
                                                </c:when>
                                                <c:when test="${c.estado == 'CONFIRMADA'}">
                                                    <span class="badge badge-confirmada"><i class="fas fa-check-circle"></i> <fmt:message key='cita.estado.confirmada'/></span>
                                                </c:when>
                                                <c:when test="${c.estado == 'ATENDIDA'}">
                                                    <span class="badge badge-atendida"><i class="fas fa-check-double"></i> <fmt:message key='cita.estado.atendida'/></span>
                                                </c:when>
                                                <c:when test="${c.estado == 'CANCELADA'}">
                                                    <span class="badge badge-cancelada"><i class="fas fa-times-circle"></i> <fmt:message key='cita.estado.cancelada'/></span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        
                                        <!-- Acciones -->
                                        <td style="text-align:center;">
                                            <div class="action-group" onclick="event.stopPropagation()">
                                                <a href="${pageContext.request.contextPath}/citas?accion=detalle&id=${c.id}" 
                                                   class="btn-action btn-detail" data-tooltip="<fmt:message key='btn.ver'/>"
                                                   onclick="event.stopPropagation()">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${sessionScope.usuarioRol != 'ENFERMERO' && c.estado != 'ATENDIDA' && c.estado != 'CANCELADA'}">
                                                <button class="btn-action btn-estado" data-tooltip="<fmt:message key='btn.cambiar.estado'/>"
                                                        onclick="event.stopPropagation(); abrirModal(${c.id},'${c.estado}')">
                                                    <i class="fas fa-exchange-alt"></i>
                                                </button>
                                                </c:if>
                                                <c:if test="${(sessionScope.usuarioRol == 'RECEPCIONISTA' || sessionScope.usuarioRol == 'MEDICO') && (c.estado == 'PROGRAMADA' || c.estado == 'CONFIRMADA')}">
                                                <a href="${pageContext.request.contextPath}/citas?accion=cancelar&id=${c.id}" 
                                                   class="btn-action btn-cancel" data-tooltip="<fmt:message key='btn.cancelar'/>"
                                                   onclick="event.stopPropagation(); return confirm('<fmt:message key='cita.confirmar.cancelar'/>')">
                                                    <i class="fas fa-times"></i>
                                                </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6">
                                            <div class="empty-state">
                                                <div class="empty-state-icon"><i class="fas fa-calendar-times"></i></div>
                                                <h4><fmt:message key="cita.sin.registros"/></h4>
                                                <p><fmt:message key="cita.sin.registros.mensaje"/></p>
                                                <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                                                <a href="${pageContext.request.contextPath}/citas?accion=nuevo" class="btn-primary">
                                                    <i class="fas fa-plus"></i> <fmt:message key='cita.nueva'/>
                                                </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="section-footer">
                    <span><i class="fas fa-info-circle"></i> <fmt:message key="cita.total.registros"/>: <strong id="totalCitas"><c:out value="${empty citas ? 0 : citas.size()}"/></strong></span>
                    <span><i class="fas fa-clock"></i> <fmt:message key="cita.actualizado"/>: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
            </div>
        </main>
    </div>

    <!-- ═══════════ MODAL PREMIUM ═══════════ -->
    <div class="modal-overlay" id="modalEstado" onclick="if(event.target===this)cerrarModal()">
        <div class="modal">
            <h3><i class="fas fa-exchange-alt"></i> <fmt:message key="cita.cambiar.estado"/></h3>
            <select id="nuevoEstado">
                <option value="PROGRAMADA"><fmt:message key='cita.estado.programada'/></option>
                <option value="CONFIRMADA"><fmt:message key='cita.estado.confirmada'/></option>
                <option value="ATENDIDA"><fmt:message key='cita.estado.atendida'/></option>
                <option value="CANCELADA"><fmt:message key='cita.estado.cancelada'/></option>
            </select>
            <div class="modal-actions">
                <button class="btn-modal-cancel" onclick="cerrarModal()"><fmt:message key="btn.cancelar"/></button>
                <button class="btn-modal-save" onclick="confirmarEstado()"><i class="fas fa-save"></i> <fmt:message key="btn.guardar"/></button>
            </div>
        </div>
    </div>

    <button class="mobile-toggle" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>

    <script>
        function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('active'); }
        var citaId = null;
        function abrirModal(id, estado){ citaId = id; document.getElementById('nuevoEstado').value = estado; document.getElementById('modalEstado').classList.add('active'); document.body.style.overflow = 'hidden'; }
        function cerrarModal(){ document.getElementById('modalEstado').classList.remove('active'); document.body.style.overflow = ''; citaId = null; }
        function confirmarEstado(){ if(!citaId) return; window.location.href = '${pageContext.request.contextPath}/citas?accion=cambiarEstado&id=' + citaId + '&estado=' + document.getElementById('nuevoEstado').value; }
        
        function filtrar(){
            const term = (document.getElementById('searchInput')?.value || '').toLowerCase().trim();
            const estado = document.getElementById('filtroEstado')?.value || '';
            const especialidad = document.getElementById('filtroEspecialidad')?.value || '';
            const fecha = document.getElementById('filtroFecha')?.value || '';
            const rows = document.querySelectorAll('#citaTableBody tr[data-estado]');
            let count = 0;
            rows.forEach(row => {
                const searchable = (row.getAttribute('data-search') || '').toLowerCase();
                const rowEstado = row.getAttribute('data-estado') || '';
                const rowEspecialidad = row.getAttribute('data-especialidad') || '';
                const rowFecha = row.getAttribute('data-fecha') || '';
                const ok = (!term || searchable.indexOf(term) !== -1) && (!estado || rowEstado === estado) && (!especialidad || rowEspecialidad === especialidad) && (!fecha || rowFecha === fecha);
                row.style.display = ok ? '' : 'none';
                if(ok) count++;
            });
            document.getElementById('contadorCitas').textContent = count + ' citas';
        }
        function limpiarFiltros(){
            document.getElementById('searchInput').value = '';
            document.getElementById('filtroEstado').value = '';
            document.getElementById('filtroEspecialidad').value = '';
            document.getElementById('filtroFecha').value = '';
            filtrar();
        }
        document.addEventListener('DOMContentLoaded', function(){
            ['searchInput','filtroEstado','filtroEspecialidad','filtroFecha'].forEach(id => {
                const el = document.getElementById(id);
                if(el) el.addEventListener(el.tagName === 'INPUT' && el.type !== 'date' ? 'input' : 'change', filtrar);
            });
            document.getElementById('contadorCitas').textContent = document.querySelectorAll('#citaTableBody tr[data-estado]').length + ' citas';
        });
        document.addEventListener('keydown', e => { if(e.key === 'Escape') cerrarModal(); });
        document.addEventListener('click', function(e){
            const sidebar = document.getElementById('sidebar');
            const toggleBtn = document.querySelector('.mobile-toggle');
            if(window.innerWidth <= 1100 && sidebar.classList.contains('active') && !sidebar.contains(e.target) && !toggleBtn?.contains(e.target)){
                sidebar.classList.remove('active');
            }
        });
    </script>
    <script src="<%= request.getContextPath() %>/js/saludboyaca-chatbot.js"></script>
</body>
</html>
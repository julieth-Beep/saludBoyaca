<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Error – SaludBoyacá</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f0fdf9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 48px 40px;
            max-width: 520px;
            width: 100%;
            text-align: center;
        }
        .icon {
            width: 72px; height: 72px;
            background: #fef2f2;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 24px;
            font-size: 2rem;
        }
        h1 { font-size: 1.6rem; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
        .subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 24px; }
        .detail-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 16px;
            text-align: left;
            margin-bottom: 28px;
            font-size: 0.85rem;
            color: #475569;
        }
        .detail-box strong { color: #ef4444; }
        .detail-box code {
            display: block;
            margin-top: 8px;
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 10px 12px;
            word-break: break-all;
            font-size: 0.8rem;
            color: #dc2626;
        }
        .btn {
            display: inline-flex; align-items: center; gap: 8px;
            background: #0d9488; color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: background 0.2s;
            margin: 4px;
        }
        .btn:hover { background: #0f766e; }
        .btn-sec {
            background: #f1f5f9; color: #334155;
        }
        .btn-sec:hover { background: #e2e8f0; }
    </style>
</head>
<body>
<div class="card">
    <div class="icon">⚠️</div>
    <h1>Ocurrió un error</h1>
    <p class="subtitle">
        <c:choose>
            <c:when test="${pageContext.errorData.statusCode == 404}">
                La página que buscas no existe o fue movida.
            </c:when>
            <c:otherwise>
                Algo salió mal al procesar tu solicitud.
                Por favor revisa la consola de Tomcat para más detalles.
            </c:otherwise>
        </c:choose>
    </p>

    <div class="detail-box">
        <strong>Código de error:</strong> ${pageContext.errorData.statusCode}
        <c:if test="${pageContext.errorData.throwable != null}">
            <br><strong>Causa:</strong> ${pageContext.errorData.throwable}
            <code>${pageContext.errorData.throwable.message}</code>
        </c:if>
        <c:if test="${pageContext.errorData.requestURI != null}">
            <br><strong>URL:</strong> ${pageContext.errorData.requestURI}
        </c:if>
    </div>

    <a href="${pageContext.request.contextPath}/dashboard" class="btn">🏠 Ir al Dashboard</a>
    <a href="javascript:history.back()" class="btn btn-sec">← Volver</a>
</div>
</body>
</html>

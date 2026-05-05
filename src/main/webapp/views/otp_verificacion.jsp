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
    <title><fmt:message key='otp.titulo'/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #E0F2FE 0%, #F0F9FF 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            position: relative;
            overflow: hidden;
        }

        /* Glassmorphism Orbs */
        .orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.5;
            animation: float 15s ease-in-out infinite;
        }

        .orb-1 {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, #93C5FD, #A5F3FC);
            top: -100px;
            right: -50px;
        }

        .orb-2 {
            width: 250px;
            height: 250px;
            background: linear-gradient(135deg, #BAE6FD, #DBEAFE);
            bottom: -80px;
            left: -50px;
            animation-delay: -5s;
        }

        .orb-3 {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, #7DD3FC, #BFDBFE);
            top: 50%;
            right: 10%;
            animation-delay: -10s;
            opacity: 0.4;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(20px, -20px) scale(1.05); }
        }

        /* Glassmorphism Card - COMPACT */
        .otp-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(59, 130, 246, 0.15);
            max-width: 400px;
            width: 100%;
            animation: slideUp 0.5s ease;
            position: relative;
            z-index: 10;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Compact Header */
        .otp-header {
            background: linear-gradient(135deg, #3B82F6, #06B6D4);
            padding: 25px 20px;
            text-align: center;
            border-radius: 20px 20px 0 0;
        }

        .otp-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 12px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(255,255,255,0.4); }
            50% { box-shadow: 0 0 0 15px rgba(255,255,255,0); }
        }

        .otp-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: white;
            margin: 0;
        }

        /* Compact Body */
        .otp-body {
            padding: 20px;
        }

        /* Email Box */
        .email-box {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(147, 197, 253, 0.5);
            border-radius: 12px;
            padding: 10px 15px;
            margin-bottom: 16px;
            text-align: center;
            font-size: 0.85rem;
            color: #1E293B;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .email-box i { color: #3B82F6; }

        /* Timer Compact */
        .timer-box {
            text-align: center;
            margin-bottom: 16px;
            padding: 12px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.6);
        }

        .timer-label {
            font-size: 0.75rem;
            color: #64748B;
            margin-bottom: 4px;
        }

        #contador {
            font-size: 1.8rem;
            font-weight: 700;
            color: #3B82F6;
            font-family: 'Courier New', monospace;
        }

        #contador.urgente {
            color: #EF4444;
            animation: pulseRed 1s infinite;
        }

        @keyframes pulseRed {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        /* Error */
        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 16px;
            color: #DC2626;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Input Compact */
        .otp-input {
            font-size: 1.8rem;
            letter-spacing: 10px;
            text-align: center;
            border: 2px solid rgba(147, 197, 253, 0.6);
            border-radius: 12px;
            padding: 12px;
            font-weight: 700;
            color: #1E293B;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            margin-bottom: 14px;
        }

        .otp-input:focus {
            border-color: #3B82F6;
            box-shadow: 0 0 0 6px rgba(59, 130, 246, 0.15);
            outline: none;
            background: white;
        }

        /* Buttons Compact */
        .btn-otp {
            background: linear-gradient(135deg, #3B82F6, #06B6D4);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            width: 100%;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-otp:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.4);
            color: white;
        }

        .btn-outline {
            background: rgba(255, 255, 255, 0.6);
            color: #64748B;
            border: 1px solid rgba(147, 197, 253, 0.5);
            border-radius: 12px;
            padding: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.9);
            border-color: #3B82F6;
            color: #3B82F6;
        }

        @media (max-width: 480px) {
            .otp-card { margin: 10px; }
            .otp-header { padding: 20px 15px; }
            .otp-body { padding: 15px; }
            .otp-input { font-size: 1.5rem; letter-spacing: 6px; }
            #contador { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
    <!-- Glassmorphism Orbs -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>

    <div class="otp-card">
        <!-- Header -->
        <div class="otp-header">
            <div class="otp-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <h1 class="otp-title"><fmt:message key='otp.titulo'/></h1>
        </div>

        <!-- Body -->
        <div class="otp-body">
            <!-- Error -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Email -->
            <div class="email-box">
                <i class="fas fa-envelope"></i>
                <fmt:message key='otp.instruccion'>
                    <fmt:param value="${emailMasked}"/>
                </fmt:message>
            </div>

            <!-- Timer -->
            <div class="timer-box">
                <div class="timer-label">
                    <i class="fas fa-clock"></i>
                    Expira en:
                </div>
                <div id="contador">5:00</div>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/otp" method="post">
                <input type="text" name="otpCodigo"
                       class="form-control otp-input"
                       maxlength="6" pattern="[0-9]{6}"
                       placeholder="000000" required autofocus>
                
                <button type="submit" class="btn btn-otp">
                    <i class="fas fa-check-circle"></i>
                    <fmt:message key='otp.verificar'/>
                </button>
                
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">
                    <i class="fas fa-redo"></i>
                    <fmt:message key='otp.reenviar'/>
                </a>
            </form>
        </div>
    </div>

    <!-- Lógica ORIGINAL intacta -->
    <script>
        let segundos = 300;
        const contador = document.getElementById('contador');
        const intervalo = setInterval(() => {
            segundos--;
            const min = Math.floor(segundos / 60);
            const seg = segundos % 60;
            contador.textContent = min + ':' + (seg < 10 ? '0' : '') + seg;
            if (segundos <= 60) contador.classList.add('urgente');
            if (segundos <= 0) {
                clearInterval(intervalo);
                contador.textContent = '0:00';
            }
        }, 1000);
    </script>
</body>
</html>
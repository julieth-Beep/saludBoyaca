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
    <title><fmt:message key='login.titulo'/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ============================================
           SALUDBOYACA - LOGIN PREMIUM ELEGANTE
           Tonos: Azul claro + Blanco puro
           Efecto: Glassmorphism sutil + Animaciones suaves
           ============================================ */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: linear-gradient(180deg, 
                #e8f4fc 0%, 
                #d6ebf7 30%, 
                #c5e3f5 60%, 
                #b8dcf2 100%);
            overflow: hidden;
            position: relative;
        }

        /* ============================================
           FONDO ANIMADO - Nubes suaves flotantes
           ============================================ */
        .clouds-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
            overflow: hidden;
        }

        .cloud {
            position: absolute;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 100px;
            filter: blur(40px);
        }

        .cloud::before,
        .cloud::after {
            content: '';
            position: absolute;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 100px;
        }

        .cloud-1 {
            width: 300px;
            height: 120px;
            top: 10%;
            left: -100px;
            animation: floatCloud 25s linear infinite;
        }

        .cloud-1::before {
            width: 180px;
            height: 180px;
            top: -90px;
            left: 50px;
        }

        .cloud-1::after {
            width: 200px;
            height: 150px;
            top: -60px;
            left: 120px;
        }

        .cloud-2 {
            width: 250px;
            height: 100px;
            top: 40%;
            right: -80px;
            animation: floatCloud 30s linear infinite reverse;
        }

        .cloud-2::before {
            width: 150px;
            height: 150px;
            top: -75px;
            left: 40px;
        }

        .cloud-2::after {
            width: 180px;
            height: 120px;
            top: -50px;
            left: 100px;
        }

        .cloud-3 {
            width: 350px;
            height: 140px;
            bottom: 15%;
            left: -150px;
            animation: floatCloud 35s linear infinite;
            animation-delay: -10s;
        }

        .cloud-3::before {
            width: 200px;
            height: 200px;
            top: -100px;
            left: 60px;
        }

        .cloud-3::after {
            width: 220px;
            height: 160px;
            top: -70px;
            left: 140px;
        }

        .cloud-4 {
            width: 200px;
            height: 80px;
            top: 60%;
            left: 30%;
            animation: floatCloud 20s linear infinite;
            animation-delay: -5s;
            opacity: 0.4;
        }

        .cloud-4::before {
            width: 120px;
            height: 120px;
            top: -60px;
            left: 30px;
        }

        .cloud-4::after {
            width: 140px;
            height: 100px;
            top: -40px;
            left: 80px;
        }

        @keyframes floatCloud {
            0% { transform: translateX(0) translateY(0); }
            25% { transform: translateX(30px) translateY(-15px); }
            50% { transform: translateX(60px) translateY(0); }
            75% { transform: translateX(30px) translateY(15px); }
            100% { transform: translateX(0) translateY(0); }
        }

        /* ============================================
           CONTENEDOR PRINCIPAL
           ============================================ */
        .main-wrapper {
            position: relative;
            z-index: 10;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* ============================================
           CARD PRINCIPAL - Glassmorphism premium
           ============================================ */
        .login-card {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 100%;
            max-width: 1000px;
            min-height: 600px;
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 32px;
            box-shadow: 
                0 20px 60px rgba(100, 181, 246, 0.15),
                0 8px 24px rgba(100, 181, 246, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.9);
            overflow: hidden;
            animation: cardAppear 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes cardAppear {
            from {
                opacity: 0;
                transform: translateY(30px) scale(0.97);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* ============================================
           PANEL IZQUIERDO - Ilustracion/Branding
           ============================================ */
        .brand-panel {
            position: relative;
            background: linear-gradient(160deg, 
                #4fc3f7 0%, 
                #29b6f6 30%, 
                #039be5 70%,
                #0288d1 100%);
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 50px;
            overflow: hidden;
        }

        /* Circulos decorativos flotantes */
        .brand-panel::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: pulseCircle 6s ease-in-out infinite;
        }

        .brand-panel::after {
            content: '';
            position: absolute;
            bottom: -50px;
            left: -50px;
            width: 250px;
            height: 250px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            animation: pulseCircle 8s ease-in-out infinite reverse;
        }

        @keyframes pulseCircle {
            0%, 100% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
        }

        /* Ilustracion central */
        .illustration-area {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -55%);
            text-align: center;
            z-index: 2;
        }

        .illustration-icon {
            width: 180px;
            height: 180px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            box-shadow: 
                0 10px 40px rgba(0, 0, 0, 0.1),
                inset 0 2px 10px rgba(255, 255, 255, 0.3);
            animation: floatIcon 4s ease-in-out infinite;
        }

        @keyframes floatIcon {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        .illustration-icon i {
            font-size: 5rem;
            color: white;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.15));
        }

        .illustration-text {
            color: white;
            font-size: 1.1rem;
            font-weight: 500;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            opacity: 0.9;
        }

        /* Contenido inferior del panel */
        .brand-content {
            position: relative;
            z-index: 2;
        }

        .brand-title {
            color: white;
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 12px;
            line-height: 1.2;
            text-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }

        .brand-title span {
            font-weight: 300;
            opacity: 0.9;
        }

        .brand-desc {
            color: rgba(255, 255, 255, 0.85);
            font-size: 0.95rem;
            line-height: 1.6;
            font-weight: 400;
            margin-bottom: 30px;
        }

        .brand-features {
            display: flex;
            gap: 20px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: rgba(255, 255, 255, 0.9);
            font-size: 0.85rem;
            font-weight: 500;
        }

        .feature-item i {
            width: 28px;
            height: 28px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }

        /* ============================================
           PANEL DERECHO - Formulario
           ============================================ */
        .form-panel {
            padding: 50px 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }

        /* Logo pequeno arriba */
        .form-logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-logo-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #4fc3f7, #039be5);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            box-shadow: 0 8px 20px rgba(3, 155, 229, 0.25);
        }

        .form-logo-icon i {
            color: white;
            font-size: 1.5rem;
        }

        .form-logo h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1565c0;
            margin: 0;
        }

        .form-logo p {
            color: #90a4ae;
            font-size: 0.85rem;
            margin: 4px 0 0;
            font-weight: 400;
        }

        /* Selector de idioma */
        .lang-selector {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-bottom: 28px;
        }

        .lang-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            color: #78909c;
            background: rgba(236, 239, 241, 0.6);
            border: 1.5px solid transparent;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .lang-btn:hover {
            background: rgba(3, 155, 229, 0.08);
            color: #039be5;
            transform: translateY(-1px);
        }

        .lang-btn.active {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #0277bd;
            border-color: rgba(3, 155, 229, 0.2);
            box-shadow: 0 4px 12px rgba(3, 155, 229, 0.12);
        }

        .lang-flag {
            font-size: 1rem;
        }

        /* Alerta */
        .alert-elegant {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 16px;
            background: rgba(239, 83, 80, 0.06);
            border: 1px solid rgba(239, 83, 80, 0.15);
            border-radius: 14px;
            color: #e53935;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 20px;
            animation: shakeSubtle 0.5s ease;
        }

        @keyframes shakeSubtle {
            0%, 100% { transform: translateX(0); }
            20% { transform: translateX(-4px); }
            40% { transform: translateX(4px); }
            60% { transform: translateX(-2px); }
            80% { transform: translateX(2px); }
        }

        /* Inputs premium */
        .input-group-elegant {
            margin-bottom: 18px;
        }

        .input-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: #546e7a;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-elegant {
            width: 100%;
            padding: 14px 16px 14px 48px;
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(207, 216, 220, 0.5);
            border-radius: 14px;
            font-size: 0.95rem;
            font-weight: 500;
            color: #37474f;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            font-family: inherit;
        }

        .input-elegant::placeholder {
            color: #b0bec5;
            font-weight: 400;
        }

        .input-elegant:focus {
            background: white;
            border-color: #4fc3f7;
            box-shadow: 
                0 0 0 4px rgba(79, 195, 247, 0.15),
                0 4px 12px rgba(79, 195, 247, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #b0bec5;
            font-size: 1rem;
            transition: color 0.3s ease;
        }

        .input-elegant:focus ~ .input-icon {
            color: #039be5;
        }

        /* Boton principal */
        .btn-elegant {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #039be5 0%, #4fc3f7 100%);
            border: none;
            border-radius: 14px;
            color: white;
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 8px 24px rgba(3, 155, 229, 0.3);
            font-family: inherit;
            margin-top: 8px;
        }

        .btn-elegant::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }

        .btn-elegant:hover::before {
            left: 100%;
        }

        .btn-elegant:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(3, 155, 229, 0.4);
        }

        .btn-elegant:active {
            transform: translateY(0);
        }

        .btn-elegant i {
            margin-right: 8px;
        }

        /* Separador */
        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            gap: 16px;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(176, 190, 197, 0.5), transparent);
        }

        .divider-text {
            font-size: 0.75rem;
            color: #b0bec5;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Link consulta publica */
        .public-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 14px;
            background: rgba(255, 255, 255, 0.6);
            border: 1.5px dashed rgba(3, 155, 229, 0.2);
            border-radius: 14px;
            color: #039be5;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .public-link:hover {
            background: rgba(3, 155, 229, 0.05);
            border-color: rgba(3, 155, 229, 0.4);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(3, 155, 229, 0.1);
        }

        .public-link i:first-child {
            font-size: 1.1rem;
        }

        /* Footer */
        .form-footer {
            text-align: center;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid rgba(207, 216, 220, 0.3);
        }

        .form-footer small {
            color: #b0bec5;
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* ============================================
           RESPONSIVE
           ============================================ */
        @media (max-width: 768px) {
            .login-card {
                grid-template-columns: 1fr;
                max-width: 420px;
            }

            .brand-panel {
                display: none;
            }

            .form-panel {
                padding: 40px 30px;
            }
        }

        @media (max-width: 480px) {
            .main-wrapper {
                padding: 20px 15px;
            }

            .login-card {
                border-radius: 24px;
            }

            .form-panel {
                padding: 35px 25px;
            }

            .form-logo h2 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>

    <!-- Nubes flotantes de fondo -->
    <div class="clouds-container">
        <div class="cloud cloud-1"></div>
        <div class="cloud cloud-2"></div>
        <div class="cloud cloud-3"></div>
        <div class="cloud cloud-4"></div>
    </div>

    <div class="main-wrapper">
        <div class="login-card">

            <!-- Panel izquierdo: Branding -->
            <div class="brand-panel">
                <div class="illustration-area">
                    <div class="illustration-icon">
                        <i class="fas fa-heart-pulse"></i>
                    </div>
                    <p class="illustration-text">Cuidamos de ti</p>
                </div>

                <div class="brand-content">
                    <h1 class="brand-title">
                        Salud<br>
                        <span>Boyaca</span>
                    </h1>
                    <p class="brand-desc">
                        Sistema integral de gestion de citas medicas para el 
                        Centro de Salud Municipal de Paipa, Boyaca.
                    </p>
                    <div class="brand-features">
                        <div class="feature-item">
                            <i class="fas fa-shield-halved"></i>
                            <span>Seguro</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-bolt"></i>
                            <span>Rapido</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-clock"></i>
                            <span>24/7</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel derecho: Formulario -->
            <div class="form-panel">

                <div class="form-logo">
                    <div class="form-logo-icon">
                        <i class="fas fa-hospital"></i>
                    </div>
                    <h2><fmt:message key='login.titulo'/></h2>
                    <p>Ingrese sus credenciales para continuar</p>
                </div>

                <!-- Selector de idioma -->
                <div class="lang-selector">
                    <a href="?lang=es" class="lang-btn ${sessionScope.lang == 'es' || sessionScope.lang == null ? 'active' : ''}">
                        <span class="lang-flag">🇨🇴</span>
                        <span>ES</span>
                    </a>
                    <a href="?lang=en" class="lang-btn ${sessionScope.lang == 'en' ? 'active' : ''}">
                        <span class="lang-flag">🇺🇸</span>
                        <span>EN</span>
                    </a>
                    <a href="?lang=it" class="lang-btn ${sessionScope.lang == 'it' ? 'active' : ''}">
                        <span class="lang-flag">🇮🇹</span>
                        <span>IT</span>
                    </a>
                </div>

                <!-- Error -->
                <c:if test="${not empty error}">
                    <div class="alert-elegant">
                        <i class="fas fa-circle-exclamation"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <!-- Formulario -->
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="input-group-elegant">
                        <label class="input-label"><fmt:message key='login.usuario'/></label>
                        <div class="input-wrapper">
                            <input type="text" name="username" class="input-elegant"
                                   placeholder="Ingrese su usuario" required autofocus>
                            <i class="fas fa-user input-icon"></i>
                        </div>
                    </div>

                    <div class="input-group-elegant">
                        <label class="input-label"><fmt:message key='login.contrasena'/></label>
                        <div class="input-wrapper">
                            <input type="password" name="password" class="input-elegant"
                                   placeholder="Ingrese su contrasena" required>
                            <i class="fas fa-lock input-icon"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-elegant">
                        <i class="fas fa-arrow-right-to-bracket"></i>
                        <fmt:message key='login.ingresar'/>
                    </button>
                </form>

                <div class="divider">
                    <div class="divider-line"></div>
                    <span class="divider-text">o</span>
                    <div class="divider-line"></div>
                </div>

                <!-- Link consulta publica -->
                <a href="${pageContext.request.contextPath}/consulta-cita" class="public-link">
                    <i class="fas fa-magnifying-glass"></i>
                    <span><fmt:message key='nav.consulta'/></span>
                    <i class="fas fa-arrow-right" style="font-size: 0.75rem; opacity: 0.5;"></i>
                </a>

                <div class="form-footer">
                    <small><fmt:message key='app.footer'/></small>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
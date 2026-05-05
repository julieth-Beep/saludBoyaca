(function () {
    'use strict';

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }

    function boot() {
        injectCSS();
        injectHTML();
        wire();
        setTimeout(function () {
            obtenerRol().then(function (rd) {
                actualizarBadgeRol(rd.rol);
                botMsg(msgBienvenida(rd.rol, rd.nombre), chipsIniciales(rd.rol));
            });
        }, 600);
    }

    /* ══════════════════════════════════════════════════════════════
       CSS — Glassmorphism azul salud
    ══════════════════════════════════════════════════════════════ */
    function injectCSS() {
        if (document.getElementById('_sb_css')) return;
        var el = document.createElement('style');
        el.id = '_sb_css';
        el.textContent = [
            ':root{',
            '  --_sb-glass:rgba(255,255,255,.55);',
            '  --_sb-glass-strong:rgba(255,255,255,.82);',
            '  --_sb-glass-border:rgba(255,255,255,.38);',
            '  --_sb-accent:#039be5;',
            '  --_sb-accent-end:#0277bd;',
            '  --_sb-ink:#0d2137;',
            '  --_sb-ink-soft:#546e7a;',
            '  --_sb-radius:20px;',
            '  --_sb-blur:blur(28px);',
            '}',
            /* FAB */
            '#_sb_fab{',
            '  position:fixed;bottom:24px;right:24px;width:56px;height:56px;',
            '  border-radius:50%;border:none;cursor:pointer;z-index:9998;',
            '  background:linear-gradient(135deg,var(--_sb-accent),var(--_sb-accent-end));',
            '  box-shadow:0 6px 24px rgba(3,155,229,.38);',
            '  display:flex;align-items:center;justify-content:center;',
            '  transition:transform .25s,box-shadow .25s;',
            '}',
            '#_sb_fab:hover{transform:scale(1.08);box-shadow:0 8px 32px rgba(3,155,229,.5);}',
            '#_sb_fab svg{pointer-events:none;}',
            '#_sb_badge{',
            '  position:absolute;top:-4px;right:-4px;',
            '  background:#ef5350;color:#fff;font-size:9px;font-weight:700;',
            '  border-radius:8px;padding:2px 5px;min-width:16px;text-align:center;',
            '  line-height:1.2;border:2px solid #fff;display:none;',
            '}',
            /* PANEL */
            '#_sb_panel{',
            '  position:fixed;bottom:92px;right:24px;',
            '  width:370px;max-height:560px;',
            '  background:var(--_sb-glass);',
            '  backdrop-filter:var(--_sb-blur);-webkit-backdrop-filter:var(--_sb-blur);',
            '  border:1px solid var(--_sb-glass-border);',
            '  border-radius:var(--_sb-radius);',
            '  box-shadow:0 12px 48px rgba(3,155,229,.18),0 2px 8px rgba(0,0,0,.08);',
            '  display:none;flex-direction:column;z-index:9999;overflow:hidden;',
            '  animation:_sb_in .28s cubic-bezier(.22,1,.36,1);',
            '}',
            '@keyframes _sb_in{from{opacity:0;transform:translateY(20px) scale(.95)}to{opacity:1;transform:none}}',
            /* HEADER */
            '#_sb_hdr{',
            '  background:linear-gradient(120deg,var(--_sb-accent) 0%,var(--_sb-accent-end) 100%);',
            '  padding:14px 16px;display:flex;align-items:center;gap:10px;',
            '}',
            '#_sb_hdr_title{flex:1;color:#fff;font-weight:700;font-size:.95rem;line-height:1.2;}',
            '#_sb_hdr_sub{color:rgba(255,255,255,.8);font-size:.72rem;font-weight:400;}',
            '#_sb_role_badge{',
            '  background:rgba(255,255,255,.18);border:1px solid rgba(255,255,255,.3);',
            '  color:#fff;font-size:.68rem;font-weight:700;padding:3px 8px;border-radius:20px;',
            '  text-transform:uppercase;letter-spacing:.5px;',
            '}',
            '#_sb_close{background:none;border:none;color:rgba(255,255,255,.7);cursor:pointer;font-size:1.1rem;padding:4px 8px;}',
            '#_sb_close:hover{color:#fff;}',
            /* FEED */
            '#_sb_feed{flex:1;overflow-y:auto;padding:14px;display:flex;flex-direction:column;gap:10px;',
            '  scrollbar-width:thin;scrollbar-color:rgba(3,155,229,.2) transparent;}',
            /* MENSAJES */
            '._sb_msg{display:flex;gap:8px;max-width:92%;animation:_sb_msg_in .2s ease;}',
            '@keyframes _sb_msg_in{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:none}}',
            '._sb_msg.bot{align-self:flex-start;}',
            '._sb_msg.usr{align-self:flex-end;flex-direction:row-reverse;}',
            '._sb_avatar{width:28px;height:28px;border-radius:50%;flex-shrink:0;',
            '  display:flex;align-items:center;justify-content:center;font-size:.8rem;}',
            '._sb_msg.bot ._sb_avatar{background:rgba(3,155,229,.12);}',
            '._sb_msg.usr ._sb_avatar{background:rgba(3,155,229,.18);}',
            '._sb_bubble{padding:10px 13px;border-radius:16px;font-size:.84rem;line-height:1.5;',
            '  color:var(--_sb-ink);}',
            '._sb_msg.bot ._sb_bubble{',
            '  background:var(--_sb-glass-strong);border:1px solid var(--_sb-glass-border);',
            '  border-bottom-left-radius:4px;',
            '  box-shadow:0 2px 8px rgba(3,155,229,.06);}',
            '._sb_msg.usr ._sb_bubble{',
            '  background:linear-gradient(135deg,var(--_sb-accent),var(--_sb-accent-end));',
            '  color:#fff;border-bottom-right-radius:4px;}',
            '._sb_time{font-size:.65rem;color:var(--_sb-ink-soft);margin-top:4px;text-align:right;}',
            '._sb_msg.bot ._sb_time{text-align:left;}',
            /* CHIPS */
            '._sb_chips{display:flex;flex-wrap:wrap;gap:6px;padding:4px 0 2px;}',
            '._sb_chip{',
            '  background:rgba(3,155,229,.08);border:1px solid rgba(3,155,229,.2);',
            '  color:var(--_sb-accent-end);border-radius:20px;padding:5px 12px;',
            '  font-size:.75rem;font-weight:600;cursor:pointer;transition:all .2s;}',
            '._sb_chip:hover{background:rgba(3,155,229,.16);border-color:rgba(3,155,229,.4);}',
            /* CARD */
            '._sb_card{',
            '  background:rgba(255,255,255,.6);border:1px solid rgba(3,155,229,.12);',
            '  border-radius:12px;padding:10px 12px;margin-top:8px;width:100%;}',
            '._sb_card_title{font-size:.76rem;font-weight:700;color:var(--_sb-accent-end);',
            '  text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px;border-bottom:1px solid rgba(3,155,229,.1);padding-bottom:5px;}',
            '._sb_row{display:flex;justify-content:space-between;align-items:center;',
            '  padding:4px 0;border-bottom:1px solid rgba(0,0,0,.04);}',
            '._sb_row:last-child{border-bottom:none;}',
            '._sb_row_label{font-size:.78rem;color:var(--_sb-ink-soft);}',
            '._sb_row_val{font-size:.78rem;font-weight:700;color:var(--_sb-ink);}',
            '._sb_row_val.ok{color:#2e7d32;}._sb_row_val.warn{color:#f57c00;}._sb_row_val.err{color:#c62828;}',
            /* TYPING */
            '._sb_typing{display:flex;gap:5px;align-items:center;padding:4px 0;}',
            '._sb_typing span{width:7px;height:7px;border-radius:50%;background:var(--_sb-accent);',
            '  animation:_sb_bounce .9s infinite ease-in-out;}',
            '._sb_typing span:nth-child(2){animation-delay:.15s;}',
            '._sb_typing span:nth-child(3){animation-delay:.3s;}',
            '@keyframes _sb_bounce{0%,80%,100%{transform:translateY(0)}40%{transform:translateY(-6px)}}',
            /* INPUT */
            '#_sb_input_row{',
            '  display:flex;gap:8px;padding:12px 14px;',
            '  border-top:1px solid rgba(3,155,229,.1);',
            '  background:rgba(255,255,255,.6);',
            '}',
            '#_sb_input{',
            '  flex:1;padding:9px 13px;',
            '  background:rgba(255,255,255,.85);',
            '  border:1.5px solid rgba(3,155,229,.2);border-radius:24px;',
            '  font-size:.83rem;color:var(--_sb-ink);outline:none;',
            '  font-family:inherit;transition:border .2s;',
            '}',
            '#_sb_input:focus{border-color:var(--_sb-accent);}',
            '#_sb_input::placeholder{color:#b0bec5;}',
            '#_sb_send{',
            '  width:36px;height:36px;border-radius:50%;border:none;cursor:pointer;flex-shrink:0;',
            '  background:linear-gradient(135deg,var(--_sb-accent),var(--_sb-accent-end));',
            '  display:flex;align-items:center;justify-content:center;',
            '  transition:transform .2s,box-shadow .2s;',
            '  box-shadow:0 3px 10px rgba(3,155,229,.3);',
            '}',
            '#_sb_send:hover{transform:scale(1.08);box-shadow:0 5px 16px rgba(3,155,229,.45);}',
            '@media(max-width:480px){',
            '  #_sb_panel{width:calc(100vw - 32px);right:16px;bottom:80px;}',
            '  #_sb_fab{right:16px;bottom:16px;}',
            '}'
        ].join('');
        document.head.appendChild(el);
    }

    /* ══════════════════════════════════════════════════════════════
       HTML
    ══════════════════════════════════════════════════════════════ */
    function injectHTML() {
        if (document.getElementById('_sb_fab')) return;

        // FAB
        var fab = document.createElement('button');
        fab.id = '_sb_fab';
        fab.setAttribute('aria-label', 'Abrir asistente SaludBot');
        fab.innerHTML = '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>'
                      + '<span id="_sb_badge"></span>';
        document.body.appendChild(fab);

        // PANEL
        var panel = document.createElement('div');
        panel.id = '_sb_panel';
        panel.setAttribute('role', 'dialog');
        panel.setAttribute('aria-label', 'Asistente SaludBot');
        panel.innerHTML =
            '<div id="_sb_hdr">'
          +   '<div style="width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.2);display:flex;align-items:center;justify-content:center;flex-shrink:0;">'
          +     '<svg width="18" height="18" viewBox="0 0 24 24" fill="#fff"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg>'
          +   '</div>'
          +   '<div id="_sb_hdr_title">SaludBot<br><span id="_sb_hdr_sub">Centro de Salud Municipal</span></div>'
          +   '<span id="_sb_role_badge">Invitado</span>'
          +   '<button id="_sb_close" aria-label="Cerrar">✕</button>'
          + '</div>'
          + '<div id="_sb_feed" role="log" aria-live="polite"></div>'
          + '<div id="_sb_input_row">'
          +   '<input id="_sb_input" type="text" placeholder="Escribe tu consulta..." autocomplete="off" maxlength="250">'
          +   '<button id="_sb_send" aria-label="Enviar">'
          +     '<svg width="16" height="16" viewBox="0 0 24 24" fill="#fff"><path d="M2 21l21-9L2 3v7l15 2-15 2z"/></svg>'
          +   '</button>'
          + '</div>';
        document.body.appendChild(panel);
    }

    /* ══════════════════════════════════════════════════════════════
       WIRE
    ══════════════════════════════════════════════════════════════ */
    function wire() {
        document.getElementById('_sb_fab').addEventListener('click', function () {
            togglePanel();
        });
        document.getElementById('_sb_close').addEventListener('click', function () {
            closePanel();
        });
        document.getElementById('_sb_send').addEventListener('click', sendMsg);
        document.getElementById('_sb_input').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') sendMsg();
        });
    }

    var panelOpen = false;

    function togglePanel() {
        panelOpen ? closePanel() : openPanel();
    }

    function openPanel() {
        panelOpen = true;
        var p = document.getElementById('_sb_panel');
        p.style.display = 'flex';
        document.getElementById('_sb_badge').style.display = 'none';
        document.getElementById('_sb_input').focus();
    }

    function closePanel() {
        panelOpen = false;
        document.getElementById('_sb_panel').style.display = 'none';
    }

    function sendMsg() {
        var input = document.getElementById('_sb_input');
        var text  = input.value.trim();
        if (!text) return;
        input.value = '';
        userMsg(text);
        showTyping();
        answer(text).then(function (res) {
            removeTyping();
            botMsg(res.html, res.chips || []);
        });
    }

    /* ══════════════════════════════════════════════════════════════
       RENDER HELPERS
    ══════════════════════════════════════════════════════════════ */
    function botMsg(html, chips) {
        var feed = document.getElementById('_sb_feed');
        var wrap = document.createElement('div');
        wrap.className = '_sb_msg bot';
        wrap.innerHTML =
            '<div class="_sb_avatar">' + iconBot() + '</div>'
          + '<div><div class="_sb_bubble">' + html + '</div>'
          + (chips && chips.length
                ? '<div class="_sb_chips">' + chips.map(function(c){
                      return '<button class="_sb_chip" onclick="_sbChip(this)">' + esc(c) + '</button>';
                  }).join('') + '</div>'
                : '')
          + '<div class="_sb_time">' + hora() + '</div></div>';
        feed.appendChild(wrap);
        scroll();
    }

    window._sbChip = function(el) {
        var text = el.textContent;
        userMsg(text);
        showTyping();
        answer(text).then(function(res){
            removeTyping();
            botMsg(res.html, res.chips || []);
        });
    };

    function userMsg(text) {
        var feed = document.getElementById('_sb_feed');
        var wrap = document.createElement('div');
        wrap.className = '_sb_msg usr';
        wrap.innerHTML =
            '<div class="_sb_avatar">' + iconUser() + '</div>'
          + '<div><div class="_sb_bubble">' + esc(text) + '</div>'
          + '<div class="_sb_time">' + hora() + '</div></div>';
        feed.appendChild(wrap);
        scroll();
    }

    var typingEl = null;
    function showTyping() {
        var feed = document.getElementById('_sb_feed');
        typingEl = document.createElement('div');
        typingEl.className = '_sb_msg bot';
        typingEl.innerHTML =
            '<div class="_sb_avatar">' + iconBot() + '</div>'
          + '<div class="_sb_bubble"><div class="_sb_typing"><span></span><span></span><span></span></div></div>';
        feed.appendChild(typingEl);
        scroll();
    }
    function removeTyping() {
        if (typingEl && typingEl.parentNode) typingEl.parentNode.removeChild(typingEl);
        typingEl = null;
    }

    function actualizarBadgeRol(rol) {
        var badge = document.getElementById('_sb_role_badge');
        if (!badge) return;
        var labels = {
            administrador: 'Administrador',
            medico:        'Médico',
            recepcionista: 'Recepcionista',
            enfermero:     'Enfermero',
            invitado:      'Invitado'
        };
        badge.textContent = labels[rol] || 'Invitado';
    }

    function card(title, rows) {
        return '<div class="_sb_card"><div class="_sb_card_title">' + title + '</div>'
            + rows.map(function(r){
                return '<div class="_sb_row"><span class="_sb_row_label">' + r.label + '</span>'
                     + '<span class="_sb_row_val' + (r.cls ? ' '+r.cls : '') + '">' + r.val + '</span></div>';
              }).join('')
            + '</div>';
    }

    function scroll() {
        var f = document.getElementById('_sb_feed');
        if (f) setTimeout(function(){ f.scrollTop = f.scrollHeight; }, 50);
    }

    function hora() {
        return new Date().toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' });
    }

    function esc(s) {
        if (!s) return '';
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }

    function fmt(n) {
        return (n || 0).toLocaleString('es-CO');
    }

    function iconBot() {
        return '<svg width="15" height="15" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="3" fill="rgba(3,155,229,.12)" stroke="#039be5" stroke-width="1.5"/><path d="M7 8h10M7 12h8M7 16h5" stroke="#039be5" stroke-width="1.5" stroke-linecap="round"/></svg>';
    }

    function iconUser() {
        return '<svg width="14" height="14" viewBox="0 0 24 24" fill="#039be5"><path d="M12 12c2.7 0 5-2.3 5-5S14.7 2 12 2 7 4.3 7 7s2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>';
    }

    /* ══════════════════════════════════════════════════════════════
       CONTEXTO Y ROL
    ══════════════════════════════════════════════════════════════ */
    function getCtx() {
        var path = window.location.pathname;
        var ctx  = path.substring(0, path.indexOf('/', 1));
        return ctx || '';
    }

    function obtenerRol() {
        return fetch(getCtx() + '/chatbot?accion=obtener_rol', { credentials: 'include' })
            .then(function(r){ return r.json(); })
            .catch(function(){ return { rol: 'invitado', nombre: '' }; });
    }

    function fetchData(url) {
        return fetch(url, { credentials: 'include' })
            .then(function(r){ return r.json(); })
            .catch(function(){ return { success: false, error: 'No se pudo conectar.' }; });
    }

    function errMsg(msg, chips) {
        return { html: '⚠️ ' + esc(msg || 'Error al obtener datos.'), chips: chips || [] };
    }

    /* ══════════════════════════════════════════════════════════════
       BIENVENIDA Y CHIPS INICIALES POR ROL
    ══════════════════════════════════════════════════════════════ */
    function msgBienvenida(rol, nombre) {
        var n = nombre ? ', <b>' + esc(nombre) + '</b>' : '';
        if (rol === 'administrador')
            return '¡Bienvenido' + n + '! 👋 Soy <b>SaludBot</b>, tu asistente del Centro de Salud Municipal. Puedo mostrarte estadísticas, citas del día, pacientes recientes y más.';
        if (rol === 'medico')
            return '¡Hola' + n + '! 🩺 Soy <b>SaludBot</b>. Puedo ayudarte a revisar las citas de hoy, información de pacientes y el módulo de horarios.';
        if (rol === 'recepcionista')
            return '¡Hola' + n + '! 📋 Soy <b>SaludBot</b>. Puedo ayudarte con el registro de citas, pacientes y consultas del día.';
        if (rol === 'enfermero')
            return '¡Hola' + n + '! 💉 Soy <b>SaludBot</b>. Puedo mostrarte las citas de hoy y ayudarte con información del sistema.';
        return '👋 Bienvenido al <b>Centro de Salud Municipal — Paipa, Boyacá</b>. Soy <b>SaludBot</b>, tu asistente virtual. Puedo ayudarte a consultar citas o resolver tus dudas.';
    }

    function chipsIniciales(rol) {
        if (rol === 'administrador')
            return ['Estadísticas de citas', 'Pacientes recientes', 'Citas de hoy', 'Gestionar usuarios', 'Horarios'];
        if (rol === 'medico')
            return ['Citas de hoy', 'Ver mis horarios', 'Información paciente', 'Contacto administrativo'];
        if (rol === 'recepcionista')
            return ['Citas de hoy', 'Registrar cita', 'Pacientes recientes', 'Estadísticas'];
        if (rol === 'enfermero')
            return ['Citas de hoy', 'Horario de enfermería', 'Contacto médico', 'Procedimientos'];
        return ['Consultar cita', 'Cómo agendar', 'Horarios de atención', 'Contacto', 'Especialidades'];
    }

    /* ══════════════════════════════════════════════════════════════
       NORMALIZACIÓN
    ══════════════════════════════════════════════════════════════ */
    function norm(s) {
        return (s || '').toLowerCase()
            .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
            .replace(/[¿?¡!.,;:()]/g, '');
    }

    function tiene(q, palabras) {
        return palabras.some(function(p){ return q.indexOf(p) !== -1; });
    }

    /* ══════════════════════════════════════════════════════════════
       MOTOR DE RESPUESTAS
    ══════════════════════════════════════════════════════════════ */
    function answer(text) {
        return obtenerRol().then(function(rd) {
            actualizarBadgeRol(rd.rol);
            var rol    = rd.rol;
            var nombre = rd.nombre;
            var q      = norm(text);
            var ctx    = getCtx();

            /* ── GLOBALES ──────────────────────────────────────── */

            if (tiene(q, ['hola','buenos dias','buenas tardes','buenas noches','hey','saludos','buenas'])) {
                return Promise.resolve({ html: msgBienvenida(rol, nombre), chips: chipsIniciales(rol) });
            }

            if (tiene(q, ['adios','chao','bye','hasta luego','hasta pronto','nos vemos'])) {
                return Promise.resolve({ html: '👋 ¡Hasta luego' + (nombre ? ', <b>'+esc(nombre)+'</b>' : '') + '! Recuerda que puedes consultar tus citas en cualquier momento.', chips: [] });
            }

            if (tiene(q, ['gracias','muchas gracias','perfecto','excelente','listo'])) {
                return Promise.resolve({ html: '😊 ¡Con gusto! Si tienes más consultas, aquí estaré.', chips: chipsIniciales(rol) });
            }

            if (tiene(q, ['quien eres','que eres','como te llamas','eres un bot','eres ia'])) {
                return Promise.resolve({
                    html: '🤖 Soy <b>SaludBot</b>, el asistente virtual del Centro de Salud Municipal de Paipa, Boyacá. Puedo ayudarte con:<br><br>'
                        + '📅 Información sobre citas médicas<br>'
                        + '🏥 Especialidades disponibles<br>'
                        + '🕐 Horarios de atención<br>'
                        + (rol !== 'invitado' ? '📊 Estadísticas del sistema' : '📞 Información de contacto'),
                    chips: chipsIniciales(rol)
                });
            }

            if (tiene(q, ['especialidades','especialidad','que especialidades','medicos disponibles'])) {
                return Promise.resolve({
                    html: '🏥 <b>Especialidades disponibles:</b><br><br>'
                        + card('Servicios médicos', [
                            { label: '🫀 Medicina General',     val: 'Consulta general' },
                            { label: '🦷 Odontología',          val: 'Salud oral' },
                            { label: '👶 Pediatría',            val: 'Niños hasta 17 años' },
                            { label: '🤰 Ginecología',          val: 'Salud femenina' },
                            { label: '💉 Enfermería',           val: 'Procedimientos' }
                        ]),
                    chips: ['Cómo agendar', 'Horarios de atención', 'Contacto']
                });
            }

            if (tiene(q, ['horario','cuando atienden','hora atencion','horarios de atencion','horario de atencion'])) {
                return Promise.resolve({
                    html: '🕐 <b>Horarios de atención:</b><br><br>'
                        + card('Centro de Salud Paipa', [
                            { label: '🗓️ Lunes a Viernes',     val: '7:00 AM – 6:00 PM' },
                            { label: '🗓️ Sábados',             val: '8:00 AM – 12:00 PM' },
                            { label: '🚨 Urgencias',            val: '24 horas / 7 días' },
                            { label: '📞 Línea salud',          val: '018000-910097' }
                        ]),
                    chips: ['Cómo agendar', 'Especialidades', 'Contacto']
                });
            }

            if (tiene(q, ['como agendar','agendar cita','solicitar cita','pedir cita','nueva cita','registrar cita'])) {
                return Promise.resolve({
                    html: '📅 <b>¿Cómo agendar una cita?</b><br><br>'
                        + '1. Ve a la sección <b>"Consulta de Citas"</b> o inicia sesión<br>'
                        + '2. Selecciona la <b>especialidad</b> requerida<br>'
                        + '3. Elige el <b>médico</b> y el <b>horario disponible</b><br>'
                        + '4. Confirma tus <b>datos personales</b><br>'
                        + '5. Recibirás confirmación del sistema<br><br>'
                        + '💡 También puedes llamar al <b>018000-910097</b> para agendar.',
                    chips: ['Horarios de atención', 'Especialidades', 'Consultar cita']
                });
            }

            if (tiene(q, ['consultar cita','ver cita','mi cita','estado cita','buscar cita'])) {
                return Promise.resolve({
                    html: '🔍 <b>Consulta el estado de tu cita:</b><br><br>'
                        + '1. Ingresa a la sección <b>"Consulta tu Cita"</b><br>'
                        + '2. Ingresa tu <b>número de documento</b><br>'
                        + '3. El sistema mostrará tu cita activa<br><br>'
                        + '⚠️ Si necesitas cancelar o reprogramar, comunícate al <b>018000-910097</b>.',
                    chips: ['Cómo agendar', 'Horarios de atención', 'Contacto']
                });
            }

            if (tiene(q, ['contacto','telefono','correo','email','comunicarme','numero'])) {
                return Promise.resolve({
                    html: '📞 <b>Información de contacto:</b><br><br>'
                        + card('Canales de atención', [
                            { label: '📞 Línea gratuita',   val: '018000-910097' },
                            { label: '📧 Correo',           val: 'salud@paipa-boyaca.gov.co' },
                            { label: '🕐 Horario oficina',  val: 'Lun–Vie · 7AM–6PM' },
                            { label: '📍 Municipio',        val: 'Paipa, Boyacá' }
                        ]),
                    chips: ['Horarios de atención', 'Especialidades', 'Cómo agendar']
                });
            }

            /* ══════════════════════════════════════════════════════
               ADMINISTRADOR
            ══════════════════════════════════════════════════════ */
            if (rol === 'administrador') {

                if (tiene(q, ['estadisticas','estadisticas citas','resumen general','dashboard','cuantas citas','total citas'])) {
                    return fetchData(ctx + '/chatbot?accion=stats_citas').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Citas de hoy', 'Pacientes recientes']);
                        return {
                            html: '📊 <b>Estadísticas generales del sistema:</b>'
                                + card('Estado actual', [
                                    { label: '📅 Total citas',           val: fmt(d.totalCitas) },
                                    { label: '⏳ Pendientes',            val: fmt(d.pendientes), cls: d.pendientes > 0 ? 'warn' : 'ok' },
                                    { label: '📆 Citas hoy',             val: fmt(d.hoy) },
                                    { label: '👥 Total pacientes',       val: fmt(d.totalPacientes) }
                                ]),
                            chips: ['Citas de hoy', 'Pacientes recientes', 'Gestionar usuarios']
                        };
                    });
                }

                if (tiene(q, ['pacientes recientes','ultimos pacientes','nuevos pacientes'])) {
                    return fetchData(ctx + '/chatbot?accion=pacientes_recientes').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Estadísticas de citas']);
                        var filas = [];
                        if (d.pacientes && d.pacientes.length > 0) {
                            d.pacientes.forEach(function(p) {
                                filas.push({ label: '👤 ' + esc(p.nombre), val: p.documento });
                            });
                        }
                        return {
                            html: '👥 <b>Últimos pacientes registrados:</b>'
                                + card('Pacientes recientes', filas),
                            chips: ['Estadísticas de citas', 'Citas de hoy', 'Gestionar usuarios']
                        };
                    });
                }

                if (tiene(q, ['gestionar usuarios','usuarios sistema','modulo usuarios'])) {
                    return Promise.resolve({
                        html: '👤 <b>Módulo de Usuarios del Sistema:</b><br><br>'
                            + card('Acciones disponibles', [
                                { label: '📋 Ver todos',        val: 'Menú → Usuarios' },
                                { label: '➕ Nuevo usuario',    val: 'Botón "+ Nuevo"' },
                                { label: '✏️ Editar usuario',   val: 'Ícono lápiz en la fila' },
                                { label: '🗑️ Eliminar usuario', val: 'Ícono basura en la fila' }
                            ])
                            + '<br>💡 Los roles disponibles son: <b>Administrador, Médico, Recepcionista, Enfermero</b>.',
                        chips: ['Estadísticas de citas', 'Pacientes recientes']
                    });
                }

                if (tiene(q, ['horarios','gestionar horarios','modulo horarios'])) {
                    return Promise.resolve({
                        html: '🗓️ <b>Módulo de Horarios:</b><br><br>'
                            + card('Acciones disponibles', [
                                { label: '📋 Ver horarios',     val: 'Menú → Horarios' },
                                { label: '➕ Nuevo horario',    val: 'Botón "+ Nuevo Horario"' },
                                { label: '✏️ Editar horario',   val: 'Ícono lápiz' },
                                { label: '🗑️ Eliminar horario', val: 'Ícono basura' }
                            ])
                            + '<br>💡 Los horarios se asignan por <b>médico y especialidad</b>.',
                        chips: ['Gestionar usuarios', 'Estadísticas de citas']
                    });
                }

                if (tiene(q, ['ayuda','opciones','que puedo hacer','menu'])) {
                    return Promise.resolve({
                        html: '🤝 <b>Todo lo que puedo ayudarte como Administrador:</b><br><br>'
                            + '<b>📊 Datos en tiempo real:</b><br>'
                            + '• Estadísticas generales (citas, pacientes)<br>'
                            + '• Citas programadas para hoy<br>'
                            + '• Pacientes registrados recientemente<br><br>'
                            + '<b>🛠️ Gestión:</b><br>'
                            + '• Usuarios del sistema (médicos, enfermeros, recepcionistas)<br>'
                            + '• Horarios médicos<br>'
                            + '• Módulo completo de pacientes y citas',
                        chips: ['Estadísticas de citas', 'Citas de hoy', 'Pacientes recientes', 'Gestionar usuarios']
                    });
                }

                return Promise.resolve({
                    html: '🤔 No encontré respuesta para "<b>' + esc(text) + '</b>".<br><br>Puedo ayudarte con estadísticas, citas, pacientes y gestión del sistema.',
                    chips: ['Ayuda', 'Estadísticas de citas', 'Citas de hoy']
                });
            }

            /* ══════════════════════════════════════════════════════
               MÉDICO
            ══════════════════════════════════════════════════════ */
            if (rol === 'medico') {

                if (tiene(q, ['citas de hoy','mis citas','agenda hoy','pacientes hoy'])) {
                    return fetchData(ctx + '/chatbot?accion=citas_hoy').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Ver mis horarios', 'Contacto administrativo']);
                        if (d.total === 0) {
                            return { html: '✅ No hay citas programadas para hoy.', chips: ['Ver mis horarios', 'Contacto administrativo'] };
                        }
                        var filas = d.citas.map(function(c) {
                            return { label: '👤 ' + esc(c.paciente), val: c.hora ? c.hora.substring(11,16) : '-' };
                        });
                        return {
                            html: '📅 <b>' + d.total + ' cita(s) programadas para hoy:</b>'
                                + card('Agenda del día', filas),
                            chips: ['Ver mis horarios', 'Información paciente', 'Contacto administrativo']
                        };
                    });
                }

                if (tiene(q, ['ver mis horarios','mis horarios','horario medico'])) {
                    return Promise.resolve({
                        html: '🗓️ <b>Tus horarios médicos:</b><br><br>'
                            + 'Ve a <b>Menú → Horarios</b> para ver y gestionar tu agenda semanal.<br><br>'
                            + '💡 Si necesitas ajustar horarios, contacta al administrador del sistema.',
                        chips: ['Citas de hoy', 'Contacto administrativo']
                    });
                }

                if (tiene(q, ['informacion paciente','datos paciente','buscar paciente','historial'])) {
                    return Promise.resolve({
                        html: '👤 <b>Consulta de información de pacientes:</b><br><br>'
                            + '1. Ve a <b>Menú → Citas</b> y selecciona la cita del paciente<br>'
                            + '2. Haz clic en el nombre del paciente para ver su historial<br><br>'
                            + '💡 Para búsqueda directa, usa <b>Menú → Pacientes</b>.',
                        chips: ['Citas de hoy', 'Ver mis horarios']
                    });
                }

                if (tiene(q, ['contacto administrativo','contactar admin','soporte sistema'])) {
                    return Promise.resolve({
                        html: '📞 <b>Contacto con administración:</b><br><br>'
                            + card('Canales internos', [
                                { label: '📧 Correo interno',   val: 'admin@saludboyaca.local' },
                                { label: '📞 Ext. interna',     val: 'Ext. 101 – Administración' },
                                { label: '🕐 Disponibilidad',   val: 'Lun–Vie · 7AM–4PM' }
                            ]),
                        chips: ['Citas de hoy', 'Ver mis horarios']
                    });
                }

                if (tiene(q, ['ayuda','opciones','que puedo hacer'])) {
                    return Promise.resolve({
                        html: '🤝 <b>Puedo ayudarte con:</b><br><br>'
                            + '📅 Revisar citas del día<br>'
                            + '🗓️ Ver mis horarios asignados<br>'
                            + '👤 Información de pacientes<br>'
                            + '📞 Contacto con administración<br>'
                            + '🕐 Horarios de atención del centro',
                        chips: ['Citas de hoy', 'Ver mis horarios', 'Contacto administrativo']
                    });
                }

                return Promise.resolve({
                    html: '🤔 No encontré respuesta para "<b>' + esc(text) + '</b>". Puedo ayudarte con tus citas, horarios y más.',
                    chips: ['Citas de hoy', 'Ver mis horarios', 'Ayuda']
                });
            }

            /* ══════════════════════════════════════════════════════
               RECEPCIONISTA
            ══════════════════════════════════════════════════════ */
            if (rol === 'recepcionista') {

                if (tiene(q, ['citas de hoy','agenda hoy','citas programadas'])) {
                    return fetchData(ctx + '/chatbot?accion=citas_hoy').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Registrar cita', 'Estadísticas']);
                        if (d.total === 0) {
                            return { html: '✅ No hay citas para hoy.', chips: ['Registrar cita', 'Estadísticas'] };
                        }
                        var filas = d.citas.map(function(c) {
                            return { label: '👤 ' + esc(c.paciente), val: (c.hora ? c.hora.substring(11,16) : '-') + ' · ' + esc(c.estado) };
                        });
                        return {
                            html: '📅 <b>' + d.total + ' cita(s) para hoy:</b>'
                                + card('Agenda del día', filas),
                            chips: ['Registrar cita', 'Pacientes recientes', 'Estadísticas']
                        };
                    });
                }

                if (tiene(q, ['estadisticas','estadisticas citas','resumen'])) {
                    return fetchData(ctx + '/chatbot?accion=stats_citas').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Citas de hoy']);
                        return {
                            html: '📊 <b>Estadísticas de citas:</b>'
                                + card('Resumen', [
                                    { label: '📅 Total citas',     val: fmt(d.totalCitas) },
                                    { label: '⏳ Pendientes',      val: fmt(d.pendientes), cls: d.pendientes > 0 ? 'warn' : 'ok' },
                                    { label: '📆 Hoy',             val: fmt(d.hoy) },
                                    { label: '👥 Pacientes',       val: fmt(d.totalPacientes) }
                                ]),
                            chips: ['Citas de hoy', 'Pacientes recientes']
                        };
                    });
                }

                if (tiene(q, ['pacientes recientes','ultimos pacientes'])) {
                    return fetchData(ctx + '/chatbot?accion=pacientes_recientes').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Citas de hoy']);
                        var filas = (d.pacientes || []).map(function(p) {
                            return { label: '👤 ' + esc(p.nombre), val: p.documento };
                        });
                        return {
                            html: '👥 <b>Últimos pacientes registrados:</b>' + card('Recientes', filas),
                            chips: ['Registrar cita', 'Citas de hoy', 'Estadísticas']
                        };
                    });
                }

                if (tiene(q, ['registrar cita','nueva cita','agendar cita','crear cita'])) {
                    return Promise.resolve({
                        html: '📅 <b>Registrar nueva cita:</b><br><br>'
                            + '1. Ve a <b>Menú → Citas → Nueva Cita</b><br>'
                            + '2. Busca o registra el <b>paciente</b><br>'
                            + '3. Selecciona <b>especialidad y médico</b><br>'
                            + '4. Elige el <b>horario disponible</b><br>'
                            + '5. Confirma y guarda',
                        chips: ['Citas de hoy', 'Pacientes recientes', 'Estadísticas']
                    });
                }

                if (tiene(q, ['ayuda','opciones','que puedo hacer'])) {
                    return Promise.resolve({
                        html: '🤝 <b>Puedo ayudarte con:</b><br><br>'
                            + '📅 Ver citas del día<br>'
                            + '📋 Registrar nuevas citas<br>'
                            + '👥 Consultar pacientes recientes<br>'
                            + '📊 Ver estadísticas de citas<br>'
                            + '📞 Información de contacto',
                        chips: ['Citas de hoy', 'Registrar cita', 'Estadísticas']
                    });
                }

                return Promise.resolve({
                    html: '🤔 No encontré respuesta para "<b>' + esc(text) + '</b>". Puedo ayudarte con citas, pacientes y más.',
                    chips: ['Citas de hoy', 'Registrar cita', 'Ayuda']
                });
            }

            /* ══════════════════════════════════════════════════════
               ENFERMERO
            ══════════════════════════════════════════════════════ */
            if (rol === 'enfermero') {

                if (tiene(q, ['citas de hoy','pacientes hoy','agenda hoy'])) {
                    return fetchData(ctx + '/chatbot?accion=citas_hoy').then(function(d) {
                        if (!d.success) return errMsg(d.error, ['Horario de enfermería', 'Contacto médico']);
                        if (d.total === 0) {
                            return { html: '✅ No hay citas programadas para hoy.', chips: ['Horario de enfermería', 'Contacto médico'] };
                        }
                        var filas = d.citas.map(function(c) {
                            return { label: '👤 ' + esc(c.paciente), val: c.hora ? c.hora.substring(11,16) : '-' };
                        });
                        return {
                            html: '💉 <b>' + d.total + ' cita(s) para hoy:</b>'
                                + card('Agenda del día', filas),
                            chips: ['Procedimientos', 'Horario de enfermería', 'Contacto médico']
                        };
                    });
                }

                if (tiene(q, ['horario de enfermeria','mi horario','horario turnos'])) {
                    return Promise.resolve({
                        html: '🗓️ <b>Horario de enfermería:</b><br><br>'
                            + 'Ve a <b>Menú → Horarios</b> para consultar los turnos asignados.<br><br>'
                            + card('Turnos generales', [
                                { label: '🌅 Turno mañana',    val: '6:00 AM – 2:00 PM' },
                                { label: '🌇 Turno tarde',     val: '2:00 PM – 10:00 PM' },
                                { label: '🌙 Turno noche',     val: '10:00 PM – 6:00 AM' }
                            ]),
                        chips: ['Citas de hoy', 'Contacto médico', 'Procedimientos']
                    });
                }

                if (tiene(q, ['procedimientos','procedimiento enfermeria','que procedimientos'])) {
                    return Promise.resolve({
                        html: '💉 <b>Procedimientos de enfermería:</b><br><br>'
                            + card('Procedimientos comunes', [
                                { label: '💉 Aplicación de vacunas',  val: 'Sala vacunación' },
                                { label: '🩸 Toma de muestras',       val: 'Laboratorio · 7AM–12PM' },
                                { label: '🩺 Control de signos',      val: 'En consulta' },
                                { label: '🩹 Curaciones',             val: 'Sala procedimientos' }
                            ]),
                        chips: ['Citas de hoy', 'Horario de enfermería', 'Contacto médico']
                    });
                }

                if (tiene(q, ['contacto medico','hablar con medico','comunicar medico'])) {
                    return Promise.resolve({
                        html: '🩺 <b>Contacto con el equipo médico:</b><br><br>'
                            + card('Comunicación interna', [
                                { label: '📞 Médico de turno',  val: 'Ext. 102' },
                                { label: '📞 Jefe enfermería',  val: 'Ext. 103' },
                                { label: '📞 Administración',   val: 'Ext. 101' }
                            ]),
                        chips: ['Citas de hoy', 'Procedimientos', 'Horario de enfermería']
                    });
                }

                if (tiene(q, ['ayuda','opciones','que puedo hacer'])) {
                    return Promise.resolve({
                        html: '🤝 <b>Puedo ayudarte con:</b><br><br>'
                            + '📅 Ver citas del día<br>'
                            + '🗓️ Horario de turnos de enfermería<br>'
                            + '💉 Información sobre procedimientos<br>'
                            + '📞 Contacto con el equipo médico',
                        chips: ['Citas de hoy', 'Horario de enfermería', 'Procedimientos']
                    });
                }

                return Promise.resolve({
                    html: '🤔 No encontré respuesta para "<b>' + esc(text) + '</b>". Puedo ayudarte con citas, turnos y procedimientos.',
                    chips: ['Citas de hoy', 'Horario de enfermería', 'Ayuda']
                });
            }

            /* ══════════════════════════════════════════════════════
               INVITADO
            ══════════════════════════════════════════════════════ */

            if (tiene(q, ['ayuda','opciones','que puedo hacer','como funciona'])) {
                return Promise.resolve({
                    html: '🤝 <b>Como visitante puedo ayudarte con:</b><br><br>'
                        + '📅 Cómo agendar una cita médica<br>'
                        + '🏥 Especialidades disponibles<br>'
                        + '🕐 Horarios de atención<br>'
                        + '📞 Información de contacto<br><br>'
                        + '💡 <a href="/login" style="color:#039be5;font-weight:700;">Inicia sesión</a> para acceder a más servicios.',
                    chips: ['Cómo agendar', 'Especialidades', 'Horarios de atención', 'Contacto']
                });
            }

            return Promise.resolve({
                html: '👋 Puedo ayudarte a agendar una cita médica o responder tus preguntas sobre el Centro de Salud Municipal de Paipa, Boyacá.',
                chips: ['Cómo agendar', 'Especialidades', 'Horarios de atención', 'Contacto']
            });
        });
    }

})();
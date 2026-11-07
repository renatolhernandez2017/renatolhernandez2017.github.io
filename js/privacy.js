(() => {
  'use strict';
  const KEY = 'renato_privacy_choice_v1';
  const GA_ID = (window.PORTFOLIO_GA4_ID || '').trim();
  const validID = /^G-[A-Z0-9]{6,16}$/.test(GA_ID);
  let activated = false;
  const getChoice = () => { try { const v = localStorage.getItem(KEY); return v === 'accepted' || v === 'rejected' ? v : null; } catch (_) { return null; } };
  const saveChoice = (value) => { try { localStorage.setItem(KEY, value); } catch (_) {} };
  const privacyHref = document.currentScript?.src?.includes('/js/') && location.pathname.includes('/projetos/') ? '../privacidade.html' : (location.pathname.includes('/projetos/') ? '../privacidade.html' : 'privacidade.html');
  function activate() {
    if (activated || !validID) return;
    activated = true;
    window.dataLayer = window.dataLayer || [];
    window.gtag = function(){ window.dataLayer.push(arguments); };
    window.gtag('js', new Date());
    window.gtag('config', GA_ID, { send_page_view: true });
    const script = document.createElement('script');
    script.async = true;
    script.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(GA_ID);
    document.head.appendChild(script);
    document.addEventListener('click', event => {
      const link = event.target.closest('a[href]'); if (!link) return;
      let tipo = '';
      try { const u = new URL(link.href);
        if (u.hostname === 'wa.me' || u.hostname.endsWith('.whatsapp.com')) tipo = 'whatsapp';
        else if (u.protocol === 'mailto:') tipo = 'email';
        else if (u.pathname.toLowerCase().endsWith('.pdf')) tipo = 'curriculo';
        else if (u.pathname.includes('/projetos/') || u.pathname.endsWith('/projeto.html')) tipo = 'projeto';
      } catch (_) { return; }
      if (tipo && getChoice() === 'accepted') window.gtag('event', 'portfolio_click', { tipo, link_url: link.href });
    });
    document.addEventListener('portfolio:lead', event => {
      if (getChoice() === 'accepted') window.gtag('event', event.detail?.success ? 'generate_lead' : 'lead_error', { origem: 'formulario' });
    });
  }
  function stopAnalytics() {
    if (validID) window['ga-disable-' + GA_ID] = true;
    // A revogação impede novos envios; cookies anteriores podem permanecer até expirar
    // ou ser excluídos nas configurações do navegador.
  }
  const style = document.createElement('link');
  style.rel = 'stylesheet'; style.href = location.pathname.includes('/projetos/') ? '../css/privacy.css' : 'css/privacy.css';
  document.head.appendChild(style);
  function draw() {
    const panel = document.createElement('section');
    panel.id = 'privacy-panel'; panel.className = 'privacy-panel';
    panel.setAttribute('role', 'dialog'); panel.setAttribute('aria-label', 'Preferências de privacidade');
    panel.innerHTML = '<div class="privacy-panel-inner"><div><strong>Suas escolhas de privacidade</strong><p>Usamos armazenamento necessário para lembrar sua preferência. Com sua autorização, o Google Analytics mede visitas e interações. Recusar não impede o uso do site. <a href="' + privacyHref + '">Leia a Política de Privacidade</a>.</p></div><div class="privacy-actions"><button type="button" data-choice="rejected">Recusar opcionais</button><button type="button" data-choice="accepted" class="privacy-primary">Aceitar analíticos</button></div></div>';
    document.body.appendChild(panel);
    const footerLink = document.createElement('button'); footerLink.type = 'button'; footerLink.className = 'privacy-manage'; footerLink.textContent = 'Preferências de cookies';
    footerLink.addEventListener('click', () => { panel.hidden = false; panel.querySelector('button')?.focus(); });
    const footer = document.querySelector('footer .wrap') || document.querySelector('footer') || document.body;
    footer.appendChild(footerLink);
    panel.addEventListener('click', e => {
      const btn = e.target.closest('[data-choice]'); if (!btn) return;
      const choice = btn.dataset.choice;
      saveChoice(choice);
      if (choice === 'accepted') { if (validID) window['ga-disable-' + GA_ID] = false; activate(); }
      else stopAnalytics();
      panel.hidden = true;
    });
    panel.hidden = !!getChoice();
  }
  if (getChoice() === 'accepted') activate(); else stopAnalytics();
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', draw, { once: true }); else draw();
})();

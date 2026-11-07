(() => {
  const id = (window.PORTFOLIO_GA4_ID || '').trim();
  if (!/^G-[A-Z0-9]{6,16}$/.test(id)) return;
  window.dataLayer = window.dataLayer || [];
  window.gtag = function(){ window.dataLayer.push(arguments); };
  window.gtag('js', new Date());
  window.gtag('config', id, { anonymize_ip: true, send_page_view: true });
  const script = document.createElement('script');
  script.async = true;
  script.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(id);
  document.head.appendChild(script);
  document.addEventListener('click', (event) => {
    const link = event.target.closest('a[href]');
    if (!link) return;
    let kind = '';
    try { const u = new URL(link.href);
      if (u.hostname === 'wa.me' || u.hostname.endsWith('.whatsapp.com')) kind = 'whatsapp';
      else if (u.protocol === 'mailto:') kind = 'email';
      else if (u.pathname.toLowerCase().endsWith('.pdf')) kind = 'curriculo';
      else if (u.pathname.includes('/projetos/') || u.pathname.endsWith('/projeto.html')) kind = 'projeto';
    } catch (_) { return; }
    if (kind) window.gtag('event', 'portfolio_click', { tipo: kind, link_url: link.href });
  });
  document.addEventListener('portfolio:lead', (event) => {
    window.gtag('event', event.detail?.success ? 'generate_lead' : 'lead_error', { origem: 'formulario' });
  });
})();

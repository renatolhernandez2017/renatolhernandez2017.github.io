#!/usr/bin/env python3
# Generate indexable project pages from published Supabase records.
# Run after editing projects in admin. Uses public anon/publishable credentials and RLS.
import json,os,re,html,urllib.request,urllib.parse,pathlib,datetime,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
BASE='https://renatolhernandez2017.github.io/'
config=(ROOT/'js/config.js').read_text()
url=os.environ.get('SUPABASE_URL') or re.search(r'https://[\w-]+\.supabase\.co',config).group(0)
key=os.environ.get('SUPABASE_PUBLISHABLE_KEY') or re.search(r"'((?:sb_publishable_|eyJ)[^']+)'",config).group(1)
req=urllib.request.Request(url+'/rest/v1/projects?select=id,slug,title,description,details,technologies,url,cover_image&published=eq.true&order=sort_order.asc',headers={'apikey':key,'Authorization':'Bearer '+key,'Accept':'application/json'})
try:
 with urllib.request.urlopen(req,timeout=25) as r: projects=json.load(r)
except Exception as e:
 sys.exit('Não foi possível consultar projetos publicados; arquivos existentes preservados: '+str(e))
if not isinstance(projects,list):sys.exit('Resposta inesperada')
# No destructive cleanup unless data retrieval succeeded.
folder=ROOT/'projetos';folder.mkdir(exist_ok=True)
for f in folder.glob('*.html'):f.unlink()
urls=[BASE]
links=[]
for x in projects:
 slug=str(x.get('slug') or '').strip().lower()
 if not re.fullmatch('[a-z0-9]+(?:-[a-z0-9]+)*',slug):
  print('Ignorando projeto sem slug seguro:',x.get('title'));continue
 title=str(x.get('title') or '').strip()
 if not title:continue
 description=str(x.get('description') or '').strip()
 details=str(x.get('details') or '').strip()
 canonical=BASE+'projetos/'+slug+'.html'
 e=lambda v:html.escape(str(v),quote=True)
 summary=(description or details or ('Conheça o projeto '+title))[:155]
 image=x.get('cover_image') or BASE+'images/renato.jpg'
 if not str(image).startswith('https://'):image=BASE+'images/renato.jpg'
 techs=[v.strip() for v in str(x.get('technologies') or '').split(',') if v.strip()]
 tech_html=''.join('<span class="tag">'+e(t)+'</span>' for t in techs)
 external=x.get('url') or ''
 external_html='<p><a href="'+e(external)+'" target="_blank" rel="noopener noreferrer">Acessar projeto ↗</a></p>' if str(external).startswith('https://') else ''
 doc='''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="index,follow"><title>'''+e(title)+''' | Projetos de Renato Hernandez</title><meta name="description" content="'''+e(summary)+'''"><link rel="canonical" href="'''+e(canonical)+'''"><meta property="og:type" content="article"><meta property="og:locale" content="pt_BR"><meta property="og:title" content="'''+e(title)+'''"><meta property="og:description" content="'''+e(summary)+'''"><meta property="og:url" content="'''+e(canonical)+'''"><meta property="og:image" content="'''+e(image)+'''"><meta name="twitter:card" content="summary_large_image"><script src="../js/analytics-config.js"></script><script src="../js/analytics.js" defer></script><link rel="stylesheet" href="../css/public-modern.css"><link rel="stylesheet" href="../css/site-clean.css"></head><body><header><nav class="wrap nav"><a class="brand" href="../">Renato Hernandez.</a><div class="navlinks"><a href="../#projetos">Projetos</a><a class="btn" href="../#contato">Solicitar orçamento</a></div></nav></header><main class="project-shell"><a class="project-back" href="../#projetos">← Voltar aos projetos</a><article class="project-panel"><h1>'''+e(title)+'''</h1>'''+('<img id="cover" src="'+e(image)+'" alt="Capa de '+e(title)+'" loading="lazy">' if x.get('cover_image') else '')+('<p>'+e(description)+'</p>' if description else '')+('<p>'+e(details)+'</p>' if details else '')+'<div>'+tech_html+'</div>'+external_html+'''</article></main><footer class="footer"><div class="wrap">© Renato Hernandez · Desenvolvimento de soluções digitais</div></footer></body></html>'''
 (folder/(slug+'.html')).write_text(doc,encoding='utf-8')
 urls.append(canonical)
 links.append((slug,title,description))
# Static links help crawlers discover projects without executing JS.
idx=ROOT/'index.html';markup=idx.read_text()
start='<!-- STATIC_PROJECT_LINKS_START -->';end='<!-- STATIC_PROJECT_LINKS_END -->'
nav='<div class="wrap" aria-label="Índice dos projetos publicados"><h3>Todos os projetos</h3><ul>'+''.join('<li><a href="projetos/'+e(slug)+'.html">'+e(title)+'</a></li>' for slug,title,_ in links)+'</ul></div>' if links else ''
if start in markup and end in markup:
 markup=markup[:markup.index(start)]+start+nav+end+markup[markup.index(end)+len(end):]
else:
 markup=markup.replace('</section>\n<section class="section" id="sobre">',start+nav+end+'</section>\n<section class="section" id="sobre">',1)
idx.write_text(markup)
# XML sitemap regenerated from successfully retrieved public data.
from xml.sax.saxutils import escape
xml='<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'+''.join('  <url><loc>'+escape(u)+'</loc></url>\n' for u in urls)+'</urlset>\n'
(ROOT/'sitemap.xml').write_text(xml)
print('Geradas',len(urls)-1,'páginas de projeto e sitemap.')

# encoding: utf-8
from iniparse import ini
from werkzeug.wrappers import Request, Response
from werkzeug.routing import Map, Rule
from werkzeug.local import Local, LocalManager
from werkzeug.exceptions import HTTPException
from werkzeug.wsgi import ClosingIterator
from jinja2 import Environment, FileSystemLoader
import os.path
import sys
import re

PREFIX = os.path.dirname(os.path.dirname(__file__))

local = Local()
local_manager = LocalManager([local])
tpl_env = Environment(loader=FileSystemLoader(os.path.join(PREFIX, "templates")), autoescape=True)
url_map = Map()
config = ini.INIConfig(open(os.path.join(PREFIX, 'etc', 'ちんこまんこd', 'config.ini')))

def get_module(name):
    module = __import__(name)
    for n in name.split('.')[1:]:
        module = module.getattr(n)
    return module

def getdict(dict, k, default=None):
    try:
        return dict[k]
    except KeyError:
        return default

def expose(rule, **kw):
    def decorate(f):
        kw['endpoint'] = f.__name__
        url_map.add(Rule(rule, **kw))
        return f
    return decorate

def url_for(endpoint, _external=False, **values):
    return local.url_adapter.build(endpoint, values, force_external=_external)

def render_template(name, **kwarg):
    return Response(tpl_env.get_template(name).render(**kwarg), content_type='text/html')

def application(environ, start_response):
    request = Request(environ)
    local.url_adapter = adapter = url_map.bind_to_environ(environ)
    try:
        endpoint, values = adapter.match()
        handler = globals()[endpoint]
        response = handler(request, **values)
    except HTTPException, e:
        response = e
    return ClosingIterator(response(environ, start_response),
                           [local_manager.cleanup])

def validate_and_convert_domain(domain, field):
    domain = domain.strip().lower()
    if domain == '':
        raise Exception(u'%sを指定してください' % field)
    if domain.startswith(u'.'):
        raise Exception(u'%sは「.」で始めることができません' % field)
    if domain.endswith(u'.'):
        raise Exception(u'%sは「.」で終わることができません' % field)
    if u'..' in domain:
        raise Exception(u'%sに2個以上の連続する「.」が含まれています' % field)
    try:
        domain = domain.encode('idna')
    except UnicodeError:
        domain = None
    if domain is None or not re.match(ur'[0-9a-z][0-9a-z-]*', domain):
        raise Exception(u'%sに不正な文字が含まれています' % field)
    return unicode(domain, 'utf-8')

@expose('/')
def index(request):
    message = None

    origin = request.environ['SERVER_NAME']
    http_host = request.environ['HTTP_HOST']
    section = config[origin]
    dbmodule = get_module(section['db.module'])
    conn = dbmodule.connect(database=section['db.name'], user=getdict(section, 'db.user', ''), password=getdict(section, 'db.password', ''))

    if http_host != origin and http_host.endswith(origin):
        domain = http_host[0:-len(origin) - 1]
    else:
        domain = None 

    if domain is not None:
        cur = conn.cursor()
        cur.execute('SELECT url FROM redirects WHERE domain=%s AND origin=%s', domain, origin)
        row = cur.fetchone()
        if row is not None:
            return Response(status=302, headers=[('Location', row['url'])])

    if request.method == 'POST':
        while True:
            entry_type = request.values.get('entry_type', '')
            subdomain = request.values.get('subdomain', '')
            if entry_type == '':
                message = u'アクションを指定してください'
                break

            try:
                _subdomain = validate_and_convert_domain(subdomain, u'サブドメイン名')
            except Exception:
                message = sys.exc_value.args[0]
                break

            if entry_type == '0':
                domain_name = request.values.get('domain_name', '')
                try:
                    _domain_name = validate_and_convert_domain(domain_name, u'CNAMEドメイン名')
                except Exception:
                    message = sys.exc_value.args[0]
                    break

                cur = conn.cursor()
                cur.execute("REPLACE INTO records (`type`, `domain`, `origin`, `value`) VALUES (%s, %s, %s, %s)", 'CNAME', _subdomain, origin, _domain_name)
                cur.execute("DELETE FROM redirects WHERE `domain`=%s AND `origin`=%s", _subdomain, origin)
                conn.commit()
                message = u'正常に終了しました'
            else:
                url = request.values.get('url', '').strip()
                if url == '':
                    message = u'リダイレクト先URLを指定してください'
                    break
                cur = conn.cursor()
                cur.execute("REPLACE INTO redirects (`domain`, `origin`, `url`) VALUES (%s, %s, %s)", _subdomain, origin, url)
                cur.execute("DELETE FROM records WHERE `domain`=%s AND `origin`=%s", _subdomain, origin)
                conn.commit()
                message = u'正常に終了しました'
            break
    return render_template('index.tpl', **locals())



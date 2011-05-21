# encoding: utf-8
from werkzeug.wrappers import Request, Response
from werkzeug.routing import Map, Rule
from werkzeug.local import Local, LocalManager
from werkzeug.exceptions import HTTPException
from werkzeug.wsgi import ClosingIterator
from jinja2 import Environment, FileSystemLoader
import os.path

local = Local()
local_manager = LocalManager([local])
tpl_env = Environment(loader=FileSystemLoader(os.path.join(os.path.dirname(os.path.dirname(__file__)), "templates")))
url_map = Map()
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

@expose('/')
def index(request):
    message = None
    if request.method == 'POST':
        message = u'正常に終了しました'
    return render_template('index.tpl', message=message)



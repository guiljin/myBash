import urllib
import urllib2
import cookielib

filename = 'cookie.txt'
cookie = cookielib.MozillaCookieJar(filename)
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
postdata = urllib.urlencode({
    'came_from': '/',
    'euca-region': '',
    'csrf_token': '6f7d1a680d87b634c01e317136769c8b9df2e8e2',
    'account': 'guiljin',
    'username': 'guiljin',
    'password': 'cloud456'
})
loginUrl = 'https://escloc60ui.eecloud.nsn-net.net:8443/login?login_type=Eucalyptus'
result = opener.open(loginUrl, postdata)
cookie.save(ignore_discard=True, ignore_expires=True)

singleUrl = 'https://escloc60ui.eecloud.nsn-net.net:8443/instances?status=running'
result = opener.open(singleUrl)
print result.read()
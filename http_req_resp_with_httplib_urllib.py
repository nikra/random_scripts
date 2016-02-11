import httplib, urllib, re
params = urllib.urlencode({'login': 'admin', 'passwd': 'password'})
headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
conn = httplib.HTTPSConnection("1.1.1.1")
conn.request("POST", "/login", params, headers)
response = conn.getresponse()
if response.status == 302:
	m = re.search("A=(\w+)", response.getheader('set-cookie'))
	cookie_32_byte = m.group(0)
	#print cookie_32_byte
	if len(cookie_32_byte) >= 32:
		headers = {"Cookie": cookie_32_byte, "Connection": "keep-alive", "Host": "1.1.1.1"}
		conn = httplib.HTTPSConnection("1.1.1.1")
		conn.request("GET", "/after_login", "", headers)
		response = conn.getresponse()
		print response.getheaders()
	else:
		print "Did not get cookie"
else:
	print "Wrong response"

data = response.read()
conn.close()

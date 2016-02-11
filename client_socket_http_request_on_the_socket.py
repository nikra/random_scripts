#!/usr/bin/python
import socket

#Define the type of socket that you will be creating.
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

print(s)

server = "en.wikipedia.org"
port = 80

#Result of below code is not used. This is how you can get the IP address, if a server name is given
server_ip = socket.gethostbyname(server)
print(server_ip)

#Create an HTTP GET request
request = "GET / HTTP/1.1\nHost: "+server+"\n\n"

#Create a Socket
s.connect((server,port))

#Send the HTTP request on to the socket
s.send(request.encode())

#Define the buffer size for the receive data.
result = s.recv(4096)

#Print all the data received in the buffer in one shot
print(result)

#Print the data received in buffer in chunks of 1024 bytes
#while (len(result) > 0):
#	print(result)
#	result = s.recv(1024)


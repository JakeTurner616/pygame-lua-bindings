import requests
import socket

# Networking functions
def http_get(url):
    try:
        response = requests.get(url)
        return response.text
    except requests.RequestException as e:
        return str(e)

def create_socket():
    return socket.socket(socket.AF_INET, socket.SOCK_STREAM)

def connect_socket(sock, host, port):
    try:
        sock.connect((host, port))
        return True
    except socket.error as e:
        return str(e)

def send_socket(sock, data):
    try:
        sock.sendall(data.encode('utf-8'))
        return True
    except socket.error as e:
        return str(e)

def receive_socket(sock, buffer_size):
    try:
        data = sock.recv(buffer_size)
        return data.decode('utf-8')
    except socket.error as e:
        return str(e)
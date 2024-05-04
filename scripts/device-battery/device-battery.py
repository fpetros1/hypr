#!/bin/python

import socket
import os

portfile_folder = f'{os.getenv("XDG_RUNTIME_DIR")}/device-battery'
portfile_path = f'{portfile_folder}/socket'

portfile = open(portfile_path, "r")
port = portfile.readline()
portfile.close()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client:
    client.connect((socket.gethostname(), int(port)))

    device_data = ""
    while True:
        buf = client.recv(32)
        if len(buf) <= 0:
            break
        device_data += buf.decode("utf-8")
    print(device_data)


#!/bin/python

import subprocess
import json
import os
import time
import threading
import socket

lockfile_folder = f'{os.getenv("XDG_RUNTIME_DIR")}/device-battery'

device_name_header = 'Device:'
model_name_header = 'model:'
has_statistiscs_header = 'has statistics:'
has_history_header = 'has history:'
percentage_header = 'percentage:'
state_header = 'state:'

model_property = 'model'
has_statistiscs_property = 'has_statistiscs'
has_history_property = 'has_history'
state_property = 'state'

percentage_property = 'percentage'

warning_threshold = 15.0
notification_cooldown_seconds = 600


def lockfile_handler():
    while True:
        lockfiles = os.listdir(lockfile_folder)
        for lockfile in lockfiles:
            if lockfile.endswith(".notif.lock"):
                full_path = f'{lockfile_folder}/{lockfile}'
                ct_time = os.path.getmtime(full_path)
                lifespan = time.time() - ct_time
                if lifespan > notification_cooldown_seconds:
                    os.remove(full_path)
                else:
                    print(
                        f"Won't delete '{full_path}', lifespan < \
                                {notification_cooldown_seconds} seconds")
        time.sleep(10)


def filter_with_model_and_statistics(device):
    return device[model_property] is not None and\
            (device[has_statistiscs_property] is True or device[has_history_property] is True)


def filter_is_charging(device):
    return device[state_property] == "charging"


def parse_line_value(line):
    return line.split(':')[1].strip()


def create_lockfile_folder():
    if not os.path.exists(lockfile_folder):
        subprocess.run(['mkdir', '-p', lockfile_folder])


def parse_upower_information():
    result = subprocess.run(['upower', '--dump'],
                            stdout=subprocess.PIPE, encoding='UTF-8')

    devices = []
    device_index = -1

    for line in result.stdout.split('\n'):
        stripped_line = line.strip()

        if stripped_line.startswith(device_name_header):
            device_index += 1
            devices.append(
                {model_property: None, has_statistiscs_property: None,
                 percentage_property: None, state_property: None})

        if device_index >= 0:
            if stripped_line.startswith(model_name_header):
                devices[device_index][model_property] = parse_line_value(
                    stripped_line)

            if stripped_line.startswith(has_statistiscs_header):
                devices[device_index][has_statistiscs_property] = \
                    parse_line_value(stripped_line) == 'yes'
            
            if stripped_line.startswith(has_history_header):
                devices[device_index][has_history_property] = \
                    parse_line_value(stripped_line) == 'yes'

            if stripped_line.startswith(percentage_header):
                devices[device_index][percentage_property] = parse_line_value(
                    stripped_line)

            if stripped_line.startswith(state_header):
                devices[device_index][state_property] = parse_line_value(
                    stripped_line)
    return devices


def create_lock_and_notify(device, simple_name):
    lockfile_path = f'{lockfile_folder}/{simple_name}.notif.lock'
    if not os.path.exists(lockfile_path):
        lockfile = open(lockfile_path, "x")
        lockfile.close()
        subprocess.run(
            ['notify-send',
                f'[{device[model_property]}] \
                    \n\nLow Battery: {device[percentage_property]}'])


def determine_battery_icon(average_battery, devices):

    charging_devices = list(filter(filter_is_charging, devices))

    charging = bool(len(charging_devices) == len(devices))

    if average_battery <= 10:
        return "󰢜" if charging else "󰁺"

    if average_battery > 10 and average_battery <= 20:
        return "󰂆" if charging else "󰁻"

    if average_battery > 20 and average_battery <= 30:
        return "󰂇" if charging else "󰁼"

    if average_battery > 30 and average_battery <= 40:
        return "󰂈" if charging else "󰁽" 

    if average_battery > 40 and average_battery <= 50:
        return "󰢝" if charging else "󰁾"

    if average_battery > 50 and average_battery <= 60:
        return "󰂉" if charging else "󰁿"

    if average_battery > 60 and average_battery <= 70:
        return "󰢞" if charging else "󰂀"

    if average_battery > 70 and average_battery <= 80:
        return "󰂊" if charging else "󰂁"

    if average_battery > 80 and average_battery <= 90:
        return "󰂋" if charging else "󰂂"

    if average_battery > 90:
        return "󰂄" if charging else "󰁹"


def handle_client(client):
    devices = parse_upower_information()
    device_string = '\n'
    battery_numbers = []

    if len(devices) == 0:
        icon = "󰂃"

        json_response = {
            "text": f'{icon} 0%',
            "alt": f'{icon}',
            "tooltip": ""
        }
        client.send(bytes(json.dumps(json_response), "utf-8"))
        return
    
    devices = list(filter(filter_with_model_and_statistics, devices))

    for device in devices:
        battery_number = float(device[percentage_property].replace('%', ''))
        battery_numbers.append(battery_number)
        if battery_number <= warning_threshold:
            simple_name = device[model_property]\
                .replace("/", "")\
                .replace(" ", "")
            create_lock_and_notify(device, simple_name)
        model = device[model_property]
        state = device[state_property]
        percentage = device[percentage_property]
        device_string += f'{model}, {state}, {percentage}\n'

    average_battery = int(sum(battery_numbers) / len(battery_numbers))
    icon = determine_battery_icon(average_battery, devices)

    json_response = {
        "text": f'{icon} {average_battery}%',
        "alt": f'{icon}',
        "tooltip": device_string
    }
    client.send(bytes(json.dumps(json_response), "utf-8"))


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
    create_lockfile_folder()

    lockfile_handler_thread = threading.Thread(
        target=lockfile_handler, args=(), daemon=True)
    lockfile_handler_thread.start()

    server.bind((socket.gethostname(), 0))

    portfile_path = f'{lockfile_folder}/socket'

    portfile = open(portfile_path, "w")
    portfile.write(str(server.getsockname()[1]))
    portfile.close()

    server.listen(1)
    while True:
        client, address = server.accept()
        handle_client(client)
        client.close()

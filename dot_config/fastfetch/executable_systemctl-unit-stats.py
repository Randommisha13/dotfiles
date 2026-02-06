#!/usr/bin/env python
import re
import subprocess

checked_fields = ["Units", "Jobs", "Failed"]

systemctl_status = subprocess.check_output(['systemctl', 'status']).decode(encoding='utf-8')

fields_and_values = {}
for field in checked_fields:
    match = re.search(rf"^\s*{field}:\s+(\d+).*$", systemctl_status, re.MULTILINE)
    if match:
        fields_and_values[field] = match.group(1)

if int(fields_and_values["Failed"]) != 0:
    exit_status = 1
else:
    exit_status = 0

output_string = ""
is_first = True
for field, value in fields_and_values.items():
    if is_first:
        output_string += f"{value} {field.lower()}"
        is_first = False
    else:
        output_string += f", {value} {field.lower()}"
if exit_status == 0:
    print(output_string)
else:
    # White foreground, red background, bold
    print(f"\033[37;41;1m{output_string}\033[0m")

exit(exit_status) 

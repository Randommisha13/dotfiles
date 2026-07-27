#!/usr/bin/env python
import re
import sys
import curses
import subprocess

checked_fields = ["Units", "Jobs", "Failed"]

systemctl_out = subprocess.run(['systemctl', 'status'], capture_output=True)

if systemctl_out.returncode > 0:
    print(f"systemctl exited with status {systemctl_out.returncode}", file=sys.stderr)
    exit(systemctl_out.returncode)

stdout = systemctl_out.stdout.decode(encoding="utf-8")

parsed_output = {}
for field in checked_fields:
    match = re.search(rf"^\s*{field}:\s+(\d+).*$", stdout, re.MULTILINE)
    if match:
        parsed_output[field] = match.group(1)


output_strings = []
for field, value in parsed_output.items():
    output_strings.append(f"{value} {field.lower()}")

curses.setupterm()
reset_seq = curses.tparm(curses.tigetstr("sgr0")).decode(encoding="utf-8")
bold_seq = curses.tparm(curses.tigetstr("bold")).decode(encoding="utf-8")
white_fg_seq = curses.tparm(curses.tigetstr("setaf"), 7).decode(encoding="utf-8")
red_bg_seq = curses.tparm(curses.tigetstr("setab"), 1).decode(encoding="utf-8")

if int(parsed_output["Failed"]) > 0:
    print(f"{bold_seq}{red_bg_seq}{white_fg_seq}{", ".join(output_strings)}{reset_seq}")
    exit_status = 1
else:
    print(f"{", ".join(output_strings)}")
    exit_status = 0

exit(exit_status) 

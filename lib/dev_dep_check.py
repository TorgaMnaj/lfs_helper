#!/usr/bin/env python3
# Copyright (c) 2016 janmagrot@gmail.com

import os
r = os.popen("bash ./bin/dev_dep_check.sh").read()
print(r)
errors = []
for i in r:
	if "error" in i.lower():
		errors.append(i)

if errors:
	print("\nERRORS:")
	for x in errors:
		print(x)
else:
	print("\nNO ERRORS FOUND.\n")

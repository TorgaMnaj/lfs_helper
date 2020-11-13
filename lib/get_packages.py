#!/usr/bin/env python3
# Copyright (c) 2016 janmagrot@gmail.com
import os
import sys
import time


class IllegalArgumentError(ValueError):
	print("Arguments error. Thre has to be two arguments:"
	      "Path to packages.txt and path to patches.txt")


if len(sys.argv) != 3:
	raise IllegalArgumentError

batchpackagesfile = sys.argv[1]
batchpatchesfile = sys.argv[2]


def getBatch(packagesdir, patchesdir):
	batchpackages = {}
	with open(packagesdir) as o:
		a = o.read()
		b = a.split("\n\n")
		for d in b:
			name = None
			tdict = {}
			e = d.split("\n")
			for q in e:
				if q.startswith("•"):
					name = q.split(" - ")[0]
			for q in e:
				if q.startswith("Download: "):
					tdict["download"] = q.split(" ")[1]
			for q in e:
				if q.startswith("MD5 sum: "):
					tdict["sum"] = q.split("sum: ")[1]
			batchpackages[name] = tdict
	batchpatches = {}
	with open(patchesdir)as o:
		a = o.read()
		b = a.split("\n\n")
		for d in b:
			name = None
			tdict = {}
			e = d.split("\n")
			for q in e:
				if q.startswith("•"):
					name = q.split(" - ")[0]
			for q in e:
				if q.startswith("Download: "):
					tdict["download"] = q.split(" ")[1]
			for q in e:
				if q.startswith("MD5 sum: "):
					tdict["sum"] = q.split("sum: ")[1]
			batchpatches[name] = tdict
	return batchpackages, batchpatches


downloaded = []
notdownloaded = []
verified = []
unverified = []

batchpackages, batchpatches = getBatch(batchpackagesfile, batchpatchesfile)
print(90 * "\n")
print("\n           Downloading packages:\n\n")
time.sleep(1)
for k, v in batchpackages.items():
	name = k
	addr = v["download"]
	pname = addr.split("/")[-1]
	mdsum = v["sum"]
	print("\n >>> Downloading package " + name + "...")
	print(65 * ".")
	if not os.path.exists("./" + pname):
		wm = os.system("wget " + addr)
		print(65 * ".")
		if wm == 0:
			print(name + " downloaded")
			downloaded.append(pname)
			r = os.popen("md5sum " + pname).read()
			dsum = r.split(" ")[0]
			print("Checking md5sum...")
			if dsum == mdsum:
				print("Md5sum Verified.")
				verified.append(name)
			else:
				print("Md5sum Unverified.")
				unverified.append(name)
		else:
			print(name + " not downloaded")
			notdownloaded.append(pname)
	else:
		print("Package {} already downloaded".format(pname))
	print(65 * ".")
	print("\n")
	print(90 * "#")

print("\n\n\n           Downloading patches:\n\n")
time.sleep(1)
for k, v in batchpatches.items():
	name = k
	addr = v["download"]
	pname = addr.split("/")[-1]
	mdsum = v["sum"]
	print("\n >>> Downloading patch " + name + "...")
	print(65 * ".")
	if not os.path.exists("./" + pname):
		wm = os.system("wget " + addr)
		print(65 * ".")
		if wm == 0:
			print(name + " downloaded")
			downloaded.append(pname)
			r = os.popen("md5sum " + pname).read()
			dsum = r.split(" ")[0]
			print("Checking md5sum...")
			if dsum == mdsum:
				print("Md5sum Verified.")
				verified.append(name)
			else:
				print("Md5sum Unverified.")
				unverified.append(name)
		else:
			print(name + " not downloaded")
			notdownloaded.append(pname)
	else:
		print("Package {} already downloaded".format(pname))

	print(65 * ".")
	print("\n")
	print(90 * "#")

print("\nWriting...")
with open("downloaded.txt", "w") as o:
	o.write(str(downloaded))
with open("notdownloaded.txt", "w") as o:
	o.write(str(notdownloaded))
with open("verified.txt", "w") as o:
	o.write(str(verified))
with open("unverified.txt", "w") as o:
	o.write(str(unverified))

print("\nSumary:")
print("Not downloaded: " + str(notdownloaded))
print("Not verified: " + str(unverified))

if not notdownloaded and not unverified:
	print("\nNo errors occured...\n")
else:
	print("\nERRORS OCCURED...!\nREPAIR THEM AND THEN CONTINUE.\n")

input("\nPress enter for continue...")

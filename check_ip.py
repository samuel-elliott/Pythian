# -*- coding: utf-8 -*-
# IP Address Checker
# Sam Elliott
# Monday, 11 July 2016

import datetime # For date/time stamps
import re # For regex operations
import urllib2 # For querying URLs, such as dyndns.org URLs 
import socket # For network socket operations
import httplib # For handling an odd HTTP error I encountered during testing.
import os, sys # For changing ownership of check_ip.py file at end of script

# Gets current date/time stamp in a nice and purdy format and sets
# it to datetimestamp variable.
datetimestamp = datetime.datetime.now().strftime('%A, %d %B %Y %H:%M:%S')
# Queries checkip.dyndns.org for external (public-facing) IP address and sets
# it to ip_checker_url variable.
ip_checker_url = "http://checkip.dyndns.org"
# Tries to obtain desired output.
try:
	response = urllib2.urlopen(ip_checker_url).read()
# Handles a timeout error.
except socket.timeout, e:
	print "There was a timeout error. Please try again."
# Handles an "unknown HTTP code" error I encountered
except httplib.BadStatusLine:
	print "The server returned a non-sensical HTTP status code. Please try again."

# Extracts just the IP address
ip = re.findall( r'[0-9]+(?:\.[0-9]+){3}', response)
# Joins ip list into just one variable to get rid of unwanted characters
ip_cleaned = ''.join(ip)
# Opens dyndns.log in vagrant user's home dir in append mode
file = open("/home/vagrant/" + "dyndns.log","a")
# Writes desired data to the above log file and adds a line break for clean
# appending
file.write("%s | %s\n" % (datetimestamp, ip_cleaned))
# Closes the file.
file.close()
# Sets ownership to vagrant user and group, whereas before it was root:root
os.chown("/home/vagrant/dyndns.log", 1000, 1000)
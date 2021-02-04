import re
import requests
import datetime
import schedule
import time

# x = datetime.datetime.now()
# day = x.strftime("%A")
# time = x.strftime("%X")
x = datetime.datetime.now()
t = x.strftime("%X")
# t = t[:-3] # remove milliseconds
print(t)

def getTime():
    x = datetime.datetime.now()
    t = x.strftime("%X")
    t = t[:-3]
    print(t)

def sendRequest(mode):
    getTime()
    print("Mode: " + mode)
    address = "http://192.168.50.114:8181/esp8266_door/" + mode
    response = requests.get(address)
    print(response.status_code)

def start():
    sendRequest("red_pulse")

def end_pulse():
    sendRequest("green_pulse")

def end_stable():
    sendRequest("green_stable")

def red_stable():
    sendRequest("red_stable")

def off():
    sendRequest("off")

schedule.every().day.at("07:00").do(red_stable)
schedule.every().day.at("10:00").do(end_stable)
schedule.every().day.at("22:00").do(off)
# CS 480 lecture - start
schedule.every().monday.at("13:00").do(start)
schedule.every().wednesday.at("13:00").do(start)
schedule.every().friday.at("13:00").do(start)
# CS 480 lecture - end
schedule.every().monday.at("13:50").do(end_pulse)
schedule.every().wednesday.at("13:50").do(end_pulse)
schedule.every().friday.at("13:50").do(end_stable)

# CS 361 lab - start
schedule.every().monday.at("15:00").do(start)
# CS 361 lab - end
schedule.every().monday.at("15:50").do(end_pulse)
# CS 361 lecture - start
schedule.every().thursday.at("15:30").do(start)
# CS 361 lecture - end
schedule.every().thursday.at("16:45").do(end_stable)

# CS 418 lecture - start
schedule.every().monday.at("16:30").do(start)
schedule.every().wednesday.at("16:30").do(start)
# CS 418 lecture - end
schedule.every().monday.at("17:45").do(end_stable)
schedule.every().wednesday.at("17:45").do(end_stable)

# RELS 120 lecture - start
schedule.every().tuesday.at("12:30").do(start)
schedule.every().thursday.at("12:30").do(start)
# RELS 120 lecture - end
schedule.every().tuesday.at("13:45").do(end_pulse)
schedule.every().thursday.at("13:45").do(end_pulse)

while True:
    schedule.run_pending()
    time.sleep(1)
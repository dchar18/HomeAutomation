# HomeAutomation

## Description
In hopes of creating a Google-Home-esque home automation system, I have created this project in two parts. First, I have set up a web server running on a Raspberry Pi (code found in "Server" folder). A description of how the server works will follow. Secondly, I have set up several esp8266 boards to receive messges from the server and listen to specific messages depending on what each board does. Again, a description of how this works will follow.

## Scale
This project was originally a part of my TORi project, which is a virtual assistant that I am currently developing. By merging the two projects, I am able to control all server/client functionality through voice inputs that are parsed and categorized by the TORi program. Due to the size of the TORi project, I felt as though this home automation system was overshadowed by TORi. As a result, I am currently working on the two projects separately.

## Server
The server is created using Flask and Python, allowing for the seamless integration with TORi, as mentioned above. When the server begins, a MQTT broker is started, which is how the server and each esp8266 board communicates. When an HTTP request is sent to the server, the server looks at the requests and finds a corresponding function based on the format of the request (ex: /esp8266_desk/rgb would be directed to the function that deals with /\<board>/\<mode>). Once the request has been processed, the MQTT broadcasts the message to all the boards connected to the server. I will explain how the clients deal with these messafes in the "Clients" section. 
  
I chose to run this script on a Raspberry Pi because it allows me continuously run the server code without risking the possiblility of the Pi running out of resources or accidentally closing the script. This is because the Pi has one job and that is to run the script. I am able to monitor the status of the server using a 7 inch touchscreen display that the Pi is connected to.

## Clients

## Future plans

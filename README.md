# x11vnc-chrome
Dockerized Chrome Browser

x11vnc-chrome is a Docker image designed for hosting a sandboxed instance of Google's Chrome browser. Its primary use is for the Guacamole remote desktop server.

## Features

  * Barebones install of Chrome
  * Pulseaudio server for audio forwarding.

## How To Use

The recommended setup is to use a Dockerized version of the Guacmole daemon. Once started you can create a new Docker network like so:

    docker network create vnc
    
Then attach your Guacamole daemon to this network, where `guacd` is the container name of your Guacamole daemon.

    docker network connect vnc guacd
    
Now start a new instance of chrome on the `vnc` network

    docker run --net vnc --name chrome relvacode/x11vnc-chrome
    
Now, in your Guacamole interface add a new connection for `chrome.vnc` on port `5900` without any password.
Audio forwarding can also be enabled using Guacamole's audio setting, check `Enable Audio` and enter `chrome.vnc` as the audio server name.

## Bugs

  * Chrome requires `--no-sandbox` to prevent it from trying to create new PID namespaces (this results in a warning on startup).
  * Chrome does not fill the entire remote session display

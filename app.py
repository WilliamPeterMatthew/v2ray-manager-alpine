import os
import subprocess
import time
from flask import Flask, render_template, request, redirect

app = Flask(__name__)

PID_FILE = '/var/run/v2ray.pid'
CONFIG_FILE = '/etc/v2ray/config.json'

def get_status():
    try:
        if os.path.exists(PID_FILE):
            with open(PID_FILE, 'r') as f:
                pid = int(f.read().strip())
            # Check if process exists
            os.kill(pid, 0)
            return (True, str(pid))
    except (FileNotFoundError, ValueError, ProcessLookupError, OSError):
        # Clean up stale pid file
        if os.path.exists(PID_FILE):
            os.remove(PID_FILE)
    return (False, None)

@app.route('/')
def index():
    status = get_status()
    return render_template('index.html', 
                          running=status[0],
                          pid=status[1])

@app.route('/action', methods=['POST'])
def action():
    running, pid = get_status()
    
    if running:
        # STOP
        try:
            os.kill(int(pid), 15) # SIGTERM
            time.sleep(1)
            if os.path.exists(PID_FILE):
                os.remove(PID_FILE)
        except:
            pass
    else:
        # START
        # V2Ray runs in foreground normally, so we use Popen
        cmd = ["v2ray", "run", "-c", CONFIG_FILE]
        # Using start_new_session to ensure it doesn't die with the request
        proc = subprocess.Popen(cmd, start_new_session=True)
        
        # Write PID
        with open(PID_FILE, 'w') as f:
            f.write(str(proc.pid))
    
    return redirect('/')

if __name__ == '__main__':
    # Generate dummy config if missing to prevent v2ray crash
    if not os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'w') as f:
            f.write('{"log":{"loglevel":"warning"},"inbounds":[{"port":1080,"protocol":"socks","settings":{"auth":"noauth"}}],"outbounds":[{"protocol":"freedom"}]}')
            
    app.run(host='0.0.0.0', port=5000)
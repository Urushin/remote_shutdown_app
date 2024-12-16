from flask import Flask, request, jsonify
import subprocess
import threading
import time

app = Flask(__name__)

# Chemin complet vers shutdown.exe
SHUTDOWN_CMD = r"C:\Windows\System32\shutdown.exe"

def shutdown_server():
    try:
        subprocess.run([SHUTDOWN_CMD, '/s', '/t', '0'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Erreur lors de l'arrêt du PC : {e}")

def delayed_shutdown(seconds):
    time.sleep(seconds)
    try:
        subprocess.run([SHUTDOWN_CMD, '/s', '/t', '0'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Erreur lors de l'arrêt différé du PC : {e}")

@app.route('/shutdown-now', methods=['GET'])
def shutdown_now():
    threading.Thread(target=shutdown_server).start()
    return jsonify({"message": "Le PC va s'éteindre immédiatement."}), 200

@app.route('/shutdown-delay', methods=['GET'])
def shutdown_delay():
    minutes = request.args.get('minutes', default=0, type=int)
    if minutes <= 0:
        return jsonify({"error": "Le délai doit être supérieur à 0 minutes."}), 400
    seconds = minutes * 60
    threading.Thread(target=delayed_shutdown, args=(seconds,)).start()
    return jsonify({"message": f"Le PC va s'éteindre dans {minutes} minute(s)."}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

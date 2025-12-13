from flask import Flask, request, render_template, redirect, url_for, session, send_from_directory
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)

# Securely load secret key
if not os.getenv("FLASK_SECRET_KEY"):
    raise RuntimeError("Critical: FLASK_SECRET_KEY not set in environment or .env file.")
app.secret_key = os.getenv("FLASK_SECRET_KEY")

app.config['SESSION_COOKIE_NAME'] = 'lex_session'
app.config['PERMANENT_SESSION_LIFETIME'] = 3600 # 1 hour

# Configuration
if not os.getenv("FLASK_USERNAME") or not os.getenv("FLASK_PASSWORD"):
    raise RuntimeError("Critical: FLASK_USERNAME or FLASK_PASSWORD not set.")

USERNAME = os.getenv("FLASK_USERNAME")
PASSWORD = os.getenv("FLASK_PASSWORD")
CONTENT_DIR = os.getenv("CONTENT_DIR", "/mnt/hdd/public/real-x-dreams.com")

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        # print(f"DEBUG: Login attempt for user {request.form.get('username')}") # Commented out for security logs
        if request.form['username'] == USERNAME and request.form['password'] == PASSWORD:
            session['logged_in'] = True
            session.permanent = True
            # print("DEBUG: Login Success")
            return redirect(url_for('serve_root'))
        else:
            # print("DEBUG: Login Failed")
            error = 'Invalid Credentials. Access Denied.'
    return render_template('login.html', error=error)

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('login'))

@app.route('/')
def serve_root():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    return send_from_directory(CONTENT_DIR, 'index.html')

@app.route('/<path:filename>')
def serve_static(filename):
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    return send_from_directory(CONTENT_DIR, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

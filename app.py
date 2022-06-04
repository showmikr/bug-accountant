from cmath import log
from locale import currency
from turtle import title
from urllib.parse import urldefrag
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'secretkey'

app.config['MYSQL_HOST'] = 'ls-0e6dd62320aa7f6d260d0d5825892f815269cf28.cmprcwekrhkn.us-west-2.rds.amazonaws.com'
app.config['MYSQL_USER'] = 'dbmasteruser'
app.config['MYSQL_PASSWORD'] = 'vET[O|{UeZ&9=FBqn9`x)9G3~fQtSC|^'
app.config['MYSQL_DB'] = 'BugAccountantP2'

mysql = MySQL(app)


@app.route('/pythonlogin/', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM Users WHERE UserName = %s', (username,))
        # Fetch one record and return result
        account = cursor.fetchone()
        # If account exists in accounts table in our database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['id'] = account['UserID']
            session['username'] = account['UserName']
            session['project'] = None
            # Redirect to home page
            return redirect(url_for('home'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('index.html', msg=msg)


# http://localhost:5000/python/logout - this will be the logout page
@app.route('/pythonlogin/logout')
def logout():
    # Remove session data, this will log the user out
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    session.pop('project', None)
    # Redirect to login page
    return redirect(url_for('login'))


# http://localhost:5000/pythonlogin/register - this will be the registration page, we need to use both GET and POST requests
@app.route('/pythonlogin/register', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM Users WHERE UserName = %s', (username,))
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password:
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute('INSERT INTO Users (UserName) VALUES (%s)',
                           (username,))  # EDIT THIS ASAP TO WORK ON NEW DATABASE
            mysql.connection.commit()
            msg = 'You have successfully registered!'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'

    return render_template('register.html', msg=msg)


# http://localhost:5000/pythinlogin/home - this will be the home page, only accessible for loggedin users
@app.route('/pythonlogin/home')
def home():
    session.pop('project', None)
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        cursor = mysql.connection.cursor()
        cursor.callproc('ListProjects', [session['id']])
        data = cursor.fetchall()
        return render_template('home.html', username=session['username'], projects=data)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))


@app.route('/pending/<projID>')
def pending(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetPendingIssues', [projID])
    data = cursor.fetchall()
    if 'loggedin' in session:
        session['project'] = projID
        return render_template(['pending_issues.html', 'unassigned_issues.html'], issues=data, unassigned=data)
    else:
        return redirect(url_for('login'))

@app.route('/unassigned/<projID>')
def unassigned(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetUnassignedIssues', [projID])
    unassigned = cursor.fetchall()
    if 'loggedin' in session:
        session['project'] = projID
        return render_template('unassigned_issues', unassigned=unassigned)
    else:
        return redirect(url_for('login'))

@app.route('/')
def data_test():
    return login()


if __name__ == '__main__':
    app.run()

# Make sure you are in bug-accountant directory when trying to start up the webpage.
# 1. To start webpage, type the following in terminal (don't include quotes): ". venv/bin/activate" (for Linux/MacOS) 
# OR "venv\Scripts\activate" (for Windows)
# 2. Then type in terminal: "flask run"
# Once the site is running in terminal, click on this link to show the webpage on browser: http://127.0.0.1:5000/

# Login page: http://localhost:5000/pythonlogin/

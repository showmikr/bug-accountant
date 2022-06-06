from ast import arg
from cmath import log
from locale import currency
from turtle import title
from urllib.parse import urldefrag
from colorama import Cursor
from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'secretkey'

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
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
            session['project_names'] = {}
            session['project_roles'] = {}
            session['project_users'] = {}
            cursor.callproc('ListProjects', [session['id']])
            projects = cursor.fetchall()
            for project in projects:
                session['project_names'][project['ProjectID']] = project['ProjectName']
            cursor.close()

            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.callproc('GetProjectRoles', [session['id']])
            project_roles = cursor.fetchall()
            for project_role in project_roles:
                session['project_roles'][project_role['ProjectID']] = project_role['ProjectRole']
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
    session.pop('project_names', None)
    session.pop('project_roles', None)
    session.pop('project_users', None)
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
            # Account doesnt exists and the form data is valid, now insert new account into users table
            cursor.execute('INSERT INTO Users (UserName) VALUES (%s)', (username,))
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
    session.pop('project_users', None)
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
        return render_template('pending_issues.html', issues=data)
    else:
        return redirect(url_for('login'))

@app.route('/unassigned/<projID>')
def unassigned(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetUnassignedIssues', [projID])
    unassigned = cursor.fetchall()
    if 'loggedin' in session:
        session['project'] = projID
        return render_template('unassigned_issues.html', unassigned=unassigned)
    else:
        return redirect(url_for('login'))


@app.route('/my_issues/<projID>')
def my_issues(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetMyProjectIssues', [session['id'], projID])
    my_issues = cursor.fetchall()
    if 'loggedin' in session:
        session['project'] = projID
        return render_template('my_issues.html', issues=my_issues)
    else:
        return redirect(url_for('login'))


@app.route('/my_issues/close_tickets', methods=['GET', 'POST'])
def close_tickets():
    if request.method == 'POST':
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        ticket_list = request.form.getlist('close_checkbox')
        for ticket in ticket_list:
            cursor.callproc('CloseIssue', (session['project'], int(ticket)))
        print(request.form.getlist('close_checkbox'))
        mysql.connection.commit()
        cursor.close()
    return redirect(url_for('my_issues', projID=session['project']))


@app.route('/resolved/<projID>')
def resolved(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetResolvedIssues', [projID])
    data = cursor.fetchall()
    return render_template('resolved.html', resolved=data)

@app.route('/resolved/reopen_tickets', methods=['GET', 'POST'])
def reopen_tickets():
    if request.method == 'POST':
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        ticket_list = request.form.getlist('reopen_checkbox')
        for ticket in ticket_list:
            cursor.callproc('ReopenIssue', (session['project'], int(ticket)))
            mysql.connection.commit()
        print(request.form.getlist('reopen_checkbox'))
        cursor.close()
    return redirect(url_for('resolved', projID=session['project']))


@app.route('/all_issues/<projID>')
def all_issues(projID):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetAllIssues', [projID])
    all_issues = cursor.fetchall()
    cursor.close()

    if 'loggedin' in session:
        session['project'] = projID
        session['project_users'] = {}
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.callproc('GetProjectUsers', (session['project']))
        userlist = cursor.fetchall()
        for user in userlist:
            user_id = user['UserID']
            if user_id != session['id']:
                session['project_users'][user['UserName']] = user_id
        print(session['project_users'])
        return render_template('all_issues.html', issues=all_issues)
    else:
        redirect(url_for('login'))


@app.route('/add_ticket/<projID>', methods=['GET', 'POST'])
def add_ticket(projID):
    if request.method == 'GET':
        return render_template('add_ticket.html')
    elif request.method == 'POST':
        assignee = None
        assignee_str = request.form.get('assignee')
        if assignee_str != None:
            if assignee_str == session['username']:
                assignee_id = session['id']
            else:
                assignee_id = session['project_users'][assignee_str]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        values = (
            session['project'],
            request.form.get('summary'),
            request.form.get('description'),
            request.form.get('priority'),
            session['id'],
            assignee_id
        )
        cursor.callproc('AddIssue', values)
        mysql.connection.commit()
        return render_template('add_ticket.html')
        


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

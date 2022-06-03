from flask import Flask,render_template, request
from flask_mysqldb import MySQL
import MySQLdb.cursors 

app = Flask(__name__)
 
#app.config['MYSQL_HOST'] = 'ls-0e6dd62320aa7f6d260d0d5825892f815269cf28.cmprcwekrhkn.us-west-2.rds.amazonaws.com'
#app.config['MYSQL_USER'] = 'dbmasteruser'
#app.config['MYSQL_PASSWORD'] = 'vET[O|{UeZ&9=FBqn9`x)9G3~fQtSC|^'
#app.config['MYSQL_DB'] = 'BugAccountant'
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Dragonfruit#4'
app.config['MYSQL_DB'] = 'BugAccountant'

mysql = MySQL(app)
 
@app.route('/')
def data_test():
    
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    cursor.execute("select * from Users")
    
    data = cursor.fetchall()
    
    return render_template('GlobalUsersTable.html', data=data)

@app.route('/projects')
def project_test():

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cursor.execute("select * from Projects")

    data = cursor.fetchall()

    return render_template('GlobalProjectsTable.html', data=data)

@app.route('/projects/<project_entry>')
def project_entry(project_entry):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cursor.execute("""  select Projects.ProjectID, ProjectName, UserID, ProjectRole 
                        from Projects 
                        join ProjectUsers 
                        on Projects.ProjectID = ProjectUsers.ProjectID
                        Where Projects.ProjectName = \"""" + project_entry + "\"")

    data = cursor.fetchall()

    return render_template('ProjectEntry.html', data=data)
 
app.run(host='localhost', port=5000)

# Make sure you are in bug-accountant directory when trying to start up the webpage.
# 1. To start webpage, type the following in terminal (don't include quotes): ". venv/bin/activate" (for Linux/MacOS) 
# OR "venv\Scripts\activate" (for Windows)
# 2. Then type in terminal: "flask run"
# Once the site is running in terminal, click on this link to show the webpage on browser: http://127.0.0.1:5000/
# Bug Accountant
Bug Accountant is a project management and issue tracking site made to help teams of software developers centralize and organize all the issues, tasks, and bug reports that they need to take care of on their projects. This app is a more scrappy version of Jira, an industry-standard project management application for software developers.

# Core Technologies
- Python
- Flask: Python-based web server framework
- MySQL: Industry-standard Relational Database
- Docker: Containerize the front-end and back-end
- HTML: Web Page Structure
- CSS: Web Page Styling

# Primary Features
- Role Based Access Control: Different people get differing levels of access and permissions to projects
- Creating, assigning, and resolving bug reports/issue tickets

# Docker Setup
Make sure you have docker or docker desktop installed on your system beforehand
1. `git clone` the project
2. Go into the project directory and run `docker compose up -d --build` from your terminal
3. You can now access the website by visiting `localhost:3000` on your browser
4. To tear down the whole docker setup, just run `docker compose down -v`


-- Group: Showmik Roy, Nick Ryan, Tony Le
-- Run this file inside MySQL Workbench or on the command line to setup a local database
-- Once you've run this file, you should see 'BugAccountantP2' listed as a local database on MySQL.

-- PART A - START
CREATE DATABASE IF NOT EXISTS BugAccountantP2;
USE BugAccountantP2;

-- Lists out all users in the database
CREATE TABLE Users (
    UserID INT NOT NULL AUTO_INCREMENT,
    UserName VARCHAR(100) NOT NULL,
    PRIMARY KEY (UserID)
);

-- Lists out all projects in the database
CREATE TABLE Projects (
    ProjectID INT NOT NULL AUTO_INCREMENT,
    ProjectName VARCHAR(30) NOT NULL,
    PRIMARY KEY (ProjectID)
);

-- Encodes the roles a user can have in a project (We plan on only using 3 roles total)
CREATE TABLE ProjectRoles (
    RoleLevel INT NOT NULL,
    RoleTitle VARCHAR(12),
    PRIMARY KEY (RoleLevel)
);

-- Encodes all project users across all projects along w/ their respective roles
CREATE TABLE ProjectUsers (
    ProjectID INT NOT NULL,
    UserID INT NOT NULL,
    ProjectRole INT NOT NULL,
    PRIMARY KEY (ProjectID, UserID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ProjectRole) REFERENCES ProjectRoles(RoleLevel)
);


-- Lists out all issues across all projects, assigned and unassigned
CREATE TABLE Issues (
    ProjectID INT NOT NULL,
    TicketID INT NOT NULL,
    Summary VARCHAR(100) NOT NULL,
    Description VARCHAR(1000),
    DateReported DATETIME NOT NULL,
    Priority INT UNSIGNED NOT NULL DEFAULT 1,
    ReportedBy INT NOT NULL,
    AssignedTo INT DEFAULT NULL,
    DateAssigned DATETIME DEFAULT NULL,
    DateClosed DATETIME DEFAULT NULL,
    PRIMARY KEY (ProjectID, TicketID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (ReportedBy) REFERENCES Users(UserID),
    FOREIGN KEY (AssignedTo) REFERENCES Users(UserID)
);

-- PART A END

-- PART B START

INSERT INTO Users (UserName)  
VALUES
    ('Brad'), 
    ('Paul'), 
    ('Katie'), 
    ('Bob'), 
    ('Dylan'), 
    ('Showmik'), 
    ('Tony'), 
    ('Nick'),
    ('Jane'),
    ('Morgan'),
    ('Stanley'),
    ('Maya'),
    ('Aaron'),
    ('Joe'),
    ('ProfessionalParmesanPractitioner'),
    ('DancingDinoDuck'),
    ('MisterMuse'),
    ('ForkMyRepo');

INSERT INTO Projects (ProjectName)
VALUES
    ('Bug Accountant'),
    ('NLP Paraphraser'),
    ('Nintendo Themed Trivia Maze'),
    ('Ebay Sniping Bot'),
    ('Stock Options Trading Bot'),
    ('Image SuperSampler'),
    ('Automatic Nav-Mesh Maker'),
    ('Personal Website (Pls Hire Me)'),
    ('Hacker Man Hacking Project'),
    ('Personal Trainer AI');

INSERT INTO ProjectRoles
VALUES
    (0, 'Owner'),
    (1, 'Admin'),
    (2, 'Contributor');

INSERT INTO ProjectUsers (ProjectID, UserID, ProjectRole)
VALUES
    (1, 7, 0),
    (2, 1, 0),
    (3, 6, 0),
    (4, 2, 0),
    (5, 5, 0),
    (6, 2, 0),
    (7, 9, 0),
    (8, 10, 0),
    (9, 15, 0),
    (10, 4, 0),

    (1, 6, 1),
    (1, 8, 1),
    (2, 2, 1),
    (2, 3, 1),
    (3, 4, 1),
    (3, 5, 1),
    (4, 3, 1),
    (5, 3, 1),
    (5, 9, 1),
    (5, 10, 1),
    (6, 4, 1),
    (6, 11, 1),
    (6, 12, 1),
    (7, 10, 1),
    (7, 1, 1),
    (7, 7, 1),
    (7, 12, 1),
    (9, 8, 1),
    (9, 14, 1),
    (9, 12, 1),
    (9, 11, 1),
    (9, 10, 1),
    (10, 2, 1),
    (10, 10, 1),
    (10, 15, 1),
    (10, 5, 1),

    (2, 4, 2),
    (2, 5, 2),
    (2, 6, 2),
    (3, 10, 2),
    (3, 11, 2),
    (3, 12, 2),
    (4, 4, 2),
    (4, 8, 2),
    (5, 4, 2),
    (5, 7, 2),
    (5, 12, 2),
    (6, 1, 2),
    (6, 10, 2),
    (6, 15, 2),
    (6, 13, 2),
    (6, 5, 2),
    (7, 8, 2),
    (7, 11, 2),
    (7, 14, 2),
    (7, 13, 2),
    (9, 7, 2),
    (9, 13, 2),
    (9, 6, 2),
    (9, 9, 2),
    (9, 4, 2),
    (9, 1, 2),
    (9, 5, 2),
    (9, 16, 2),
    (10, 7, 2),
    (10, 3, 2),
    (10, 16, 2),
    (10, 17, 2),
    (10, 18, 2);

INSERT INTO Issues (ProjectID, TicketID, Summary, Description, DateReported, Priority, ReportedBy, AssignedTo, DateAssigned, DateClosed)
VALUES
    (1, 1, "Can't connect react project to local database", NULL, '2022-04-04 10:00:00', 3, 6, 6, '2022-04-05 12:18:24', NULL),
    (1, 2, "Routing to user home page not working", "Something to do w/ using WSL for coding, but Windows for browser testing - maybe.", '2022-04-05 12:13:12', 2, 6, NULL, NULL, NULL),
    (1, 3, "Resolving ticket in front end not deleting it in db", NULL, '2022-04-06 9:32:54', 1, 6, 7, '2022-04-06 13:44:12', NULL),

    (2, 1, "NLP algorithm not autocorrecting typos", "This needs fixing in the pre-processing layer - fix should be put in there", '2022-03-04 3:12:32', 2, 3, 5, '2022-03-06 10:42:12', '2022-03-10 12:10:23'),
    (2, 2, "Document Scanning function not working in angled orientation", "Need to do matrix transform of angled scan to be flat", '2022-03-13 11:54:23', 2, 2, 6, '2022-03-13 13:54:21', '2022-03-20 13:12:42'),
    (2, 3, "Paraphrasing algorithm making vague results", "Need to make algorithm run on sentence by sentence basis instaed of paragraph", '2022-04-12 4:15:22', 3, 1, 4, '2022-04-15 12:10:42', NULL),

    (3, 1, "View not updating after moving player in model", NULL, '2022-02-22 12:00:45', 3, 6, 6, '2022-02-22 12:01:45', '2022-03-01 13:45:42'),
    (3, 2, "Music volume slider not working", "The volume slider value needs to be binded to music volume variable", '2022-02-14 12:30:24', 1, 10, NULL, NULL, NULL),

    (4, 1, "Sniping bot bids outrageous amounts within last few seconds", NULL, '2022-01-12 4:50:23', 3, 4, 8, '2022-01-14 10:54:12', '2022-01-21 14:23:43'),
    (4, 2, "Ebay site listing price not longer being read by scraper", NULL, '2022-01-20 19:20:43', 2, 3, 8, '2022-01-20 20:24:17', NULL),
    (4, 3, "Sniping bot not bidding below current highest bid", NULL, '2022-02-03 17:32:23', 3, 8, 4, '2022-02-04 12:03:39', NULL),
    (4, 4, "Bot bids too aggressively on GPU products", NULL, '2022-02-14 14:43:12', 1, 4, NULL, NULL, NULL),

    (5, 1, "Options trading bot getting previous days values, not current", NULL, '2022-03-12 10:30:43', 3, 7, 12, '2022-03-13 13:32:45', NULL),

    (6, 1, "Anti-aliasing not working correctly", "Jagged lines seems to increase with higher anti-aliasing", '2022-05-1 12:43:23', 2, 5, 5, '2022-05-01 12:45:32', '2022-05-15 13:32:43'),
    (6, 2, "Sharpening filter not working correctly on images w/ Bokeh", NULL, '2022-05-04 9:30:45', 1, 11, 11, '2022-05-04 9:40:23', '2022-05-23 14:22:29'),

    (7, 1, "Nav-mesh arcs jumping into air on slopes higher than 90 degrees", "I have no idea how to fix this - pls help", '2022-03-24 14:23:40', 3, 14, 8, '2022-03-25 12:23:43', '2022-04-02 9:43:12'),
    (7, 2, "Nav-mesh arc generation algorithm too slow", "Switch from BFS algorithm to A* search for optimal pathing", '2022-02-20 14:45:32', 2, 9, 14, '2022-02-23 10:10:39', '2022-03-01 11:43:21'),
    (7, 3, "Nav-mesh algorithm not working on 3D mesh with holes", "Run algorithm in a for/while loop to cover every surface", '2022-03-12 13:24:21', 1, 12, 12, '2022-03-13 10:43:21', NULL),
    (7, 4, "Nav-mesh algorithm traces unoptimal shortest path sometimes", "Need to determine cases where this happens then fix said cases", '2022-04-2 14:23:41', 1, 10, 10, '2022-04-03 12:20:15', NULL),
    (7, 5, "GUI in UE5 engine not loading preview of nav-mesh", NULL, '2022-05-11 11:54:54', 2, 13, NULL, NULL, NULL),

    (8, 1, "Youtube videos not loading in page", "Maybe switch to different video hosting method?", '2022-04-12 15:54:23', 1, 10, NULL, NULL, NULL),
    (8, 2, "Div not centering correctly within skills component", NULL, '2022-04-14 10:14:45', 1, 10, NULL, NULL, NULL),
    (8, 3, "Website speed slow according to google performance measures", "Might need to do image compression or lazy loading", '2022-10-16 13:43:23', 2, 10, NULL, NULL, NULL),

    (9, 1, "Captcha clearer bot not beating captchas anymore", "Stack Overflow how to fix this", '2022-02-16 11:53:20', 1, 3, 9, '2022-02-17 09:20:42', '2022-02-26 11:10:44'),
    (9, 2, "Local Library SQL injection attack not penetrating system anymore", "Why is this even a problem?", '2022-03-12', 1, 16, 4, '2022-03-13 10:30:43', '2022-03-18 17:23:54'),
    (9, 3, "Wifi password guesser not working on passwords greater than 30 characters", "Algorithm upgrade time...", '2022-03-25 10:10:32', 1, 1, 9, '2022-03-26 12:32:32', NULL),
    (9, 4, "Hidden Bitcoin miner getting detected by Avast Antivirus", "Need to reduce network load for miner", '2022-02-08 12:30:54', 3, 10, 10, '2022-02-11 9:12:32', '2022-02-20 13:42:17'),
    (9, 5, "NFT malicious code injection not working on Etherium blockchain", NULL, '2022-05-03 10:56:32', 2, 10, 10, '2022-05-09 10:30:32', NULL),
    (9, 6, "Did you guys see Mr. Robot's Final Season?", "Seriously, it's trippy. Pls don't ban me.", '2022-03-15 20:19:42', 1, 14, 1, '2022-03-17 12:21:12', NULL),
    (9, 7, "Keylogger not working after several thousand characters written", "Might be due to buffer overflow, need to reset buffer occasionally", '2022-05-06 22:32:09', 2, 12, NULL, NULL, NULL),
    (9, 8, "Desktop Duck application not working on Ubuntu 20.04 build", "Get that duck working ASAP!", '2022-05-12 23:15:10', 3, 8, NULL, NULL, NULL),
    (9, 9, "Windows Defender detecting malicious C code in desktop duck application", "We'll have to update the C code slightly to prevent detection from Windows Defender.", '2022-04-13 4:32:21', 1, 12, 8, '2022-04-16 14:44:54', NULL),

    (10, 1, "AI trainer is very rude", "AI sometimes yells curse words to users. Get rid of that and whoever coded it - stop adding curse words!.", '2022-05-05 10:13:33', 2, 15, 3, '2022-05-05 12:30:32', '2022-05-10 12:20:25'),
    (10, 2, "AI trainer doesn't count steps correctly", "This can be implemented with a pre-built API - find one", '2022-05-10 15:22:22', 1, 10, 18, '2022-05-12 13:10:37', '2022-05-14 11:15:19'),
    (10, 3, "Diet Form not handling invalid input correctly", NULL, '2022-04-25 10:12:15', 2, 18, 18, '2022-04-26 14:27:21', '2022-04-29 14:17:52'),
    (10, 4, "User logout button showing when user hasn't signed in", NULL, '2022-03-05', 1, 2, NULL, NULL, NULL),
    (10, 5, "User passwords are NOT ENCRYPTED!", "FIX IMMEDIATELY!", '2022-03-07', 3, 4, NULL, NULL, NULL),
    (10, 6, "AI trainer reccomends too many squats", "Somebody likes leg day too much... pls fix", '2022-03-19 19:23:56', 2, 15, NULL, NULL, NULL);

-- PART B END

-- PART C START

-- **********************************************************************************************
-- Query 1
-- **********************************************************************************************
-- Requirements: Compute a join of at least three tables
--
-- Expected: Find all issues of certain project
--
-- Purpose: This is useful to find bugs for specific project

-- Query 1: List all bug for project Bug Accountant-- 
SELECT DISTINCT ProjectName, Summary, DateReported, DateAssigned
FROM Projects 
JOIN Issues ON Issues.ProjectID=Projects.ProjectID 
JOIN ProjectUsers ON ProjectUsers.ProjectID=Projects.ProjectID
WHERE ProjectName = "Bug Accountant";

-- Query 2: Nested Query using IN and GROUP BY
-- Purpose: Track how many tickets a given user has resolved for each project they're involved in
-- Summary: Displays ProjectID, ProjectName, and # of tickets resolved by the user in each project
DELIMITER //
CREATE PROCEDURE SelectResolvedTicketsAcrossProjects(UserIDValue INT)
BEGIN
    SELECT issues.ProjectID, ProjectName, COUNT(TicketID) AS TicketsResolved
    FROM issues JOIN Projects ON issues.ProjectID = Projects.ProjectID
    WHERE AssignedTo IN (
	    SELECT AssignedTo
        FROM issues
        WHERE AssignedTo = UserIDValue AND DateClosed IS NOT NULL
	)
    GROUP BY issues.ProjectID;
END //
DELIMITER ;

-- Query 3
-- Correlated nested query with proper aliasing
-- Determine which projects have more issues than project x
Select Projects.ProjectName, Count(Issues.TicketID) as 'Number of Issues'
From Issues 
JOIN Projects
ON Issues.ProjectID = Projects.ProjectID
Group by Projects.ProjectID
Having Count(Issues.TicketID) > (
	Select Count(Issues.TicketID)
	From Issues
    JOIN Projects
	ON Issues.ProjectID = Projects.ProjectID
    Where Projects.ProjectName = 'NLP Paraphraser'
    );

-- **********************************************************************************************
-- Query 4
-- **********************************************************************************************
-- Requirements: Use a FULL OUTER JOIN
--
-- Expected: List all projects and users whether they've been assigned 
--
-- Purpose: This is useful when we need to know the current assignment of all projects and users

SELECT i1.ProjectID, i1.Summary, i1.ticketId, u1.UserName AS 'Assigned User'
FROM Issues AS i1
LEFT JOIN Users AS u1
ON i1.AssignedTo = u1.UserID
UNION
SELECT i1.ProjectID, i1.Summary, i1.ticketId, u1.UserName AS 'Assigned User'
FROM Issues AS i1
RIGHT JOIN Users AS u1
ON i1.AssignedTo = u1.UserID;


-- Query 5
-- Uses nested queries with any of the set operations UNION, EXCEPT, or INTERSECT*  
-- Find all the users working on Project A or Project B but not Both
-- The Except set operation in MySQl is called Not In
Select Users.UserName, Users.UserID, Projects.ProjectName
From Users
Join ProjectUsers
ON Users.UserID = ProjectUsers.UserID
JOIN Projects
ON ProjectUsers.ProjectID = Projects.ProjectID
Where 
	(Projects.ProjectName = 'NLP Paraphraser' or Projects.ProjectName = 'Bug Accountant') 
    AND Users.UserName NOT IN (
		Select distinct u1.UserName
		From (Users as u1
		Join ProjectUsers as pu1
		ON u1.UserID = pu1.UserID
		JOIN Projects as p1
		ON pu1.ProjectID = p1.ProjectID)
		CROSS JOIN
		(Users as u2
		Join ProjectUsers as pu2
		ON u2.UserID = pu2.UserID
		JOIN Projects as p2
		ON pu2.ProjectID = p2.ProjectID)
		Where 
		(u1.UserName = u2.UserName)
		AND
		(
			(p1.ProjectName = 'NLP Paraphraser' AND p2.ProjectName = 'Bug Accountant') 
			OR
			(p2.ProjectName = 'NLP Paraphraser' AND p1.ProjectName = 'Bug Accountant')
		)
);

-- Non-Trivial Query 6
-- Get all unassigned issues for a given project (Input = ProjectID, Output = Table of all unassigned issues)
DELIMITER //
CREATE PROCEDURE GetUnassignedIssues(ProjID INT) 
BEGIN 
	SELECT TicketID, Priority, Summary, getUserName(ReportedBy) as Reporter, DateReported
	FROM BugAccountantP2.Issues
	    JOIN Users ON ReportedBy = UserID
	WHERE ProjectID = ProjID AND DateAssigned IS NULL
	ORDER BY Priority DESC, DateReported ASC;
END // 
DELIMITER ;

-- Non-Trivial Query 7 - Function call
-- Purpose: Automatically increment the TicketID when adding new ticket to a given project
-- Input = ProjectID, Output = Incremented TicketID value within project
-- Outputs the next TicketID value when inserting a new issue into a given project
DELIMITER //
CREATE FUNCTION getIncrementedTicketID(ProjID INT) 
RETURNS INT READS SQL DATA 
BEGIN 
	DECLARE retVal INT;
	SELECT
	    MAX(TicketID) + 1 INTO retVal
	FROM
	    (
            SELECT TicketID
	        FROM issues
	        WHERE ProjectID = ProjID
	    ) AS ProjectObserved;
	RETURN retVal;
END // 
DELIMITER ;

-- Non-Trivial Query 8
-- Purpose: Get list of all users involved in a given project
-- Summary: Displays UserID and UserName of every user involved in a given project
DELIMITER //
CREATE PROCEDURE SelectProjectUsers(ProjID INT)
BEGIN
    SELECT Users.UserID, UserName
    FROM projectusers JOIN users ON projectusers.UserID = users.UserID
    WHERE ProjectID = ProjID;
END //
DELIMITER ;

-- Non trivial query 9
-- Purpose: display all queries that have been assigned but not resolved
-- Summary: Displays ProjectName, TicketID, 
Select Projects.ProjectName, Issues.TicketID, Users.UserName AS 'Assigned User', Issues.Summary, 
		Issues.Description, Issues.DateReported, Issues.DateAssigned
From Issues
JOIN Projects
ON Issues.ProjectID = Projects.ProjectID
Join Users
ON Users.UserID = Issues.AssignedTo
Where Issues.DateClosed Is NUll AND Issues.DateAssigned IS NOT NULL;

-- Non-Trivial Query 10 - doesn't use 3 tables, but makes use of 2 queries in total
-- Purpose: Get username based on userID
-- Summary: Return username for a given UserID
-- Function that returns UserName when given a UserID
DELIMITER //
CREATE FUNCTION getUserName(UserIDValue INT)
RETURNS VARCHAR(100) READS SQL DATA
BEGIN
    DECLARE retString VARCHAR(100);
    SELECT UserName INTO retString
    FROM Users
    WHERE UserID = UserIDValue;
    RETURN retString;
END //
DELIMITER ;

-- Apart of Query 10: Get List of all issues for a given project (assigned, unassigned, resolved - every issue)
DELIMITER //
CREATE PROCEDURE GetAllIssues(ProjID INT)
BEGIN
    SELECT DISTINCT TicketID, Priority, Summary, getUserName(AssignedTo) AS Asignee, getUserName(ReportedBy) AS Reporter, DateAssigned, DateReported, DateClosed
    FROM BugAccountantP2.Issues
    WHERE Issues.ProjectID = ProjID
    ORDER BY Priority DESC, DateReported ASC;
END //
DELIMITER ;

-- PART C END

-- All Queries Below Are Extras that we'll use later on


-- Adds an issue to a project
DELIMITER //
CREATE PROCEDURE AddIssue(ProjectID INT, Summary VARCHAR(100), Description VARCHAR(1000), Priority INT UNSIGNED, ReportedBy INT, AssignedTo INT)
BEGIN
	DECLARE outputDescription VARCHAR(1000);
    DECLARE outputAssignedDate DATETIME;
    SELECT NULLIF(TRIM(Description), '') INTO outputDescription;
    SELECT IF(AssignedTo IS NOT NULL, NOW(), NULL) INTO outputAssignedDate;
    INSERT INTO Issues (ProjectID, TicketID, Summary, Description, DateReported, Priority, ReportedBy, AssignedTo, DateAssigned)
    VALUES
        (ProjectID, getIncrementedTicketID(ProjectID), Summary, outputDescription, COALESCE(outputAssignedDate, NOW()), Priority, ReportedBy, AssignedTo, outputAssignedDate);
END //
DELIMITER ;


-- List all projects for a given user
DELIMITER //
CREATE PROCEDURE ListProjects(UID INT)
BEGIN
    SELECT ProjectID, ProjectName
    FROM Projects
    WHERE Projects.ProjectID IN (
		SELECT ProjectID
        FROM ProjectUsers
        WHERE ProjectUsers.UserID = UID
    );
END //
DELIMITER ;


-- Get List of all pending issues for a given project (has been assigned, but not yet resolved)
DELIMITER //
CREATE PROCEDURE GetPendingIssues(ProjID INT)
BEGIN
    SELECT DISTINCT TicketID, Priority, Summary, getUserName(AssignedTo) AS Asignee, getUserName(ReportedBy) AS Reporter, DateAssigned, DateReported
    FROM BugAccountantP2.Issues
    WHERE Issues.ProjectID = ProjID AND AssignedTo IS NOT NULL AND DateAssigned IS NOT NULL AND DateClosed IS NULL
    ORDER BY Priority DESC, DateReported ASC;
END //
DELIMITER ;


-- Get List of all issues assigned to a particular user of a project
DELIMITER //
CREATE PROCEDURE GetMyProjectIssues(UID INT, ProjID INT)
BEGIN
    SELECT DISTINCT TicketID, Priority, Summary, getUserName(AssignedTo) AS Asignee, getUserName(ReportedBy) AS Reporter, DateAssigned, DateReported
    FROM BugAccountantP2.Issues
    WHERE Issues.ProjectID = ProjID AND AssignedTo = UID AND DateAssigned IS NOT NULL AND DateClosed IS NULL
    ORDER BY Priority DESC, DateReported ASC;
END //
DELIMITER ;


-- Closes and issue given the project id and ticket id
DELIMITER //
CREATE PROCEDURE CloseIssue(ProjID INT, TickID INT)
BEGIN
	UPDATE Issues SET DateClosed = NOW() WHERE ProjectID = ProjID AND TicketID = TickID;
END //
DELIMITER ;


-- Closes an issue given the project id and ticket id
DELIMITER //
CREATE PROCEDURE ReopenIssue(ProjID INT, TickID INT)
BEGIN
	UPDATE Issues SET DateClosed = NULL WHERE ProjectID = ProjID AND TicketID = TickID;
END //
DELIMITER ;


-- Get the role a user plays for each project they're involved in.
DELIMITER //
CREATE PROCEDURE GetProjectRoles(UID INT)
BEGIN
    SELECT ProjectID, ProjectRole
    FROM ProjectUsers
    WHERE UserID = UID;
END //
DELIMITER ;


-- Get all the resolved issues for a given project
DELIMITER //
CREATE PROCEDURE GetResolvedIssues(ProjID INT)
BEGIN
    SELECT DISTINCT TicketID, Priority, Summary, getUserName(AssignedTo) AS Asignee, getUserName(ReportedBy) AS Reporter, DateReported, DateClosed
    FROM Issues
    WHERE ProjectID = ProjID AND DateClosed IS NOT NULL;
END //
DELIMITER ;


-- Get all the users in a given project
DELIMITER //
CREATE PROCEDURE GetProjectUsers(ProjID INT)
BEGIN
    SELECT DISTINCT UserID, getUserName(UserID) as UserName
    FROM ProjectUsers
    WHERE ProjectID = ProjID;
END //
DELIMITER ;


-- Assigns an issue given a project and user
DELIMITER //
CREATE PROCEDURE AssignIssue(ProjID INT, TickID INT, UID INT)
BEGIN
	UPDATE Issues 
    SET 
		DateAssigned = NOW(),
        AssignedTo = UID
    WHERE ProjectID = ProjID AND TicketID = TickID;
END //
DELIMITER ;


-- Add a new project and assign the current user as owner of said project
DELIMITER //
CREATE PROCEDURE AddProject(ProjectTitle VARCHAR(30), ProjectOwner INT)
BEGIN
	DECLARE ProjID INT;
    SELECT MAX(ProjectID) + 1 FROM Projects INTO ProjID;
	INSERT INTO Projects (ProjectName)
		VALUES (ProjectTitle);
    INSERT INTO ProjectUsers
		VALUES (ProjID, ProjectOwner, 0);
END //
DELIMITER ;


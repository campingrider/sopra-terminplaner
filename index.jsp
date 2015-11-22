<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	boolean inContainer = true;
	boolean loggedIn = false;
	boolean dataFault = false;
	boolean fatalError = false;
	String fatalErrorMessage = "";
	String messages = ""; 
	String status = "";
	java.security.MessageDigest md;
	String[] defRegVals = new String[7];
	int i = 0;
</jsp:declaration>
<%
	// Anfangswerte rauswerfen bzw. initialisieren
	fatalErrorMessage = "";
	messages = "";
	status = "";
	for (int i = 0; i < 7; i++) {
		defRegVals[i] = "";
	}
%>
<%	// Hash-Funktion initialisieren
	md = java.security.MessageDigest.getInstance("SHA-512");
%>
<%	// Status-Abfrage und Einbindung entsprechender Skripte zur Datenbehandlung
	if (request.getParameter("status") != null) {
		status = request.getParameter("status");
	}
	loggedIn = false;
	if (status.equals("login")) {
		loggedIn = true;		
	}

	if (!status.equals("")) {
		if (status.equals("login")) {
		%>
			<%@ include file="includes/login.jsp" %>
		<%
		} else if (status.equals("logout")) {
		%>
			<%@ include file="includes/logout.jsp" %>
		<%
		} else if (status.equals("pwres")) {
		%>
			<%@ include file="includes/pwres.jsp" %>
		<%
		} else if (status.equals("register")) {
		%>
			<%@ include file="includes/register.jsp" %>
		<%
		} 
	}
%>
<!DOCTYPE html>
<html lang="de">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" type="text/css" href="css/style.css">
		<title>Wochenplaner - Programmierübungsaufgabe</title>
	</head>	
	<body>
		<header>
			<h1>Wochenplaner für Veranstaltungen</h1>
			<jsp:scriptlet>
			if (loggedIn) {
			</jsp:scriptlet>
				<p><a href="?status=logout">abmelden.</a></p>
			<jsp:scriptlet>
			}
			</jsp:scriptlet>
		</header>
		<% if (!messages.equals("")) { %>
		<aside id="messages">
			<%= messages %>
		</aside>
		<% } %>
		<main>
			<% if(request.isSecure()) { %>
				<jsp:scriptlet>
				if (loggedIn) {
				</jsp:scriptlet>
					<jsp:directive.include file="includes/wochenplan.jsp" />
				<jsp:scriptlet>
				} else {
				</jsp:scriptlet>
					<jsp:directive.include file="includes/loginform.jsp" />
				<jsp:scriptlet>
				}
				</jsp:scriptlet>
			<% } else { %>
				<div class="formbox">
					<h2>Fehler: Unsichere Verbindung</h1>
					<p>Wir verarbeiten in unserem Service personenbezogene Daten unserer Kunden. Es ist daher bedauerlicherweise nicht möglich, unseren Service über eine unverschlüsselte Verbindung zu nutzen. Rufen Sie unsere Seite bitte über das sichere https-Protokoll ab, um unseren Service zu nutzen.</p>
				</div>
			<% } %>
		</main>
	</body>
</html>

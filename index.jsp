<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	boolean inContainer = true;
	boolean loggedIn = false;
	String status = "";
</jsp:declaration>
<%
	if (request.getParameterMap().get("status") != null) {
		status = request.getParameterMap().get("status")[0];
	}
	loggedIn = false;
	if (status.equals("login") || status.equals("register")) {
		loggedIn = true;		
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

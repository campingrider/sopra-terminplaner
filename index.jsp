<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	boolean inContainer = true;
	boolean loggedIn = true;
</jsp:declaration>
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
				<p><a>abmelden.</a></p>
			<jsp:scriptlet>
			}
			</jsp:scriptlet>
		</header>
		<main>
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
		</main>
	</body>
</html>

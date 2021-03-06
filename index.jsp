<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<jsp:declaration>
	String home;
	String host;
	String mailserver;
	String mailAddress;
</jsp:declaration>
<%-- Die folgende Datei initialisiert die obigen Verbindungsdaten zu E-Mail-Server und Wochenplaner --%>
<%@ include file="maildata.jsp" %>

<%@ include file="init_generics.jsp" %>
<jsp:declaration>
	boolean inContainer;
	String messages; 
	String status;
	java.security.MessageDigest md;
	java.security.MessageDigest md2;
	String[] defRegVals = new String[7];
	String[] defLogVals = new String[2];
	String[] defPWRVals = new String[3];
	int i = 0;
	String pwhash;
	Properties mailprops;
	Session mailSession;
	MimeMessage mail;
	String key;
	String href;
</jsp:declaration>
<%
	// Anfangswerte rauswerfen bzw. initialisieren
	inContainer = true;
	messages = "";
	status = "";
	for (int i = 0; i < 7; i++) {
		if (i < 2) defLogVals[i] = "";
		if (i < 3) defPWRVals[i] = "";
		defRegVals[i] = "";
	}
	defPWRVals[1] = "Zunächst E-Mail angeben";
	mailprops = System.getProperties();
	mailprops.setProperty(mailserver, host);
	mailSession = Session.getDefaultInstance(mailprops);
%>

<%@ include file="init_db.jsp" %>
<%	// Hash-Funktionen initialisieren
	md = java.security.MessageDigest.getInstance("SHA-512");
	md2 = java.security.MessageDigest.getInstance("SHA-1");
%>


<%	// Status-Abfrage und Einbindung entsprechender Skripte zur Datenbehandlung
	if (request.getParameter("status") != null) {
		status = request.getParameter("status");
	}
	

	if (!status.equals("")) {
		if (status.equals("login") && session.getAttribute("uid") == null) {
		%>
			<%@ include file="includes/login.jsp" %>
		<%
		} else if (status.equals("update") && session.getAttribute("uid") != null) {
		%>
			<%@ include file="includes/processChanges.jsp" %>
		<%
		} else if (status.equals("logout")) {
		%>
			<%@ include file="includes/logout.jsp" %>
		<%
		} else if (status.equals("pwres") && session.getAttribute("uid") == null) {
		%>
			<%@ include file="includes/pwres.jsp" %>
		<%
		} else if (status.equals("register") && session.getAttribute("uid") == null) {
		%>
			<%@ include file="includes/register.jsp" %>
		<%
		} else if (status.equals("mailconfirm")) {
		%>
			<%@ include file="includes/mailconfirm.jsp" %>
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
		<script type="text/javascript" src="js/toolbox.js"></script>
<% if (session.getAttribute("uid") == null) { %>
		<script type="text/javascript" src="js/loginform.js"></script>
<% } else { %>
		<script type="text/javascript" src="js/wochenplan.js"></script>
<% } %>
		<title>Wochenplaner - Programmierübungsaufgabe</title>
	</head>	
	<body>
		<header>
			<h1>Wochenplaner für Veranstaltungen<% if (session.getAttribute("uid") != null) { %><span class="onlyprint_i"> von <%= session.getAttribute("firstname") %>&nbsp;<%= session.getAttribute("lastname") %></span><% } %></h1>
			<jsp:scriptlet>
			if (session.getAttribute("uid") != null) {
			</jsp:scriptlet>
				<p class="noprint"><a href="javascript:window.print()">drucken.</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="?status=logout">abmelden.</a></p>
			<jsp:scriptlet>
			}
			</jsp:scriptlet>
		</header>
		<% if (!messages.equals("") && !fatalError && request.isSecure()) { %>
		<aside id="messages">
			<%= messages %>
		</aside>
		<% } %>
		<main>
			<% if (!fatalError) { %>
				<% if(request.isSecure()) { %>
					<jsp:scriptlet>
					if (session.getAttribute("uid") != null) {
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
					<div id="messages">
						<h2>Fehler: Unsichere Verbindung</h1>
						<p>Wir verarbeiten in unserem Service personenbezogene Daten unserer Kunden. Es ist daher bedauerlicherweise nicht möglich, unseren Service über eine unverschlüsselte Verbindung zu nutzen. Rufen Sie unsere Seite bitte über das sichere https-Protokoll ab, um unseren Service zu nutzen.</p>
					</div>
				<% } %>
			<% } else { %>
					<div id="messages">
						<h2>Fataler Fehler</h1>
						<%= fatalErrorMessage %>
					</div>
			<% } %>
		</main>
	</body>
</html>

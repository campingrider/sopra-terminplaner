<%@ page trimDirectiveWhitespaces="true" %>
<jsp:declaration>
	boolean dataFault;
	boolean fatalError;
	String fatalErrorMessage;
</jsp:declaration>
<%
	// Anfangswerte rauswerfen bzw. initialisieren
	dataFault = false;
	fatalError = false;
	fatalErrorMessage = "";
%>

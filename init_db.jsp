<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	Connection dbcon;
	Statement dbs;
	ResultSet dbrs;
	PreparedStatement dbpst;
	String sql;
</jsp:declaration>
<jsp:declaration>
	String dbUrl = "";
	String dbUsr = "";
	String dbPW = "";
</jsp:declaration>
<%-- Die folgende Datei initialisiert die obigen Verbindungsdaten zur Datenbank --%>
<%@ include file="dbdata.jsp" %>
<% //DB-Initialisierung
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		dbcon = DriverManager.getConnection("jdbc:mysql://"+dbUrl+"?useUnicode=true&characterEncoding=UTF-8", dbUsr, dbPW);
	} catch (Exception e) {
		fatalError = true;
		fatalErrorMessage = fatalErrorMessage+"<p>Verbindung zur Datenbank ist fehlgeschlagen.</p>";
		fatalErrorMessage = fatalErrorMessage+"<pre>"+e.toString()+"</pre>";
	}
%>

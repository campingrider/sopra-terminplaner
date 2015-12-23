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
	
	// Anlegen der Tabellen, falls nötig
	try {
		
		dbs = dbcon.createStatement();
		
		sql = "CREATE TABLE IF NOT EXISTS `sopraplaner_dates` (`eid` bigint(20) NOT NULL, `daytime` int(10) NOT NULL COMMENT 'day*100+time') ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;";
		dbs.execute(sql); 
		
		sql = "CREATE TABLE IF NOT EXISTS `sopraplaner_events` (`eid` bigint(20) NOT NULL AUTO_INCREMENT,`uid` bigint(20) NOT NULL,`title` varchar(30) COLLATE utf8_bin NOT NULL,`description` varchar(128) COLLATE utf8_bin NOT NULL, PRIMARY KEY (`eid`)) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;";
		dbs.execute(sql); 
		
		sql = "CREATE TABLE IF NOT EXISTS `sopraplaner_users` (`uid` bigint(20) NOT NULL AUTO_INCREMENT,`email` varchar(50) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,`firstname` varchar(30) COLLATE utf8_bin NOT NULL,`lastname` varchar(30) COLLATE utf8_bin NOT NULL,`sec_q` varchar(50) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,`sec_a` varchar(20) COLLATE utf8_bin NOT NULL,`pwhash` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,`activated` tinyint(1) NOT NULL DEFAULT '0',PRIMARY KEY (`uid`),UNIQUE KEY `email` (`email`)) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;";
		dbs.execute(sql); 
		
	} catch (Exception e) {
		fatalError = true;
		fatalErrorMessage = fatalErrorMessage+"<p>Initialisieren der Datentabellen ist fehlgeschlagen.</p>";
		fatalErrorMessage = fatalErrorMessage+"<pre>"+e.toString()+"</pre>";
	}
%>

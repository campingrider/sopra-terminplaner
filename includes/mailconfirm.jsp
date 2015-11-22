<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	// 0: Mail
	// 1: key
	String[] confirmdata = new String[2];
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
	<%
		confirmdata[0] = request.getParameter("mail");
		
		if (confirmdata[0] == null || confirmdata[0].equals("")) {
			dataFault = true;
			messages = messages + "<p>Ihre E-Mail-Adresse konnte nicht verwertet werden, das Benutzerkonto wurde nicht aktiviert.</p>";
			confirmdata[0] = "";
		} else if (!confirmdata[0].matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
			dataFault = true;
			messages = messages + "<p>Ihre E-Mail-Adresse konnte nicht verwertet werden, das Benutzerkonto wurde nicht aktiviert.</p>";
		}
		
		confirmdata[1] = request.getParameter("key");
		if (confirmdata[1] == null || confirmdata[1].equals("")) {
			dataFault = true;
			messages = messages + "<p>Der Aktivierungscode konnte nicht ausgewertet werden.</p>";
			confirmdata[1] = "";
		} else if (!confirmdata[1].matches("^[a-fA-F0-9]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Aktivierungscode konnte nicht ausgewertet werden.</p>";
		}
		
		// Falls es bis hier keinen DataFault gab: Werte abgleichen
		if (!dataFault) {
			sql = "SELECT `uid`,`firstname`,`lastname`,`pwhash`,`activated` FROM `sopraplaner_users` WHERE `email`='"+confirmdata[0]+"';";
			
			dbs = dbcon.createStatement();
			try {
				dbrs = dbs.executeQuery(sql); 
				dbrs.next();
				
				if (!dbrs.getBoolean("activated")) {	
					key = dbrs.getString("uid")+confirmdata[0]+dbrs.getString("firstname")+dbrs.getString("uid")+dbrs.getString("lastname")+dbrs.getString("pwhash")+dbrs.getString("uid");
					md2.update(key.getBytes());
					key = javax.xml.bind.DatatypeConverter.printHexBinary(md2.digest());
					
					if (key.equals(confirmdata[1])) {
						sql = "UPDATE `sopraplaner_users` SET `activated`='1' WHERE  `email`='"+confirmdata[0]+"';";
						dbs.executeUpdate(sql);
						messages = messages + "<p>Das Benutzerkonto wurde aktiviert.</p>";
					} else {
						messages = messages + "<pre>"+key+"</pre>";
						messages = messages + "<pre>"+confirmdata[1]+"</pre>";
						messages = messages + "<p>Der Aktivierungsschlüssel ist falsch, das Benutzerkonto wurde nicht aktiviert.</p>";
					}
				} else {
					messages = messages + "<p>Das Benutzerkonto ist bereits aktiviert.</p>";
				}
			
			} catch (SQLException e) {
				dataFault = true;
				messages = messages + "<p>Das Aktivieren des Benutzerkontos ist fehlgeschlagen.</p>";
				messages = messages + "<p>Die Datenbank akzeptiert Ihre Eingaben nicht: "+e.getMessage()+"</p>";	
			}
		}
	%>	
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

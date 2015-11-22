<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	// 0: Mail
	// 1: Passwort
	String[] logdata = new String[7];
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
<%
		logdata[0] = request.getParameter("login_mail");
		
		if (logdata[0] == null || logdata[0].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine E-Mail-Adresse angegeben</p>";
			logdata[0] = "";
		} else if (!logdata[0].matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine gültige E-Mail-Adresse angegeben. Gültige E-Mail-Adressen bestehen aus alphanumerischen Zeichen sowie _.+-, einem @-Zeichen und weiteren alphanumerischen Zeichen sowie -.</p>";
		}
		
		logdata[1] = request.getParameter("login_password");	
		
		if (logdata[1] != null && !logdata[1].equals("")) {
			// hash the password
			md.update(logdata[1].getBytes());
			pwhash = javax.xml.bind.DatatypeConverter.printHexBinary(md.digest());
		} else {
			logdata[1] = "";
			dataFault = true;
			messages = messages + "<p>Sie haben kein Passwort angegeben.</p>";
		}
		
		
		// Falls es bis hier keinen DataFault gab: Logindaten überprüfen
		if (!dataFault) {
			sql = "SELECT `uid`,`pwhash`,`firstname`,`lastname` FROM `sopraplaner_users` WHERE `email` = '"+logdata[0]+"'";
			
			dbs = dbcon.createStatement();
			try {
				dbrs = dbs.executeQuery(sql); 
				
				dbrs.next();
								
				if (pwhash.equals(dbrs.getString("pwhash"))) {
					
					// Bei richtigen Daten: Eintrag in den sessions-Daten vornehmen
					session.setAttribute("uid",dbrs.getString("uid"));
					session.setAttribute("mail",logdata[0]);
					session.setAttribute("firstname",dbrs.getString("firstname"));
					session.setAttribute("lastname",dbrs.getString("lastname"));
					
					dbrs.close();
					
				} else {
					throw new SQLException("Passwörter stimmen nicht überein.");
				} 	
			} catch (SQLException e) {	
				dataFault = true;
				messages = messages + "<p>Die Anmeldung war wegen falscher Benutzerdaten nicht erfolgreich.</p>";	
				//messages = messages + "<p>Die Datenbank akzeptiert Ihre Eingaben nicht: "+e.getMessage()+"</p>";
			}
		}
		
		// Falls es einen dataFault gab muss die Eingabemaske wieder gefüllt werden -> Befüllen von defLogVals
		if (dataFault) {
			for (int i = 0; i < 2; i++) {
				defLogVals[i] = logdata[i];
			}
		}
%>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	// 0: Mail
	// 1: Vorname
	// 2: Nachname
	// 3: Passwort
	// 4: Passwort wiederholen bzw. Passworthash
	// 5: Sicherheits-Frage
	// 6: Sicherheits-Antwort
	String[] regdata = new String[7];
	String pwhash;
</jsp:declaration>
<jsp:scriptlet>
	if (inContainer) { 
</jsp:scriptlet>
	<%	// Daten auf Konformität überprüfen und in regdata ablegen
		regdata[0] = request.getParameter("register_mail");
		
		if (regdata[0] == null || regdata[0].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine E-Mail-Adresse angegeben</p>";
			regdata[0] = "";
		} else if (!regdata[0].matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine gültige E-Mail-Adresse angegeben. Gültige E-Mail-Adressen bestehen aus alphanumerischen Zeichen sowie _.+-, einem @-Zeichen und weiteren alphanumerischen Zeichen sowie -.</p>";
		}
		
		regdata[1] = request.getParameter("register_firstname");
		
		if (regdata[1] == null || regdata[1].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keinen Vornamen angegeben</p>";
			regdata[1] = "";
		} else if (!regdata[1].matches("^[^!\"§$%&/()=\\\\{}°_.,;:]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Vorname darf keine Sonderzeichen außer dem Bindestrich beinhalten.</p>";
		}
		
		regdata[2] = request.getParameter("register_lastname");
		
		if (regdata[2] == null || regdata[2].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keinen Nachnamen angegeben</p>";
			regdata[2] = "";
		} else if (!regdata[2].matches("^[^!\"§$%&/()=\\\\{}°_.,;:]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Nachname darf keine Sonderzeichen außer dem Bindestrich beinhalten.</p>";
		}
		
		regdata[3] = request.getParameter("register_password");	
		regdata[4] = request.getParameter("register_password_repeat");
		
		if (regdata[3] != null && regdata[4] != null && !regdata[3].equals("") && regdata[3].equals(regdata[4])) {
			md.update(regdata[3].getBytes());
			pwhash = new String(md.digest());
		} else {
			if (regdata[3] == null) regdata[3] = "";
			if (regdata[4] == null) regdata[4] = "";
			dataFault = true;
			messages = messages + "<p>Sie haben kein Passwort angegeben oder die angegebenen Passwörter stimmen nicht überein.</p>";
		}
		
		regdata[5] = request.getParameter("register_sec_q");
		
		if (regdata[5] == null || regdata[5].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine Sicherheitsfrage gewählt.</p>";
			regdata[5] = "";
		} else if (!regdata[5].matches("^[^(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		}
		
		regdata[6] = request.getParameter("register_sec_a");
		
		if (regdata[6] == null || regdata[6].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine Antwort auf die Sicherheitsfrage gegeben.</p>";
			regdata[6] = "";
		} else if (!regdata[6].matches("^[^(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Antwort auf die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		} 

		// 

		// Falls es einen dataFault gab muss die Eingabemaske wieder gefüllt werden -> Befüllen von defRegVals
		if (dataFault) {
			for (int i = 0; i < 7; i++) {
				defRegVals[i] = regdata[i];
			}
		}
	%>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

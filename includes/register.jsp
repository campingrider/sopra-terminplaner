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
		} else if (!regdata[1].matches("^[^!\"'§$%&/()=\\\\{}°_.,;:]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Vorname darf keine Sonderzeichen außer dem Bindestrich beinhalten.</p>";
		}
		
		regdata[2] = request.getParameter("register_lastname");
		
		if (regdata[2] == null || regdata[2].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keinen Nachnamen angegeben</p>";
			regdata[2] = "";
		} else if (!regdata[2].matches("^[^!\"'§$%&/()=\\\\{}°_.,;:]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Nachname darf keine Sonderzeichen außer dem Bindestrich beinhalten.</p>";
		}
		
		regdata[3] = request.getParameter("register_password");	
		regdata[4] = request.getParameter("register_password_repeat");
		
		if (regdata[3] != null && regdata[4] != null && !regdata[3].equals("") && regdata[3].equals(regdata[4])) {
			// hash the password
			md.update(regdata[3].getBytes());
			pwhash = javax.xml.bind.DatatypeConverter.printHexBinary(md.digest());
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
		} else if (!regdata[5].matches("^[^'(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		}
		
		regdata[6] = request.getParameter("register_sec_a");
		
		if (regdata[6] == null || regdata[6].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine Antwort auf die Sicherheitsfrage gegeben.</p>";
			regdata[6] = "";
		} else if (!regdata[6].matches("^[^'(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Antwort auf die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		} 

		// Falls es bis hier keinen DataFault gab: Versuchen, Werte einzufügen.
		if (!dataFault) {
			sql = "INSERT INTO `sopraplaner_users` (`uid`, `email`, `firstname`, `lastname`, `sec_q`, `sec_a`, `pwhash`) VALUES (NULL, '"+regdata[0]+"', '"+regdata[1]+"', '"+regdata[2]+"', '"+regdata[5]+"', '"+regdata[6]+"', '"+pwhash+"');";
			
			dbs = dbcon.createStatement();
			try {
				dbs.executeUpdate(sql); 
				
				messages = messages + "<p>Die Registrierung war erfolgreich. Ihr Benutzerkonto muss noch aktiviert werden. Betätigen Sie dazu den Link in der E-Mail, die wir Ihnen soeben zugesandt haben.</p>";
			
				// E-Mail mit Bestätigungslink senden
				key = "";
				href = home+"?status=mailconfirm&mail="+regdata[0]+"&key="+key;
				
			   try{
				  mail = new MimeMessage(mailSession);
				  mail.setFrom(new InternetAddress(mailAddress));
				  mail.addRecipient(Message.RecipientType.TO,
										   new InternetAddress(regdata[0]));
				  mail.setSubject("Aktivierung des Wochenplaner-Benutzerkontos");
				 
				  mail.setContent("<h1>Aktivierung des Wochenplaner-Benutzerkontos</h1><p>Auf Ihre E-Mail-Adresse wurde ein Wochenplan-Benutzerkonto angelegt. Sie können die Echtheit der E-Mail-Adresse über folgenden Link bestätigen:</p><p><a href=\""+href+"\">"+href+"</a></p><p>Sollten Sie die Registrierung nicht persönlich vorgenommen haben, so ignorieren Sie bitte diese Benachrichtigung.</p><p>Mit freundlichen Grüßen,<br><br>Ihr Wochenplaner-Serviceteam</p>",
										"text/html" );
				  
				  Transport.send(mail);
			   }catch (MessagingException mex) {
				   dataFault = true;
				  mex.printStackTrace();
				  messages = messages + "Error: unable to send E-Mail....";
			   }
			
			
			} catch (SQLException e) {
				dataFault = true;
				messages = messages + "<p>Die Registrierung ist fehlgeschlagen.</p>";
				if (e.getMessage().matches("Duplicate entry '"+regdata[0]+"' for key 'email'")) {
					messages = messages + "<p>Mit dieser E-Mail-Adresse ist schon ein Nutzer registriert.</p>";
				} else {
					messages = messages + "<p>Die Datenbank akzeptiert Ihre Eingaben nicht: "+e.getMessage()+"</p>";
				}	
			}
		}

		// Falls es einen dataFault gab muss die Eingabemaske wieder gefüllt werden -> Befüllen von defRegVals
		if (dataFault) {
			for (int i = 0; i < 7; i++) {
				defRegVals[i] = regdata[i];
			}
		}
	%>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

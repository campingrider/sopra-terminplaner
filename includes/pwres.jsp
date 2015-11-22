<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	// 0: Mail
	// 1: Sicherheits-Frage
	// 2: Sicherheits-Antwort
	String[] pwresdata = new String[3];
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
	<%
		pwresdata[0] = request.getParameter("pwres_mail");
		
		if (pwresdata[0] == null || pwresdata[0].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine E-Mail-Adresse angegeben</p>";
			regdata[0] = "";
		} else if (!pwresdata[0].matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine gültige E-Mail-Adresse angegeben. Gültige E-Mail-Adressen bestehen aus alphanumerischen Zeichen sowie _.+-, einem @-Zeichen und weiteren alphanumerischen Zeichen sowie -.</p>";
		}
		
		pwresdata[1] = request.getParameter("pwres_sec_q");
		
		if (pwresdata[1] == null || pwresdata[1].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine Sicherheitsfrage gewählt.</p>";
			pwresdata[1] = "";
		} else if (!pwresdata[1].matches("^[^'(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		}
		
		pwresdata[2] = request.getParameter("pwres_sec_a");
		
		if (pwresdata[2] == null || pwresdata[2].equals("")) {
			dataFault = true;
			messages = messages + "<p>Sie haben keine Antwort auf die Sicherheitsfrage gegeben.</p>";
			pwresdata[2] = "";
		} else if (!pwresdata[2].matches("^[^'(),.]+$")) {
			dataFault = true;
			messages = messages + "<p>Die Antwort auf die Sicherheitsfrage darf keine Klammern, Kommata oder Punkte enthalten.</p>";
		} 
		
		// Falls es bis hier keinen DataFault gab: Werte abgleichen
		if (!dataFault) {
			sql = "SELECT `sec_a`,`sec_q`,`activated` FROM `sopraplaner_users` WHERE `email`='"+pwresdata[0]+"';";
			
			dbs = dbcon.createStatement();
			try {
				dbrs = dbs.executeQuery(sql); 
				
				dbrs.next();
				
				if (dbrs.getBoolean("activated")) {
					if (dbrs.getString("sec_a").equals(pwresdata[2]) && dbrs.getString("sec_q").equals(pwresdata[1])) {
					
						messages = messages + "<p>Es wird Ihnen ein neues Passwort per E-Mail zugeschickt.</p>";
					
						// E-Mail mit neuem Passwort senden
						key = UUID.randomUUID().toString().substring(0,12);
						
					   try{
						  mail = new MimeMessage(mailSession);
						  mail.setFrom(new InternetAddress(mailAddress));
						  mail.addRecipient(Message.RecipientType.TO,
												   new InternetAddress(pwresdata[0]));
						  mail.setSubject("Wochenplaner-Benutzerkonto: Passwort zurückgesetzt");
						 
						  mail.setContent("<h1>Wochenplaner-Benutzerkonto: Passwort zurückgesetzt</h1><p>Sie haben die Zurücksetzung Ihres Passworts angefordert. Ihr neues Passwort lautet:</p><p><strong>"+key+"</strong></p><p>Bedenken Sie, dass Ihr bisheriges Passwort nun zungunsten des neu zugewiesenen Passworts ungültig ist.</p><p>Mit freundlichen Grüßen,<br><br>Ihr Wochenplaner-Serviceteam</p>",
												"text/html" );
						  
						  Transport.send(mail);
						  
						  //Falls keine Exception auftrat: neues Passwort hashen und eintragen.
						  md.update(key.getBytes());
						  pwhash = javax.xml.bind.DatatypeConverter.printHexBinary(md.digest());
						  
						  sql = "UPDATE `sopraplaner_users` SET `pwhash`='"+pwhash+"' WHERE  `email`='"+pwresdata[0]+"';";
						  messages = messages + "<pre>"+sql+"</pre>";
						  dbs.executeUpdate(sql);
					   }catch (MessagingException mex) {
						   dataFault = true;
						  mex.printStackTrace();
						  messages = messages + "Error: unable to send E-Mail.... The password was not changed.";
					   }
					} else {
						dataFault = true;
						if (!dbrs.getString("sec_a").equals(pwresdata[2])) {
							messages = messages + "<p>Die Antwort auf die Sicherheitsfrage ist nicht korrekt.</p>";
						} else {
							messages = messages + "<p>Die Sicherheitsfrage ist nicht korrekt.</p>";
						}
					}
				} else {
					dataFault = true;
					messages = messages + "<p>Solange ein Benutzerkonto nicht aktiviert wurde, können auch keine Passwörter zurückgesetzt werden!</p>";
				}
			
			} catch (SQLException e) {
				dataFault = true;
				messages = messages + "<p>Das Zurücksetzen des Passworts ist fehlgeschlagen.</p>";
				messages = messages + "<p>Die Datenbank akzeptiert Ihre Eingaben nicht: "+e.getMessage()+"</p>";	
			}
		}
		
		// Falls es einen dataFault gab muss die Eingabemaske wieder gefüllt werden -> Befüllen von defPWRVals
		if (dataFault) {
			for (i = 0; i < 3; i++) {
				defPWRVals[i] = pwresdata[i];
			}
		}
	%>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

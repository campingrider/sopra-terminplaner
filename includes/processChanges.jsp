<jsp:directive.page pageEncoding="UTF-8"/>
<%

	// Veranstaltung bearbeiten
	if (request.getParameter("event_title") != null) {
		
		if (!request.getParameter("event_title").matches("^[^\"'\\\\]+$")) {
			dataFault = true;
			messages = messages + "<p>Der Titel der Veranstaltung darf keine Anführungszeichen, Akzentzeichen oder Backslashes beinhalten.</p>";
		}
		
		if (request.getParameter("event_title") == "") {
			dataFault = true;
			messages = messages + "<p>Der Titel der Veranstaltung darf nicht leer sein</p>";
		}
		
		if (!dataFault && request.getParameter("event_description") != null) {
			
			// Beschreibung gesetzt -> Veranstaltung neu anlegen oder Beschreibung verändern
			
			if (!request.getParameter("event_description").matches("^[^\"'\\\\]+$")) {
				dataFault = true;
				messages = messages + "<p>Die Beschreibung der Veranstaltung darf keine Anführungszeichen, Akzentzeichen oder Backslashes beinhalten.</p>";
			}
		
			if (!dataFault) {
				sql = "SELECT `eid` FROM `sopraplaner_events` WHERE `title`='"+request.getParameter("event_title")+"' AND `uid`='"+session.getAttribute("uid")+"';";
			
				dbs = dbcon.createStatement();
				try {
					dbrs = dbs.executeQuery(sql); 
					
					if (dbrs.next()) {
						// entsprechende eid existiert -> Änderung
						sql = "UPDATE `sopraplaner_events` SET `description`='"+request.getParameter("event_description")+"' WHERE  `eid`='"+dbrs.getString("eid")+"';";
						
											
					} else {
						// entsprechende eid existiert nicht -> neu anlegen
						sql = "INSERT INTO `sopraplaner_events` (`uid`, `title`, `description`) VALUES ('"+session.getAttribute("uid")+"', '"+request.getParameter("event_title")+"', '"+request.getParameter("event_description")+"');";
							
					}
					
					dbs.executeUpdate(sql); 
				
				} catch (SQLException e) {
					dataFault = true;
					messages = messages + "<p>Die Datenbank hat die gewünschte Operation zurückgewiesen</p>";
				}
			}
		}
		
		if (!dataFault && request.getParameter("event_day") != null && request.getParameter("event_time") != null) {
		
			try {
				
				int tday = Integer.parseInt(request.getParameter("event_day"));
				int ttime = Integer.parseInt(request.getParameter("event_time"));
				
				if (tday < 1 || tday > 7 || ttime < 7 || ttime > 21) throw new NumberFormatException("Tag oder Uhrzeit sind außerhalb der zulässigen Grenzen.");
			
				int daytime = tday * 100 + ttime;
				
				// Suche nach Überschneidungen
				sql = "SELECT `sopraplaner_dates`.`eid` FROM `sopraplaner_dates` INNER JOIN `sopraplaner_events` ON `sopraplaner_dates`.`eid`=`sopraplaner_events`.`eid` WHERE `uid`='"+session.getAttribute("uid")+"' AND `daytime`='"+daytime+"';";
			
				dbs = dbcon.createStatement();
				try {
					dbrs = dbs.executeQuery(sql); 
					
					if (dbrs.next()) {
						// entsprechende eid existiert -> Kann Termin nicht eintragen
						messages = messages + "<p>Fehler: Zu dieser Zeit existiert schon ein Termin!</p>";
											
					} else {
						// entsprechende eid existiert nicht -> Termin anlegen
						sql = "SELECT `eid` FROM `sopraplaner_events` WHERE `title`='"+request.getParameter("event_title")+"' AND `uid`='"+session.getAttribute("uid")+"';";
						
						dbrs = dbs.executeQuery(sql);
						
						if (!dbrs.next()) {
							throw new SQLException("Die Veranstaltung existiert nicht");
						} else {
						
							sql = "INSERT INTO `sopraplaner_dates` (`eid`, `daytime`) VALUES ('"+dbrs.getInt("eid")+"', '"+daytime+"');";
							
							dbs.executeUpdate(sql);
						}
							
					}
				
				} catch (SQLException e) {
					dataFault = true;
					messages = messages + "<p>Die Datenbank hat die gewünschte Operation zurückgewiesen</p>";
				}
			
			} catch (NumberFormatException e) {
				dataFault = true;
				messages = messages + "<p>Es wurden ungültige Zeitdaten übertragen.</p>";
			}
		
		} else {	
			messages = messages + "<p>Irgendwas war null</p>";
			if (request.getParameter("event_day") == null) { messages = messages + "<p>Tag</p>"; }
			if (request.getParameter("event_time") == null) { messages = messages + "<p>Stunde</p>"; }
		}
	} 
%>

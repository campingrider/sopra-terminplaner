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
			
			if (!request.getParameter("event_description").matches("^[^\"'\\\\]*$")) {
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
		
		// Termine anlegen
		
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
		
		}
				
	} 
	
	// Termine löschen - unabhängig von der Angabe einer Veranstaltung
	if (!dataFault && request.getParameter("delete_day") != null && request.getParameter("delete_time") != null) {
	
		try {
			
			int tday = Integer.parseInt(request.getParameter("delete_day"));
			int ttime = Integer.parseInt(request.getParameter("delete_time"));
			
			if (tday < 1 || tday > 7 || ttime < 7 || ttime > 21) throw new NumberFormatException("Tag oder Uhrzeit sind außerhalb der zulässigen Grenzen.");
		
			int daytime = tday * 100 + ttime;
			
			// Suche nach diesem Termin
			sql = "SELECT `sopraplaner_dates`.`eid` FROM `sopraplaner_dates` INNER JOIN `sopraplaner_events` ON `sopraplaner_dates`.`eid`=`sopraplaner_events`.`eid` WHERE `uid`='"+session.getAttribute("uid")+"' AND `daytime`='"+daytime+"';";
		
			dbs = dbcon.createStatement();
			try {
				dbrs = dbs.executeQuery(sql); 
				
				if (!dbrs.next()) {
					// entsprechende eid existiert nicht -> Kann Termin nicht löschen
					messages = messages + "<p>Fehler: Zu dieser Zeit gibt es keinen Termin, der gelöscht werden kann!</p>";
										
				} else {
					// entsprechende eid existiert -> Termin löschen
					int eid = dbrs.getInt("eid");
					
					sql = "DELETE FROM `sopraplaner_dates` WHERE `eid`='"+eid+"' AND `daytime`='"+daytime+"';";
					
					dbs.executeUpdate(sql);
					
					// Überprüfen, ob die Veranstaltung nun keine Termine mehr besitzt und wenn ja -> löschen
					sql = "SELECT `daytime` FROM `sopraplaner_dates` WHERE `eid`='"+eid+"';";
					
					dbrs = dbs.executeQuery(sql);
					
					if (!dbrs.next()) {
						// keine weiteren Termine mehr -> Veranstaltung löschen
						sql = "DELETE FROM `sopraplaner_events` WHERE `eid`='"+eid+"';";
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
	
	}
%>

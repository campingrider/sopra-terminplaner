<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	int stunde;
	int tag;
	String[] wochentag = {"","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"};
</jsp:declaration>

<%-- Kalenderdaten aus Datenbank laden --%>
<%@ include file="loadEvents.jsp" %>

<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
<div>
	<p>Herzlich Willkommen, <strong><%= session.getAttribute("firstname") %>&nbsp;<%= session.getAttribute("lastname") %></strong>. Wählen Sie einen Zeitslot zum Hinzufügen neuer Termine oder zum Bearbeiten bestehender Termine.</p>
	<table id="weekly">
		<tbody>
			<tr>
			<% for (tag = 0; tag <= 7; tag++) { %>	
				<th><%= wochentag[tag] %></th>
			<% } %>
			</tr>
			<% for (stunde = 7; stunde <= 21; stunde++) { %>
				<tr>
					<td class="hour"><%= stunde %>:00</td>
					<% for (tag = 1; tag <= 7; tag++) { %>	
						<td id="<%=tag%>-<%=stunde%>" x-tag="<%= tag %>" x-stunde="<%=stunde%>" 
						<% if(dates.containsKey(Integer.valueOf((tag*100+stunde)))) { 
								
								//create Color from Title
								i = dates.get(Integer.valueOf((tag*100+stunde))).hashCode();
								String titleColor = Integer.toHexString(((i>>16)&0xFF))+Integer.toHexString(((i>>8)&0xFF))+Integer.toHexString((i&0xFF));
						%>
							x-titel="<%=dates.get(Integer.valueOf((tag*100+stunde)))%>" x-beschreibung="<%=descriptions.get(dates.get(Integer.valueOf((tag*100+stunde))))%>" class="slot date" title="<%= descriptions.get(dates.get(Integer.valueOf((tag*100+stunde)))) %>" style="background-color:#<%=titleColor%>"><%=dates.get(Integer.valueOf((tag*100+stunde)))%></td>
						<% } else { %>
							class="slot"></td>
						<% } %>
					<% } %>
				</tr>
			<% } %>
		</tbody>
	</table>
</div>
<dialog id="clickEmpty" class="modal">
	<p style="float:right"><button type="button" onclick="closeDialogs()">Ohne Änderung schließen</button></p>
	<h1>Einen Termin eintragen</h1>
	<p>Sie möchten einen Termin eintragen am<br>
	<strong class="thisDay">Wochentag</strong> um <strong class="thisTime">XX</strong> Uhr.</p>	
	<p>Sie haben die Wahl zwischen folgenden Möglichkeiten:
	<div class="boxcontainer">
		<form class="formbox" action="?status=update" method="POST">
			<h2>Den Termin zu einer bestehenden Veranstaltung hinzufügen</h2>
			<p><input type="hidden" class="thisDay" name="event_day"><input type="hidden" class="thisTime" name="event_time"></p>
			<p class="boxlabel">Wählen Sie die Veranstaltung aus, zu der der Termin hinzugefügt werden soll.</p>
			<p>
				<label for="empty_event_title_continuance">Titel der Veranstaltung</label><br>
				<select size="1" id="empty_event_title_continuance" name="event_title">
				<%
				
					for (i = 0; i < titles.size(); i++) {
				%>
					<option><%=titles.get(i)%></option>
				<%
					}
				%>
				</select>
				<p class="formbuttons"><button type="submit">Neuen Termin eintragen</button></p>
			</p>
		</form>
		<form class="formbox" action="?status=update" method="POST">
			<h2>Eine neue Veranstaltung eintragen</h2>
			<p><input type="hidden" class="thisDay" name="event_day"><input type="hidden" class="thisTime" name="event_time"></p>
			<p class="boxlabel">Vergeben Sie einen neuen eindeutigen Titel. Sollte schon eine Veranstaltung mit diesem Titel bestehen, so wird der Termin stattdessen dieser Veranstaltung hinzugefügt und die Beschreibung der Veranstaltung mit der angegebenen Beschreibung überschrieben.</p>
			<p>
				<label for="empty_event_title_new">Titel der Veranstaltung</label><br><input name="event_title" id="empty_event_title_new" type="text">
				<label for="empty_event_description">Beschreibung</label><br><input name="event_description" id="empty_event_description" type="text">
			</p>
			<p class="formbuttons"><button type="submit">Neue Veranstaltung eintragen</button></p>
		</form>
	</div>
</dialog>
<dialog id="clickFull" class="modal">
	<p style="float:right"><button type="button" onclick="closeDialogs()">Ohne Änderung schließen</button></p>
	<h1>Einen bestehenden Termin bearbeiten</h1>
	<p>Sie möchten den Termin am<br>
	<strong class="thisDay">Wochentag</strong> um <strong class="thisTime">XX</strong> Uhr bearbeiten.</p>
	<p>Der Termin gehört zur Veranstaltung <strong class="thisTitle">Titel</strong> und deren Beschreibung lautet &ldquo;<strong class="thisDescription">Beschreibung</strong>&rdquo;.
	<p>Sie haben die Wahl zwischen folgenden Möglichkeiten:</p>
	<div class="boxcontainer">
		<form class="formbox" action="?status=update" method="POST">
			<h2>Die Beschreibung der Veranstaltung anpassen</h2>
			<p class="boxlabel">Vergeben Sie hier eine neue Beschreibung für die Veranstaltung. Bedenken Sie, dass diese Änderung alle Einzeltermine der Veranstaltung betrifft.</p>
			<p>
				<label for="full_event_title">Titel der Veranstaltung</label><br><input name="event_title" id="full_event_title" type="text" class="thisTitle" readonly value="Titel">
				<label for="full_event_description">Beschreibung</label><br><input name="event_description" id="full_event_description" type="text" class="thisDescription" value="Beschreibung">
			</p>
			<p class="formbuttons"><button type="submit">Beschreibung ändern</button></p>
		</form>
		<form class="formbox" action="?status=update" method="POST">
			<h2>Den Termin löschen</h2>
			<p class="boxlabel">Mit Klick auf diesen Button löschen Sie den Termin. Bedenken Sie, dass beim Löschen des letzten Termins einer Veranstaltung auch die Veranstaltung selbst gelöscht wird.</p>
			<p>
				<input type="hidden" name="delete_day" class="thisDay">
				<input type="hidden" name="delete_time" class="thisTime">
			</p>
			<p class="formbuttons"><button type="submit">Termin löschen</button></p>
		</form>
		<form class="formbox" action="?status=update" method="POST">
			<h2>Den Termin verschieben</h2>
			<p class="boxlabel">Geben Sie hier an, auf welchen freien Zeitslot Sie diesen Termin verschieben wollen.</p>
			<p>
				<input type="hidden" name="delete_day" class="thisDay">
				<input type="hidden" name="delete_time" class="thisTime">
				<input type="hidden" name="event_title" class="thisTitle">
			</p>
			<p>
				<label for="full_event_day">Wochentag</label>
				<select id="full_event_day" size="1" name="event_day">
					<%
						for (i = 1; i <= 7; i++) {
					%>
						<option value="<%=i%>"><%=wochentag[i]%></option>
					<%
						}
					%>
				</select>
				<br>
				<label for="full_event_time">Uhrzeit</label>
				<select id="full_event_time" size="1" name="event_time">
					<%
						for (i = 7; i <= 21; i++) {
							String xav = "+";
							for (int j = 1; j <= 7; j++) {
								if (!dates.containsKey(Integer.valueOf((j*100+i)))) {
									xav = xav + "1";
								} else {
									xav = xav + "0";
								}
							}
					%>
						<option value="<%=i%>" x-available="<%=xav%>"><%=i%>:00 Uhr</option>
					<%
						}
					%>
				</select>
			</p>
			<p class="formbuttons"><button type="submit">Termin verschieben</button></p>
		</form>
	</div>
</dialog>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

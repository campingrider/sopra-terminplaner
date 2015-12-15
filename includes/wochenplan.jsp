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
						<% if(dates.containsKey(Integer.valueOf((tag*100+stunde)))) { %>
							class="slot date"><%=dates.get(Integer.valueOf((tag*100+stunde)))%></td>
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
		<form class="formbox">
			<h2>Den Termin zu einer bestehenden Veranstaltung hinzufügen</h2>
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
	<h1>Einen bestehenden Termin bearbeiten</h1>

</dialog>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

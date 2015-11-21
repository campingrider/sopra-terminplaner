<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	int maxhr = 21;
	int minhr = 7;
	int stunde;
	int tag;
	String[] wochentag = {"","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"};
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
<div>
	<p>Wählen Sie einen Zeitslot zum Hinzufügen neuer Termine oder zum Bearbeiten bestehender Termine.</p>
	<table id="weekly">
		<tbody>
			<% for (stunde = minhr-1; stunde <= maxhr; stunde++) { %>
				<tr>	
					<% if (stunde < minhr) { %>
					
						<% for (tag = 0; tag <= 7; tag++) { %>	
							<th><%= wochentag[tag] %></th>
						<% } %>
					<% } else { %>
						<td class="hour"><%= stunde %>:00</td>
						<% for (tag = 1; tag <= 7; tag++) { %>	
							<td></td>
						<% } %>
					<% } %>
				</tr>
			<% } %>
		</tbody>
	</table>
</div>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

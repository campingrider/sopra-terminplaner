<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	int maxhr = 21;
	int minhr = 7;
	int stunde;
	int tag;
	String[] wochentag = {"","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"};
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
	<table>
		<tbody>
			<% for (stunde = minhr-1; stunde <= maxhr; stunde++) { %>
				<% if (stunde < minhr) { %>
					<th>	
						<td>blabla</td>
					</th>
				<% } %>
			<% } %>
		</tbody>
	</table>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

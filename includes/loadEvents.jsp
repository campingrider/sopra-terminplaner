<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	HashMap descriptions;
	HashMap dates;
</jsp:declaration>
<%

	descriptions = new HashMap<String,String>();
	dates = new HashMap<Integer,String>();
	
	sql = "SELECT `title`,`description`,`daytime` FROM `sopraplaner_dates` INNER JOIN `sopraplaner_events` ON `sopraplaner_dates`.`eid`=`sopraplaner_events`.`eid` WHERE `uid`='"+session.getAttribute("uid")+"';";
	
	dbs = dbcon.createStatement();
	try {
		dbrs = dbs.executeQuery(sql); 
				
		while (dbrs.next()) {			
			dates.put(Integer.valueOf(dbrs.getInt("daytime")),dbrs.getString("title"));
			descriptions.put(dbrs.getString("title"),dbrs.getString("description"));
			%>
			<script type="text/javascript">
				console.log('<%=dbrs.getString("daytime")%>');
			</script>
			<%
		} 
	
	} catch (SQLException e) {
		%>
		<script type="text/javascript">
			window.alert("Die Datenbank hatte Schwierigkeiten, Termine zu finden.");
			console.log("<%=e.getMessage()%>");
		</script>
		<%
	}

%>

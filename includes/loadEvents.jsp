<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	HashMap descriptions;
	HashMap dates;
	ArrayList titles;
</jsp:declaration>
<%

	descriptions = new HashMap<String,String>();
	dates = new HashMap<Integer,String>();
	titles = new ArrayList<String>();
	
	sql = "SELECT `title`,`description`,`daytime` FROM `sopraplaner_dates` INNER JOIN `sopraplaner_events` ON `sopraplaner_dates`.`eid`=`sopraplaner_events`.`eid` WHERE `uid`='"+session.getAttribute("uid")+"';";
	
	dbs = dbcon.createStatement();
	try {
		dbrs = dbs.executeQuery(sql); 
				
		while (dbrs.next()) {			
			dates.put(Integer.valueOf(dbrs.getInt("daytime")),dbrs.getString("title"));
			
			if (!descriptions.containsKey(dbrs.getString("title"))) {
				titles.add(dbrs.getString("title"));
				descriptions.put(dbrs.getString("title"),dbrs.getString("description"));
			}
			
		} 
	
	} catch (SQLException e) {
		%>
		<script type="text/javascript">
			window.alert("Die Datenbank hatte Schwierigkeiten, Termine zu finden.");
		</script>
		<%
	}

%>

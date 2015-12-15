<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*,java.io.*,java.math.*" %>
<%@ include file="init_db.jsp" %>
<%@ include file="init_generics.jsp" %>
<%	
	String output = "";
	
	if(request.isSecure()) {
	
		String mail = request.getParameter("mail");
		
		if (mail == null || mail.equals("")) {
			dataFault = true;
		} else if (!mail.matches("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
			dataFault = true;
		}			
	
		if (!dataFault) {
			sql = "SELECT `sec_q` FROM `sopraplaner_users` WHERE `email` = '"+mail+"'";
			
			dbs = dbcon.createStatement();
			try {
				dbrs = dbs.executeQuery(sql); 
				
				dbrs.next();
								
				out.print(dbrs.getString("sec_q"));
					
				dbrs.close();
					 	
			} catch (SQLException e) {	
				dataFault = true;
			}
		}
		
		if (dataFault) {
			output = "Zunächst gültige E-Mail angeben";
		}
	} else { 
		output="ERROR! Insecure Connection!";
	} 
	
	out.print(output);
%>

<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
<%
	session.removeAttribute("uid");
	session.removeAttribute("mail");
	session.removeAttribute("firstname");
	session.removeAttribute("lastname");
%>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

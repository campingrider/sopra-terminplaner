<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:declaration>
	String[] secQOptions;
</jsp:declaration>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
	<%
		secQOptions = new String[4];
		secQOptions[0] = "Geburtsname Ihrer Mutter";
		secQOptions[1] = "Name Ihres ersten Haustiers";
		secQOptions[2] = "Ihr Lieblings-Urlaubsziel";
		secQOptions[3] = "Ihr Lieblings-Musiker";
	%>
	<div>
		<form id="loginbox" class="formbox" action="?status=login" method="post">
			<h2>Anmelden</h2>
			<p class="boxlabel">Haben Sie schon ein Benutzerkonto bei uns? Dann geben Sie hier Ihre Logindaten ein.</p>
			<p>
				<label for="login_mail">E-Mail-Adresse</label><br><input name="login_mail" id="login_mail" type="text" value="<%= defLogVals[0] %>">
			</p>
			<p>
				<label for="login_password">Passwort</label><br><input name="login_password" id="login_password" type="password" value="<%= defLogVals[1] %>">
			</p>
			<p class="formbuttons"><button>Anmelden.</button></p>
		</form>
		<form id="pwresbox" class="formbox" action="?status=pwres" method="post">
			<h2>Passwort zurücksetzen</h2>
			<p class="boxlabel">Haben Sie ihr Passwort vergessen? Dann können Sie sich hier ein Neues zusenden lassen.</p>
			<p>
				<label for="pwres_mail">E-Mail-Adresse</label><br><input name="pwres_mail" id="pwres_mail" type="text">
			</p>
			<p>
				<label for="pwres_sec_a">Sicherheitsfrage</label>
				<br>
				<input name="pwres_sec_q" id="pwres_sec_q" type="text" readonly value="Zunächst E-Mail angeben">
				<input name="pwres_sec_a" id="pwres_sec_a" type="text">
			</p>
			<p class="formbuttons"><button>Passwort zurücksetzen.</button></p>
		</form>
	</div>
	<form id="registerbox" class="formbox" action="?status=register" method="post">
		<h2>Registrieren</h2>
		<p class="boxlabel">Geben Sie hier ihre Daten an, falls Sie unseren Service zum ersten Mal benutzen möchten.</p>
		<p>
			<label for="register_mail">E-Mail-Adresse</label><br><input name="register_mail" id="register_mail" type="text" value="<%= defRegVals[0] %>">
		</p>
		<p>
			<label for="register_firstname">Vorname</label><br><input name="register_firstname" id="register_lastname" type="text" value="<%= defRegVals[1] %>">
			<label for="register_lastname">Nachname</label><br><input name="register_lastname" id="register_lastname" type="text" value="<%= defRegVals[2] %>">
		</p>
		<p>
			<label for="register_password">Passwort</label><br><input name="register_password" id="register_password" type="password" value="<%= defRegVals[3] %>">
			<label for="register_password_repeat">Passwort wiederholen</label><br><input name="register_password_repeat" id="register_password_repeat" type="password" value="<%= defRegVals[4] %>">
		</p>
		<p>
			<label for="register_sec_q">Sicherheitsfrage</label><br>
			<select name="register_sec_q" id="register_sec_q" size="1">
				<%
					for (i = 0; i < secQOptions.length; i++) {
				%>
						<option <%= secQOptions[i].equals(defRegVals[5])?"selected ":"" %>><%= secQOptions[i] %></option>
				<%
					}
				%>
			</select>
			<br><input name="register_sec_a" id="register_sec_a" type="text" value="<%= defRegVals[6] %>">
		</p>
		<p class="formbuttons"><button>Registrieren.</button></p>
	</form>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

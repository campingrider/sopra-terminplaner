<jsp:directive.page pageEncoding="UTF-8"/>
<jsp:scriptlet>if (inContainer) {</jsp:scriptlet>
	<div>
		<form id="loginbox" class="formbox">
			<h2>Anmelden</h2>
			<p class="boxlabel">Haben Sie schon ein Benutzerkonto bei uns? Dann geben Sie hier Ihre Logindaten ein.</p>
			<input type="hidden" name="status" value="login">
			<p>
				<label for="login_mail">E-Mail-Adresse</label><br><input name="login_mail" id="login_mail" type="text">
			</p>
			<p>
				<label for="login_password">Passwort</label><br><input name="login_password" id="login_password" type="password">
			</p>
			<p class="formbuttons"><button>Anmelden.</button></p>
		</form>
		<form id="pwresbox" class="formbox">
			<h2>Passwort zurücksetzen</h2>
			<input type="hidden" name="status" value="pwres">
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
	<form id="registerbox" class="formbox">
		<h2>Registrieren</h2>
		<input type="hidden" name="status" value="register">
		<p class="boxlabel">Geben Sie hier ihre Daten an, falls Sie unseren Service zum ersten Mal benutzen möchten.</p>
		<p>
			<label for="login_mail">E-Mail-Adresse</label><br><input name="register_mail" id="register_mail" type="text">
		</p>
		<p>
			<label for="register_firstname">Vorname</label><br><input name="register_firstname" id="register_lastname" type="text">
			<label for="register_lastname">Nachname</label><br><input name="register_lastname" id="register_lastname" type="text">
		</p>
		<p>
			<label for="register_password">Passwort</label><br><input name="register_password" id="register_password" type="password">
			<label for="register_password_repeat">Passwort wiederholen</label><br><input name="register_password" id="register_password" type="password">
		</p>
		<p>
			<label for="register_sec_q">Sicherheitsfrage</label><br>
			<select name="register_sec_q" id="register_sec_q" size="1">
				<option value="mother_birthname">Geburtsname Ihrer Mutter</option>
				<option value="first_pet_name">Name Ihres ersten Haustiers</option>
				<option value="holiday_goal">Ihr Lieblings-Urlaubsziel</option>
				<option value="musician">Ihr Lieblings-Musiker</option>
			</select>
			<br><input name="register_sec_a" id="register_sec_a" type="text">
		</p>
		<p class="formbuttons"><button>Registrieren.</button></p>
	</form>
<jsp:scriptlet>} else { out.println("Direct Call is Prohibited!"); }</jsp:scriptlet>

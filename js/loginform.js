window.addEventListener("load",function() {
	
	// neuen Ajax-Handler aus der Toolbox bereitstellen
	window.secxhr = new Toolbox.jz_xhr();

	// Trigger für Ajax-Antwort einrichten, sodass....
	window.secxhr.xmlHttp_response_function_standard = function () {
		if (this.xmlHttp.responseText && this.xmlHttp.responseText !== '' && this.xmlHttp.responseText != ' ') {
			// ...die vom Server erhaltene Sicherheitsfrage nach Erhalt vom Server eingetragen wird
			document.getElementById("pwres_sec_q").value = this.xmlHttp.responseText;
		}
	}
	
	// Bei jeder Eingabe einer E-Mail-Adresse soll ein Request bezüglich der Sicherheitsfrage gesendet werden
	document.getElementById("pwres_mail").addEventListener("change",function() {
			
			window.secxhr.send("fetch_secq.jsp","mail="+encodeURIComponent(document.getElementById("pwres_mail").value),"POST");
			
		});

});

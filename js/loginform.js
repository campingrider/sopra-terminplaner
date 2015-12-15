window.addEventListener("load",function() {
	
	window.secxhr = new Toolbox.jz_xhr();

	window.secxhr.xmlHttp_response_function_standard = function () {
		if (this.xmlHttp.responseText && this.xmlHttp.responseText !== '' && this.xmlHttp.responseText != ' ') {
			document.getElementById("pwres_sec_q").value = this.xmlHttp.responseText;
		}
	}
	
	document.getElementById("pwres_mail").addEventListener("change",function() {
			
			window.secxhr.send("fetch_secq.jsp","mail="+encodeURIComponent(document.getElementById("pwres_mail").value),"POST");
			
		});

});

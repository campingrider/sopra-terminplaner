// Dieses Skript soll Steuerungsfunktionen für die Wochenplaner-Ansicht übernehmen, ist also vor allem für Frontend-Funktionalitäten zuständig

var wochentag = ["","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"];

window.addEventListener("load",function () {

	var tds = document.getElementById("weekly").getElementsByTagName("td");
	
	// Stunden-Zellen mit click-Handlern versehen
	for (var i = 0; i < tds.length; i++) {
		if (!Toolbox.hasClassName(tds[i],"hour")) {
			tds[i].addEventListener("click",handleHourClick);
		}
	}
	
	/* Dialog schließen bei Klick außerhalb */
	document.addEventListener("click",function(e) {
		if (e.target.tagName != "TD") {
			var elm = e.target;
			var inDialog = false;
			while (elm.tagName != "BODY" && elm.parentNode) {
				if (elm.tagName == "DIALOG") {
					inDialog = true;
					break;
				} 
				elm = elm.parentNode;
			}
			
			if (!inDialog) {
				closeDialogs();
			}
		}
	});
	
	
	// Interaktivität der Zeitauswahl initialisieren und entsprechende Trigger setzen
	updateEventTime();
	document.getElementById("full_event_day").addEventListener("change",updateEventTime);

});

// Supervisor-Funktion: regelt die Anzeige des korrekten Dialogs bei Klick auf Stunden-Zelle
// Ausführung als Event-Handler mit entsprechendem Click-Event als Argument
function handleHourClick (e) {
	// Vorausfüllen der Eingabefelder mit den entsprechenden Daten der gewählten Zelle, basierend auf den statischen Informationen des Click-targets
	var tmp = document.querySelectorAll("input.thisDay");
	for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-tag"].nodeValue; }
	
	var tmp = document.querySelectorAll(".thisDay:not(input)");
	for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = wochentag[this.attributes["x-tag"].nodeValue]; }
	
	var tmp = document.querySelectorAll("input.thisTime");
	for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-stunde"].nodeValue; }
	
	var tmp = document.querySelectorAll(".thisTime:not(input)");
	for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = this.attributes["x-stunde"].nodeValue; }
	
	// Wenn Zelle bisher leer: Optionen für neuen Eintrag anzeigen / ...
	if (this.innerHTML == "") {
		closeDialogs();
		document.getElementById("clickEmpty").open = true;
	} else {
		// ...ansonsten: spezialisierte Eingabefelder auch vorausfüllen und Optionen für bestehenden Eintrag anzeigen
		var tmp = document.querySelectorAll("input.thisTitle");
		for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-titel"].nodeValue; }
	
		var tmp = document.querySelectorAll(".thisTitle:not(input)");
		for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = this.attributes["x-titel"].nodeValue; }
		
		var tmp = document.querySelectorAll("input.thisDescription");
		for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-beschreibung"].nodeValue; }
	
		var tmp = document.querySelectorAll(".thisDescription:not(input)");
		for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = this.attributes["x-beschreibung"].nodeValue; }
		
		closeDialogs();
		document.getElementById("clickFull").open = true;
	}
}

// Diese Funktion schließt alle geöffneten Dialogboxen
function closeDialogs() {
	document.getElementById("clickFull").open = false;
	document.getElementById("clickEmpty").open = false;
}

// Diese Funktion passt die Verfügbarkeit der Optionen im Stunden-Auswahldialog dynamisch an die Gegebenheiten an
function updateEventTime () {
	var elms = document.getElementById("full_event_time").getElementsByTagName("option");
	for (var i = 0; i < elms.length;i++) {
		elms[i].disabled = (elms[i].attributes["x-available"].nodeValue.charAt(document.getElementById("full_event_day").value) == 0);	
	}
}

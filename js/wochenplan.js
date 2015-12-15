var wochentag = ["","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"];

window.addEventListener("load",function () {

	var tds = document.getElementById("weekly").getElementsByTagName("td");
	
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
	
	updateEventTime();
	document.getElementById("full_event_day").addEventListener("change",updateEventTime);

});

function handleHourClick (e) {

	var tmp = document.querySelectorAll("input.thisDay");
	for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-tag"].nodeValue; }
	
	var tmp = document.querySelectorAll(".thisDay:not(input)");
	for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = wochentag[this.attributes["x-tag"].nodeValue]; }
	
	var tmp = document.querySelectorAll("input.thisTime");
	for (var i = 0; i < tmp.length; i++) { tmp[i].value = this.attributes["x-stunde"].nodeValue; }
	
	var tmp = document.querySelectorAll(".thisTime:not(input)");
	for (var i = 0; i < tmp.length; i++) { tmp[i].innerHTML = this.attributes["x-stunde"].nodeValue; }
	
	if (this.innerHTML == "") {
		closeDialogs();
		document.getElementById("clickEmpty").open = true;
	} else {
		
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

function closeDialogs() {
	document.getElementById("clickFull").open = false;
	document.getElementById("clickEmpty").open = false;
}

function updateEventTime () {
	var elms = document.getElementById("full_event_time").getElementsByTagName("option");
	for (var i = 0; i < elms.length;i++) {
		elms[i].disabled = (elms[i].attributes["x-available"].nodeValue.charAt(document.getElementById("full_event_day").value) == 0);	
	}
}

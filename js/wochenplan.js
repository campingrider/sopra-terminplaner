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
				} else {
					console.log(elm.tagName);
				}
				elm = elm.parentNode;
			}
			
			if (!inDialog) {
				closeDialogs();
			}
		}
	});

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
		
		document.getElementById("emptyDay").innerHTML = this.attributes["x-tag"].nodeValue;
		document.getElementById("emptyTime").innerHTML = this.attributes["x-stunde"].nodeValue;
	} else {
		closeDialogs();
		document.getElementById("clickFull").open = true;
	}
}

function closeDialogs() {
	document.getElementById("clickFull").open = false;
	document.getElementById("clickEmpty").open = false;
}

// (C) 2010, Janosch Zoller
// As part of JZCMS

// Commentary (c) 2016

// create global Toolbox object
var Toolbox = {
	// this function searches for Elements by className, optionally also filtered with tagName
	// ancient variant of modern querySelectorAll(tagName+"."+className)
	getElementsByClassName : function (className, tagName) {
		var elms = tagName ? window.document.getElementsByTagName(tagName) : window.document.getElementsByTagName('*');
		var ret = [];
		var classNames = [];
		for (var i = 0; i < elms.length; i++) {
			if (elms[i].className) {
				var check = true; 
				var suche = /\b(\w*)\b/;
				var classNames = elms[i].className.split(" ");
				for (var j = 0; j < classNames.length; j++) {
					if (classNames[j] == className && check) {
						ret[ret.length] = elms[i];
						check = false;
					}
				}
			}
		}
		return ret;
	},
	// retrieve all classNames as Strings from elms className-Property - ancient variant of modern class-list-functions
	getClassNames : function (elm) {
		if (elm) {
			if (elm.className) {
				var string = '';
				var classNames = [];
				classNames = elm.className.split(' ');
				if (classNames) {
					return classNames;
				} 
			} else { return false; }
		} else { return false; }
	},
	// checks whether elm has className cN in its className - ancient variant of modern class-list-functions
	hasClassName : function (elm,cN) {
		var cNs = Toolbox.getClassNames(elm);
		if (cNs.length > 0) {
			return Toolbox.isInArray(cNs,cN);
		} else {
			return false;
		}
	},
	// checks whether search is inside arr; 
	// index: boolean whether key of found entry should be returned instead of boolean - default: false
	// findAll: boolean whether an array with all found entities should be returned instead of first finding - default: false
	isInArray : function (arr,search,index,findAll) {
		if (arr && arr.length > 0 && search && typeof(search) == 'string') {
			var id, check = false, idAll = [];
			for ( var i = 0; i < arr.length; i++) {
				if ( arr[i] == search ) {
					check = true;
					id = i;
					idAll[idAll.length] = i;
				}
			}
			if (!check) {
				return false;
			}
			if (findAll && check && index) {
				return idAll;
			}
			if (!findAll && check && index) {
				return id;
			}
			if (check && !index) {
				return true;
			}
		} else {
			window.alert('Javascript -> Funktion: Toolbox.isInArray(): Fehler bei den übergebenen Argumenten.');
		}
	},
	// similar to isInArray, assuming that param index from isInArray is set to true, but uses obj to search for attribute instead of array to search for value
	isInObject : function (obj,search,findAll) {
		if (obj && search && typeof(search) == 'string') {
			var id, check = false, idAll = [];
			for ( var key in obj) {
				if ( obj[key] == search ) {
					check = true;
					id = key;
					idAll[idAll.length] = key;
				}
			}
			if (!check) {
				return false;
			}
			if (findAll && check) {
				return idAll;
			}
			if (!findAll && check) {
				return id;
			}
		} else {
			window.alert('Javascript -> Funktion: Toolbox.isInObject(): Fehler bei den übergebenen Argumenten.');
		}
	},
	// central XMLHttpRequest, enabling Requests through central management rather than having to define a new one each time needed
	xmlHttp : new XMLHttpRequest(),
	// initialize xmlHttp - set up a queue of requests and start the cycling queueWorker
	xmlHttp_init : function () {
		//Toolbox.xmlHttp.open('POST', '/cms/xhr', true);
		//Toolbox.xmlHttp.setRequestHeader('content-type','text/plain');
		//Toolbox.xmlHttp.send();
		
		Toolbox.xmlHttp.onreadystatechange = function () {
			if (Toolbox.xmlHttp.readyState == 4) {
				if (Toolbox.xmlHttp.status == 200) {
					Toolbox.xmlHttp_response_function();
				} 
			}
		}
		
		Toolbox.xmlHttp.queue = [];
		Toolbox.xmlHttp.queueHistory = [];
		
		Toolbox.xmlHttp_errorMessage = function () {
			Toolbox.xmlHttp_errorMessage_standard();
		}
		
		Toolbox.xmlHttp_errorMessage_standard = function () {
			alert('Bei einem XML-HTTP-Request trat ein Fehler (Error '+Toolbox.xmlHttp.status+' - '+Toolbox.xmlHttp.statusText+') auf. Es kann sein, dass dieser Fehler durch eine unautorisierte Handlung ausgelöst wurde. In diesem Fall bitten wir um Unterlassung.');
		}
		
		Toolbox.xmlHttp.queueWorker = window.setInterval(
			function () {
				if (Toolbox.xmlHttp.queue.length > 0) {
					if ((Toolbox.xmlHttp.readyState == 4 || Toolbox.xmlHttp.readyState == 0) && !Toolbox.xmlHtpp_blockNewRequest)  {
						obj = Toolbox.xmlHttp.queue.shift();
						Toolbox.xmlHttp.lastRequest = obj;
						Toolbox.xmlHttp.queueHistory.push(obj);
						if (obj.blockNext) {
							Toolbox.xmlHttp.blockNewRequest = true;
						}
						Toolbox.xmlHttp.open(obj.method, obj.url, true);
						Toolbox.xmlHttp.setRequestHeader('content-type',obj.ct);
						Toolbox.xmlHttp.send(obj.content);
						Toolbox.xmlHttp.onreadystatechange = function () {
							if (Toolbox.xmlHttp.readyState == 4) {
								if (Toolbox.xmlHttp.status == 200) {
									Toolbox.xmlHttp.lastRequest.xrf();
								} else {
									Toolbox.xmlHttp_errorMessage();
								}
							}
						}
					}	//*/
				}
			},200
		);
	},
	// add a new Request into the queue so it can wait for being processed by the queueWorker
	// url: Target of the Request
	// content: encoded String with content of the Request
	// blockNext: enforce follow-up requests to wait for my answer (ensure synchronous handling)
	// method: send via GET or POST?
	// ct: Content-Type in which content is encoded (default: application/x-www-form-urlencoded)
	xmlHttp_send : function (url,content,blockNext,method,ct) {	
		if (url) {
			blockNext = blockNext ? blockNext : 'false';
			content = content ? content : 'value=empty';
			method = method ? method : 'POST';
			ct = ct ? ct : 'application/x-www-form-urlencoded';
			xrf = Toolbox.xmlHttp_response_function;
			Toolbox.xmlHttp.queue.push({ url:url,content:content,blockNext:blockNext,method:method,ct:ct,xrf:xrf });
		}
	},
	// the following functions represent the handlers for Request-Answers as well as their default values
	xmlHttp_response_function : function () {
		Toolbox.xmlHttp_response_function_standard();
	},
	xmlHttp_response_function_standard : function () {
		if (Toolbox.xmlHttp.responseText && Toolbox.xmlHttp.responseText !== '' && Toolbox.xmlHttp.responseText != ' ') {
			alert(Toolbox.xmlHttp.responseText);
		}
		window.setTimeout(function () { window.location.reload(); }, 100);
	},
	// compute absolute URI if a relative URL (towards locationHref) is given 
	href_rel2abs : function (locationHref,relHref) {
		var loc = locationHref.split('?')[0].split('#')[0];
		
		if (loc[loc.length-1] == '/') {
			var i = 1;
		} else {
			var i = 0;
		}
		loc = loc.split('/');
		while (relHref.search(/^\.\.\//) != -1) {
			relHref = relHref.replace(/^\.\.\//,'');
			i++;
		}
		var abs = '';
		for (var j = 0; j < loc.length - i; j++) {
			abs += loc[j]+'/';
		}
		abs += relHref;
		
		return abs;
	},
	// Polyfill - get scrollTop/scrollLeft in all Browsers
	getScrollXY : function () {
		var scrOfX = 0, scrOfY = 0;
		if( typeof( window.pageYOffset ) == 'number' ) {
			//Netscape compliant
			scrOfY = window.pageYOffset;
			scrOfX = window.pageXOffset;
		} else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
			//DOM compliant
			scrOfY = document.body.scrollTop;
			scrOfX = document.body.scrollLeft;
		} else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
			//IE6 standards compliant mode
			scrOfY = document.documentElement.scrollTop;
			scrOfX = document.documentElement.scrollLeft;
		}
		return [ scrOfX, scrOfY ];
	},
	// temporary var-Container
	temp : {
	}
}

// The following definition takes the methods from Toolbox.xmlHttp and wraps them into an object-oriented class Toolbox.jz_xhr
// Using this, various instances of Objects like Toolbox.xmlHttp can be created and run parallely
// We will only comment functions and methods not covered in the description of Toolbox.xmlHttp above.


// Array - all instances are registered here automatically 
Toolbox.jz_xhrs = [];

Toolbox.jz_xhr = function() {
	// see Toolbox.xmlHttp
	this.xmlHttp = false;
	
	// see Toolbox.xmlHttp
	this.workerFunction = function () {
		if (this.xmlHttp.queue.length > 0) {
			if ((this.xmlHttp.readyState == 4 || this.xmlHttp.readyState == 0) && !Toolbox.xmlHtpp_blockNewRequest)  {
				obj = this.xmlHttp.queue.shift();
				this.xmlHttp.lastRequest = obj;
				this.xmlHttp.queueHistory.push(obj);
				if (obj.blockNext) {
					this.xmlHttp.blockNewRequest = true;
				}
				this.xmlHttp.open(obj.method, obj.url, true);
				this.xmlHttp.setRequestHeader('content-type',obj.ct);
				this.xmlHttp.send(obj.content);
				this.xmlHttp.onreadystatechange = function () {
					if (this.readyState == 4) {
						if (this.status == 200) {
							this.lastRequest.xrf();
						} else {
							this.errorMessage();
						}
					}
				}
			}	
		}
	}
	
	// see Toolbox.xmlHttp
	this.xmlHttp_init = function () {		
		
		this.xmlHttp = new XMLHttpRequest();
		this.xmlHttp.obj = this;
	
		this.xmlHttp.onreadystatechange = function () {
			if (this.readyState == 4) {
				if (this.status == 200) {
					this.obj.xmlHttp_response_function();
				} 
			}
		}
		
		this.xmlHttp.queue = [];
		this.xmlHttp.queueHistory = [];
		
		this.xmlHttp.errorMessage = function () {
			this.errorMessage_standard();
		}
		
		this.xmlHttp.errorMessage_standard = function () {
			alert('Bei einem XML-HTTP-Request trat ein Fehler (Error '+this.status+' - '+this.statusText+') auf. Es kann sein, dass dieser Fehler durch eine unautorisierte Handlung ausgelöst wurde. In diesem Fall bitten wir um Unterlassung.');
		}
	
		Toolbox.jz_xhrs.push(this);
	}
	
	// see Toolbox.xmlHttp
	// args: variables that can be used inside response_functions, e.g. as static parameters for other functions
	this.xmlHttp_send = function (url,content,blockNext,method,ct,args) {	
		if (url) {
			blockNext = blockNext ? blockNext : 'false';
			content = content ? content : 'value=empty';
			method = method ? method : 'POST';
			ct = ct ? ct : 'application/x-www-form-urlencoded';
			xrf = this.response_function;
			this.xmlHttp.queue.push({ url:url,content:content,blockNext:blockNext,method:method,ct:ct,xrf:xrf,obj:this,args:args });
		}
	}	
	
	// see Toolbox.xmlHttp - it is important to check whether jz_xhr or its xmlHttp-Member is the caller of this function
	this.xmlHttp_response_function = function () {
		if (this instanceof Toolbox.jz_xhr) {
			this.xmlHttp_response_function_standard();
		} else {
			this.obj.xmlHttp_response_function_standard();
		}
	}
	
	// see Toolbox.xmlHttp
	this.xmlHttp_response_function_standard = function () {
		if (this.xmlHttp.responseText && this.xmlHttp.responseText !== '' && this.xmlHttp.responseText != ' ') {
			alert(this.xmlHttp.responseText);
		}
	}

	// Shortcut
	this.send = function (url,content,blockNext,method,ct,args) {
		this.xmlHttp_send(url,content,blockNext,method,ct,args);
	}
	
	// Shortcut
	this.init = function() {
		this.xmlHttp_init();
	}
	
	// Shortcuts
	this.response_function_standard = this.xmlHttp_response_function_standard;
	this.response_function = this.xmlHttp_response_function;
	
	// initialize
	this.init();
}

// initialize static Toolbox.xmlHttp
Toolbox.xmlHttp_init();

// enable Worker-Functions; cycle with 200 ms delay
window.setInterval(
	function() {
		for (var i = 0; i < Toolbox.jz_xhrs.length; i++) {
			Toolbox.jz_xhrs[i].workerFunction();
		}
	},200
);

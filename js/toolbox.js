// (C) 2010, Janosch Zoller
// As part of JZCMS

var Toolbox = {
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
	hasClassName : function (elm,cN) {
		var cNs = Toolbox.getClassNames(elm);
		if (cNs.length > 0) {
			return Toolbox.isInArray(cNs,cN);
		} else {
			return false;
		}
	},
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
	xmlHttp : new XMLHttpRequest(),
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
	xmlHttp_response_function : function () {
		Toolbox.xmlHttp_response_function_standard();
	},
	xmlHttp_response_function_standard : function () {
		if (Toolbox.xmlHttp.responseText && Toolbox.xmlHttp.responseText !== '' && Toolbox.xmlHttp.responseText != ' ') {
			alert(Toolbox.xmlHttp.responseText);
		}
		window.setTimeout(function () { window.location.reload(); }, 100);
	},
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
	temp : {
	}
}

Toolbox.jz_xhrs = [];

Toolbox.jz_xhr = function() {
	this.xmlHttp = false;
	
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
	
	this.xmlHttp_response_function = function () {
		if (this instanceof Toolbox.jz_xhr) {
			this.xmlHttp_response_function_standard();
		} else {
			this.obj.xmlHttp_response_function_standard();
		}
	}
	
	this.xmlHttp_response_function_standard = function () {
		if (this.xmlHttp.responseText && this.xmlHttp.responseText !== '' && this.xmlHttp.responseText != ' ') {
			alert(this.xmlHttp.responseText);
		}
	}

	this.send = function (url,content,blockNext,method,ct,args) {
		this.xmlHttp_send(url,content,blockNext,method,ct,args);
	}
	
	this.init = function() {
		this.xmlHttp_init();
	}
	
	this.response_function_standard = this.xmlHttp_response_function_standard;
	this.response_function = this.xmlHttp_response_function;
	
	this.init();
}

Toolbox.xmlHttp_init();

window.setInterval(
	function() {
		for (var i = 0; i < Toolbox.jz_xhrs.length; i++) {
			Toolbox.jz_xhrs[i].workerFunction();
		}
	},200
);

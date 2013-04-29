var svg = document.getElementsByTagName('svg');
svg = svg.item(0);
var console = console || {};
if( document.getElementById("console") && (!console.log) ) {
	console = {
	    that : document.getElementById("console"),
		text : (document.getElementById("console-text").childNodes.item(1).getFirstChild()) ? document.getElementById("console-text").childNodes.item(1).getFirstChild() : document.getElementById("console-text").appendChild(document.createTextNode("")),
		height : 50,
		open: function() {
			that = this.that;
			/* Set the size of the console box */
			var console_box = that.childNodes.item(1);
			var size = Number(svg.getAttribute('width'));
			console_box.setAttribute('width', size);
			/* Move the console to the bottom of the visual */
			that.setAttribute ( 'transform', 'translate(0,'+ svg.getAttribute('height') +')' );
			svg.setAttribute( 'height',  this.height+Number(svg.getAttribute('height')) );
		},
		log : function(o) {
			/* Use the size of the console box to alter the number 
			 * of text lines (by adding new <text> elements) if needed
			 */
			this.text.data = o;

			/*
			if( o.length*6 > size ) {
				var n = (o.length+1) * 6;
				var spc = o.search(' ');
			    spc = (spc < (size/6)) ? size/6 : spc;
				for( var i=1; i<2; i+=1) {
					var text = document.getElementById("console-text").childNodes.item(3).getFirstChild();
					if(! text ) return;
					var str = o.substring(i*(99), i*(99)+100);
					this.text.data = str;
					spc = o.substring(spc).search(' ');
			        spc = (spc < (size/6)) ? size/6 : spc;
				}
			}
			*/
		},
	}
} else {
	/* Nullify calls to console functions */
	console.open = function(){ return; };
	console.log = function(){ return; };
	console.close = function(){ return; };
}
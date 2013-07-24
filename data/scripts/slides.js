var startTime = Math.floor( (new Date).getTime()/1000 );
var delay = 0.1;

function secondsAhead(sec) {
	var timePassed = Math.floor( (new Date).getTime()/1000 ) - startTime;
	return timePassed + sec;
}

function rotateSlide() {
	/* Update the begin time for Animations */
	var anims = [];
	anims.push( document.getElementById('shiftTop1') );
	anims.push( document.getElementById('shiftTop2') );
	anims.push( document.getElementById('shiftTop3') );
	anims.push( document.getElementById('shiftBot1') );
	anims.push( document.getElementById('shiftBot2') );
	anims.push( document.getElementById('shiftBot3') );
	for( var i=0, z=anims.length; i<z; i++ ) {
		anims[i].setAttribute( 'begin', secondsAhead(delay) );
	}
}

function changeSlide(cur1, cur2) {
	var curr = [];
	curr.push( document.getElementById(cur1) );
	curr.push( document.getElementById(cur2) );
	var total = document.getElementsByTagName('g').length;
	for(var i=0, z=curr.length; i<z; i++) { 
		var get_href = curr[i].getAttribute( 'xlink:href' );
		var curr_name = get_href ||curr[i].attributes.item(3).value;
		try {
			/* Check that an href value was captured, by printing to console or a text elm */
			console.log( curr_name );
		} catch(e) {
			var label = document.createElement('text');
			curr[i].appendChild( label );
			label.setAttribute( 'font-color', '#ff0000' );
			label.setAttribute( 'x', '10' );
			label.setAttribute( 'y', '20' );
			label.appendChild(
				document.createTextNode( curr_name )
			);
		}
		var curr_pos = +( curr_name.match(/\d+/).join("") );
		var next_name;
		if( curr_pos < total ) {
			next_name = "#slide-" + ( ++curr_pos );
		} else {
			next_name = "#slide-1";
		}
		if( get_href ) {
			curr[i].setAttribute( 'xlink:href', next_name );
		} else {
			curr[i].attributes.item(3).value = next_name;
		}
	}
}
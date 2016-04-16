"use strict";
Debugger.on = true;

var practice = angular.module('practice-angularjs', []);


practice.controller( 'HelloController', function($scope) {
try {
	"debugger";
	$scope.greeting = "Hello, $1!";
	
	$scope.greet = function(n) {
		return $scope.greeting.replace(/\$1/, n);
	};
	
	Debugger.log( this );
} catch(e) {
	Debugger.log( e.stack );
}
} );


practice.controller( 'typeBoxController', function($scope) {
try {
	$scope.MAX_LEN = 100;
	$scope.WARN_LEN = 10;
	$scope.greeting = "You said,";
	//$scope.usrmsg = $scope.usrmsg || "";
	$scope.longmsg = false;
	
	$scope.remaining = function() {
		if(! $scope.usrmsg ) return $scope.MAX_LEN;
		
		var remains = $scope.MAX_LEN - $scope.usrmsg.length;
		return( remains > 0 )?
			remains:
			0;
	};
	
	$scope.warning = function() {
		if(! $scope.usrmsg ) return false;
		
		var remains = $scope.MAX_LEN - $scope.usrmsg.length;
		return( remains < $scope.WARN_LEN );
	};

	$scope.transformField = function() {
		if(! $scope.usrmsg ) return $scope.longmsg;
		
	try {
		if ($scope.usrmsg.length > 20) {
			$scope.longmsg = true;
		} else {
			$scope.longmsg = false;				
		}
	} catch (e) {
		console.log( "Failed to update usrmsg box: "+ e.stack );
	} finally {
		return $scope.longmsg;
	}
		
	};
} catch(e) {
	Debugger.log( e.stack );
}
} );
practice.directive( 'practiceUserMessage', function() {
try {
	return {
		restrict: 	'C',
		replace: 	true,
		//transclude:	true,
		template: 	'<span>'+
						'<input data-ng-model="usrmsg" data-ng-change="transformField()" data-ng-hide="longmsg"></input>'+
						'<textarea data-ng-model="usrmsg" data-ng-change="transformField()" data-ng-show="longmsg"></textarea>'+
					'</span>',
		link: function( scope, element, attrs ) {
			var $lilBox = angular.element( element.children()[0] );
			var $bigBox = angular.element( element.children()[1] );
			scope.$watch(scope.transformField, function( n, o, scope ){
				Debugger.log( o, "practiceUserMessage: $1" );
				if( n === o ) {
					return;
				} else if(! n ) {
					$lilBox[0].focus();
					$lilBox[0].selectionStart = 
						$lilBox[0].selectionEnd = 
						$lilBox[0].value.length;
				} else {
					$bigBox[0].focus();
					$bigBox[0].selectionStart = 
						$bigBox[0].selectionEnd = 
						$bigBox[0].value.length;
				}
			} );
		}
	};
} catch(e) {
	Debugger.log( e.stack );
}
} );

///**
// *  creates a circle in the upper left corner of its container
// *  with the given radius. `<custom-circle radius="10"/>`
// * (Adapted from https://gist.github.com/blesh/2a11d1b4d65006d6ade3#file-custom-circle-js)
// */
//practice.directive('customCircle', function(){
//  return {
//	restrict: 	'C',
//
//	// the following two configuration options are 
//	// required for SVG custom elements.
//	templateNamespace: 'svg',
//	replace: true, 
//
//	// NOTE: ng-attr- style binding is used to prevent SVG validation
//	// error messages.
//	template: '<circle data-ng-attr-cx="{{radius}}" data-ng-attr-cy="{{radius}}" data-ng-attr-r="{{radius}}"/>',
//
//	// everything else as normal
//	scope: {
//	  radius: '@',
//	}
//  };
//});

1;

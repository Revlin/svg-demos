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


practice.service( 'SubscriptionService', [
	'$q',
	function( $q ) {
	try {
		this.getUsers = function() {
			/* Skip ajax call because data is already on the page;
			 * resolve promise immediately
			 */
			var userList = [],
				defer = $q.defer();
			$('.user-list').each( function( idx ) {
				var data = this.innerHTML.match(/^(.+\s.+)\s(.+)$/);
				var user = {
					name: (!!data)? data[1]: "No name",
					email: (!!data)? data[2]: "No@Email",
					id: (idx + 1),
					isSubscriber: false
				};
				userList.push(user);
			} );
			defer.resolve( userList );
			
			return defer.promise;
		};
		
		this.updateParticipants = function( users ) {
			var defer = $q.defer();
			defer.resolve();
			return defer.promise;
		};
	} catch(e) {
		Debugger.log( e.stack );
	}
	}
] );
practice.controller( 'selectSubscribersController', [
	'$scope',
	'SubscriptionService',
	function( $scope, SubscriptionService ) {
	try {
		$scope.model = {};
		
		SubscriptionService.getUsers().then( function( users) {
			Debugger.log( users );
			$scope.model.users = users;
		} );
		
		$scope.watchSubscribers = function( newValue, oldValue ) {
			if( (newValue === oldValue) || (!newValue) ) return;
			$scope.model.selected.isSubscriber = true;
		};
		
		$scope.$watch('model.selected', $scope.watchSubscribers);
		
		$scope.removeSubscriber = function( subscriber ) {
			subscriber.isSubscriber = false;
			$scope.model.selected = null; // reset choice
		}
		
		$scope.saveChanges = function() {
			SubscriptionService.updateUsers($scope.model.users).then(
				function() {
					/* Handle save success */
				},
				function() {
					/* Handle save failure */
				}
			)
		}
	} catch(e) {
		Debugger.log( e.stack );
	}
	}
] );


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
practice.directive( 'practiceSvgMessage', function() {
try {
	return {
		restrict: 	'C',
		//transclude:	true,
		// the following two configuration options are 
		// required for SVG custom elements.
		templateNamespace: 'svg',
		replace: true, 
		template: 	'<tspan data-ng-model="usrmsg" data-ng-hide="longmsg"  data-ng-change="transformField()">{{usrmsg}}</tspan>',
		link: function( scope, element, attrs ) {
			var $lilBox = angular.element( element.children()[0] );
			var $bigBox = angular.element( element.children()[1] );
			scope.$watch(scope.transformField, function( n, o, scope ){
				Debugger.log( o, "practiceSvgMessage: $1" );
				/*
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
				*/
				return true;
			} );
		}
	};
} catch(e) {
	Debugger.log( e.stack );
}
} );

1;

   var myApp = angular.module("myApp", ["firebase"]);
 
      myApp.controller("MyController", ["$scope", "$firebaseArray",
        function($scope, $firebaseArray) {
          var ref = new Firebase("https://mydogspot.firebaseio.com/posts");
          $scope.messages = $firebaseArray(ref);
		  
		  //console.log($scope.messages);
		 
		 
		   ref.orderByChild("comments").on("child_added", function(snapshot) {
  			//console.log(snapshot.val().comments);
			
			});
			
			
			
		

        }
		
		

      ] );
	  
	  /*myApp.controller("loginController", function($scope){
		
	
	});*/
var rookGame = (function($){
	return{
		scope : {},
		gameId: "",
		playerId: "",
		send : function(operation,data){
			data = data == undefined ? {} : data;
			data.op = operation;
			data.gameId = rookGame.gameId;
			data.playerId = rookGame.playerId;
			$.post("rook/messages",data)
		},
		refresh : function(){
			scope.$apply();
		},
		getQueryStringValue : function(key){
			return unescape(window.location.search.replace(new RegExp("^(?:.*[&\\?]" + escape(key).replace(/[\.\+\*]/g, "\\$&") + "(?:\\=([^&]*))?)?.*$", "i"), "$1"));
		},
		selectCards:function(numberOfCards){
			$(".card:not(.mCard)").click(function(elm){
				var card = $(elm.currentTarget);
				if(card.attr("data-selected") == "true"){
					card.attr("data-selected","false");
				}
				else if(rookGame.getSelectedCards().length < numberOfCards){
					card.attr("data-selected","true");
				}
			});
			
			rookGame.scope.canSubmitCards = true;
			rookGame.scope.cardsToSubmit = numberOfCards;
		},
		getSelectedCards:function(){
			var cardData = [];
			 $(".card[data-selected='true']").each(function(i,card){
				 var dataObj = JSON.parse($(card).attr("data-card"));
				 cardData.push(dataObj)
			 });
			 
			return cardData;
		},
		deselectAllCards : function(){
			$(".card").attr("data-selected","false").css("bottom","").unbind("click");
			rookGame.scope.canSubmitCards = false;
		}
	}
})(jQuery);

rookGame.gameController = function($scope, $modal, $location, $log, $rootScope){
	
	//Scope variable to show the bid counter
	$scope.showBidCounter = false;
	
	$scope.numplayers = 0;
	$scope.inviteUrl = "";
	$scope.middleHand = [];
	$scope.playerHand = [];
	$scope.showChat = false;
	$scope.trump = "";
	$scope.trickColor = "";
	$scope.modalID = "myModalContent.html";
	$scope.opponents = [{name:"Player 1",bid:0,score:0},{name:"Player 2",bid:0,score:0},{name:"Player 3",bid:0,score:0},{name:"Player 4",bid:0,score:0}];
	$scope.currentPlayer = 0;
	rookGame.scope = $scope;
	$scope.selectedIndex = -1; /* Not Selected */
	$scope.canSubmitCards = false;
	$scope.cardsToSubmit = 0;
	$rootScope.winningTeam = "PlaceHolder";
	$rootScope.winningScore = 0;
	$scope.cardsChoosen = 0;
	$scope.cardsNeeded = 0;
	$scope.theBidder = "PlaceHolder";
	
	//Run count function
	count(counter, 30, 0, 32000);
	
	$scope.select= function(i) {
	  $scope.selectedIndex=i;
	};
	
	//for the view
	
	//Values for Bids/Scores//
		$rootScope.topBid = 100;
		
	
	  $scope.items = ['item1', 'item2', 'item3'];
	  $scope.open = function (page){
		  $rootScope.modalVal = page;
	     var modalInstance = $modal.open({
	      backdrop : 'static',
	      templateUrl: page,
	      controller: 'modalController',
	      resolve: {
	        items: function () {
	          return $scope.items;
	        }
	      }
	    });

	    modalInstance.result.then(function (selectedItem) {
	      $scope.selected = selectedItem;
	    }, function () {
	      $log.info('Modal dismissed at: ' + new Date());
	    });
	  };

	// Please note that $modalInstance represents a modal window (instance) dependency.
	// It is not the same as the $modal service used above.
	$scope.discardTheFive = function(){
		rookGame.send("discardFive", {"theFive" : rookGame.getSelectedCards()});
	}

	onMessage = function(msg) {
		var data = JSON.parse(msg.data);
		
		if(data.team1Score != undefined){
			$scope.opponents[0].score = data.team1Score;
			$scope.opponents[2].score = data.team1Score;
		}
		
		if(data.team2Score != undefined){
			$scope.opponents[1].score = data.team2Score;
			$scope.opponents[3].score = data.team2Score;
		}

		if(data.playerID != undefined) {
			$scope.currentPlayer = data.playerID;
		}
		
		if(data.msg != undefined) {
			printToConsole(data.msg);
		}
		
		if (data.centerDeck != undefined) {
			$scope.middleHand = data.centerDeck;
			
			if(data.centerDeck.length == 4){
				setTimeout(function(){ 
					$scope.trickColor = ""
					$scope.middleHand = {};
					$scope.$apply(); 
				}, 2000);
			}
		}

		if (data.hand != undefined) {
			$scope.playerHand = data.hand;
		}

		if (data.playersConnected != undefined) {
			$scope.numplayers = parseInt(data.playersConnected);
			if ($scope.numplayers >= 4)
				$location.path('/RookBoard');
		}
		
		if (data.startBidding != undefined) {
			$rootScope.topBid = 100;
			$scope.open("myModalContent.html");
		}
		
		if (data.chooseTrump != undefined) {
			 $scope.open("trumpContent.html");
		}
		
		if(data.trump != undefined){
			$scope.trump = data.trump.charAt(0).toUpperCase() + data.trump.substring(1);
		}
		
		if(data.newPlayerBid != undefined){
			//#-BID
			console.log(data.newPlayerBid);
			var playerNumber = parseInt(data.newPlayerBid[0]);
			console.log(data.newPlayerBid);
			var playerBidNew = parseInt(data.newPlayerBid.substring(2, data.newPlayerBid.length));
			
			if(playerBidNew == 0){
				$scope.opponents[playerNumber].bid = "Pass";
			}else{
				$scope.opponents[playerNumber].bid = playerBidNew;
				$rootScope.topBid = playerBidNew;
			}
			
		}
		
		if(data.discardFive != undefined){
			rookGame.selectCards(5);
			$scope.cardsNeeded = 5;
		}
		
		if(data.trick != undefined){
			$scope.trickColor = (data.trick.substring(0,1).toUpperCase() + data.trick.substring(1));
		}

		if(data.playCard != undefined){
			rookGame.selectCards(1);
			$scope.cardsNeeded = 1;
		}
		
		if(data.winningTeam != undefined){
			$rootScope.winningTeam = "Team " + data.winningTeam[0];
			$rootScope.winningScore = data.winningScore[0];
			$scope.open("gameOver.html");
		}

		$scope.$apply();
  	}
	
	$scope.submitCards = function(cardsToSubmit){
		var cards = rookGame.getSelectedCards();
			
		if(cards.length == cardsToSubmit){
			var operation = cardsToSubmit == 5 ? "discardFive" : "playCard";
			var hasTrickColoredCard = false;
			
			if(operation == "playCard")
			{
				if(cards[0].color.toUpperCase() != $scope.trump.toUpperCase() && cards[0].color.toUpperCase() != $scope.trickColor.toUpperCase() && cards[0].color.toUpperCase() != "white"){
					
					
					jQuery($scope.playerHand).each(function(i,e){
						if(e.color.toUpperCase() == $scope.trickColor.toUpperCase()){
							alert("You have a card of the same color as the trick you must play that instead");
							hasTrickColoredCard = true;
							return false;
						}
					});
				}
			}
			
			if(!hasTrickColoredCard){
				rookGame.send(operation, {"cards":cards});
				rookGame.deselectAllCards();
			}
			
		}else{
			alert("You must select " + cardsToSubmit +" cards");
		}
	}
		  
	onOpened = function() {
		if ($scope.numplayers >= 4) {
			rookGame.send("start");
			$location.path('/RookBoard');
		}

		$scope.$apply();
	}

	onError = function(err) {
		console.log(err);
	}

	onClose = function() {
		console.log("Channel closed!");
	}

	$scope.connect = function() {
		var gameId = rookGame.getQueryStringValue("gameId");
		var data = {
			"isNewGame" : true
		};
		// if url contains a game id Create new game
		if (gameId != "") {
			data.gameId = gameId;
			data.isNewGame = false;
		}

		jQuery.ajax({
			data : data,
			type : "GET",
			url : "rook/messages",
			async : true
		}).done(
			function(msg) {
				var serverMessage = JSON.parse(msg);

				console.log(serverMessage.gameId);
				rookGame.gameId = serverMessage.gameId;
				rookGame.playerId = serverMessage.playerId;

				$scope.numplayers = serverMessage.connectedPlayers;

				channel = new goog.appengine.Channel(serverMessage.token);
				socket = channel.open();
				socket.onopen = onOpened;
				socket.onmessage = onMessage;
				socket.onerror = onError;
				socket.onclose = onClose;

				$scope.inviteUrl = window.location.protocol + "//"
						+ window.location.host + window.location.pathname
						+ "?gameId=" + serverMessage.gameId;
				jQuery("#searchbox").val($scope.inviteUrl);
		});
	}
};

rookGame.modalController = function($scope, $modalInstance, items, $rootScope){
	$scope.bidWarning = false;
	$scope.colorWarning = false;
	$scope.value = 150;
	$scope.selectedItem = null;
	$scope.items = items;
	$scope.selected = {
			item: $scope.items[0]
	};
	  
    $scope.okBet = function (bet) {
    	if (bet <= $rootScope.topBid && bet != 0) {
			$scope.bidWarning = true;
		} else {
			var data = {
				"playerBet" : bet
			};
			rookGame.send("bid", data);

			$modalInstance.close($scope.selected.item);
		}
	};
	  
    $scope.okColor = function () {
    	if ($scope.selectedItem == null){
    		$scope.colorWarning = true;
    	}
    	else{
			rookGame.send("trump",{"theTrump" : $scope.selectedItem});
    		$modalInstance.close($scope.selected.item);
		}
    };

	$scope.cancel = function () {
	    $modalInstance.dismiss('cancel');
	  };

    $scope.selectItem = function( item ) {
        $scope.selectedItem = item;
    };
	 
}
rookGame.routeProvider = function($routeProvider, $locationProvider) {
    $routeProvider
    // route for the home page
    .when('/', {
        templateUrl : 'RookGame/lobby.html'
    })

    // route for the game page
    .when('/RookBoard', {
        templateUrl : 'RookGame/RookBoard.jsp'
    });
 // use the HTML5 History API
	$locationProvider.html5Mode(true);
};

var myModule = angular.module('rook', ['ngRoute','ui.bootstrap']);

myModule.controller('myController', rookGame.gameController);
myModule.controller('modalController', rookGame.modalController);

myModule.config(rookGame.routeProvider);

//Get element for the counter
var counter = $('#counter');

//Count function - element for counter, starting count number, ending count number, time in milliseconds
function count(elem, startnum, endnum, time){
  
  //Create a variable to store the current counter number and add it to the counter
  var curnum = startnum;
  elem.text(curnum);
  
  //Work out the speed of the counter
  var speed = time / (endnum + startnum);
  
  //Create the counter animation
  var timer = window.setInterval(function(){
    
    //Test if counter has finished
    if(curnum > endnum){
      //Increase the counter by 1 and add it to the counter
      curnum--;
      elem.text(curnum);
    }else{
      //Stop the animation
      clearInterval(timer);
    }
    
  },speed);
  
}

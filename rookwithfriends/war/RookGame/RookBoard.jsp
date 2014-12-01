
<!-- Page Content -->
<div style="margin: 0 auto 0 auto;width:1250px;">
	<script type="text/ng-template" id="myModalContent.html">
        <div class="modal-header">
            <h3 class="modal-title">Make a Bid!</h3>
        </div>
		<div class="modal-body" id="modalMain">
		<h3>Current Bid is: {{topBid}}</h3> 
		<div id="slider">
			<input step="5" min=0 max=200 class="bar" type="range" id="rangeinput" ng-model="value" onchange="rangevalue.value=value;"/>
			<output id="rangevalue"><span>50</span></output>	
		</div>
		<h3>Your Bid is: {{value}}</h3> 
		</div>
        </div>
		<div class="alert alert-danger" role="alert" ng-show="bidWarning">Bid must be more than current bid, please select again.</div>
        <div class="modal-footer">
            <button class="btn btn-primary" ng-click="ok()">OK</button>
            <button class="btn btn-warning" ng-click="cancel()">Cancel</button>
        </div>
    </script>
    <!-- Player Stat Boxes -->
    <div class="box" id="player2StatBox">
	  <div class="box__header">
	    <h3 class="box__header-title">Team 1</h3>
	  </div>
	  <div class="box__body">
	    <div class="stats stats--main" id="player2Points">
	    <p>Score:</p>
	    </div>
	    <div class="stats" id="player2CB">
	    <p>Current Bid:</p>
	    </div>
	  </div>
	</div>
	<div class="box" id="player1StatBox">
	  <div class="box__header">
	    <h3 class="box__header-title">Team 1</h3>
	  </div>
	  <div class="box__body">
	    <div class="stats stats--main" id="player2Points">
	    <p>Score:</p>
	    </div>
	    <div class="stats" id="player2CB">
	    <p>Current Bid:</p>
	    </div>
	  </div>
	</div>
	<!--User Avatars and Names-->
	<button class="btn btn-default" ng-click="open()">Open me!</button>
	<div class="avatarContainer">	
		<a class="circle" id="player2"> 
			<img height="83" width="83" src="avatarImg.png">
			<h5 class="playerName">{{opponentNames[1]}}</h5>
		</a> 
	</div>
	<div>
		<div class="centerStrip avatarContainer">
			<a class="circle" id="player3"> 
				<img height="83" width="83" src="avatarImg.png">
				<h5 class="playerName">{{opponentNames[2]}}</h5>
			</a> 
		</div>
		<div id="table1" class="centerStrip">
			<div id="table2">
			 
				<div id="middleHand">
					 <div class="three midCards" ng-class="card.color" data-card="" id="player2MidCard">
						<div class="cardTop">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
						<div class="cardMiddle ng-binding"></div>
						<div class="cardBottom">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
					</div>
					<div class="three midCards" ng-class="card.color" data-card="" id="player1MidCard">
						<div class="cardTop">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
						<div class="cardMiddle ng-binding"></div>
						<div class="cardBottom">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
					</div>
  					<div class="three midCards" ng-class="card.color" data-card="" id="player4MidCard">
						<div class="cardTop">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
						<div class="cardMiddle ng-binding"></div>
						<div class="cardBottom">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
					</div>
  					<div class="three midCards" ng-class="card.color" data-card="" id="player3MidCard">
						<div class="cardTop">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
						<div class="cardMiddle ng-binding"></div>
						<div class="cardBottom">
							<div class="number ng-binding"></div>
							<div class="color"></div>
						</div>
					</div>
				</div>
				<div id="playerHand">
					<div class="card pCard" ng-class="card.color" ng-click="select($index)" ng-repeat="card in playerHand" data-card="{{card}}">
						<div class="cardTop">
							<div class="number">{{card.rank}}</div>
							<div class="color"></div>
						</div>
						<div class="cardMiddle">{{card.rank}}</div>
						<div class="cardBottom">
							<div class="number">{{card.rank}}</div>
							<div class="color"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="centerStrip avatarContainer">
			<a class="circle" id="player4"> 
				<img height="83" width="83" src="avatarImg.png">
				<h5 class="playerName">{{opponentNames[3]}}</h5>
			</a>
		</div>
	</div>
	<div class="avatarContainer" id="player1Container">
		<a class="circle" id="player1">
			<img height="83" width="83" src="avatarImg.png">
			<h5 class="playerName">{{opponentNames[0]}}</h5>
		</a> 
	</div>
</div>
<!--End Player Hand-->

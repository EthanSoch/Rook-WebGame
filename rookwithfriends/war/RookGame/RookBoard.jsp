
<!-- Page Content -->
<div style="margin: 0 auto 0 auto;width:1300px;">
	<script type="text/ng-template" id="myModalContent.html">
        <div class="modal-header">
            <h3 class="modal-title">Make a Bid!</h3>
        </div>
		<div class="modal-body" id="modalMain">
		<h3>Current Bid is: {{topBid}}</h3> 
		<div id="slider">
			<input step="5" min={{topBid}} max=200 class="bar" type="range" id="rangeinput" ng-model="value" onchange="rangevalue.value=value;"/>
			<output id="rangevalue"><span>50</span></output>
		</div>
		<h3>Your Bid is: {{value}}</h3> 
		</div>
        </div>
		<div class="alert alert-danger" role="alert" ng-show="bidWarning">Bid must be more than current bid, please select again.</div>
        <div class="modal-footer">
            <button class="btn btn-primary" ng-click="okBet(value)">OK</button>
			<button class="btn btn-primary" ng-click="okBet(0)">Pass</button>
            <button class="btn btn-warning" ng-click="cancel()">Cancel</button>
        </div>
    </script>
    <script type="text/ng-template" id="trumpContent.html">
        <div class="modal-header">
            <h3 class="modal-title">Select a trump color!</h3>
        </div>
		<div class="modal-body" id="modalMain">
		<div class="color-selection">
  				<ul class="color-select">
  				  <li><a ng-class="{'selected': selectedItem === 'red'}" ng-click="selectItem('red')" style="background: #FF0000;"></a></li>
  				  <li><a ng-class="{'selected': selectedItem === 'black'}" ng-click="selectItem('black')" style="background: #000000;"></a></li>
   				  <li><a ng-class="{'selected': selectedItem === 'green'}" ng-click="selectItem('green')" style="background: #008000;"></a></li>
   				  <li><a ng-class="{'selected': selectedItem === 'yellow'}" ng-click="selectItem('yellow')" style="background: #FFFF00;"></a></li>
  				</ul>
			<span id="colorSelSpan">Please select a color for the trump.</span>
			<div class="alert alert-danger" role="alert" ng-show="colorWarning">Please select a color first.</div>
		</div><!--/ color-selection -->
        </div>
		<div class="alert alert-danger" role="alert" ng-show="bidWarning">Bid must be more than current bid, please select again.</div>
        <div class="modal-footer">
            <button class="btn btn-primary" ng-click="okColor()">OK</button>
            <button class="btn btn-warning" ng-click="cancel()">Cancel</button>
        </div>
    </script>
    <!-- Player Stat Boxes -->
	<!--User Avatars and Names-->
	<button class="btn btn-default" ng-click="discardTheFive()">Choose!</button>
	<div class="avatarContainer">
		<div class="StatBox playerMidAlign">
			<div class="box">
				<div class="box__header">
					<h3 class="box__header-title">Team 1</h3>
				</div>
				<div class="box__body">
					<div class="stats stats--main" id="player2Points">Score: {{team1Score}}</div>
					<div class="stats" id="player2CB">Current Bid: {{opponents[3].bid}}</div>
				</div>
			</div>
			<a class="circle" id="player2"> <img height="83" width="83"
				src="avatarImg.png">
				<h5 class="playerName">{{opponents[3].name}}</h5>
			</a>
		</div>
	</div>
	<div>
		<div class="centerStrip avatarContainer" id="player3Container">
			<div class="StatBox">
				<div class="box">
					<div class="box__header">
						<h3 class="box__header-title">Team 2</h3>
					</div>
					<div class="box__body">
						<div class="stats stats--main" id="player2Points">Score: {{team2Score}}</div>
						<div class="stats" id="player2CB">Current Bid: {{opponents[2].bid}}</div>
					</div>
				</div>
				<a class="circle" id="player3"> <img height="83" width="83"
					src="avatarImg.png">
					<h5 class="playerName">{{opponents[2].name}}</h5>
				</a>
			</div>
		</div>
		<div id="table1" class="centerStrip">
			<div id="table2">
				<div id="middleHand">
					<div class="card pCard" ng-class="card.color"
						ng-click="select($index)" ng-repeat="card in middleHand"
						data-card="{{card}}">
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
				<div id="playerHand">
					<div class="card pCard" ng-class="card.color"
						ng-click="select($index)" ng-repeat="card in playerHand"
						data-card="{{card}}">
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
		<div class="centerStrip avatarContainer" id="player2Container">
			<div class="StatBox">
				<div class="box">
					<div class="box__header">
						<h3 class="box__header-title">Team 2</h3>
					</div>
					<div class="box__body">
						<div class="stats stats--main" id="player2Points">Score: {{team2Score}}</div>
						<div class="stats" id="player2CB">Current Bid: {{opponents[1].bid}}</div>
					</div>
				</div>
				<a class="circle" id="player4"> <img height="83" width="83"
					src="avatarImg.png">
					<h5 class="playerName">{{opponents[1].name}}</h5>
				</a>
			</div>
		</div>
	</div>
	<div class="avatarContainer" id="player1Container">
		<div class="StatBox playerMidAlign">
			<div class="box">
				<div class="box__header">
					<h3 class="box__header-title">Team 1</h3>
				</div>
				<div class="box__body">
					<div class="stats stats--main" id="player2Points">Score: {{team1Score}}</div>
					<div class="stats" id="player2CB">Current Bid: {{opponents[0].bid}}</div>
				</div>
			</div>
			<a class="circle" id="player1"> <img height="83" width="83"
				src="avatarImg.png">
				<h5 class="playerName">{{opponents[0].name}}</h5>
			</a>
			<input id="playCardsButtom" type="button" ng-show="canSubmitCards" ng-click="submitCards" value="Player Cards">
		</div>
	</div>
</div>
<!--End Player Hand-->

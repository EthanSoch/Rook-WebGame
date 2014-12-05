package com.rookwithfriends.web;

import java.util.*;
import java.io.*;

import com.google.gson.Gson;
import com.rookwithfriends.game.*;
import com.rookwithfriends.util.*;

public class GameSession implements Serializable{
	private static final long serialVersionUID = -443526662938702934L;
	private Game game;
	private UUID gameId;
	private List<UserSession> players;
	private int currentBidder;
	
	public static GameSession getGameSession(UUID gameId){
		CacheUtility util = new CacheUtility();
		GameSession session = (GameSession) util.get(gameId);
		
		return session;
	}
	
	public GameSession(){
		players = new ArrayList<UserSession>();
		
		gameId = UUID.randomUUID();
	}
	
	public void gameInstruction(Map<String,String[]> input){
		
		switch(input.get("op")[0]){
		case "msg":
			Map<String,Object> msg = new HashMap<String,Object>();
			msg.put("op","msg");
			msg.put("msg", input.get("msg")[0]);
			sendToAll(msg);
			break;
		case "start":
			startGame();
			break;
		case "bid":
			//Need to pull out bid and playerID
			
			
			//NOT SURE HOW TO GET PLAYER
			int playerID = Integer.parseInt(input.get("playerId")[0]);
			//game.setBid(THEPLAYER,Integer.parseInt(input.get("playerBet")[0]);
			
			
			//NOT SURE HOW TO FIND NEXT BIDDER
			/*if(!game.getBettingIsDone()) {
				
				for(int i = 0; i < players.size(); i++){
					UserSession player = players.get(i);
					System.out.println(player);
					
					Player currentPlayer = game.getPlayerById(player.getGameID());
					int currentID = currentPlayer.getPlayerID();
					System.out.println("Current:"+currentID);
					System.out.println("NEW"+input.get("playerId")[0]);
					if(currentID == Integer.parseInt(input.get("playerId")[0])){
						currentBidder = i+1;
					}
					
				}*/
				
			
				//Next player to bit
				//UserSession player = players.get(currentBidder);
				//startBidding(player);
			//}
			break;
			
		}
	}

	public void startGame(){
		game = new Game();
		currentBidder = 0;

		//set user ids
		for(int i = 0 ; i < players.size() ; i++){
			players.get(i).setGameID(i);
		}
		
		game.startGame();
		updateGameBoard();
		updateAllPlayersCards();
		
		UserSession player = players.get(currentBidder);
		startBidding(player);
	}
	
	public void updateAllPlayersCards(){
		for(UserSession player : players){
			Player gamePlayer = game.getPlayerById(player.getGameID());
			String jsonString = gamePlayer.toJSON();
			player.sendMessage(jsonString);
		}
	}
	
	public void updateGameBoard(){
		for(UserSession player : players){
			String jsonString = game.toJSON();
			player.sendMessage(jsonString);
		}
	}
	
	public void startBidding(UserSession currentPlayer){
		
		Map<String,Object> response = new HashMap<String, Object>();
		response.put("startBidding", "true");
    	
		String responseJSON = JSONUtility.convertToJson(response);
		
		currentPlayer.sendMessage(responseJSON);
	}
	
	/*
	 * Save this game instance
	 */
	public void saveToCache(){
		CacheUtility util = new CacheUtility();
		util.put(getGameId(), this);
	}
	
	/*
	 * Creates player and returns the channel id
	 */
	public UserSession addPlayer(){
		//Add player to the list
		UUID newChannelKey = UUID.randomUUID();
		UserSession newPlayer = new UserSession(players.size(), newChannelKey);
		players.add(newPlayer);
		
		//send player Connected messages to all other players
		Map<String,Object> response = new HashMap<String, Object>();
		String numOfPlayers = String.valueOf(players.size());
		response.put("playersConnected", numOfPlayers);
    	
		String responseJSON = JSONUtility.convertToJson(response);
		
		for(UserSession player : players){
			if(!player.getChannelKey().equals(newPlayer.getChannelKey()))
				player.sendMessage(responseJSON);
		}
		
		return newPlayer;
	}
	
	public void sendToAll(Map<String,Object> data){
		sendToAll(JSONUtility.convertToJson(data));
	}
	
	public void sendToAll(String message){
		for(UserSession player : players){
			player.sendMessage(message);
		}
	}
	
//	public Game getGame(){
//		return game;
//	}
	
	public UUID getGameId() {
		return gameId;
	}

	public void setGameId(UUID gameId) {
		this.gameId = gameId;
	}
	
	public List<UserSession> getPlayers() {
		return players;
	}

	public void setPlayers(List<UserSession> players) {
		this.players = players;
	}
}

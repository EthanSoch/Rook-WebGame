package com.rookwithfriends.game;

import java.io.Serializable;
import java.io.StringWriter;
import java.util.Scanner;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

import org.eclipse.persistence.jaxb.MarshallerProperties;

@XmlRootElement
public class Player implements Serializable{
	private static final long serialVersionUID = -1161562471614255655L;
	// Declare Class Members//
	private int playerID;
	private int playerBid;
	private int handID;
	private boolean hasPassed;

	// CardSet Objects For Player//
	@XmlElement(name = "hand")
	private CardSet playerHand;
	private CardSet cardsWon;

	public Player(int id) {
		this.playerID = id;
		this.playerHand = new CardSet();
		this.cardsWon = new CardSet();
		this.hasPassed=false;
	}

	public Player() {
		this.playerHand = new CardSet();
		this.cardsWon = new CardSet();
		this.playerID = 0;
		this.hasPassed=false;
	}

	// selectCard(); -- Makes use of CardSet method getCard to return card in
	// playerHand at specific index
	// Should this ask the user for the card?
	public Card selectCard(int index) {

		return this.playerHand.get(index);

	}

	// Class Setters and Getters for Player//
	public int getPlayerBid() {
		return playerBid;
	}

	public void setPlayerBid(int playerBid) {
		this.playerBid = playerBid;
	}

	public int getPlayerID() {
		return playerID;
	}

	public void setPlayerID(int playerID) {
		this.playerID = playerID;
	}

	public int getHandID() {
		return handID;
	}

	public void setHandID(int handID) {
		this.handID = handID;
	}

	public CardSet getPlayerHand() {
		return playerHand;
	}

	public void setPlayerHand(CardSet playerHand) {
		this.playerHand = playerHand;
	}

	public CardSet getCardsWon() {
		return cardsWon;
	}

	public void setCardsWon(CardSet cardsWon) {
		this.cardsWon = cardsWon;
	}

	public boolean getHasPassed() {
		return hasPassed;
	}

	public void setHasPassed(boolean hasPassed) {
		this.hasPassed = hasPassed;
	}

	public Card chooseCard() {
		Scanner read = new Scanner(System.in);
		int theVal;
		Card theCard = null;
		
		theVal=0;//read.nextInt();
		if(theVal<playerHand.size())
		{
			theCard=playerHand.get(theVal);
		}

		return theCard;
	}

	public void setBid(int currentBid) {
		// If currentBid == 0 then the bid was "passed"
		if (currentBid != 0) {
			playerBid = currentBid;
		} else {
			hasPassed = true;
		}
	}

	public void printHand() {
		System.out.println(playerHand);
	}
	
	public String toJSON(){
		try{
			// Create a JaxBContext
			JAXBContext jc = JAXBContext.newInstance(Player.class);
	
			// Create the Marshaller Object using the JaxB Context
			Marshaller marshaller = jc.createMarshaller();
			
			// Set the Marshaller media type to JSON or XML
			marshaller.setProperty(MarshallerProperties.MEDIA_TYPE, "application/json");
			
			// Set it to true if you need to include the JSON root element in the JSON output
			marshaller.setProperty(MarshallerProperties.JSON_INCLUDE_ROOT, false);
			
			// Set it to true if you need the JSON output to formatted
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			
			StringWriter stringWriter = new StringWriter();
			
			// Marshal the employee object to JSON and print the output to console
			marshaller.marshal(this, stringWriter);
			
			return stringWriter.toString();
		}
		catch(JAXBException e){
			System.err.println("toJson error\n" + e.getMessage());
		}
		
		return "error";
		
	}
}

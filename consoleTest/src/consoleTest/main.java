package consoleTest;

import java.util.Scanner;

import com.rookwithfriends.game.*;

public class main {
		Scanner read = new Scanner(System.in);

	public static void main(String[] args) {
		Game game = new Game(0, 1, 2, 3);

	}

	public CardColor setTrump() {
		
		String input = null;
		String colorUp;
		boolean correctInput = false;

		// Keep prompting for input until a string has been entered
		do {
			System.out.println("Please enter the new trump.");
			input = read.next();

			colorUp = input.toUpperCase();

			if (colorUp == "RED") {
				correctInput = true;
			} else if (colorUp == "BLACK") {
				correctInput = true;
			} else if (colorUp == "YELLOW") {
				correctInput = true;
			} else if (colorUp == "GREEN") {
				correctInput = true;
			}

		} while (!correctInput);

		// Call Enum method to return the Enum cast of the input
		CardColor trump = CardColor.returnColor(colorUp);

		read.close();
		return trump;
	}

	public Card chooseCard(Player player) {
		String cardColor = null;
		String colorUp;
		double theVal;
		boolean correctInput = false;
		boolean cardNotFound = false;
		Card theCard = null;

		do {

			// Keep prompting for input until a string has been entered
			do {
				System.out
						.println("Please enter color of the card that you want.\n");
				cardColor = read.next();
				colorUp = cardColor.toUpperCase();
				System.out.println(colorUp);

				if (colorUp == "RED") {
					correctInput = true;
					System.out.println("Called");
				} else if (colorUp == "BLACK") {
					correctInput = true;
				} else if (colorUp == "YELLOW") {
					correctInput = true;
				} else if (colorUp == "GREEN") {
					correctInput = true;
				}
				System.out.println(correctInput);
			} while (!correctInput);

			System.out
					.println("Please enter value of the card that you want.\n");
			theVal = read.nextDouble();

			CardRank cardVal = CardRank.returnRank(theVal);
			CardColor theCardColor = CardColor.returnColor(colorUp);

			for(Card card : player.getPlayerHand().getArrayList()){
				if (card.getColor() == theCardColor
						&& card.getRank() == cardVal) {
					theCard = card;
				} else {
					cardNotFound = true;
				}
			}
		} while (cardNotFound);

		read.close();

		return theCard;
	}

	public int setBid(int currentBid) {
		Scanner read = new Scanner(System.in);
		System.out.println("Current bid is " + currentBid);
		System.out.println("Enter 1 to increase, enter 2 to pass.");

		int answer = read.nextInt();
		if (answer == 1) {
			System.out.println("What is your new bid. Must be a multiple of 5");

			int bid = read.nextInt();
			if (bid % 5 == 0 && bid > currentBid) {
				currentBid = bid;
				System.out
						.println("Thank you, your bid has been set. New bid is: "
								+ currentBid);
			}
		}
		read.close();
		return currentBid;
	}
}
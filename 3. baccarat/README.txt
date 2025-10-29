This project's purpose was to design a functional Baccarat game on the DE1-SoC. The intention of the project was to become familiarized with state machine logic, SystemVerilog, Quartus and ModelSim. 

Baccarat is a casino game where the dealer and player are both dealt 2 cards each to start the game. The following rules take place depending on the score of each hand:

If the player’s or banker’s hand has a score of 8 or 9, the game is over and whoever has the higher score wins.
Otherwise, if the player’s score from his/her first two cards was 0 to 5, the player gets a third card:

The banker may get a third card depending on the following rule:
	If the banker’s score from the first two cards is 7, the banker does not take another card
	If the banker’s score from the first two cards is 6, the banker gets a third card if the face value of the player’s third card was a 	6 or 7
	If the banker’s score from the first two cards is 5, the banker gets a third card if the face value of the player’s third card was 	4, 5, 6, or 7
	If the banker’s score from the first two cards is 4, the banker gets a third card if the face value of player’s third card was 2, 3, 	4, 5, 6, or 7
	If the banker’s score from the first two cards is 3, the banker gets a third card if the face value of player’s third card was 	anything but an 8
	If the banker’s score from the first two cards is 0, 1, or 2, the banker gets a third card.

Otherwise, if the player’s score from his/her first two cards was 6 or 7, then the player does not get a third card:
	If the banker’s score from his/her first two cards was 0 to 5, the banker gets a third card otherwise the banker does not get a 	third card.

For the scores:
	Each numbered card up to 9 is equal to its face value.
	Every card above 9 is equal to 0 points.

When calculating a score, if the score exceeds 10, then the score's real value is its value % 10. 
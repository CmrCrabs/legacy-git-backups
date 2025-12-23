namespace gofish {
    class Program {
        - Main(string[] args)
        - queryCards(string input, List<card> query_hand, List<card> opp_hand): bool
        - CountBooks(List<card> hand): int
        - Value(card Card): int
    }
    class card {
        + suit: Suit
        + rank: Rank
    }
    enum Suit {
        Diamonds
        Hearts
        Spades
        Clubs
    }
    enum Rank {
        Joker
        Ace
        Two
        Three
        Four
        Five
        Six
        Seven
        Eight
        Nine
        Ten
        Jack
        Queen
        King
    }
    class Deck {
        - deckData: List<card>
        + Deck()
        + GenDeck(): List<card>
        + Shuffle()
        + Draw(): card
    }
    class Hand {
        - handData: List<card>
        + Hand(List<card> deck)
        + InitialHand(List<card> deck): List<card>
    }
    class Display {
        + Render(card vroom)
    }
}


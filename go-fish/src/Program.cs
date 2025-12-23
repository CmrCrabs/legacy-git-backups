namespace gofish;

class Program {

  static void Main(string[] args) {
    Console.Clear();
    Deck deck = new Deck();
    deck.Shuffle();

    Hand Player1 = new Hand(deck.deckData);
    Hand Player2 = new Hand(deck.deckData);

    while(deck.deckData.Count > 0) {
      Console.Write("Player 1s Turn\nWhich card do you call?");
      if (!queryCards(Console.ReadLine(), Player1.handData, Player2.handData)) { 
        Console.WriteLine("Go Fish."); 
        var drawnCard = deck.Draw();
        Console.WriteLine("You drew:");
        Display.Render(drawnCard);
        Player1.handData.Add(drawnCard); 
      }

      Console.Write("Player 2s Turn\nWhich card do you call?");
      if (!queryCards(Console.ReadLine(), Player2.handData, Player1.handData)) { 
        Console.WriteLine("Go Fish."); 
        var drawnCard = deck.Draw();
        Console.WriteLine("You drew:");
        Display.Render(drawnCard);
        Player1.handData.Add(drawnCard); 
      }
    }
    if (CountBooks(Player1.handData) > CountBooks(Player2.handData)) { Console.WriteLine("Player 1 Wins"); }
    else { Console.WriteLine("Player 2 Wins");


  }

  static bool queryCards(string input, List<card> query_hand, List<card> opp_hand) {

    Rank queried_rank = input switch {
      "j" => Rank.Joker,
      "A" => Rank.Ace,
      "2" => Rank.Two,
      "3" => Rank.Three,
      "4" => Rank.Four,
      "5" => Rank.Five,
      "6" => Rank.Six,
      "7" => Rank.Seven,
      "8" => Rank.Eight,
      "9" => Rank.Nine,
      "10" => Rank.Ten,
      "J" => Rank.Jack,
      "Q" => Rank.Queen,
      "K" => Rank.King,
      _ => throw new ArgumentOutOfRangeException(),
    };
    bool real = false;
    for (int i = 0; i < opp_hand.Count; i++) {
      if (opp_hand[i].rank == queried_rank) {
        real = true;
        Console.WriteLine("You found:");
        Display.Render(opp_hand[i]);
        query_hand.Add(opp_hand[i]);
        opp_hand.RemoveAt(i);
      }
    }
    return real;
  }

  static int CountBooks(List<card> hand) {
      Dictionary<Rank, int> rankCounts = new Dictionary<Rank, int>();

      foreach (var card in hand) {
        if (rankCounts.ContainsKey(card.rank)) { rankCounts[card.rank]++; } 
        else { rankCounts[card.rank] = 1; }
      }

      int real = 0;
      foreach (var entry in rankCounts) { if (entry.Value >= 4) { real++; } }
      return real;
    }

  static int Value(card Card) {
    return Card.rank switch {
      Rank.Joker => 11,
      Rank.Ace => 11,
      Rank.Two => 2,
      Rank.Three => 3,
      Rank.Four => 4,
      Rank.Five => 5,
      Rank.Six => 6,
      Rank.Seven => 7,
      Rank.Eight => 8,
      Rank.Nine => 9,
      Rank.Ten => 10,
      Rank.Jack => 10,
      Rank.Queen => 10,
      Rank.King => 10,
      _ => throw new ArgumentOutOfRangeException(),
    };
  }
}

public struct card {
  public Suit suit;
  public Rank rank;
}

public enum Suit {
  Diamonds, Hearts, Spades, Clubs,
}
public enum Rank {
  Joker, Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King,
}

public class Deck {
  public List<card> deckData;
  public Deck() { this.deckData = GenDeck(); }

  List<card> GenDeck()
  {
    List<card> deck = new List<card>();
    foreach (Suit suit in Enum.GetValues(typeof(Suit)))
    {
      foreach (Rank rank in Enum.GetValues(typeof(Rank)))
      {
        deck.Add(new card { suit = suit, rank = rank });
      }
    }
    return deck;
  }

  public void Shuffle()
  {
    Random rng = new Random();
    int n = this.deckData.Count;
    while (n > 1) {
      n--;
      int k = rng.Next(n + 1);
      card value = this.deckData[k];
      this.deckData[k] = this.deckData[n];
      this.deckData[n] = value;
    }
  }  
  public card Draw() {
    var buf = this.deckData[this.deckData.Count - 1];
    this.deckData.RemoveAt(this.deckData.Count - 1);
    return buf;
  }
}

public class Hand {
  public List<card> handData;

  public Hand(List<card> deck) {
    this.handData = InitialHand(deck);
  }

  public List<card> InitialHand(List<card> deck) {
    int handsize = 5;
    List<card> burger = new List<card>();
    for (int i = 0; i < handsize; i++) {
      burger.Add(deck[i]);
      deck.RemoveAt(i);
    }
    return burger;
  }


}

public class Display {
  public static void Render(card vroom) {

    var suitRep = vroom.suit switch {
      Suit.Diamonds => "♦",
      Suit.Hearts => "♥",
      Suit.Spades => "♠",
      Suit.Clubs => "♣",
      _ => throw new ArgumentOutOfRangeException(),
    };

    var rankRep = vroom.rank switch {
      Rank.Joker => "j",
      Rank.Ace => "A",
      Rank.Two => "2",
      Rank.Three => "3",
      Rank.Four => "4",
      Rank.Five => "5",
      Rank.Six => "6",
      Rank.Seven => "7",
      Rank.Eight => "8",
      Rank.Nine => "9",
      Rank.Ten => "10",
      Rank.Jack => "J",
      Rank.Queen => "Q",
      Rank.King => "K",
      _ => throw new ArgumentOutOfRangeException(),
    };
    Console.WriteLine($"|{suitRep}  |");
    Console.WriteLine("|   |");
    if (rankRep == "10") { Console.WriteLine($"| {rankRep}|\n"); } else { Console.WriteLine($"|  {rankRep}|\n"); };
  }
}
}

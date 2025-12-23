namespace LiarsDice
{
    public struct Bid
    {
        public int face;
        public int quant;
    }
    public class Table
    {
        public Bid bid;
        public Player player;
        public Computer computer;

        public Table()
        {
            this.bid.face = 1;
            this.bid.quant = 0;
            this.player = new Player();
            this.computer = new Computer();
        }

        public void GameLoop()
        {
            while (player.Cup.Count > 0 && computer.Cup.Count > 0)
            {
                player.Roll();
                player.DisplayDice();
                Console.WriteLine("\n1 - Raise Bid\n2 - Call Liar");
                var choice = Console.ReadKey();
                switch (choice.Key)
                {
                    case ConsoleKey.D1:
                        bid = player.RaiseBid(bid); break;
                    case ConsoleKey.D2:
                        CallLiar(player, computer); break;
                    default:
                        Console.WriteLine("bad input"); break;
                }

                computer.Roll();
                Random rnd = new Random();
                if (rnd.Next(0, 4) == 1) { Console.WriteLine("Computer Called Liar"); CallLiar(computer, player); }
                else { Console.WriteLine("Computer Raised Bid"); computer.RaiseBid(bid); OutputBid(); }
            }
            if (player.Cup.Count > 0) { Console.WriteLine("Player wins."); System.Environment.Exit(0); }
            else { Console.WriteLine("Computer wins."); System.Environment.Exit(0); }
        }

        public void CallLiar(Pirate player, Pirate prev_player)
        {
            player.DisplayDice();
            prev_player.DisplayDice();
            int validBidCount = player.Cup.Count(dice => dice.value == this.bid.face);
            if (validBidCount < this.bid.quant)
            {
                prev_player.Cup.RemoveAt(prev_player.Cup.Count - 1);
                Console.WriteLine("the previous bidder has lost a die for lying");
                this.bid.face = 1;
                this.bid.quant = 0;
            }
            else
            {
                Console.WriteLine("bid was valid, Accuser has lost a die");
                player.Cup.RemoveAt(prev_player.Cup.Count - 1);
            }
        }
        public void OutputBid()
        {
            Console.WriteLine($"Current Face Bid: {this.bid.face}");
            Console.WriteLine($"Current Quantity Bid: {this.bid.quant}");
        }
    }
}

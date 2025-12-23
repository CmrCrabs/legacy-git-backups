namespace LiarsDice
{
    public abstract class Pirate
    {
        public List<Dice> Cup;

        public Pirate()
        {
            this.Cup = Enumerable.Range(0, 5).Select(_ => new Dice()).ToList();
        }
        public void Roll() { foreach (var dice in this.Cup) { dice.Roll(); } }

        public void DisplayDice()
        {
            int i = 1;
            foreach (var dice in this.Cup)
            {
                Console.WriteLine($"Dice {i}: {dice.value}");
                i++;
            }
        }
        public abstract Bid RaiseBid(Bid table_bid);
    }


    public class Player : Pirate
    {
        public override Bid RaiseBid(Bid table_bid)
        {
            Bid bid = new Bid();
            Console.Write("\nFace Value (1-6): ");
            bid.face = Convert.ToInt32(Console.ReadLine());
            bool real = false;
            do
            {
                Console.Write("Quantity: ");
                int fake = Convert.ToInt32(Console.ReadLine());
                if (fake > table_bid.quant)
                {
                    bid.quant = fake;
                    real = true;
                }
            } while (!real);
            return bid;
        }
    }

    public class Computer : Pirate
    {
        public override Bid RaiseBid(Bid table_bid)
        {
            Random rnd = new Random();
            Bid bid;
            bid.face = rnd.Next(1, 7);
            bid.quant = rnd.Next(1, 10);
            return bid;
        }
    }
}

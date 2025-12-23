namespace LiarsDice;
class Program
{
    static void Main(string[] args)
    {
        Menu.ShowMenu();
    }
}
public class Constants
{
    public const string InstructionsPath = "./Instructions.txt";
}
public class Dice
{
    public int value;
    public Dice()
    {
        this.value = Roll();
    }
    public int Roll()
    {
        Random rand = new Random();
        return rand.Next(0, 6) + 1;
    }
}

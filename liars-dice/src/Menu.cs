namespace LiarsDice
{
    public class Menu
    {
        public static void ShowMenu()
        {
            Console.Clear();
            Console.WriteLine("Menu:\n1 - Play \n2 - View Instructions\n3- Quit");
            Console.WriteLine("Setting(s) can be changed in src/Program.cs");

            var choice = Console.ReadKey();
            switch (choice.Key)
            {
                case ConsoleKey.D1:
                    Console.Write("\n\n");
                    Table table = new Table();
                    table.GameLoop();
                    break;
                case ConsoleKey.D2:
                    ReadInstructions();
                    while (true)
                    {
                        var input = Console.ReadKey();
                        if (input.Key == ConsoleKey.Escape) { break; }
                        Menu.ReadInstructions();
                    }
                    Menu.ShowMenu();
                    break;
                case ConsoleKey.D3:
                    System.Environment.Exit(0);
                    break;
                default:
                    Menu.ShowMenu();
                    break;
            }

        }
        public static void ReadInstructions()
        {
            Console.Clear();
            Console.WriteLine(File.ReadAllText(Constants.InstructionsPath));
            Console.WriteLine("Esc - Return To Main Menu");
        }
    }
}

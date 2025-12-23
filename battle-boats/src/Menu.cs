namespace BattleBoats
{
    public class Menu
    {
        // the choice to below have show menu and show game menu as seperate functions is intentional due to them having different options and function calling logic
        public static void ShowMenu()
        {
            Console.Clear();
            Console.WriteLine("Menu:\n1 - New Game\n2 - Load Game\n3 - View Instructions\n4- Quit");

            // specifically chose to use readkey over readline, as it reduces input parsing complexity and also allows the user to skip having to press enter, creating a more seamless experience
            var choice = Console.ReadKey();
            switch (choice.Key)
            {
                case ConsoleKey.D1:
                    Game.NewGame();
                    break;
                case ConsoleKey.D2:
                    Game.LoadGame();
                    break;
                case ConsoleKey.D3:
                    ReadInstructions();
                    // while true is valid here as passing a escape flag is more effort than its worth, primarily due to the order of operations here. it could be argued that its 'incorrect' programming practice however a carpenter that is scared of using their own tools is but a common man 
                    while (true)
                    {
                        var input = Console.ReadKey();
                        if (input.Key == ConsoleKey.Escape) { break; }
                        Menu.ReadInstructions();
                    }
                    Menu.ShowMenu();
                    break;
                case ConsoleKey.D4:
                    // exit code zero in order to indicate a successful exit to OS
                    System.Environment.Exit(0);
                    break;
                default:
                    Menu.ShowMenu();
                    Console.WriteLine("bad input");
                    break;
            }

        }
        public static void ReadInstructions()
        {
            Console.Clear();
            // stored as a seperate file for easy interchangeability and to prevent unneccessary loading into memory of a large string
            Console.WriteLine(File.ReadAllText(Constants.InstructionsPath));
            Console.WriteLine("Esc - Return To Main Menu");
        }
        public static void ShowGameMenu(Data data)
        {
            Console.Clear();
            Console.WriteLine("Menu:\n1 - Continue Game\n2 - View Instructions\n3- Save & Quit");

            var choice = Console.ReadKey();
            switch (choice.Key)
            {
                case ConsoleKey.D1:
                    Game.LoadGame();
                    break;
                case ConsoleKey.D2:
                    ReadInstructions();
                    var input = Console.ReadKey();
                    if (input.Key == ConsoleKey.Escape) { Menu.ShowGameMenu(data); }
                    break;
                case ConsoleKey.D3:
                    Save.SaveGame(data);
                    // exit code zero in order to indicate successful exit
                    System.Environment.Exit(0);
                    break;
                default:
                    // handles all other cases by doing nothing
                    break;
            }
        }
    }
}

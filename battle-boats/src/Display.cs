namespace BattleBoats
{
    public class Display
    {
        public static void Draw(Tile[,] PlayerMap, string text, string log)
        {
            // while not technically needed, the following code allows any backend changes to be done easily and still create an accurate output
            // below is created a list that contains every possible colour that could be outputted, which is then used in the actual rendering code to computationally generate a key.

            Array enumValues = Enum.GetValues(typeof(Tile));
            List<Tile> ColourKey = new List<Tile>();
            // getting the already set values of the enum
            for (int i = 0; i < enumValues.Length; i++)
            {
                Tile tile = (Tile)enumValues.GetValue(i);
                ColourKey.Add(tile);
            }
            // error handling + filling in any empty gaps, scales with the height specifically
            if (Constants.Height - enumValues.Length > 0)
            {
                for (int i = 0; i < (Constants.Height - enumValues.Length); i++)
                {
                    ColourKey.Add(Tile.Buffer);
                }
            }

            // actual render code
            Console.Clear();
            // allows outputting of a title to be passed onto the function call
            Console.WriteLine("       " + text);
            Console.WriteLine("_|_______________________|_ ");
            // allows it to be generated based on constants, rather than hardcoded
            for (int i = 0; i < Constants.Height; i++)
            {
                Console.Write(" |");
                for (int j = 0; j < Constants.Width; j++)
                {
                    // use of setcolor function allows simple colour changing without creating more complex methods. there are other ways of doing this that would lead to a marginally more elegant bit of code here, however would ultimately increase complexity with no real performance gain.
                    SetColor(PlayerMap[i, j]);
                    Console.Write("■");
                    Console.ResetColor();
                    Console.Write(" |");
                }
                // code for outputting the key, occurs at the end of every grid line
                Console.Write("          ");
                SetColor(ColourKey[i]);
                Console.Write("■  ");
                Console.ResetColor();
                // switch case is used as I hardcoded a few exceptions to the naming scheme, as while some names make more sense in code, it doesnt make sense to output those same names to the end user
                switch (ColourKey[i])
                {
                    case Tile.Buffer: break;
                    case Tile.Empty1: case Tile.Empty2: Console.Write("Ocean"); break;
                    default: Console.Write($"{Enum.GetName(typeof(Tile), ColourKey[i])}"); break;
                }
                Console.WriteLine();
            }
            // extra decorations
            Console.WriteLine("-|-----------------------|-");
            Console.WriteLine("       /          \\");
            Console.WriteLine("     _/_          _\\_");
            Console.WriteLine("\n    Esc - Main Menu");
            // Outputting of current code status, primarily used for outputting errors to end user. null check exists to have a nicer way of showing a lack of error message
            if (string.IsNullOrEmpty(log))
            {
                Console.WriteLine("Incoming Message: No Message");
            }
            else
            {
                Console.WriteLine("Incoming Message: " + log);
            }


            // setcolor function, done to create seperation between the 'backend and frontend', by mapping the backend's enum values to human usable colors
            static void SetColor(Tile Tile)
            {
                switch (Tile)
                {
                    case Tile.Empty1:
                        Console.ForegroundColor = ConsoleColor.Blue; break;
                    case Tile.Empty2:
                        Console.ForegroundColor = ConsoleColor.DarkBlue; break;
                    case Tile.Boat:
                        Console.ForegroundColor = ConsoleColor.DarkGray; break;
                    case Tile.Wreckage:
                        Console.ForegroundColor = ConsoleColor.Black; break;
                    case Tile.Hit:
                        Console.ForegroundColor = ConsoleColor.Red; break;
                    case Tile.Miss:
                        Console.ForegroundColor = ConsoleColor.Magenta; break;
                    case Tile.Using:
                        Console.ForegroundColor = ConsoleColor.DarkGreen; break;
                    case Tile.Buffer: Console.ForegroundColor = ConsoleColor.Black; break;
                }

            }
        }
    }
}

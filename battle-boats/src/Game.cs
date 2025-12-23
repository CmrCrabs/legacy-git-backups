namespace BattleBoats
{
    // Class of data used for easy function parameter passing and in order to facilitate persistence methodology, more info there.
    // uses custom types, which are explained where they are created
    public class Data
    {
        public Tile[,] PlayerMap = new Tile[Constants.Height, Constants.Width];
        public Tile[,] ComputerMap = new Tile[Constants.Height, Constants.Width];
        public List<Captain.BoatMap> PlayerFleetMap = new List<Captain.BoatMap>();
        public List<Captain.BoatMap> ComputerFleetMap = new List<Captain.BoatMap>();
    }

    public class Game
    {
        public static void NewGame()
        {
            Data data = new Data();
            GenMap(data.PlayerMap);
            GenMap(data.ComputerMap);
            
            // Due to the use of an abstract class, said class needs to be initialised as a variable with the type specified in the class that inherited said abstract
            Player player = new Player();
            data.PlayerMap = player.SetShipPos(data);

            Computer computer = new Computer();
            data.ComputerMap = computer.SetShipPos(data);

            Game.Run(player, computer, data);
        }

        public static void LoadGame()
        {
            Data data = Load.LoadGame();
            // there is no point in saving / loading the abstract class creations, as creating them again has little performance overhead whilst significantly simplifying implementation
            Player player = new Player();
            Computer computer = new Computer();
            Game.Run(player, computer, data);
        }

        // creation of a run function, while seeming redundant, is intentional as it allows easy swapping of the data mid runtime if so inclined
        public static void Run(Player player, Computer computer, Data data)
        {
            // while true is valid here as passing back a endflag is more bloat then while (true) 
            while (true) // <-- peak
            {
                // there is no need for a distinct 'turn swapping' system as running the turns sequentially achieves the same result. this would not affect a loaded games ability to run as the 2 'breakpoints' where a game can be exited both occur where restarting would result in beginning with the players turn
                player.Turn(data);
                computer.Turn(data);
                Display.Draw(data.PlayerMap, "Your Board", "The Computer has fired at the position indicated above. Press Any Key To Begin Firing");
                // whilst the escape breakpoint is only checked at the end of a turn 'cycle', it is ok as it is similarly checked during the player turn so there is not a moment in time where the player cannot safely exit.
                var input = Console.ReadKey();
                if (input.Key == ConsoleKey.Escape) { Save.SaveGame(data); Menu.ShowGameMenu(data); }
            }
        }
        
        // simple code to alternate the Tile.Empties in a chequered pattern, in order to subtly imitate a wave effect.
        // serves no technical purpose, just cosmetic
        public static Tile[,] GenMap(Tile[,] Map)
        {
            for (int i = 0; i < Constants.Height; i++)
            {
                for (int j = 0; j < Constants.Width; j++)
                {
                    if ((j % 2 == 0 && i % 2 == 0) || (j % 2 == 1 && i % 2 == 1))
                    {
                        Map[i, j] = Tile.Empty1;
                    }
                    else { Map[i, j] = Tile.Empty2; }
                }
            }
            return Map;
        }
    }
}

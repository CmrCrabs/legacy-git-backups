namespace BattleBoats
{
    // custom enumerable, used in order to greatly simplify the data structure used for the game map
    // also serves to decouple the game logic from the rendering, as the enum values are not directly rendered, just parsed and then a corresponding action is performed.
    public enum Tile
    {
        Empty1,
        Empty2,
        Boat,
        Wreckage,
        Hit,
        Miss,
        Using,
        Buffer,
    }

    
    // effectively functions as the games 'settings'
    // allows easy configuration of most parameters that make sense to be, primarily those that actually affect gameplay.
    public class Constants
    {
        public const int Width = 8;
        public const int Height = 8;
        public const string InstructionsPath = "./Documentation/Instructions.txt";
        public const string SaveGamePath = "./savegame.json";
        public const int WindowWidth = 100;
        public const int WindowHeight = 100;
        // custom datatype used to create the fleet, better than creating a set of 2D arrays as it is easier to parse
        public struct boat
        {
            public int quantity;
            public int length;
        }

        // number of boats used can be easily changed here
        public static readonly List<boat> Fleet = new List<boat>()
        {
          new boat() {quantity = 2, length = 4},
          new boat() {quantity = 1, length = 3},
          new boat() {quantity = 1, length = 2},
        };
    }
}

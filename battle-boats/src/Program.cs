namespace BattleBoats
{

    class Program
    {
        static void Main(string[] args)
        {
            // OS Specific, as direct control of terminal is (rightfully) not possible on unix based systems.
            Console.Clear();
            if (OperatingSystem.IsWindows())
            {
                // Done to ensure UI is correctly formatted and doesnt break (bigger than required with current constants)
                Console.SetWindowSize(Constants.WindowWidth, Constants.WindowHeight);
            }
            else
            {
                // effectively serves as awarning / disclaimer  that the used terminal may be too small and to be conscious of it if something where to go wrong
                Console.WriteLine("Please ensure terminal is of adequate size in order to fit the following UI. Press Any Key To Continue");
                Console.ReadKey();
            }
            Menu.ShowMenu();
        }
    }
}

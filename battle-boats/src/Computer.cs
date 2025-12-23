namespace BattleBoats
{
    // indicates this class is an implementation of the captain abstract
    public class Computer : Captain
    {
        public override void Turn(Data data)
        {
            // run upon every turn cycle, checks what is required when needed
            (int, int) Coordinate = ChooseTarget(data);
            if (Hit(data.PlayerMap, Coordinate))
            {
                if (Sunk(data.PlayerFleetMap, data.PlayerMap, Coordinate))
                {
                    if (Victory(data.PlayerFleetMap, data.PlayerMap))
                    {
                        Console.Clear();
                        Console.WriteLine("Computer Wins.");
                        System.Environment.Exit(-1);
                    }
                }
            }
            else
            {
                data.PlayerMap[Coordinate.Item1, Coordinate.Item2] = Tile.Miss;
            }
        }
        // randomly chooses coordinates on the map, and then determines whether the are valid using the same checks that occurs for the player
        public override Tile[,] SetShipPos(Data data)
        {
            foreach (var boat in Constants.Fleet)
            {
                for (int i = 0; i < boat.quantity; i++)
                {
                    bool placed = false;
                    while (!placed)
                    {
                        Random rand = new Random();
                        (int, int) Coordinate = (rand.Next(0, Constants.Width), rand.Next(0, Constants.Height));
                        // nice implementation for randomly generating a boolean, it is possible there is a less verbose method but I couldnt find one.
                        bool rotation = rand.NextDouble() >= 0.5;

                        // running all checks to see if placement is valid
                        if (
                              CoordinateIsValid(Coordinate, data.ComputerMap, rotation, boat.length)
                              && PlacementIsValid(data.ComputerMap, rotation, Coordinate, boat.length)
                              && RotationIsValid(rotation, Coordinate, boat.length)
                            )
                        {
                            // saving to fleetmap
                            var boatmap = new BoatMap();
                            boatmap.Coordinate = Coordinate;
                            boatmap.Length = boat.length;
                            boatmap.Rotation = rotation;
                            data.ComputerFleetMap.Add(boatmap);
                            // saving to actual map
                            switch (rotation)
                            {
                                case true:
                                    for (int j = 0; j < boat.length; j++) { data.ComputerMap[Coordinate.Item1, Coordinate.Item2 + j] = Tile.Boat; }
                                    break;

                                case false:
                                    for (int j = 0; j < boat.length; j++) { data.ComputerMap[Coordinate.Item1 + j, Coordinate.Item2] = Tile.Boat; }
                                    break;
                            }
                            placed = true;

                        }
                    }

                }
            }
            return data.ComputerMap;
        }

        // randomly selectes a target and then checks if it is valid
        public override (int, int) ChooseTarget(Data data)
        {
            bool TargetSelected = false;
            (int, int) Coordinate = (0, 0);
            while (!TargetSelected)
            {
                Random rand = new Random();
                Coordinate = (rand.Next(0, Constants.Width), rand.Next(0, Constants.Height));
                // i am also sorry
                if ((Coordinate.Item1 >= 0 && Coordinate.Item1 < Constants.Height) && (Coordinate.Item2 >= 0 && Coordinate.Item2 < Constants.Width) && (data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Hit || data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Wreckage)) { TargetSelected = true; }
            }
            return Coordinate;
        }
    }
}

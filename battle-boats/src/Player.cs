namespace BattleBoats
{
    // indicates this class is an implementation of the captain abstract
    public class Player : Captain
    {
        // run upon every turn cycle, checks what is required when needed
        public override void Turn(Data data)
        {
            (int, int) Coordinate = ChooseTarget(data);
            if (Hit(data.ComputerMap, Coordinate))
            {
                if (Sunk(data.ComputerFleetMap, data.ComputerMap, Coordinate))
                {
                    if (Victory(data.ComputerFleetMap, data.ComputerMap))
                    {
                        Console.Clear();
                        Console.WriteLine("Player Wins.");
                        System.Environment.Exit(-1);
                    }
                }
            }
            else
            {
                data.ComputerMap[Coordinate.Item1, Coordinate.Item2] = Tile.Miss;
            }
        }

        
        // given the declared fleet, will place the ships
        public override Tile[,] SetShipPos(Data data)
        {
            string log = "";
            // the 4 layers of for loops, while seemingly unneccessary, are all required in order to go through all declared boats in a clean, scaleable way
            foreach (var boat in Constants.Fleet)
            {
                for (int j = 0; j < boat.quantity; j++)
                {
                    // creation of a buffermap is due to rendering, as in order to show the movement of the players 'cursor' the underlying enum values must be changed, however for the returned playerfleet this should not be the case.
                    Tile[,] BufferMap = new Tile[Constants.Height, Constants.Width];
                    for (int m = 0; m < Constants.Height; m++)
                    {
                        for (int n = 0; n < Constants.Width; n++)
                        {
                            BufferMap[m, n] = data.PlayerMap[m, n];
                        }
                    }

                    // initialising player 'cursor'
                    for (int i = 0; i < boat.length; i++) { BufferMap[i, 0] = Tile.Using; }
                    // reason for a previous coordinate is rendering method, explained where used
                    (int, int) Coordinate = (0, 0);
                    (int, int) Prev_Coordinate = (0, 0);

                    bool placed = false;
                    bool rotation = false;
                    while (!placed)
                    {
                        Prev_Coordinate = Coordinate;
                        Display.Draw(BufferMap, "Placing Boats", log);

                        // parsing the player input. a switch case is the most performant option available
                        var input = Console.ReadKey();
                        switch (input.Key)
                        {
                            case ConsoleKey.Enter:
                                // outputting to the player the status of the placement in the else
                                if (PlacementIsValid(data.PlayerMap, rotation, Coordinate, boat.length)) { placed = true; } else { log = "Invalid Placement"; }
                                break;

                            case ConsoleKey.W:
                            case ConsoleKey.UpArrow:
                                if (CoordinateIsValid((Coordinate.Item1 - 1, Coordinate.Item2), data.PlayerMap, rotation, boat.length)) { Coordinate.Item1 -= 1; };
                                break;

                            case ConsoleKey.A:
                            case ConsoleKey.LeftArrow:
                                if (CoordinateIsValid((Coordinate.Item1, Coordinate.Item2 - 1), data.PlayerMap, rotation, boat.length)) { Coordinate.Item2 -= 1; };
                                break;

                            case ConsoleKey.S:
                            case ConsoleKey.DownArrow:
                                if (CoordinateIsValid((Coordinate.Item1 + 1, Coordinate.Item2), data.PlayerMap, rotation, boat.length)) { Coordinate.Item1 += 1; };
                                break;

                            case ConsoleKey.D:
                            case ConsoleKey.RightArrow:
                                if (CoordinateIsValid((Coordinate.Item1, Coordinate.Item2 + 1), data.PlayerMap, rotation, boat.length)) { Coordinate.Item2 += 1; };
                                break;

                            case ConsoleKey.Escape:
                                Save.SaveGame(data);
                                Menu.ShowGameMenu(data);
                                break;
                            case ConsoleKey.R:
                                if (RotationIsValid(rotation, Coordinate, boat.length))
                                {
                                    rotation ^= true;
                                    // for logic on why a switch, see line 27 in abstracts.cs
                                    switch (rotation)
                                    {
                                        case true:
                                            for (int i = 0; i < boat.length; i++) { BufferMap[Prev_Coordinate.Item1 + i, Prev_Coordinate.Item2] = data.PlayerMap[Prev_Coordinate.Item1 + i, Prev_Coordinate.Item2]; }
                                            break;
                                        case false:
                                            for (int i = 0; i < boat.length; i++) { BufferMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2 + i] = data.PlayerMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2 + i]; }
                                            break;
                                    }
                                }
                                else
                                {
                                    // outputting to the player the status of the rotation
                                    log = "Rotation Is Invalid";
                                }
                                break;

                            default:
                                break;
                        }
                        // here we clear the previous 'using' enums, and then redraw the new positon of the player cursor using the above augmented coordinates
                        switch (rotation)
                        {
                            case true:
                                for (int i = 0; i < boat.length; i++) { BufferMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2 + i] = data.PlayerMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2 + i]; }
                                for (int i = 0; i < boat.length; i++) { BufferMap[Coordinate.Item1, Coordinate.Item2 + i] = Tile.Using; }
                                break;

                            case false:
                                for (int i = 0; i < boat.length; i++) { BufferMap[Prev_Coordinate.Item1 + i, Prev_Coordinate.Item2] = data.PlayerMap[Prev_Coordinate.Item1 + i, Prev_Coordinate.Item2]; }
                                for (int i = 0; i < boat.length; i++) { BufferMap[Coordinate.Item1 + i, Coordinate.Item2] = Tile.Using; }
                                break;
                        }
                        
                        // locking in the placements of the boats onto the players actual grid instead of the buffer grid
                        if (placed)
                        {
                            switch (rotation)
                            {
                                case true:
                                    for (int i = 0; i < boat.length; i++) { data.PlayerMap[Coordinate.Item1, Coordinate.Item2 + i] = Tile.Boat; }
                                    break;

                                case false:
                                    for (int i = 0; i < boat.length; i++) { data.PlayerMap[Coordinate.Item1 + i, Coordinate.Item2] = Tile.Boat; }
                                    break;
                            }
                            // doing via a seperate data structure instead of all in one should in theory be more performant as less read writes would have to be done
                            var boatmap = new BoatMap();
                            boatmap.Coordinate = Coordinate;
                            boatmap.Length = boat.length;
                            boatmap.Rotation = rotation;
                            data.PlayerFleetMap.Add(boatmap);
                            log = "Boat Placed";
                        }
                    }
                }
            }
            return data.PlayerMap;
        }


        public override (int, int) ChooseTarget(Data data)
        {
            string log = "";
            bool TargetSelected = false;
            // the logic for a buffermap and prev_coordinate is the same as in placingboats
            (int, int) Coordinate = (0, 0);
            (int, int) Prev_Coordinate = (0, 0);
            Tile[,] BufferMap = new Tile[Constants.Height, Constants.Width];
            Game.GenMap(BufferMap);
            Tile[,] EmptyMap = new Tile[Constants.Height, Constants.Width];
            Game.GenMap(EmptyMap);
            // creating an obfuscated version of the computers grid, as it allows the player to see where they have fired before without giving away the positons of the enemy boats
            for (int i = 0; i < data.ComputerMap.GetLength(0); i++)
            {
                for (int j = 0; j < data.ComputerMap.GetLength(1); j++)
                {
                    // potentially use switch here, but yeah
                    if (data.ComputerMap[i, j] == Tile.Miss) { EmptyMap[i, j] = Tile.Miss; }
                    else if (data.ComputerMap[i, j] == Tile.Wreckage) { EmptyMap[i, j] = Tile.Wreckage; }
                    else if (data.ComputerMap[i, j] == Tile.Hit) { EmptyMap[i, j] = Tile.Hit; }
                }
            }
            // performing a deep copy, as a shallow copy would lead to erroneous data
            BufferMap = (Tile[,])EmptyMap.Clone();
            BufferMap[Coordinate.Item1, Coordinate.Item2] = Tile.Using;

            while (!TargetSelected)
            {
                Prev_Coordinate = Coordinate;
                Display.Draw(BufferMap, "Choosing Target", log);
                var input = Console.ReadKey();
                switch (input.Key)
                {
                    case ConsoleKey.Enter:
                        // im sorry
                        if ((Coordinate.Item1 < Constants.Height && Coordinate.Item1 >= 0) && ((Coordinate.Item2) <= Constants.Width && Coordinate.Item2 >= 0) && data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Hit && data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Wreckage && data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Hit && data.ComputerMap[Coordinate.Item1, Coordinate.Item2] != Tile.Miss)
                        {
                            TargetSelected = true;
                        }
                        else
                        {
                            // outputting status of firing to player
                            log = "Selected Target Is Invalid";
                        }
                        break;

                    case ConsoleKey.W:
                    case ConsoleKey.UpArrow:
                        if (Coordinate.Item1 > 0) { Coordinate.Item1 -= 1; }
                        break;

                    case ConsoleKey.A:
                    case ConsoleKey.LeftArrow:
                        if ((Coordinate.Item2 > 0)) { Coordinate.Item2 -= 1; }
                        break;

                    case ConsoleKey.S:
                    case ConsoleKey.DownArrow:
                        if (Coordinate.Item1 < (Constants.Height - 1)) { Coordinate.Item1 += 1; }
                        break;

                    case ConsoleKey.D:
                    case ConsoleKey.RightArrow:
                        if (Coordinate.Item2 < (Constants.Width - 1)) { Coordinate.Item2 += 1; }
                        break;

                    case ConsoleKey.Escape:
                        Save.SaveGame(data);
                        Menu.ShowGameMenu(data);
                        break;

                    default:
                        break;
                }

                // here is where we clear the previous 'using' enums and then redraw the 'using' enums at the new position as specified by the coordinates
                BufferMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2] = EmptyMap[Prev_Coordinate.Item1, Prev_Coordinate.Item2];
                BufferMap[Coordinate.Item1, Coordinate.Item2] = Tile.Using;
            }
            return Coordinate;
        }
    }
}

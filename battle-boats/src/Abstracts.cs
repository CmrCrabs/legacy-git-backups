namespace BattleBoats
{
    // The head of a fleet would be the captain so the name is logically based
    // an abstract class is used here as both 'player' and 'computer' use structurally similar code, with only some functions having differing implementations. By using an abstract I am able to more efficiently create both classes and reduce redundant code.
    public abstract class Captain
    {
        // struct of boatmap is used for easier data parsing.
        // this data type is used in FleetMaps, in order to allow easy determining of boat sinking and victory.
        public struct BoatMap
        {
            public (int, int) Coordinate;
            public int Length;
            public bool Rotation;
            public bool Sunk;
        }

        // abstract functions, that are then overriden when a class inherits the abstract
        public Tile[,] Map;
        public abstract void Turn(Data data);
        public abstract Tile[,] SetShipPos(Data data);
        public abstract (int, int) ChooseTarget(Data data);

        // used to check whether if a coordinate is valid, for movement purposes rather than any final placements
        public bool CoordinateIsValid((int, int) Coordinate, Tile[,] Map, bool Rotation, int length)
        {
            bool valid = false;
            // note that, throughout the program, a switch case is used for rotation instead of an if else combo. whilst technically an if else combo is more logical, I feel that using a switch is clearer to anyone reading the code and makes more sense in terms of mapping the true / false boolean to a horizontal / vertical rotation.
            // just as in all other switches for rotation, the only difference is that when iterating for the length of the specified boat, instead of moving horizontally, the code moves vertically (or vice versa)
            switch (Rotation)
            {
                case true:
                    if ((Coordinate.Item1 < Constants.Height && Coordinate.Item1 >= 0) && ((Coordinate.Item2 + length) <= Constants.Width && Coordinate.Item2 >= 0)) { valid = true; } break;

                case false:
                    if (((Coordinate.Item1 + length) <= Constants.Height && Coordinate.Item1 >= 0) && (Coordinate.Item2 < Constants.Width && Coordinate.Item2 >= 0)) { valid = true; } break;
            }
            return valid;
        }

        // used to check if the final placement of a boat is valid
        public bool PlacementIsValid(Tile[,] Map, bool Rotation, (int, int) Coordinate, int length)
        {
            bool valid = false;
            // see comment line 27 of Abstracts.cs
            switch (Rotation)
            {
                case true:
                    for (int i = 0; i < length; i++)
                    {
                        if ((Map[Coordinate.Item1, Coordinate.Item2 + i] != Tile.Boat)) { valid = true; } else { valid = false; break; };
                    }
                    break;
                case false:
                    for (int i = 0; i < length; i++)
                    {
                        if ((Map[Coordinate.Item1 + i, Coordinate.Item2] != Tile.Boat)) { valid = true; } else { valid = false; break; };
                    }
                    break;
            }
            return valid;
        }

        // used to determine whether a rotation will leave the further parts of the boat out of bounds
        public bool RotationIsValid(bool Rotation, (int, int) Coordinate, int length)
        {
            bool valid = false;
            switch (Rotation)
            {
                case true:
                    if ((Coordinate.Item1 + length) <= Constants.Height) { valid = true; }
                    break;
                case false:
                    if ((Coordinate.Item2 + length) <= Constants.Width) { valid = true; }
                    break;
            }
            return valid;
        }

        // determines whether a specified coordinate, when shot at, would be a hit or miss
        public bool Hit(Tile[,] Map, (int, int) Coordinate)
        {
            bool hit = false;
            if (Map[Coordinate.Item1, Coordinate.Item2] == Tile.Boat)
            {
                hit = true;
                Map[Coordinate.Item1, Coordinate.Item2] = Tile.Hit;
            }
            return hit;
        }

        // this code is only run upon a hit being confirmed, so the arguably 'suboptimal' implementation is okay as dedicating more time for a more performant solution will lead to no percievable performance change.
        // using the fleetmap declared above, this code determines whether or not the previously confirmed hit has resulted in the sinking of a boat
        // if a boat has been sunk it then will change all hits to wreckages, to convey this fact to the player.
        public bool Sunk(List<BoatMap> FleetMap, Tile[,] Map, (int, int) Coordinate)
        {
            bool sunk = false;
            int j = 0;
            // the use of a bufferfleet is done to allow changing of the data that is being enumerated over
            var BufferFleet = new List<BoatMap>();
            // .addrange, while technically not the 'correct' way of performing a deep copy, is done as the list consists of a custom type that does not implement the .clone method
            BufferFleet.AddRange(FleetMap);

            foreach (var boat in BufferFleet)
            {
                switch (boat.Rotation)
                {
                    case true:
                        for (int i = 0; i < boat.Length; i++)
                        {
                            if (Map[boat.Coordinate.Item1, boat.Coordinate.Item2 + i] == Tile.Hit) { sunk = true; } else { sunk = false; break; }
                        }
                        break;
                    case false:
                        for (int i = 0; i < boat.Length; i++)
                        {
                            if (Map[boat.Coordinate.Item1 + i, boat.Coordinate.Item2] == Tile.Hit) { sunk = true; } else { sunk = false; break; }
                        }
                        break;
                }
                if (sunk)
                {
                    switch (boat.Rotation)
                    {
                        case true:
                            for (int i = 0; i < boat.Length; i++) { Map[boat.Coordinate.Item1, boat.Coordinate.Item2 + i] = Tile.Wreckage; }
                            break;
                        case false:
                            for (int i = 0; i < boat.Length; i++) { Map[boat.Coordinate.Item1 + i, boat.Coordinate.Item2] = Tile.Wreckage; }
                            break;
                    }
                    // updating the fleetmap for usage when checking victory
                    var BufferBoat = FleetMap[j];
                    BufferBoat.Sunk = true;
                    FleetMap[j] = BufferBoat;
                    break;
                }
                // this iteration variable is declared solely for use in updating fleetmap, as a foreach loop does not have a count
                j++;
            }
            return sunk;
        }

        // this code is only run upon a sink being confirmed, so the implementation is okay as dedicating more time for a more performant solution will lead to no percievable performance change.
        // using the fleetmap declared above, this code determines whether or not the previously confirmed sink has resulted in all boats in the fleet being sunk
        // if so, it will return a true bool, where the abstract implementation will choose what will occur ( a specific victory message )
        public bool Victory(List<BoatMap> FleetMap, Tile[,] Map)
        {
            bool victory = true;
            foreach (var boat in FleetMap)
            {
                if (boat.Sunk == false)
                {
                    victory = false;
                }
            }
            return victory;
        }

        public Captain()
        {
            this.Map = new Tile[Constants.Height, Constants.Width];
        }
    }
}

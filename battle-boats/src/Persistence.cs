// very useful c# library to allow universal (de)serialisation of json
// key factor being includes custom types, which native system json does not support (as far as i know)
using Newtonsoft.Json;

namespace BattleBoats
{
    // can be argued that having 2 seperate classes for this is redundant, however i believe that this allows for easy expansion and by extension a cleaner developer experience
    class Save
    {
        public static void SaveGame(Data data)
        {
            File.Create(Constants.SaveGamePath).Close();
            string json = JsonConvert.SerializeObject(data);
            File.WriteAllText(Constants.SaveGamePath, string.Empty);
            File.WriteAllText(Constants.SaveGamePath, json);
        }
    }

    class Load
    {
        public static Data LoadGame()
        {
            string json = File.ReadAllText(Constants.SaveGamePath);
            Data data = JsonConvert.DeserializeObject<Data>(json);
            return data;
        }
    }
}

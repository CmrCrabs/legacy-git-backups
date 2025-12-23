const express = require("express");
const body_parser = require("body-parser");
const mongoose = require("mongoose");
const Users = require('./schemas/user')
const UserRouter = require('./Routes/userRouter')
const noteRouter = require('./Routes/noteRouter')

const userSchema = require("./schemas/user");

//for mongodb database connection
const password = "h1YvByk2Bgf4VtsE";
const url =
  "mongodb+srv://user:h1YvByk2Bgf4VtsE@cluster0.l05haxs.mongodb.net/?retryWrites=true&w=majority";

const app = express();

app.use(express.json());


app.get('/api' , (req , res) => {
  res.send("Tyrone")
})
app.get('/' , (req , res) => {
  res.send("Tyrone")
})
app.use('/api/users' , UserRouter)
app.use('/api/notes' , noteRouter)
app.listen(3001);
// app.use(express.static("./client/dist"));
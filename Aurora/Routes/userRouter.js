const express = require('express')
const { default: mongoose } = require('mongoose')
const Users = require('../schemas/user')
const Notes = require('../schemas/note')
const router = express.Router()


mongoose.connect('mongodb://localhost/Aurora' , () => {
    console.log("Connected")
})
router.post('/login' , async (req , res) => {
    console.log("Login")
    let details = req.body.details 
    let password = req.body.password
    try {
        var user;
        //find user
        if (details.includes("@")){
            user = await Users.findOne({email : details});
        }else{
            user = await Users.findOne({username : details}).populate;
        }
        //attempt to login
        if (user.password == password){
            // let x = await user.populate('notes')
            // console.log(x)
            res.send(user)
        }else{
            res.send("Password or username is incorrect")
        }
    } catch (error) {
        res.send(error)
    }
})
router.get('/details' , async (req ,res) => {
    // /details?account=uid
    try {
        const uid = req.query.account
        const user = await Users.findById(uid)
        if (user == null){
            res.send("User does not exist")
        }else{
            res.send({
                name : user.name,
                username : user.username,
                email : user.email,
                dateOfBirth : user.dateOfBirth,
                notes : user.notes
            })
        }
    } catch (error) {
        res.send(error)
    }
})

router.post('/new' , async (req , res) => {
    try {
        const name = req.body.name
        const username = req.body.username
        const email = req.body.email
        const password = req.body.password 
        const dateOfBirth = req.body.dateOfBirth  
        if (await Users.exists().where("email").equals(email) == null && await Users.exists().where("username").equals(username) == null){
            let user = new Users({
                name : name,
                username : username,
                email : email,
                password : password,
                dateOfBirth : dateOfBirth,
            })  
            user.notes = await createNote(user._id)
            await user.save()
            res.status(201).json({
                uid : user._id,
            })
        }else{
            res.send("User with that email or username already exists")
        }
    } catch (error) {
        res.send(error.message)
    }
})
router.delete('/delete' , async (req , res) => {
    // /delete?acccount=uid
    try {
        let x = await Users.findById(req.query.account)
        if (x == null){
            res.send("user does not exist")
        }else {
            let y = await x.delete()
            res.send("user has been succesfuly deleteted")
        }
    } catch (error) {
        res.send(error)
    }
})
router.post('/update' , async (req , res) =>{
    // /update?account=uid
    const uid = req.query.account 
    const user = await Users.findById(uid)
    if (user == null){
        res.send("User does not exist")
    }else{
        user.name = req.body.name == undefined ? user.name : req.body.name
        user.username = req.body.username == undefined ? user.username : req.body.username
        user.email = req.body.email == undefined ? user.email : req.body.email
        user.password = req.body.password == undefined ? user.password : req.body.password 
        console.log(req.body.username)
        try {
            console.log(await user.save())
            res.send(user)
        } catch (error) {
            res.send(error.message)
        }
    }
})




async function createNote(uid){
    console.log(uid)
    let before = await Notes.exists({owner : uid.toString()})
    if (before == null){
        let x = await Notes.create({
            owner : uid,
            notes : []
        })
        return x._id
    }else{
        return before._id
    }
}
module.exports = router
const express = require('express')
const Notes = require('../schemas/note')
const router = express.Router()

router.post('/new/:uid' , async ( req , res) => {
    try {
        const notes = await Notes.findOne({owner : req.params.uid})
        console.log(notes)
        console.log(req.body.username)
        notes.notes.push({
            title : (req.body.title == undefined ? "Untitled" : req.body.title),
            text : (req.body.text == undefined ? "Start Writing Here" : req.body.text)
    
        })
        await notes.save()
        res.send(notes)
    } catch (error) {
        res.send(error)
    }
})
router.get('/view/all/:uid' , async (req , res) => {
    try {
        const notes = await Notes.findOne({owner : req.params.uid})
        if (notes == null){
            res.send("User not found")
        }else{
            res.send(notes)
        }
    } catch (error) {
        res.send(error)
    }
})
router.get('/view/one/:uid' ,  async (req , res) => {
    try {
        const uid = req.params.uid
        const note_id = req.body.note_id
        const note = await Notes.findOne({owner : uid})
        res.send(note.getNote(note_id))
    } catch (error) {
        res.send(error)
    }
})
router.delete('/delete/:uid/' , async (req , res) => {
    console.log("Delete")
    try {
        const note = await Notes.findOne({owner : req.params.uid}) //find the notes
        let x = note.getNote(req.query.note_id) //get index of the note_id
        if (x !== -1){
            note.notes.splice(x , 1)
            await note.save()
            res.send(note)
        }else{
            res.send("Note does not exist")
        }
    } catch (error) {
        res.send(error)
    }
})

router.post("/save/:uid" , async (req , res) => {
    console.log(req.params.uid)
    try {
        const note = await Notes.findOne({owner : req.params.uid}) //find hte note
        note.notes = req.body.notes //completley change notes
        await note.save()
        res.send(note)
    } catch (error) {
        res.send(error)
    }
})

module.exports = router
const mongoose = require('mongoose')
const Users = require('./user')
const noteSchema = new mongoose.Schema({
    owner : {
        type : mongoose.Schema.Types.ObjectId,
        ref : 'users'
    },
    count : {
        type : Number,
        default : 1,
    },
    notes : [
        {
            title : {
                type : String,
                default : "Untitled"
            },
            text : String,
            dateCreated : {
                type : Date,
                default : Date.now(),
                immutable : true,
            }
        }
    ]
})
noteSchema.methods.getNote = function(id){
    console.log("Inside middleware")
    let index = -1;
    for (let i = 0; i < this.notes.length; i ++){
        if (this.notes[i]._id == id){
            index = i
        }
    }
    return index
}


module.exports = mongoose.model('Notes' , noteSchema)
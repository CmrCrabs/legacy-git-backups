const mongoose = require('mongoose')
const userSchema = new mongoose.Schema({
    name : {
        type : String,
        required : [true , 'Need name'],
    },
    username : {
        type : String,
        required : [true , 'Need username'],
        validate : {
            validator : v => {
                return !v.includes("@")
            },
            message : "Username is not valid"
        }
    },
    email : {
        type : String,
        required : [true , 'Need Email'],
        lowercase : true,
        validate : {
            validator : v => {
                return v.includes("@") ? true : false
            },
            message : "This is not a valid email"
        }
    },
    password : {
        type : String,
        required : true,
        validate : {
            validator : v => {
                console.log(v.length)
                if (containsUppercase(v) && containsLowercase(v) && v.length > 7){
                    return true
                }else{
                    return false
                }
            },
            message : prop => `Password is not valid needs a uppercase and lowercase letter and at least 8 characters long`
        }
    },
    dateOfBirth : {
        type : Date,
        required : true,
    },
    notes : {
        type : mongoose.Schema.Types.ObjectId,
        ref : 'notes',
    },
    /*
    subscription : {
        default : 'Free',
        enum : ["Free" , "Personal" , "Personal Pro"],
    }*/

})
userSchema.statics.findByEmail = function(email){
    return this.findOne({email : new RegExp(email , 'i')}) //search to find by email
}
function containsUppercase(str) {
    return /[A-Z]/.test(str);
}
function containsLowercase(str) {
    return /[a-z]/.test(str);
  }
module.exports = mongoose.model('Users' , userSchema)
const { createHash } = require('crypto')
module.exports = function createHashedPassword(password){
    return createHash('sha256').update(password).digest("hex")
  }
  
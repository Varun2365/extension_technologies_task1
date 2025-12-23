const jwt = require('jsonwebtoken');

async function protect(req, res, next){

    try{

        const authHeader = req.headers.authorization;
    
        if(!authHeader || !authHeader.startsWith('Bearer ')) return res.status(400).json({error : "Unauthorized / No Token Provided"});
    
        const token = authHeader.split(' ')[1];
    
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
        req.user = decoded;
        next();
    }catch(e){
        res.status(400).json({error : "Invalid / Expired Token"})
    }
}

module.exports = protect;
'use strict';

const express = require('express');
const path = require('path');

// Constants
const PORT = 3000;
const HOST = '0.0.0.0';

// App
const app = express();
app.use(express.json());
app.use(express.static("express"));
//app.engine('html', require('express').rederFile);

app.use('/', function(req,res){
    res.sendFile(path.join(__dirname+'/express/index.html'));
    //__dirname : It will resolve to your project folder.
  });

app.get('/', (req, res) => {
    res.render(__dirname+'/express/index.html', {SECRET_WORD:process.env.SECRET_WORD});
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

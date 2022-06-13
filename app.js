const express = require('express')
const mysql = require('mysql')
const bodyParser = require('body-parser')

const connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : '',
  database: 'test'
});

connection.connect(function(err) {
  if (err) {
    console.error('error connecting: ' + err.stack);
    return;
  }
 
  console.log('connected as id ' + connection.threadId);
});

const app = express()

app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())

const port = 3000

app.get('/', (req, res) => {
  const sql = 'SELECT * FROM todos'
  connection.query(sql,(err,data)=>{
    if(err){
      res.send("Error")
    }else{
      const result = JSON.parse(JSON.stringify(data))
      console.log(result)

      res.json(result)
    }
  })
})

app.post('/addtodo',(req,res)=>{
  const sql = 'INSERT INTO todos SET ?'
  connection.query(sql,[req.body],(err,data)=>{
    if(err){
      res.send("Error"+ err)
    }else{
      res.send('Inserted')
    }
  })
})

app.delete('/deletetodo/:id',(req,res)=>{
  const sql = 'DELETE FROM todos WHERE id = ?'
  connection.query(sql,[req.params.id],(err,data)=>{
    if(err){
      res.send("Error"+ err)
    }else{
      res.send('Deleted')
    }
  })
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
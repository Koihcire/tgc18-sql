const express = require("express")
const hbs = require("hbs")
const wax = require("wax-on")
require('dotenv').config()
const mysql2 = require("mysql2/promise") // to use await async, must use the promise version of the mysql tool


const app = express()

app.set("view engine", "hbs")
wax.on(hbs.handlebars)
wax.setLayoutPath("./views/layouts")

// using forms
app.use(express.urlencoded({
    extended: false
}))

async function main(){
    const connection = await mysql2.createConnection({
        "host": process.env.DB_HOST, //host -> ip address of the database server
        "user": process.env.DB_USER,
        "database": process.env.DB_DATABASE,
        "password": process.env.DB_PASSWORD
    })

    app.get("/actors", async function(req,res){
        // connection.execute returns an array of results
        //first element is the table selected
        //second element  onwards are housekeeping data
        //first element will be stored in actors variable
        const[actors] = await connection.execute("select * from actor");
        //this is short for 
        //const results = await connection.execute("select * from actor");
        //const actors = results[0];

        res.render("actors.hbs",{
            "actors": actors
        })
        // res.send(actors)
    })

    app.get("/staff", async function(req,res){
        // array destructuring
        const[staff] = await connection.execute("select first_name, last_name, email from staff")

        res.render("staff.hbs", {
            "staff": staff
        })
        // res.send(staff)
    })

    app.get("/search", async function(req,res){

        // define the get all results query "select * from actor where true"
        let query = "select * from actor where 1"
        let bindings = []
        

        // if req.query.name is not falsely
        if(req.query.first_name){
            query += ` and first_name like ?`
            bindings.push('%' + req.query.first_name + '%')
        }
        if(req.query.last_name){
            query += ` and last_name like ?`
            bindings.push('%' + req.query.last_name + '%')
        }

        let [actors] = await connection.execute(query, bindings)

        res.render("search", {
            "actors": actors
        })

    })

} main();

app.listen(3000, function(){
    console.log("server started")
})
const express = require("express")
const hbs = require("hbs")
const wax = require("wax-on")
require("handlebars-helpers")(
    {"handlebars": hbs.handlebars}
)
require('dotenv').config() //set up the .env file
const mysql2 = require("mysql2/promise") // to use await async, must use the promise version of the mysql tool


const app = express()

app.set("view engine", "hbs")
wax.on(hbs.handlebars)
wax.setLayoutPath("./views/layouts")

// using forms
app.use(express.urlencoded({
    extended: false
}));

async function main() {
    const connection = await mysql2.createConnection({
        "host": process.env.DB_HOST, //host -> ip address of the database server
        "user": process.env.DB_USER,
        "database": process.env.DB_DATABASE,
        "password": process.env.DB_PASSWORD
    })

    app.get("/actors", async function (req, res) {
        // connection.execute returns an array of results
        //first element is the table selected
        //second element  onwards are housekeeping data
        //first element will be stored in actors variable
        const [actors] = await connection.execute("select * from actor");
        //this is short for 
        //const results = await connection.execute("select * from actor");
        //const actors = results[0];

        res.render("actors.hbs", {
            "actors": actors
        })
        // res.send(actors)
    })

    app.get("/staff", async function (req, res) {
        // array destructuring
        const [staff] = await connection.execute("select first_name, last_name, email from staff")

        res.render("staff.hbs", {
            "staff": staff
        })
        // res.send(staff)
    })

    app.get("/search", async function (req, res) {

        // define the get all results query "select * from actor where true"
        let query = "select * from actor where 1"
        let bindings = []


        // if req.query.name is not falsely
        if (req.query.first_name) {
            query += ` and first_name like ?`
            bindings.push('%' + req.query.first_name + '%')
        }
        if (req.query.last_name) {
            query += ` and last_name like ?`
            bindings.push('%' + req.query.last_name + '%')
        }

        let [actors] = await connection.execute(query, bindings)

        res.render("search", {
            "actors": actors
        })
    })

    app.get('/actors/create', async function (req, res) {
        res.render("create_actor")
    })

    app.post('/actors/create', async function (req, res) {
        //sample 
        //insert into actor (first_name, last_name) values ("Fann", "Wong");
        const query = "insert into actor(first_name, last_name) values (?,?)";
        const bindings = [req.body.first_name, req.body.last_name];
        await connection.execute(query, bindings);
        res.redirect("/actors");
    })

    app.get("/actors/:actor_id/update", async function (req, res) {
        const actorId = parseInt(req.params.actor_id);
        const query = "select * from actor where actor_id = ?";
        const [actors] = await connection.execute(query, [actorId]);
        const actorToUpdate = actors[0];
        res.render("update_actor", {
            "actor": actorToUpdate
        })
    })

    app.post("/actors/:actor_id/update", async function (req, res) {
        if (req.body.first_name.length > 45 || req.body.last_name.length > 45) {
            res.status(400);
            res.send("Invalid request")
            return;
        }
        //sample
        //update actor set first_name="Fann2", last_name="Wong2" where actor_id=201;
        const query = `update actor set first_name=?, last_name=? where actor_id=?;`
        const bindings = [req.body.first_name, req.body.last_name, parseInt(req.params.actor_id)]
        await connection.execute(query, bindings);
        res.redirect("/actors");
    })

    app.post("/actors/:actor_id/delete", async function (req, res) {
        const query = "delete from actor where actor_id = ?";
        const bindings = [parseInt(req.params.actor_id)]
        await connection.execute(query, bindings);
        res.redirect("/actors");
    })

    app.get("/categories", async function (req, res) {
        const [categories] = await connection.execute("select * from category order by name");

        res.render("categories", {
            "categories": categories
        })
    })

    app.get("/categories/create", async function (req, res) {
        res.render("create-category");
    })

    app.post("/categories/create", async function (req, res) {
        let categoryName = req.body.name;
        if (categoryName.length <= 25) {
            const query = `insert into category (name) values (?)`;

            await connection.execute(query, [categoryName]);
            res.redirect("/categories");
        } else {
            res.status(400);
            res.send("Invalid request")
        }
    })

    app.get("/categories/:category_id/update", async function (req, res) {
        const query = "select * from category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        try{
            const [categories] = await connection.execute(query, bindings);
            const category = categories[0];
            res.render("update_category", {
                "category": category
            })
        }catch(e){
            res.status(400);
            res.send("Invalid request")
        }
    })

    app.post("/categories/:category_id/update", async function (req, res) {
        try{
            const query = "update category set name = ? where category_id = ?";
            const bindings = [req.body.name, parseInt(req.params.category_id)];
            await connection.execute(query, bindings);
            res.redirect("/categories");
        } catch(e){
            console.log(e);
            res.redirect("/error");
        }
    })

    app.get ("/error", async function(req,res){
        res.send("There has been an error")
    })

    app.get ("/categories/:category_id/delete", async function(req,res){
        const query = "select * from category where category_id = ?";
        const [categories] = await connection.execute(query, [parseInt(req.params.category_id)])
        const categoryToDelete = categories[0];
        res.render("confirm_delete_category",{
            "category": categoryToDelete
        })
    })

    app.post("/categories/:category_id/delete", async function (req,res){

        //sql will not allow you to delete a fk that is in use elsewhere, you will have to delete any records that are using category_id as a fk
        //find all the films which have category_id equal to the category we are trying to delete
        const deleteQuery = "delete from film_category where category_id = ?";
        await connection.execute(deleteQuery, [parseInt(req.params.category_id)]);

        const query = "delete from category where category_id = ?";
        const bindings = [parseInt(req.params.category_id)];
        await connection.execute(query, bindings);
        res.redirect("/categories");
    })

    app.get("/films/create", async function(req,res){
        const[languages] = await connection.execute(
            "select * from language"
        );
        res.render("create_film",{
            languages: languages
        })
    })

    app.post("/films/create", async function(req,res){
        // insert into film (title, description, language_id) values ("The Lord of the Rings", "blah blah blah", 1);
        await connection.execute(
        "insert into film (title, description, language_id) values (?, ?, ?)", 
        [req.body.title, req.body.description, req.body.language_id]
        );
        res.redirect('/films')
    })

} main();

app.listen(3000, function () {
    console.log("server started")
})
const express = require('express');

//app confi
const app = express();

const port = 3000;
//middleware confi
app.use(express.json());

let ItemList = [
    {id:1, name: "name here"},
    {id:2, name: "name here2"}
];

//api routes

app.get('/app',(req, res) => {
    return res.json(ItemList);
});
app.post('/app',(req, res) => {
    let newTask = {
        id: ItemList.length + 1,
        name: req.body.name,
    }
    ItemList.push(newTask);
    res.status(201).json(newTask);
});
app.put('/app/:id',(req, res) => {
    let itemId = req.params.id;
    let updateItem = req.body;
    let index = ItemList.findIndex(item => item.id ===itemId);

    if(index !== -1){
        ItemList[index] = updateItem;
        res.json(updateItem);
    }else{
        res.status(404).json({message:"Item not found"});
    }
});
app.delete('/app/:id',(req, res) => {
    let itemId = req.params.id;
    let index = ItemList.findIndex(item => item.id ===itemId);

    if(index !== -1){
        let deletItem = ItemList.splice(index, 1);
        res.json(deletItem[0]);
    }else{
        res.status(404).json({message:"Item not found"});
    }
});

//listener

app.listen(port , () => {
    console.log("Listining on Port 3000");
})
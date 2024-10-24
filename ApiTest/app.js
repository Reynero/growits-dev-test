const express = require("express");//importando....
const app = express();//libreria de node js para el lado del servidor
const firstExer = require("../ConsoleTest/app.js");//importamos codigo para mas eficiencia

// Middleware to parse JSON bodies
app.use(express.json());
// Middleware to parse URL-encoded bodies (form submissions)
app.use(express.urlencoded({ extended: true }));

//middleware para agarrar cualquier error que se produzca
app.use((err, req, res, next)=>{
    console.log(err.stack);
    res.status(500).send("something broke!");
});
  

// aca estamos haciendo un http get para todas las tareas pendientes
app.get('/tareas', (req, res) => {
    const pendingTasks = firstExer.readPendingTaks();
    res.json(pendingTasks);
});

//aca para una tarea en especifico
app.get('/tareas/:id', (req, res) => {
    const { id } = req.params; 
    const allTasks = firstExer.readAllTasks();
    console.log(allTasks);//this is just to debug
    const foundTasks = allTasks.filter((item) => item.id === parseInt(id));
    res.json(foundTasks);
});

//aca estamos solicitando un http post para crear una tarea
//nos retorna la tarea creada
app.post('/tareas', (req, res) => {
    const {name} = req.body;
    const newTask = firstExer.createTask(name);
    res.status(201).json(newTask);
});

//aca utilizamos una solicitud put para actualizar una tarea la cual nos retorna la tarea actualizada
app.put('/tareas/:id', (req, res) => {
    const { id } = req.params;
    const updated = firstExer.updateTask(id, "true");
    if (updated) {
        res.json(updated);
    } else {
        res.status(404).json({ error: 'Item not found' });
    }
});

//por ultimo borramos la tarea con una solicitud http delete
app.delete('/tareas/:id', (req, res) => {
    const {id} = req.params;
    firstExer.deleteTask(id);

    res.status(204).end();
    
});

//indicamos el puerto mientras se ejecuta la app
app.listen(3000, () => {
    console.log("RUNNING ON PORT 3000");
});
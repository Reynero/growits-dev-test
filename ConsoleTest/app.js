const fs = require("fs");//libreria para manejar archivos de texto
const readline = require("readline");//libreria para manejar entrada y salida de datos por consola

const filePath = "../db.txt";

//funcion para asegurar una devolucion de booleano
function parseBoolean(str) {
    if (str.toLowerCase() === 'true') {
      return true;
    } else if (str.toLowerCase() === 'false') {
      return false;
    } else {
      throw new Error('Invalid boolean string');
    }
}

//funcion para leer archivo de texto devolviendo los datos en objeto
const readFile = () => {
    const data = fs.readFileSync(filePath, "utf8");
    return JSON.parse(data || "[]");
}

//funcion que sobre escribe datos en el archivo de texto con formato json
const writeFile = (data) => {
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
}

//funcion para crear tarea
//adiciona un id aleatorio 
//objeto se compone de id - nombre de tarea - estado de hecho 
const createTask = (task) => {
    const randomNum = Math.floor(Math.random() * 9000) + 1000;
    const fileTasks = readFile();
    const newTask = {id: randomNum, task, done: false};
    fileTasks.push(newTask);
    writeFile(fileTasks);
    
    return newTask;
}

//lee todas las tareas independientemente si estan hechas o pendientes
const readAllTasks = () => {
    const tasks = readFile();
    
    return tasks;
  };

//lee solo las pendientes
const readPendingTaks = () => {
    const fileTasks = readFile();
    const filteredTasks = fileTasks.filter(item => item.done === false);
    
    return filteredTasks;
  };

//actualiza el estado de hecho con un booleano
//false = pendiente; true = hecha;
const updateTask = (id, done) => {
    const fileTasks = readFile();
    const taskIndex = fileTasks.findIndex(item => item.id === parseInt(id));
    if (taskIndex) {
      fileTasks[taskIndex].done = parseBoolean(done);
      writeFile(fileTasks);
      console.log("task updated!");
    } else {
      console.log("task not found");
    }
    return fileTasks;
  };

//borra tarea por medio del id
const deleteTask = (id) => {
  const fileTasks = readFile();
  const filteredTasks = fileTasks.filter(item => item.id !== parseInt(id));
  writeFile(filteredTasks);
  console.log('task deleted');
};

// (configuracion para entrada y salida de datos)
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

//interfaz del menu
const menu = () => {
    console.log(`
      Choose an option:
      1. Create Task
      2. Read All Tasks
      3. Read Pending Tasks
      4. Update Task Status
      5. Delete Task
      6. Exit
    `);
  };
  
//interfaz de entrada y salida de datos
  rl.on('line', (input) => {
    switch (input.trim()) {
      case '1':
        rl.question('Enter new task: ', (task) => {
          const newTask = createTask(task);
          console.log("new task created!: " + newTask);
          menu();
        });
        break;
      case '2':
        const tasks = readAllTasks();
        console.log('All Tasks: ', tasks);
        menu();
        break;
      case '3':
        const pending = readPendingTaks();
        console.log('Pending Tasks: ', pending);
        menu();
        break;
      case '4':
        rl.question('Enter Task ID: ', (id) => {
          rl.question('Enter new status: ', (status) => {
            const updated = updateTask(id, status);
            console.log(updated);
            menu();
          });
        });
        break;
      case '5':
        rl.question('Enter task ID: ', (id) => {
          deleteTask(id);
          menu();
        });
        break;
      case '6':
        rl.close();
        break;
      default:
        console.log('Invalid option');
        menu();
        break;
    }
  });
  
  //ejecucion del menu
  menu();

  //exportando funciones porque se van a utilizar en el ejercicio 2
  module.exports = {
    createTask,
    readAllTasks,
    readPendingTaks,
    updateTask,
    deleteTask
  }
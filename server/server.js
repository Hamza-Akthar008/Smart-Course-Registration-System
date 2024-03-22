import express, { json } from "express"
import "express-async-errors"
import dotenv from "dotenv"
import cors from "cors"
import morgan from "morgan";

//Security Library
import helmet from "helmet"
import xss from "xss-clean"
import { sequelize, dbconfig } from './config/dbconfig.js'
import { syncModels } from "./config/syncmodels.js";
import errorMiddleware from "./middlewares/errormiddleware.js";
import { Logincontroller } from "./controller/Controller.js";
import authRoutes from './routes/authRoutes.js'
import managestudent from './routes/managestudent.js'
import managehod from './routes/managehod.js'
import manageadvisor from './routes/manageadvisor.js'
import managedepart from './routes/managedepart.js'
import managebatch from './routes/managebatch.js'
import managestudyplan from './routes/managestudyplan.js'
import managecourse from './routes/managecourse.js'
//DOTENV CONFIG 
dotenv.config();

//Mongoose Connect

//rest object
const app = express()




dbconfig();
syncModels();
app.use(xss());
app.use(json());
app.use(cors({

}));
app.use(morgan("dev"));
app.use(express.static('/public'))
//routes
app.get('/', (req, res) => {
    res.send('Hello');
});

app.get('/',(req,res)=>{
res.send("Hello");
})
app.use('/auth',authRoutes)
app.use('/managestudentrecords',managestudent)
app.use('/managehod',managehod)
app.use('/managebatch_advisor',manageadvisor);
app.use('/managedepart',managedepart)
app.use('/managebatch',managebatch)
app.use('/managestudyplan',managestudyplan);
app.use('/managecourse',managecourse);
//Error Middleware

app.use(errorMiddleware)
const PORT = process.env.PORT
//listen
app.listen(PORT,()=>
{
    console.log("Started");
})

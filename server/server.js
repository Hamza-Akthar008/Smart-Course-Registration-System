import express, { json } from "express"
import "express-async-errors"
import 'dotenv/config'
import cors from "cors"
import morgan from "morgan";
import Student from './models/student_model.js';
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


//Mongoose Connect

//rest object
const app = express()

dbconfig();
syncModels();
app.use(xss());
app.use(json());
app.use(cors({
}));

app.use(express.static('/public'))
//routes


app.get('/',(req,res)=>{
res.send("Hello");
})

app.get('/user',(req, res) => {
  try {
    // Fetch all students where is_current is true
    const currentStudents = await Student.findAll({
      where: {
        is_current: '1',
      },
      attributes: ['student_id', 'student_name', 'student_email', 'student_contact', 'student_address', 'batch_id', 'depart_id'],
    });

    return res.status(200).json({
      success: true,
      message: 'Successfully retrieved all current students',
      students: currentStudents,
    });
  } catch (error) {
    console.error('Error getting current students:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while fetching current students',
    });
  }
});
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

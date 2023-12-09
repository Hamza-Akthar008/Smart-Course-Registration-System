import express from "express";
import errorMiddleware from "../middlewares/errormiddleware.js";
import {add_new_batch_advisor,deletebatchadvisorById,editbatchadvisorById,getAllBatchAdvisors} from '../controller/managebatch_advisor_controller.js'

const Router = express.Router()
Router.post('/add_new_batch_advisor',errorMiddleware,add_new_batch_advisor);
Router.patch('/edit_hod',editbatchadvisorById);
Router.get('/getallbatchadvisor',getAllBatchAdvisors);
Router.delete('/delete_advisor',deletebatchadvisorById)


export default Router;
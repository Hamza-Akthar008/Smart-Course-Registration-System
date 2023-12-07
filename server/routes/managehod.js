import express from "express";
import {addNewHOD,getAllHODs,deleteHODById, editHODById} from '../controller/managehod_controller.js'

const Router = express.Router()
Router.post('/add_new_hod',addNewHOD);
Router.get('/get_all_hod',getAllHODs)
Router.delete('/delete_hod',deleteHODById)
Router.patch('/edit_hod',editHODById)
export default Router;
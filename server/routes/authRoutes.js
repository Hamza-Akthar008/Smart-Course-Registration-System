import express from "express";
import { Logincontroller  } from "../controller/Controller.js";
import errorMiddleware from "../middlewares/errormiddleware.js";

const Router = express.Router()



// LOGIN || POST 

Router.post('/login',errorMiddleware, Logincontroller);
export default Router;
import express from "express";
import { Logincontroller, otp  } from "../controller/Controller.js";
import errorMiddleware from "../middlewares/errormiddleware.js";

const Router = express.Router()



// LOGIN || POST 

Router.post('/login',errorMiddleware, Logincontroller);
Router.post('/send_otp',otp);
export default Router;
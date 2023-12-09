
import express from 'express';  
import { addNewCourse,editCourse,deleteCourse,getAllCourses } from '../controller/managecourse_controller.js';
const Router = express.Router();

Router.post('/addNewCourse', addNewCourse);

// Edit a course
Router.patch('/editCourse', editCourse);

// Delete a course
Router.delete('/deleteCourse', deleteCourse);

// Get all courses
Router.get('/getAllCourses', getAllCourses);

export default Router;
import Course from "../models/Course.js";

export const addNewCourse = async (req, res) => {
  try {
    const { CourseID, Course_Name, Course_Type, Course_Description } = req.body;

    const existingCourse = await Course.findOne({
        where: {
            CourseID: CourseID,
        },
      });
  
      if (existingCourse) {
        // If the advisor already exists, send a conflict response
        return res.status(409).json({
          success: false,
          message: 'Course Already Exist',
        });
      }
    // Add new course
    const newCourse = await Course.create({
      CourseID,
      Course_Name,
      Course_Type,
      Course_Description,
    });

    res.status(201).json(newCourse);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

export const editCourse = async (req, res) => {
    try {
      const { CourseID } = req.body;
  
      // Find the course
      const course = await Course.findByPk(CourseID);
  
      if (!course) {
        return res.status(404).json({ error: 'Course not found' });
      }
  
      // Update the course
      await course.update(req.body);
  
      res.status(200).json(course);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const deleteCourse = async (req, res) => {
    try {
      const { CourseID } = req.body;
  
      // Find the course
      const course = await Course.findByPk(CourseID);
  
      if (!course) {
        return res.status(404).json({ error: 'Course not found' });
      }
  
      // Delete the course
      await course.destroy();
  
      res.status(200).json({ message: 'Course deleted successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  export const getAllCourses = async (req, res) => {
    try {
      // Get all courses
      const courses = await Course.findAll();
  
      res.status(200).json(courses);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
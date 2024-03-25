

import Student from '../models/student_model.js';

export const add_new_student = async (req, res) => {
  const {
    student_id,
    student_name,
    student_email,
    student_contact,
    student_address,
    batch_id,
    depart_id,
    student_password,
    academics_id,
  } = req.body;

  try {
    // Check if the student with the provided email already exists
    const existingStudent = await Student.findOne({
      where: {
        student_email,
      },
    });

    if (existingStudent) {
      return res.status(400).json({
        success: false,
        message: 'Student with this email already exists',
      });
    }

    // Create a new student
    const newStudent = await Student.create({
      student_id,
      student_name,
      student_email,
      student_contact,
      student_address,
      batch_id,
      depart_id,
      student_password,
      academics_id,
    });

    return res.status(200).json({
      success: true,
      message: 'Student added successfully',
      student: newStudent,
    });
  } catch (error) {
    console.error('Error adding new student:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while adding the student',
    });
  }
};

export const getAllCurrentStudents = async (req, res) => {
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
};

export const getStudents = async (req, res) => {
  const { student_id } = req.body;
  try {
    // Fetch all students where is_current is true
    const currentStudents = await Student.findAll({
      where: {
        is_current: '1',
        student_id:student_id
      },
      attributes: ['student_id', 'student_name', 'student_email', 'student_contact', 'student_address', 'batch_id', 'depart_id'],
    });
    return res.status(200).json({
      success: true,
      
      students: currentStudents,
    });
  } catch (error) {
    console.error('Error getting current students:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while fetching current students',
    });
  }
};

export const deactivateStudentById = async (req, res) => {
  const { student_id } = req.body;

  try {
    // Find the student by ID
    const student = await Student.findByPk(student_id);

    if (!student) {
      return res.status(404).json({
        success: false,
        message: 'Student not found',
      });
    }

    // Update is_current to false
    await student.update({ is_current: false });

    return res.status(200).json({
      success: true,
      message: 'Student deactivated successfully',
      student: student,
    });
  } catch (error) {
    console.error('Error deactivating student:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while deactivating the student',
    });
  }
};

export const editStudentById = async (req, res) => {
  const { student_id, student_name, student_email, student_contact, student_address, batch_id, depart_id } = req.body;

  try {
    // Find the student by ID
    const student = await Student.findByPk(student_id);

    if (!student) {
      return res.status(404).json({
        success: false,
        message: 'Student not found',
      });
    }

    // Update student data
    await student.update({
      student_name,
      student_email,
      student_contact,
      student_address,
      batch_id,
      depart_id,
    });

    return res.status(200).json({
      success: true,
      message: 'Student data updated successfully',
      student: student,
    });
  } catch (error) {
    console.error('Error updating student data:', error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred while updating student data',
    });
  }
};
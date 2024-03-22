// controllers/hodController.js

import HOD from "../models/hod.js";



export const addNewHOD = async (req, res,next)  => {
  try {
    // Destructure the required fields from the request body
    const { HODID, depart_id, Hod_name, hod_email, hod_contact, hod_password } = req.body;

    // Check if an HOD with the given email already exists
    const existingHOD = await HOD.findOne({
      where: { hod_email },
    });

    if (existingHOD) {
      return res.status(400).json({ success: false, error: 'HOD with this email already exists' });
    }

    // Create a new HOD record in the database
    const newHOD = await HOD.create({
        HODID, depart_id, Hod_name, hod_email, hod_contact, hod_password,
    });

    res.status(201).json({ success: true, data: newHOD });
  } catch (error) {
    console.error('Error adding new HOD:', error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
};
export const getHOD = async (req, res) => {
  const { HODID } = req.body;
  console.log(HODID);
  try {
    // Fetch all students where is_current is true
    const currentStudents = await HOD.findAll({
      where: {
        
        HODID:HODID
      },
      attributes: ['HODID', 'depart_id', 'Hod_name', 'hod_contact', 'hod_email'],
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

export const getAllHODs = async (req, res,next) => {
  try {
    // Fetch all HOD records from the database
    const allHODs = await HOD.findAll({
      attributes: ['HODID', 'depart_id', 'Hod_name', 'hod_contact', 'hod_email'], // List of fields to retrieve
    });
console.log(allHODs);
    res.status(200).json({ success: true, data: allHODs });
  } catch (error) {
    console.error('Error retrieving HODs:', error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
};

export const deleteHODById = async (req, res,next)  => {
  try {
    const { HODID } = req.body;

    // Find the HOD by ID
    const hodToDelete = await HOD.findByPk(HODID);
console.log(hodToDelete);
    // If the HOD with the specified ID doesn't exist, return an error
    if (!hodToDelete) {
      return res.status(404).json({ success: false, error: 'HOD not found' });
    }

    // Delete the HOD
    await hodToDelete.destroy();

    res.status(200).json({ success: true, message: 'HOD deleted successfully' });
  } catch (error) {
    console.error('Error deleting HOD:', error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
};
export const editHODById = async (req, res,next)  => {
  try {
    const { HODID, depart_id, Hod_name, hod_contact, hod_email } = req.body;

    // Find the HOD by ID
    const hodToUpdate = await HOD.findByPk(HODID);

    // If the HOD with the specified ID doesn't exist, return an error
    if (!hodToUpdate) {
      return res.status(404).json({ success: false, error: 'HOD not found' });
    }

    // Update the HOD fields
    hodToUpdate.depart_id = depart_id;
    hodToUpdate.Hod_name = Hod_name;
    hodToUpdate.hod_contact = hod_contact;
    hodToUpdate.hod_email = hod_email;

    // Save the changes
    await hodToUpdate.save();

    res.status(200).json({ success: true, message: 'HOD updated successfully' });
  } catch (error) {
    console.error('Error updating HOD:', error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
};

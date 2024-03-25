import  RegistrationApplication from '../models/registration_application.js';

export const addNewRegistrationApplication =  async (req, res)=> {
  try {
    const {
      student_id,
      courses,
      
    } = req.body;
const already_registrationApp =await RegistrationApplication.findOne({where:{
    student_id:student_id
}})
if (already_registrationApp) {
    return res.status(400).json({
      success: false,
      message: 'Registration Application Already Submitted',
    });
  }
    const registrationApp = await RegistrationApplication.create({
      student_id,
      courses,
     
    });

    res.status(200).json(registrationApp);
  } catch (error) {
    console.error('Error adding new registration application:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
export const get_all_registration_application =  async (req, res)=> {
  try {
   
const already_registrationApp =await RegistrationApplication.findAll({attributes: ['application_id', 'student_id', 'isRecommended', 'batchAdvisorComment', 'isApproved', 'isRejected', 'hodComments','isProcessed']});

if (already_registrationApp) {
    return res.status(200).json({
      registrationapp:already_registrationApp,
      success: false,
      message: 'Registration Application Successfully Retieved',
    });
  }
  else
  {
      return res.status(200).json({
         
          success: false,
          message: 'No Registration Application Found',
        });
  }
   
  } catch (error) {
    console.error('Error getiing  registration application:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const get_registration_application =  async (req, res)=> {
    try {
      const {
        student_id,
       
      } = req.body;
  const already_registrationApp =await RegistrationApplication.findOne({where:{
      student_id:student_id
  }})
  console.log(student_id);
  if (already_registrationApp) {
      return res.status(200).json({
        registrationapp:already_registrationApp,
        success: false,
        message: 'Registration Application Successfully Retieved',
      });
    }
    else
    {
        return res.status(200).json({
           
            success: false,
            message: 'No Registration Application Found',
          });
    }
     
    } catch (error) {
      console.error('Error getiing  registration application:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  }
  export const delete_registration_application =  async (req, res)=> {
    try {
      const {
        student_id,
       
      } = req.body;
      console.log(student_id);
  const already_registrationApp =await RegistrationApplication.findOne({where:{
      student_id:student_id
  }})
  
  if (already_registrationApp) {
    already_registrationApp.destroy();
      return res.status(200).json({
    
        success: false,
        message: 'Registration WithDrawn Successfully',
      });
    }
    else
    {
        return res.status(201).json({
           
            success: false,
            message: 'No Registration Application Found',
          });
    }
     
    } catch (error) {
      console.error('Error getiing  registration application:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  }
  
  
  

  export const update_registration_application = async (req, res) => {
    try {
      const { student_id, application_id,hodComments,batchAdvisorComment,isApproved,isRejected  } = req.body;
  
      // Check if the registration application exists
      let existingApplication = await RegistrationApplication.findOne({ where: { student_id: student_id  } });
  
      if (!existingApplication) {
        return res.status(404).json({
          success: false,
          message: 'Registration Application not found',
        });
      }
  if(hodComments)
  {

    await existingApplication.update({
          hodComments,
          isApproved,
          isRejected
          /* Add other fields to update if needed */
        });
  }
  else
  {
    console.log(batchAdvisorComment);
    await existingApplication.update({
      batchAdvisorComment,
      isRecommended:true,
      /* Add other fields to update if needed */
    });
  }
  // Update the registration application
  
      return res.status(200).json({
        success: true,
        message: 'Registration Application updated successfully',
        updatedApplication: existingApplication,
      });
    } catch (error) {
      console.error('Error updating registration application:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
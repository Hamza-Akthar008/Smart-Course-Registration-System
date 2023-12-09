import  AcademicsStaff  from '../models/academic_staff.js'; // Adjust the path accordingly
import JWT from "jsonwebtoken";

export const Logincontroller = async (req, res, next) => {
    const staff_email  = req.body.staff_email
    const staff_password  = req.body.staff_password
    try {
      
        
        if (!staff_email || !staff_password) {
            throw "Please Provide All Fields";
        }

        // Find by Email
        const user = await AcademicsStaff.findOne({
            where: { staff_email },
            attributes: {
                exclude: ['createdAt', 'updatedAt'], // Exclude timestamps from the result
            },
        });

        if (!user) {
            throw "User not Found";
        }
let isMatch=false;
        // Assuming you have a method named comparePassword in your model for password comparison
        if(user.staff_password==staff_password)
        {
            isMatch=true;
        }
      

        if (!isMatch) {
            throw 'Invalid Email or Password';
        }

        // Remove password from the response
        user.staff_password = undefined;

        // Assuming you have a method named generateJWT in your model for JWT creation
       
        const token = JWT.sign({ userId: user.userId }, process.env.secret_Key);
        res.status(200).json({
            success: true,
            message: "Login Successfully",
            user,
            token:token
         
        });
    } catch (error) {
        next(error);
    }
};

import express, { json } from "express"
import "express-async-errors"
import 'dotenv/config'
import cors from "cors"
import morgan from "morgan";
import multer from "multer";
import path  from 'path';
import {createWorker}  from "tesseract.js";
import sharp from "sharp";

//Security Library
import xss from "xss-clean"
import {  dbconfig } from './config/dbconfig.js'
import { syncModels } from "./config/syncmodels.js";
import errorMiddleware from "./middlewares/errormiddleware.js";
import authRoutes from './routes/authRoutes.js'
import managestudent from './routes/managestudent.js'
import managehod from './routes/managehod.js'
import manageadvisor from './routes/manageadvisor.js'
import managedepart from './routes/managedepart.js'
import managebatch from './routes/managebatch.js'
import managestudyplan from './routes/managestudyplan.js'
import managecourse from './routes/managecourse.js'
import managecoursetype from './routes/managecoursetype.js'
import userAuth from "./middlewares/authMiddleware.js";
import { ocrSpace } from "ocr-space-api-wrapper";
import Transcript from "./models/transcript.js";
import offercourse from "./routes/offercourse.js";
import registration_application from "./routes/registration_application.js"
import managemeeting from './routes/managemeeting.js'
import managetranscript from './routes/managetranscript.js'
import manageacademic from './routes/manageacademic.js'

import fs from 'fs'
import ConvertAPI from 'convertapi';
import { string } from "yup";
//DOTENV CONFIG 

//Mongoose Connect
//rest object
const app = express()
await dbconfig();
await syncModels();

app.use(express.static('/public'))
app.use('/uploads', express.static('uploads'));
//routes

app.get('/',(req,res)=>{
res.send("HELLO");})
app.use('/auth',authRoutes)
app.use('/managestudentrecords',userAuth,managestudent)
app.use('/manageacademic',userAuth,manageacademic)
app.use('/managehod',userAuth,managehod)
app.use('/managebatch_advisor',userAuth,manageadvisor);
app.use('/managedepart',userAuth,managedepart)
app.use('/managebatch',userAuth,managebatch)
app.use('/managestudyplan',userAuth,managestudyplan);
app.use('/managecourse',userAuth,managecourse);
app.use('/managecoursetype',userAuth,managecoursetype);
app.use('/offercourse',userAuth,offercourse);
app.use('/registrationappication',userAuth,registration_application);
app.use('/meeting',userAuth,managemeeting);
app.use('/gettranscriptstudyplan',userAuth,managetranscript)
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Uploads will be stored in the 'uploads/' directory
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  },
});
const upload = multer({ storage: storage });
function generateTranscriptId() {
  const prefix = 'T_';
  const randomDigits = Math.floor(1000 + Math.random() * 9000); // Generates a random four-digit number
  return `${prefix}${randomDigits}`;
}
const convertBase64ToPdf = async (base64string, filePath) => {
  const buffer = Buffer.from(base64string.base64string, 'base64');

  fs.writeFileSync(base64string.filePath, buffer);
};



// Image preprocessing function using sharp
async function preprocessImage(filePath) {
  const outputFilePath = `preprocessed_${path.basename(filePath)}`;

  await sharp(filePath).sharpen()
  .grayscale()
  .greyscale()
  .resize({ width: 2000 }) // Resize to a reasonable width
  .median(1)
    .toFormat('jpg')
    .toFile("output-enhanced.jpg");
  return "output-enhanced.jpg";
}


function extractRollNo(ocrText) {
  if (typeof ocrText !== 'string') {
    console.error('OCR text is not a string:', ocrText);
    return null;
  }

  const rollNoRegex = /\bRoll No: (\d{2}[A-Z]-\d{4})\b/;
  const match = ocrText.match(rollNoRegex);

  return match ? match[1] : null;
}
 
function extractCourseIds(ocrText) {
  const courseIdRegex = /\b\w{2}\d{3,4}\b/g; 
  const semesterRegex = /\b(FALL|SPRING|SUMMER)\s\d{4}\b/g;
  const codeWordRegex = /^CODE\b/gm; // This matches lines starting with "CODE"
  
  const semesterInfoList = new Set();
  const semesterInfo = [];
  const courseLines = [];
  let match;
  let count = 0;

  let remainingText = ocrText;
  
  
count=0;
let semester = 1;
  const lines = remainingText.split('\n');
  for (const line of lines) {
    if (codeWordRegex.test(line) || semesterRegex.test(line)) {
   if(count==0)
   {
  
continue;
   }
   else
   {
    
    semesterInfo.push({semester: `Semester ${semester}`, courses: count});
    count=0;
    semester++;
   }
     
    }
    else  {
      while ((match = courseIdRegex.exec(line)) !== null) {

        const courseId = match[0];
        const courseLineRegex = new RegExp(`.*${courseId}.*`, 'gi'); 
        const courseLineMatch = courseLineRegex.exec(line);
    
        if (courseLineMatch) {
          count++;
          courseLines.push(courseLineMatch[0].trim());
        }
      }
    
    }
  }
  semesterInfo.push({semester: `Semester ${semester}`, courses: count});

  return [courseLines,semesterInfo];
}


  
  function postProcessOCRText(ocrText) {

    var correctedText = ocrText.replace(/\$5/g, 'SS');
    correctedText = correctedText.replace(/MTI/g, 'MT1');
    correctedText = correctedText.replace(/\]1/g, '1');
    correctedText = correctedText.replace(/\]/g, '1');
    correctedText = correctedText.replace(/MGI/g, 'MG1'); 
    correctedText = correctedText.replace(/S\$5/g, 'SS');
    correctedText = correctedText.replace(/55/g, 'SS');
    correctedText = correctedText.replace(/SSS/g, 'SS');
    correctedText = correctedText.replace(/€/g, 'C');
    correctedText = correctedText.replace(/S5/g, 'SS');
    correctedText = correctedText.replace(/SE/g, 'SS');
    correctedText = correctedText.replace(/CSN8/g, 'CS118');
    correctedText = correctedText.replace(/SS Islamic/g, 'SS111 Islamic');
    correctedText = correctedText.replace(/MTI/g, 'MT1');
    correctedText = correctedText.replace(/I00!/g, '1001');
    correctedText = correctedText.replace(/I00E/g, '1006');
    correctedText = correctedText.replace(/100!/g, '1001');
    correctedText = correctedText.replace(/100E/g, '1006');
    correctedText = correctedText.replace(/S§5/g, 'SS');
    correctedText = correctedText.replace(/AlI/g, 'AI');
    correctedText = correctedText.replace(/88/g, '8B');
    correctedText = correctedText.replace(/FINAL YEAR PROJECT -/g, 'FINAL YEAR PROJECT  ');
    correctedText = correctedText.replace(/88B/g, '8B');
    correctedText = correctedText.replace(/8BB/g, '8B');
    correctedText = correctedText.replace(/CLI7/g, 'CL117');
    correctedText = correctedText.replace(/CLII8/g, 'CL118');
    correctedText = correctedText.replace(/CSLL8/g, 'CS118');
    correctedText = correctedText.replace(/MT12/g, 'MT119');
    correctedText = correctedText.replace(/SLIS0/g, 'SL150');
    correctedText = correctedText.replace(/SSI/g, 'SS111');
    correctedText = correctedText.replace(/2 2/g, 'C 2');
    correctedText = correctedText.toUpperCase();
  
    return correctedText;
  }
  
app.use(errorMiddleware)
const PORT = process.env.PORT
//listen
app.listen(PORT,()=>
{
    console.log("Started");
})

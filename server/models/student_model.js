import { DataTypes } from 'sequelize';
import {sequelize} from '../config/dbconfig.js'; 
import AcademicsStaff from './academic_staff.js';
import Batch from './batch.js'
import Department from './department.js';
const Student = sequelize.define('student', {
  student_id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  student_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  student_email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  student_contact: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  student_address: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  batch_id: {
    type: DataTypes.STRING, // Adjust the data type accordingly
    allowNull: false,
    references: {
      model: Batch, 
      key: 'batch_id',
    },
  },
  depart_id: {
    type: DataTypes.STRING, // Adjust the data type accordingly
    allowNull: false,
    references: {
      model: Department, 
      key: 'depart_id',
    },
  },
  student_password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  is_current: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  academics_id: {
    type: DataTypes.STRING, // Adjust the data type accordingly
    allowNull: false,
    references: {
      model: AcademicsStaff, // Reference the AcademicsStaff model
      key: 'academics_id',
    },
  },
});

export default Student;

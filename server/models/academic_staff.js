// models/academicsStaff.js
import { DataTypes } from 'sequelize';
import {sequelize} from '../config/dbconfig.js'; 

const AcademicsStaff = sequelize.define('academics_staff', {
  academics_id: {
    type: DataTypes.STRING,
    primaryKey: true,
  },
  staff_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  staff_email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  staff_contact: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  staff_password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});
export default AcademicsStaff;

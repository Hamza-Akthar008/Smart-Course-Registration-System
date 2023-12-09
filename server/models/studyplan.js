import { DataTypes } from 'sequelize';
import {sequelize} from '../config/dbconfig.js'; // Import your Sequelize instance
import Department from './department.js';
import Batch from './batch.js';

const StudyPlan = sequelize.define(
  'studyplan',
  {
    studplanid: {
      type: DataTypes.STRING, 
      primaryKey: true,
      allowNull: false,
    },
    depart_id: {
      type: DataTypes.STRING,
      allowNull: false,
      references: {
        model: Department,
        key: 'depart_id',
      },
    },
    batch_id: {
      type: DataTypes.STRING,
      allowNull: false,
      references: {
        model: Batch, 
        key: 'batch_id',
      },
    },
    studyplan_details: {
      type: DataTypes.JSON,
      allowNull: false,
    },
  },

);

export default StudyPlan;

import { Sequelize } from 'sequelize';
import mysql2 from 'mysql2';
const sequelize = new Sequelize({
  dialect: process.env.DB_DIALECT,
  dialectModule: mysql2,
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  database:process.env.DB_DATABASE,
});

const dbconfig = async () => {
  try {
    await sequelize.authenticate();
    console.log('Connected to the database');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
};


  export { sequelize, dbconfig };

import { Sequelize } from 'sequelize';


const sequelize = new Sequelize({
  dialect: 'mysql',
  dialectModule: 'mysql2',
  username: 'sql6693530',
  password: 'QW2RwtZVg9', // Add the password here
  host: 'jdbc:mysql://sql6.freemysqlhosting.net:3306/sql6693530',
  database: 'sql6693530',
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

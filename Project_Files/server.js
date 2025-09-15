const express = require('express');
const sql = require('mssql');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.set('view engine', 'ejs');

// Explicit SQL Config (with trustServerCertificate: true)
const dbConfig = {
  user: "[your_username]",
  password: "[your_password]",
  server: "[your_db_servername]",
  database: "[your_dbname]",
  options: {
    encrypt: true,                // required for Azure SQL
    trustServerCertificate: true  // now set to true
  }
};

// Homepage with search bar
app.get('/', (req, res) => {
  res.render('index', { quotes: [], search: '' });
});

// Search endpoint
app.post('/search', async (req, res) => {
  const search = req.body.search;

  try {
    let pool = await sql.connect(dbConfig);
    let result = await pool.request()
      .input('search', sql.NVarChar, `%${search}%`)
      .query(`
        SELECT * FROM Quotes
        WHERE Quote LIKE @search OR Author LIKE @search
        ORDER BY Author
      `);

    res.render('index', { quotes: result.recordset, search });
  } catch (err) {
    console.error('DB Error:', err);   // logs the exact SQL error
    res.status(500).send('Database error');
  }
});

// Random quote endpoint
app.get('/random', async (req, res) => {
  try {
    let pool = await sql.connect(dbConfig);
    let result = await pool.request().query(`
      SELECT TOP 1 * FROM Quotes ORDER BY NEWID()
    `);
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('DB Error:', err);   // logs the exact SQL error
    res.status(500).send('Database error');
  }
});

app.listen(port, () => {
  console.log(`App running at http://localhost:${port}`);
});

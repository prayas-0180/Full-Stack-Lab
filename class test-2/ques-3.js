const express = require('express');
const app = express();

app.use(express.json());

// Root route to prevent "Cannot GET /"
app.get('/', (req, res) => {
  res.send('Server Q3 is running! GET /api/books is public. POST /api/books requires header x-api-key: secret123.');
});

// (a) Custom authentication middleware
const requireAuth = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  if (apiKey !== 'secret123') {
    return res.status(401).json({ error: 'Unauthorized: Missing or invalid x-api-key header' });
  }
  next();
};

// (b) Public GET route
app.get('/api/books', (req, res) => {
  res.status(200).json({ message: 'Public book list access granted' });
});

// (b) Protected POST route applying requireAuth
app.post('/api/books', requireAuth, (req, res) => {
  res.status(201).json({ message: 'Book created successfully', data: req.body });
});

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server Q3 running at http://localhost:${PORT}`);
});
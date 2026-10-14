const express = require('express');
const app = express();

app.use(express.json());

// In-memory data store
let books = [
  { id: 1, title: 'Clean Code', author: 'Robert C. Martin' },
  { id: 2, title: 'The Pragmatic Programmer', author: 'Andrew Hunt' }
];

// Root route: redirects directly to /api/books
app.get('/', (req, res) => {
  res.redirect('/api/books');
});

// GET /api/books -> list all books
app.get('/api/books', (req, res) => {
  res.status(200).json(books);
});

// POST /api/books -> create a new book
app.post('/api/books', (req, res) => {
  const { title, author } = req.body;
  if (!title || !author) {
    return res.status(400).json({ error: 'title and author are required fields' });
  }

  const nextId = books.length > 0 ? Math.max(...books.map(b => b.id)) + 1 : 1;
  const newBook = { id: nextId, title, author };
  books.push(newBook);

  res.status(201).json(newBook);
});

// DELETE /api/books/:id -> delete a book (404 if id not found)
app.delete('/api/books/:id', (req, res) => {
  const targetId = parseInt(req.params.id, 10);
  const bookIndex = books.findIndex(b => b.id === targetId);

  if (bookIndex === -1) {
    return res.status(404).json({ error: 'Book not found' });
  }

  const deletedBook = books.splice(bookIndex, 1)[0];
  res.status(200).json({ message: 'Book deleted successfully', book: deletedBook });
});

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server Q4 running at http://localhost:${PORT}`);
});
const express = require("express");

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


const PORT = 4000;
// Custom logger middleware
const logger = (req, res, next) => {
    console.log(
        `${req.method} ${req.url} - ${new Date().toLocaleString()}`
    );

    next();
};

app.use(logger);
// API key middleware
const checkApiKey = (req, res, next) => {
    const apiKey = req.headers["x-api-key"];

    if (!apiKey) {
        return res.status(403).json({
            error: "Forbidden"
        });
    }

    next();
};
app.use("/admin", checkApiKey);
// Protected admin route
app.get("/admin/dashboard", (req, res) => {
    res.json({
        message: "Welcome to Admin Dashboard",
        data: "Protected admin data"
    });
});

// Home route
app.get("/", (req, res) => {
    res.send("Express Lab Running");
});

// About route
app.get("/about", (req, res) => {
    res.json({
        name: "Prayas Sharma",
        rollNumber: "46"
    });
});

// Courses route
app.get("/courses", (req, res) => {
    res.json([
        "Data Structures and Algorithms",
        "Database Management System",
        "Full Stack Web Development"
    ]);
});

// Echo route
app.post("/echo", (req, res) => {
    res.json(req.body);
});

// Student route
app.get("/students/:id", (req, res) => {
    const id = req.params.id;

    res.json({
        id: id,
        message: "Student details"
    });
});
// Search route
app.get("/search", (req, res) => {
    const name = req.query.name;
    const age = req.query.age;

    res.json({
        name: name,
        age: age
    });
});
// Product route
app.get("/products/:category/:id", (req, res) => {
    const category = req.params.category;
    const id = req.params.id;

    res.json({
        category: category,
        id: id
    });
});
app.post("/register", (req, res) => {
    const { name, email, password } = req.body;

    res.json({
        message: `Registration successful for ${name}`
    });
});
app.post("/contact", (req, res) => {
    console.log("Contact Form Data:", req.body);

    res.json({
        message: "Thank you for contacting us!"
    });
});
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
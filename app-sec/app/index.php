<?php
require 'db_connect.php';

$result = $conn->query("SELECT NOW() AS current_time");

if ($result) {
    $row = $result->fetch_assoc();
    echo "<h1>PHP + Nginx App</h1>";
    echo "<p>Connected to database successfully!</p>";
    echo "<p>Current time (from MySQL): " . $row['current_time'] . "</p>";
} else {
    echo "<p>Error querying database: " . $conn->error . "</p>";
}

$conn->close();
?>

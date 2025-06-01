<?php

$uploadDir = __DIR__ . '/uploads/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $errors = [];

    $name = trim($_POST['product-name'] ?? '');
    $price = trim($_POST['product-price'] ?? '');

    if ($name === '') {
        $errors[] = "Product name is required.";
    }
    if ($price === '' || !is_numeric($price) || $price <= 0) {
        $errors[] = "Valid price is required.";
    }

    
    if (!isset($_FILES['product-image']) || $_FILES['product-image']['error'] !== UPLOAD_ERR_OK) {
        $errors[] = "Product image is required.";
    } else {
        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $fileType = mime_content_type($_FILES['product-image']['tmp_name']);
        if (!in_array($fileType, $allowedTypes)) {
            $errors[] = "Only JPG, PNG, GIF, or WEBP images are allowed.";
        }
    }

    if (empty($errors)) {
        
        $ext = pathinfo($_FILES['product-image']['name'], PATHINFO_EXTENSION);
        $fileName = uniqid('product_', true) . '.' . $ext;
        $filePath = $uploadDir . $fileName;

        if (move_uploaded_file($_FILES['product-image']['tmp_name'], $filePath)) {
           
            $csvFile = __DIR__ . '/products.csv';
            $row = [$name, $price, 'uploads/' . $fileName, date('Y-m-d H:i:s')];
            $fp = fopen($csvFile, 'a');
            fputcsv($fp, $row);
            fclose($fp);

            echo "<h2>Product Listed Successfully!</h2>";
            echo "<p><strong>Name:</strong> " . htmlspecialchars($name) . "</p>";
            echo "<p><strong>Price:</strong> R" . htmlspecialchars($price) . "</p>";
            echo "<img src='uploads/" . htmlspecialchars($fileName) . "' style='max-width:300px;'><br>";
            echo "<p><a href='index.html'>Back to Store</a></p>";
        } else {
            echo "<p style='color:red;'>Failed to upload image.</p>";
        }
    } else {
        
        foreach ($errors as $error) {
            echo "<p style='color:red;'>" . htmlspecialchars($error) . "</p>";
        }
        echo "<p><a href='index.html'>Back to Store</a></p>";
    }
} else {
    echo "<p>No form submitted.</p>";
}
?>
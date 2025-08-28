<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php'; 

try {
    $sql = "SELECT id, title, content, image, publish_date AS start_date, end_date AS end_date FROM advertisements";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $announcements = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($announcements as &$announcement) {
        if (!empty($announcement['image'])) {
            $announcement['image'] = 'http://192.168.0.250/api_inst/uploads/' . $announcement['image'];
        } else {
            $announcement['image'] = null;
        }
    }

    echo json_encode($announcements, JSON_UNESCAPED_UNICODE);
} catch (PDOException $exception) {
    echo json_encode([
        "status" => "error",
        "message" => "خطأ في الاستعلام: " . $exception->getMessage()
    ]);
}


$conn = null;
?>
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'db.php';

if (!isset($_GET['id']) || empty($_GET['id'])) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "يجب إرسال معرف الطالب"
    ]);
    exit;
}

$studentId = filter_var($_GET['id'], FILTER_VALIDATE_INT);

if ($studentId === false || $studentId <= 0) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "معرف الطالب يجب أن يكون رقماً صحيحاً موجباً"
    ]);
    exit;
}

try {
    $query = "SELECT 
                id,
                user_id,
                student_name_ar AS full_name,
                student_name_en AS english_name,
                image,
                phones AS phone,
                gender,
                qualification,
                DATE_FORMAT(birth_date, '%Y-%m-%d') AS birth_date,
                birth_place,
                address,
                email,
                state
              FROM students 
              WHERE id = :id";
    
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':id', $studentId, PDO::PARAM_INT);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode([
            "status" => "error",
            "message" => "لم يتم العثور على الطالب"
        ]);
        exit;
    }

    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    $response = [
        "status" => "success",
        "data" => [
            "id" => (string)$student['id'],
            "user_id" => (string)$student['user_id'],
            "full_name" => $student['full_name'] ?? 'غير معروف',
            "english_name" => $student['english_name'] ?? '',
            "image" => $student['image'] ?? 'default.png',
            "phone" => (string)$student['phone'] ?? 'غير مسجل',
            "gender" => $student['gender'] ?? 'غير محدد',
            "qulification" => $student['qualification'] ?? 'غير محدد',
            "birth_date" => empty($student['birth_date']) ? 'غير محدد' : $student['birth_date'],
            "birth_place" => $student['birth_place'] ?? 'غير معروف',
            "address" => $student['address'] ?? 'غير معروف',
            "email" => $student['email'] ?? 'لا يوجد',
            "state" => (string)$student['state'] ?? 'غير محدد'
        ]
    ];

    http_response_code(200);
    echo json_encode($response, JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "حدث خطأ في قاعدة البيانات: " . $e->getMessage()
    ]);
}

$conn = null;
?>
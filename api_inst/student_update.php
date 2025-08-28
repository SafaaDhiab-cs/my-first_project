<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'db.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id) || !isset($data->full_name) || !isset($data->english_name) || 
    !isset($data->email) || !isset($data->phone) || !isset($data->address)) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "جميع الحقول مطلوبة"
    ]);
    exit;
}

$studentId = filter_var($data->id, FILTER_VALIDATE_INT);
if ($studentId === false || $studentId <= 0) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "معرف الطالب يجب أن يكون رقماً صحيحاً موجباً"
    ]);
    exit;
}

try {
    $query = "UPDATE students SET 
                student_name_ar = :full_name,
                student_name_en = :english_name,
                email = :email,
                phones = :phone,
                address = :address,
                updated_at = NOW()
              WHERE id = :id";
    
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':full_name', $data->full_name, PDO::PARAM_STR);
    $stmt->bindParam(':english_name', $data->english_name, PDO::PARAM_STR);
    $stmt->bindParam(':email', $data->email, PDO::PARAM_STR);
    $stmt->bindParam(':phone', $data->phone, PDO::PARAM_STR);
    $stmt->bindParam(':address', $data->address, PDO::PARAM_STR);
    $stmt->bindParam(':id', $studentId, PDO::PARAM_INT);

    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode([
            "status" => "success",
            "message" => "تم تحديث بيانات الطالب بنجاح"
        ]);
    } else {
        http_response_code(400);
        echo json_encode([
            "status" => "error",
            "message" => "حدث خطأ أثناء تحديث بيانات الطالب"
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "حدث خطأ في قاعدة البيانات: " . $e->getMessage()
    ]);
}

$conn = null;
?>
<?php
header("Content-Type: application/json");
require_once 'db.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'طريقة غير مسموح بها. يُسمح فقط بطلبات POST.'
    ]);
    exit;
}

$input = file_get_contents('php://input');
$data = json_decode($input, true);

if ($data === null || json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'تنسيق JSON غير صالح.'
    ]);
    exit;
}

// تم إزالة course_id من الحقول المطلوبة
$requiredFields = ['student_id', 'course_session_id', 'rating'];
foreach ($requiredFields as $field) {
    if (!isset($data[$field])) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => "الحقل المطلوب مفقود: $field"
        ]);
        exit;
    }
}

$studentId = (int)$data['student_id'];
$courseSessionId = (int)$data['course_session_id'];
$rating = (int)$data['rating'];
$feedback = isset($data['feedback']) ? trim($data['feedback']) : '';

if ($rating < 1 || $rating > 5) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'يجب أن يكون التقييم بين 1 و 5.'
    ]);
    exit;
}

try {
    // التحقق من اكتمال الدورة
    $checkCompletionQuery = "SELECT id FROM course_session_students 
                            WHERE student_id = :student_id 
                            AND course_session_id = :course_session_id
                            AND status = 'completed'";
    $checkCompletionStmt = $conn->prepare($checkCompletionQuery);
    $checkCompletionStmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $checkCompletionStmt->bindParam(':course_session_id', $courseSessionId, PDO::PARAM_INT);
    $checkCompletionStmt->execute();
    
    if ($checkCompletionStmt->rowCount() === 0) {
        http_response_code(403);
        echo json_encode([
            'success' => false,
            'message' => 'لم تُكمل هذه الدورة بعد، لا يمكنك تقييمها.'
        ]);
        exit;
    }

    // إدخال التقييم
    $insertQuery = "INSERT INTO course_evaluations 
                   (student_id, course_session_id, rating, feedback, date) 
                   VALUES (:student_id, :course_session_id, :rating, :feedback, NOW())";
    $insertStmt = $conn->prepare($insertQuery);
    $insertStmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $insertStmt->bindParam(':course_session_id', $courseSessionId, PDO::PARAM_INT);
    $insertStmt->bindParam(':rating', $rating, PDO::PARAM_INT);
    $insertStmt->bindParam(':feedback', $feedback, PDO::PARAM_STR);
    
    if ($insertStmt->execute()) {
        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'تم إرسال تقييم الدورة بنجاح.'
        ]);
    } else {
        throw new Exception('فشل في تنفيذ الاستعلام.');
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'خطأ في قاعدة البيانات: ' . $e->getMessage()
    ]);
    error_log("Database error: " . $e->getMessage());
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'حدث خطأ: ' . $e->getMessage()
    ]);
}
?>

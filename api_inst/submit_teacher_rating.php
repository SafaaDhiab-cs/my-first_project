<?php
header("Content-Type: application/json");
require_once 'db.php';

// تمكين عرض الأخطاء
error_reporting(E_ALL);
ini_set('display_errors', 1);

// التحقق من أن الطلب POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'يجب استخدام طريقة POST للإرسال'
    ]);
    exit;
}

// قراءة بيانات JSON
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// التحقق من صحة JSON
if ($data === null || json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'تنسيق JSON غير صالح'
    ]);
    exit;
}

// التحقق من الحقول المطلوبة
if (!isset($data['student_id'], $data['teacher_id'], $data['course_id'], $data['rating'])) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'بيانات ناقصة: يجب إرسال student_id, teacher_id, course_id, rating'
    ]);
    exit;
}

// تنظيف البيانات
$studentId = (int)$data['student_id'];
$teacherId = (int)$data['teacher_id'];
$courseId = (int)$data['course_id'];
$rating = (int)$data['rating'];
$feedback = isset($data['feedback']) ? trim($data['feedback']) : '';

// التحقق من نطاق التقييم
if ($rating < 1 || $rating > 5) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'يجب أن يكون التقييم بين 1 و 5'
    ]);
    exit;
}

// إجراءات قاعدة البيانات
try {
    // التحقق من أن الطالب أكمل الكورس
    $checkCourseQuery = "SELECT id FROM course_students 
                        WHERE student_id = :student_id 
                        AND course_id = :course_id
                        AND status = 'completed'";
    $checkCourseStmt = $conn->prepare($checkCourseQuery);
    $checkCourseStmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $checkCourseStmt->bindParam(':course_id', $courseId, PDO::PARAM_INT);
    $checkCourseStmt->execute();
    
    if ($checkCourseStmt->rowCount() == 0) {
        http_response_code(403);
        echo json_encode([
            'success' => false,
            'message' => 'لا يمكن التقييم قبل إكمال الكورس'
        ]);
        exit;
    }

    // التحقق من التقييم الموجود
    $checkQuery = "SELECT id FROM teacher_evaluations 
                  WHERE user_id = :student_id 
                  AND teacher_id = :teacher_id 
                  AND course_id = :course_id";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $checkStmt->bindParam(':teacher_id', $teacherId, PDO::PARAM_INT);
    $checkStmt->bindParam(':course_id', $courseId, PDO::PARAM_INT);
    $checkStmt->execute();
    
    if ($checkStmt->rowCount() > 0) {
        http_response_code(409);
        echo json_encode([
            'success' => false,
            'message' => 'تم تقييم هذا المدرس مسبقاً لهذه المادة'
        ]);
        exit;
    }

    // إدراج التقييم الجديد
    $insertQuery = "INSERT INTO teacher_evaluations 
                   (user_id, teacher_id, course_id, rating, feedback, date) 
                   VALUES (:student_id, :teacher_id, :course_id, :rating, :feedback, NOW())";
    $insertStmt = $conn->prepare($insertQuery);
    $insertStmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $insertStmt->bindParam(':teacher_id', $teacherId, PDO::PARAM_INT);
    $insertStmt->bindParam(':course_id', $courseId, PDO::PARAM_INT);
    $insertStmt->bindParam(':rating', $rating, PDO::PARAM_INT);
    $insertStmt->bindParam(':feedback', $feedback, PDO::PARAM_STR);
    
    if ($insertStmt->execute()) {
        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'تم تسجيل تقييم المدرس بنجاح'
        ]);
    } else {
        throw new Exception('فشل في تنفيذ الاستعلام');
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'حدث خطأ في الخادم: ' . $e->getMessage()
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
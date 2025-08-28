<?php
header("Content-Type: application/json");
require_once 'db.php'; // تأكد أن الاتصال في db.php يتم باستخدام PDO

$studentId = $_GET['student_id'] ?? 0;

if (empty($studentId)) {
    echo json_encode(['success' => false, 'message' => 'Student ID is required']);
    exit;
}

try {
    // استعلام لاسترجاع الدورات المكتملة مع بيانات الحضور
    $query = "
        SELECT 
            cs.course_id,
            c.course_name,
            COUNT(a.id) AS total_days,
            SUM(CASE WHEN a.status = 1 THEN 1 ELSE 0 END) AS attendance_days,
            SUM(CASE WHEN a.status = 0 THEN 1 ELSE 0 END) AS absence_days,
            1 AS is_completed
        FROM 
            course_session_students css
        JOIN 
            course_sessions cs ON css.course_session_id = cs.id
        JOIN 
            courses c ON cs.course_id = c.id
        LEFT JOIN 
            attendances a ON css.student_id = a.student_id AND cs.id = a.session_id
        WHERE 
            css.student_id = ?
            AND css.status = 'completed'
        GROUP BY 
            cs.course_id, c.course_name
    ";

    $stmt = $conn->prepare($query);
    $stmt->execute([$studentId]);
    $attendanceData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'attendance' => $attendanceData
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error: ' . $e->getMessage()
    ]);
}
?>

<?php
header("Content-Type: application/json");
require_once 'db.php';

$studentId = $_GET['student_id'] ?? 0;

try {
    // الاستعلام الكامل كما طلبت تمامًا
    $query = "
        SELECT 
            e.id AS teacher_id,
            e.name_ar AS teacher_name,
            c.id AS course_id,
            c.course_name,
            IFNULL(te.rating, 0) AS rating,
            IFNULL(te.feedback, '') AS feedback,
            CASE WHEN te.id IS NOT NULL THEN 1 ELSE 0 END AS is_rated
        FROM 
            course_students cs
        JOIN 
            courses c ON cs.course_id = c.id
        JOIN 
            course_sessions sess ON sess.course_id = c.id
        JOIN 
            employees e ON sess.employee_id = e.id AND e.emptype = 'teacher'
        LEFT JOIN 
            teacher_evaluations te ON te.employee_id = e.id 
            AND te.user_id = cs.student_id 
          
        WHERE 
            cs.student_id = :student_id 
            AND cs.status = 'completed'
        GROUP BY e.id, c.id
        ORDER BY is_rated ASC
    ";

    $stmt = $conn->prepare($query);
    $stmt->bindParam(':student_id', $studentId, PDO::PARAM_INT);
    $stmt->execute();

    $teachers = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'teachers' => $teachers
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>

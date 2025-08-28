<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php';

if (!isset($_GET['student_id'])) {
    echo json_encode(['success' => false, 'message' => 'معرف الطالب مطلوب']);
    exit;
}

$student_id = (int)$_GET['student_id'];

try {
    $sql = "
    SELECT 
        cs.id AS course_session_id,
        c.id AS course_id,
        c.course_name,
        d.department_name AS category,
        css.register_at,
        dg.practical_degree,
        dg.final_degree,
        dg.attendance_degree,
        dg.total_degree,
        dg.state AS degree_status,
        css.status AS course_status,
        CASE
            WHEN css.status = 'completed' THEN 1
            ELSE 0
        END AS is_completed
    FROM course_session_students css
    JOIN course_sessions cs ON css.course_session_id = cs.id
    JOIN courses c ON cs.course_id = c.id
    JOIN departments d ON c.department_id = d.id
    LEFT JOIN degrees dg ON (css.student_id = dg.student_id AND cs.id = dg.course_session_id)
    WHERE css.student_id = :student_id
    ORDER BY css.register_at DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':student_id', $student_id, PDO::PARAM_INT);
    $stmt->execute();

    $courses = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'courses' => $courses
    ], JSON_NUMERIC_CHECK);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => 'حدث خطأ: ' . $e->getMessage()
    ]);
}
?>
<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php';

try {
    $stmt = $conn->prepare("SELECT 
        e.id,
        e.name_ar,
        e.name_en,
        e.email,
        e.address,
        e.gender,
        e.image,
        e.phones,
        q.qualification_name,
        q.issuing_authority,
        q.certification,
        q.obtained_date
    FROM employees e
    LEFT JOIN qualifications q ON e.id = q.employee_id
    WHERE e.emptype = 'teacher'");
    
    $stmt->execute();
    $teachers = [];
    $currentTeacherId = null;
    $currentTeacher = null;

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        if ($row['id'] != $currentTeacherId) {
            // معلم جديد
            if ($currentTeacher != null) {
                $teachers[] = $currentTeacher;
            }
            
            $phones = !empty($row['phones']) ? json_decode($row['phones'], true) : [];
            
            $currentTeacher = [
                "id" => $row['id'],
                "name_ar" => $row['name_ar'],
                "name_en" => $row['name_en'],
                "email" => $row['email'],
                "address" => $row['address'],
                "gender" => $row['gender'],
                "phone_numbers" => $phones,
                "qualifications" => [],
                "image_url" => !empty($row['image']) ? "http://192.168.0.250/api_inst/uploads/" . $row['image'] : ""
            ];
            
            $currentTeacherId = $row['id'];
        }
        
        // إضافة المؤهل إذا كان موجوداً
        if (!empty($row['qualification_name'])) {
            $qualification = [
                "name" => $row['qualification_name'],
                "authority" => $row['issuing_authority'],
                "certification" => $row['certification'],
                "date" => $row['obtained_date']
            ];
            $currentTeacher['qualifications'][] = $qualification;
        }
    }
    
    // إضافة آخر معلم
    if ($currentTeacher != null) {
        $teachers[] = $currentTeacher;
    }

    echo json_encode([
        "status" => "success", 
        "teachers" => $teachers
    ], JSON_UNESCAPED_UNICODE);
    
} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
?>
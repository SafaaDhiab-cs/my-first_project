<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require 'db.php';

try {
    // استعلام لجلب معلومات المعهد حسب الأعمدة الجديدة
    $sql = "SELECT institute_name, institute_description, phone, email, address, about_image FROM institutes LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $institute = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // معالجة رابط الصورة إذا كان موجوداً
        if (!empty($institute['about_image'])) {  // ✅ تم تصحيح الخطأ هنا
            if (!filter_var($institute['about_image'], FILTER_VALIDATE_URL)) {
                $institute['about_image'] = 'http://192.168.0.250/api_inst/uploads/' . $institute['about_image'];
            }
        }

        echo json_encode($institute);
    } else {
        echo json_encode(['error' => 'No data found']);
    }
} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>

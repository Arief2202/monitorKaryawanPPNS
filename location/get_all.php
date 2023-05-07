<?php
// if ($_SERVER['REQUEST_METHOD'] === 'GET') {
//     http_response_code(404);  
//     exit;    
// }
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
include "../koneksi.php";

$sql = "SELECT nuid, name, username, email FROM user";
$result = mysqli_query($koneksi, $sql);
$data;
while($user = mysqli_fetch_object($result)){
    $sql2 = "SELECT x,y,ruang,timestamp FROM `history_location` where nuid = ".$user->nuid." ORDER BY `timestamp` DESC limit 1;";
    $result2 = mysqli_query($koneksi, $sql2);
    $location = mysqli_fetch_object($result2);
    if($location){        
        $user->currentLocation = $location;
        $data[] = $user;
    }
}
echo json_encode($data);
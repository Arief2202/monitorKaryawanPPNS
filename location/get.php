<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    http_response_code(404);  
    exit;    
}
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
include "../koneksi.php";

if(isset($_POST['nuid'])){
    $sql = "SELECT * FROM user WHERE nuid=".$_POST['nuid'];
    $result = mysqli_query($koneksi, $sql);
    $user = mysqli_fetch_object($result);
    $sql2 = "SELECT x,y,ruang,timestamp FROM `history_location` where nuid = ".$user->nuid." ORDER BY `timestamp` DESC limit 1;";
    $result2 = mysqli_query($koneksi, $sql2);
    if($result2){
        $location = mysqli_fetch_object($result2);
        $user->currentLocation = $location;
    }
    echo json_encode($user);
}
else{
    echo json_encode([
        "nuid" => null,
        "message" => "Please insert nuid"
    ]);
}
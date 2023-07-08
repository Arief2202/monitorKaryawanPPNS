<?php
// if ($_SERVER['REQUEST_METHOD'] === 'GET') {
//     http_response_code(404);  
//     exit;    
// }
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
include "../koneksi.php";

$sql = "SELECT nuid, foto, name, username, email FROM `user`";
$result = mysqli_query($koneksi, $sql);
$data;
while($monitor_karyawan = mysqli_fetch_object($result)){
    // $sql2 = "SELECT nuid, name, username, email FROM `user` where nuid = ".$monitor_karyawan->nuid;
    // $result2 = mysqli_query($koneksi, $sql2);
    // $monitor_karyawan->user = mysqli_fetch_object($result2);
    // $monitor_karyawan->name = $monitor_karyawan->user->name;
    $data[] = $monitor_karyawan;
}
echo json_encode($data);
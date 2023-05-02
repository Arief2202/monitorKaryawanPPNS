<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    http_response_code(404);  
    exit;    
}
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
$koneksi = mysqli_connect("localhost", "ppns/absensi", "password", "ppns/absensi");

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
else if(isset($_POST['ruang'])){
    $sql = "SELECT * FROM user";
    $result = mysqli_query($koneksi, $sql);
    $users = array();
    while($user = mysqli_fetch_object($result)){
        
        $sql2 = "SELECT x,y,ruang,timestamp FROM `history_location` where nuid = ".$user->nuid." ORDER BY `timestamp` DESC limit 1;";
        $result2 = mysqli_query($koneksi, $sql2);
        if($result2){
            $location = mysqli_fetch_object($result2);
            $user->currentLocation = $location;
        }
        if($user->currentLocation->ruang == $_POST['ruang']){
            $users[] = $user;
        }
    }
    echo json_encode($users);
}
else{
    $sql = "SELECT * FROM user";
    $result = mysqli_query($koneksi, $sql);
    $users = array();
    while($user = mysqli_fetch_object($result)){
        
        $sql2 = "SELECT x,y,ruang,timestamp FROM `history_location` where nuid = ".$user->nuid." ORDER BY `timestamp` DESC limit 1;";
        $result2 = mysqli_query($koneksi, $sql2);
        if($result2){
            $location = mysqli_fetch_object($result2);
            $user->currentLocation = $location;
        }
        $users[] = $user;
    }
    echo json_encode($users);

}
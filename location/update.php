<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    http_response_code(404);  
    exit;    
}

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
include "../koneksi.php";
if(isset($_POST['nuid']) && isset($_POST['x']) && isset($_POST['y']) && isset($_POST['ruang']) && isset($_POST['password'])){
    // if($_POST['ruang'] != )
    if( $_POST['nuid'] == "" ||
        $_POST['x'] == "" ||
        $_POST['y'] == "" ||
        $_POST['ruang'] == "" ||
        $_POST['password'] == "" ){                
            echo json_encode([
                "status" => false,
                "nuid" => $_POST['nuid'],
                "message" => "Update Location Failed, Query cannot be empty!",
                "timestamp" => date("d M Y h:i:s", time()),
            ]);
            exit;
        }
    else{
        $sql = "SELECT * FROM `user` WHERE nuid = ".$_POST['nuid'];
        $result = mysqli_query($koneksi, $sql);
        $user = mysqli_fetch_object($result);
        if($user->password != $_POST['password']){            
            echo json_encode([
                "status" => false,
                "nuid" => $_POST['nuid'],
                "message" => "Update Location Failed, Wrong Password!",
                "timestamp" => date("d M Y h:i:s", time()),
            ]);
            exit;
        }
        if($user){
            $sql = "INSERT INTO `history_location` (`id`, `nuid`, `x`, `y`, `ruang`, `timestamp`) VALUES (NULL, '".$_POST['nuid']."', '".$_POST['x']."', '".$_POST['y']."', '".$_POST['ruang']."', current_timestamp());";
            $result = mysqli_query($koneksi, $sql);

            $sql2 = "SELECT * FROM `monitor_karyawan` WHERE nuid = ".$_POST['nuid']." ORDER BY `timestamp` DESC";
            $result2 = mysqli_query($koneksi, $sql2);
            $data = mysqli_fetch_object($result2);

            $outside = false;
            $ruang = $_POST['ruang'];
            $x = $_POST['x'];
            $y = $_POST['y'];
            if($x < 0 || $y < 0) $outside = true;
            else if($y > 88) $outside = true;
            else if($ruang == "M102" && $x > 76) $outside = true;
            else if($ruang == "M103" && $x > 82) $outside = true;
            else if($ruang == "M104" && $x > 72) $outside = true;
            if($outside) $_POST['ruang'] = '-';
            if($data->ruang != $_POST['ruang'] || ($outside && $data->ruang != '-')){
                if($outside) $sql3 = "INSERT INTO `monitor_karyawan` (`id`, `nuid`, `ruang`, `pesan`) VALUES (NULL, '".$_POST['nuid']."', '-', 'Keluar ".$data->ruang."');";
                else $sql3 = "INSERT INTO `monitor_karyawan` (`id`, `nuid`, `ruang`, `pesan`) VALUES (NULL, '".$_POST['nuid']."', '".$_POST['ruang']."', 'Masuk ".$_POST['ruang']."');";
                $result3 = mysqli_query($koneksi, $sql3);
            }
            
            if($result){
                echo json_encode([
                    "status" => true,
                    "nuid" => $_POST['nuid'],
                    "message" => "Update Location Sucesfully",
                    "timestamp" => date("d M Y h:i:s", time()),
                ]);
                exit;
            }
            else{          
                echo json_encode([
                    "status" => false,
                    "nuid" => $_POST['nuid'],
                    "message" => "Update Location Failed, failed to connect database",
                    "timestamp" => date("d M Y h:i:s", time()),
                ]);
                exit;
            }
        }
        else{                      
            echo json_encode([
                "status" => false,
                "nuid" => $_POST['nuid'],
                "message" => "Update Location Failed, User not found!",
                "timestamp" => date("d M Y h:i:s", time()),
            ]);
            exit;
        }
    }
}      
echo json_encode([
    "status" => false,
    "nuid" => $_POST['nuid'],
    "message" => "Update Location Failed, Missing Some Queries!",
    "timestamp" => date("d M Y h:i:s", time()),
]);
exit;
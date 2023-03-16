<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    http_response_code(404);  
    exit;    
}

header('Content-Type: application/json; charset=utf-8');
$koneksi = mysqli_connect("localhost", "ppns/absensi", "password", "ppns/absensi");
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
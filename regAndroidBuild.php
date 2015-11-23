<?php

$db = new mysqli('localhost', 'USERNAME', 'PASSWORD', 'android_db');

if($db->connect_errno > 0){
    die('Unable to connect to database [' . $db->connect_error . ']');
}

$cpu = $_GET['cpu'];
$numprocs = $_GET['numprocs'];
$distro = $_GET['distro'];
$using_ccache = (empty($_GET['using_ccache'])) ? '0' : '1';
$ccache_size = $_GET['ccache_size'];
$ssds = (empty($_GET['ssds'])) ? 'None' : $_GET['ssds'];
$hdds = (empty($_GET['hdds'])) ? 'None' : $_GET['hdds'];
$outvolume = $_GET['outvolume'];
$sourcevolume = $_GET['sourcevolume'];
$totalmemory = $_GET['totalmemory'];
$platform = $_GET['platform'];
$prebuiltchromium = (empty($_GET['prebuiltchromium'])) ? '0':'1';
$buildtime = $_GET['buildtime'];

$query = "INSERT INTO builddb (cpu,numprocs,distro,using_ccache,ccache_size,ssds,hdds,outvolume,sourcevolume,totalmemory,platform,prebuiltchromium,buildtime) VALUES('$cpu','$numprocs','$distro','$using_ccache','$ccache_size','$ssds','$hdds','$outvolume','$sourcevolume','$totalmemory','$platform','$prebuiltchromium','$buildtime')";

if(!$result = $db->query($query)){
    die('There was an error running the query [' . $db->error . ']');
}

$db->close();
?>

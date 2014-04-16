<?php

/*
	Copyright (c) 2013 - 2014, RKE
*/


require_once('../../common.php');
checkSession();

header("Content-Type: text/javascript");

switch($_GET['action']) {
    
    case 'save':
        if (isset($_POST['settings'])) {
            file_put_contents(DATA . "/config/lesscompiler.settings.php", $_POST['settings']);
            echo '{"status":"success","message":"Settings saved"}';
        } else {
            echo '{"status":"error","message":"Missing parameter"}';
        }
        break;
    
    case 'load':
        if (file_exists(DATA . "/config/lesscompiler.settings.php")) {
            echo file_get_contents(DATA . "/config/lesscompiler.settings.php");
        } else {
            echo file_get_contents("default.settings.json");
        }
        break;
        
    case 'getWorkspaceUrl':
        $protocol = ((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
        echo json_encode(array(
            'workspaceUrl' => $protocol.WSURL.'/',
        ));
        break;
        
    default:
        echo '{"status":"error","message":"No Type"}';
        break;
}
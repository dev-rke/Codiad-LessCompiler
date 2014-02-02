<?php

/*
 * Copyright (c) Codiad & Andr3as, distributed
 * as-is and without warranty under the MIT License. 
 * See http://opensource.org/licenses/MIT for more information.
 * This information must remain intact.
 */
//error_reporting(0);


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
        
    default:
        echo '{"status":"error","message":"No Type"}';
        break;
}
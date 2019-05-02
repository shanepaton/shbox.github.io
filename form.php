<?php

if (isset($_POST['submit'])){
    $name = $_POST['name'];
    $mailFrom = $_POST['mail'];
    $message = $_POST['message'];

    $mailTo = "Shane.Games.Webmail@gmail.com";
    $headers = "From: ".mailFrom;
    $txt = "mailsent".name.".\n\n".message;

    mail($mailTo, $txt, $headers);
    header("Location: feedback.php?mailsend");
    
}
<!DOCTYPE html>
<html lang="en">
<link rel="shortcut icon" id="image" type="image/png" href="/images/favicon.png">

<body text="#ffffff" link="#addbff" vlink="#7fc7ff">

    <head>
        <link type="text/css" rel="stylesheet" href="/css/stylesheet.css" />
        <title>Feedback</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    </head>

    <body>
        <h1>Feedback</h1>
        <div class="center">

            <a href="index.html">Home</a>
            <a href="snake.html">Snake Game</a>
            <a href="pk-index.html">PK Index</a>

            <form class="contact-form" action="form.php" method="POST">
                <p>Name:</p>
                <input type="text" name="name" placeholder="Joe Generic">
                <p>Email:</p>
                <input type="email" name="mail" placeholder="JoeGeneric@mail.com">
                <br>
                <p>Message:</p>
                <input type="text" name="message" placeholder="Hi Nice website!">
                <br><br>
                <input type="submit" name="submit" value="Submit">
            </form>
        </div>
        <?php include('form.php');>
    </body>

</html>
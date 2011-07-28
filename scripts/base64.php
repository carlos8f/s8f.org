<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>base64 codec</title>
  <style type="text/css">
    body { padding: 1em 4em; font-family: sans-serif; }
    pre { font-family: mono; background-color: #eee; padding: 1em; }
  </style>
</head>
<body>
<div>
  <h1>base64 codec</h1>

  <?php
  
  foreach ($_POST as $key => &$val) $val = filter_input(INPUT_POST, $key);

  if (isset($_POST['decode'])) {
    print '<h2>decoded</h2>';
    print '<pre>'. htmlspecialchars(base64_decode(trim($_POST['content']))) .'</pre>';
  }
  if (isset($_POST['encode'])) {
    print '<h2>encoded</h2>';
    print '<pre>'. htmlspecialchars(base64_encode(trim($_POST['content']))) .'</pre>';
  }

  ?>

  <form action="" method="post" accept-charset="utf-8">
    <p><label>Input<br /><textarea name="content" cols="80" rows="10"><?php print htmlspecialchars($_POST['content']); ?></textarea></label></p>
    <p><input type="submit" name="decode" value="decode" /> <input type="submit" name="encode" value="encode" /></p>
  </form>

  <p>(<a href="https://github.com/carlos8f/s8f.org/blob/master/scripts/base64.php">source</a>)</p>
</div>
</body>
</html>

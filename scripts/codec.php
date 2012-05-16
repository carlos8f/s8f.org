<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>codec</title>
  <style type="text/css">
    body { padding: 1em 4em; font-family: sans-serif; }
    pre { font-family: mono; background-color: #eee; padding: 1em; }
  </style>
</head>
<body>
<div>
  <h1>codec</h1>

  <?php
  
  foreach ($_POST as $key => &$val) $val = filter_input(INPUT_POST, $key);

  function codec_hex($input, $dir) {
    switch ($dir) {
      case 'encode': return implode(' ', array_map('dechex', array_map('ord', str_split($input))));
      case 'decode': return implode('', array_map('chr', array_map('hexdec', explode(' ', $input))));
    }
  }

  function codec_base64($input, $dir) {
    switch ($dir) {
      case 'encode': return base64_encode($input);
      case 'decode': return base64_decode($input);
    }
  }
  
  $codices = array('hex', 'base64');
  
  $codec = isset($_POST['codec']) && in_array($_POST['codec'], $codices) ? $_POST['codec'] : NULL;
  $dir = isset($_POST['encode']) ? 'encode' : 'decode';

  if (isset($_POST['content']) && $codec) {
    $_POST['content'] = trim($_POST['content']);
    $func = "codec_$codec";
    $output = $func($_POST['content'], $dir);
  }
  if (isset($_POST['decode'])) {
    print '<h2>decoded</h2>';
    print '<pre>'. htmlspecialchars($output) .'</pre>';
  }
  if (isset($_POST['encode'])) {
    print '<h2>encoded</h2>';
    print '<pre>'. htmlspecialchars($output) .'</pre>';
  }

  ?>

  <form action="" method="post" accept-charset="utf-8">
    <p><label>Input<br /><textarea name="content" cols="80" rows="10"><?php if (isset($_POST['content'])) print htmlspecialchars($_POST['content']); ?></textarea></label></p>
    <p><label>Codec<br /><select name="codec"><?php foreach ($codices as $c): ?><option value="<?php print $c; if ($codec == $c) print '" selected="selected'; ?>"><?php print $c; ?></option><?php endforeach; ?></select></label></p>
    <p><input type="submit" name="decode" value="decode" /> <input type="submit" name="encode" value="encode" /></p>
  </form>

  <p>(<a href="https://github.com/carlos8f/s8f.org/blob/master/scripts/codec.php">source</a>)</p>
</div>
</body>
</html>

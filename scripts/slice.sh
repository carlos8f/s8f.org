#!/usr/bin/php
<?php

array_shift($argv);
$begin = strtotime(array_shift($argv));
$end = strtotime(array_shift($argv));

$col = $argv;

while ($line = fgets(STDIN)) {
  $line = trim($line);
  if (empty($line)) {
    continue;
  }
  $cols = preg_split('~\s+~', $line);
  if (count($cols) < end($col)) {
    continue;
  }
  $date = array();
  foreach ($col as $print) {
    $date[] = $cols[$print - 1];
  }
  $date = str_replace(array('[', ']'), '', implode(' ', $date));
  if (!is_numeric($date)) {
    $date = strtotime($date);
  }
  if ($date < $begin) {
    continue;
  }
  elseif ($date > $end) {
    exit();
  }
  print $line ."\n";
}


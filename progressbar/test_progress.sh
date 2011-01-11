#!/usr/bin/php
<?php
/**
 * Test the progressBar.
 */
include_once 'S8f_Progress.php';
$total = 10000000;
$p = new S8f_Progress($total);

for ($current = 0; $current < $total; $current++) {
  $p->output();
}

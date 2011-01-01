<?php
// $Id$

function s8f_preprocess_html(&$variables) {
  $body_bgs = glob(drupal_get_path('theme', 's8f') . '/images/body-backgrounds/*');
  $body_bg = base_path() . $body_bgs[mt_rand(0, count($body_bgs) - 1)];
  $header_bgs = glob(drupal_get_path('theme', 's8f') . '/images/header-backgrounds/*');
  $header_bg = base_path() . $header_bgs[mt_rand(0, count($header_bgs) - 1)];
  $css = <<<EOT
body { background-image: url($body_bg); }
#header { background-image: url($header_bg); }
EOT;
  drupal_add_css($css, array('type' => 'inline', 'group' => CSS_THEME));
}


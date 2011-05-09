<?php
// $Id$

/**
 * Implementation of hook_drush_command().
 */
function multisite_drush_command() {
  $items['multisite'] = array(
    'aliases' => array('multi', 'ms'),
    'description' => 'Run a command on multiple Drupal sites.',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_ROOT,
    'examples' => array(
      'drush [command] <command> <options>' => 'Run <command> on all sites using <options>.',
      'drush [command] --sites=http://default,http://subsite.mysite.com <command>' => 'Run <command> on sites/default and sites/subsite.mysite.com.',
    ),
  );
  $items['multisite-hosts'] = array(
    'aliases' => array('msp'),
    'description' => 'Print a list of multisite domains.',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_ROOT,
  );
  return $items;
}

/**
 * Implementation of hook_drush_help().
 */
function multisite_drush_help($section) {
  switch ($section) {
    case 'drush:multisite':
      return dt('Perform a command on multiple sites.');
  }
}

/**
 * Drush callback to run a command on multiple Drupal sites.
 */
function drush_multisite($command = NULL) {
  if (empty($command)) {
    drush_set_error(dt('Usage: drush multisite <command> [options...], where <command> is a drush command.'));
    return;
  }
  // Accept a variable number of arguments.
  $args = func_get_args();
  array_shift($args);

  // Enumerate sites and construct --uri arguments to target them.
  if ($sites_option = drush_get_option('sites')) {
    $sites = explode(',', $sites_option);
  }
  else {
    // Track symlink targets, so sites aren't hit twice.
    $targets = array();
    $sites = array();
    $result = array_keys(drush_scan_directory(drush_get_context('DRUSH_DRUPAL_ROOT') . '/sites', '/^settings\.php$/', array('.', '..', 'CVS', 'all'), 0, 2));
    foreach($result as $path) {
      $dir_path = dirname($path);
      $target = realpath($dir_path);
      if (isset($targets[$target])) {
        continue;
      }
      $targets[$target] = TRUE;
      $site = strtolower(basename($dir_path));
      if ($site === 'default') {
        continue;
      }
      $sites[] = 'http://' . $site;
    }
  }
  if (empty($sites)) {
    drush_set_error(dt('No sites found to run command on.'));
    return;
  }
  if (!drush_get_context('DRUSH_SIMULATE') && !drush_confirm(dt("Are you sure you want to run '@command' on @num site(s)?", array('@command' => $command, '@num' => count($sites))))) {
    drush_set_error(dt('Aborting.'));
    return;
  }
  // Pass options along with the command.
  $data = drush_get_context('options');
  unset($data['sites']);
  sort($sites);
  // Execute the command with drush_backend_invoke().
  foreach ($sites as $uri) {
    $data['uri'] = $uri;
    $cmd = ($args) ? $command . ' ' . implode(' ', $args) : $command;
    drush_print(dt("Running '@command' on @uri...", array('@command' => $cmd, '@uri' => $uri)));
    drush_backend_invoke_args($command, $args, $data);
    print "\n";
  }
}

/**
 * Drush callback to run a command on multiple Drupal sites.
 */
function drush_multisite_hosts($ip = NULL, $slice_size = 10) {
  if (empty($ip)) {
    drush_set_error(dt('Usage: drush multisite-hosts <ip>'));
    return;
  }
  $sites = array();
  $result = array_keys(drush_scan_directory(drush_get_context('DRUSH_DRUPAL_ROOT') . '/sites', '/^settings\.php$/', array('.', '..', 'CVS', 'all'), 0, 2));
  foreach($result as $path) {
    $dir_path = dirname($path);
    if (is_link($dir_path)) {
      continue;
    }
    $site = strtolower(basename($dir_path));
    $sites[] = $site;
  }
  sort($sites);
  $i = 0;
  while ($slice = array_slice($sites, $i, $slice_size)) {
    print $ip . "\t" . implode(' ', $slice) . "\n";
    $i += $slice_size;
  }
  print "\n";
}

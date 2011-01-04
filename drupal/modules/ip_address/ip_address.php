<?php
// $Id$
/**
 * @file
 * Print the user's IP address.
 */

header('Content-Type: text/plain; charset=utf-8');
print $_SERVER['REMOTE_ADDR'];


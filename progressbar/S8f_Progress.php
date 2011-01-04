<?php

/**
 * Progress Bar
 *
 * A portable progress bar for PHP shell scripts.
 *
 * Example usage:
 *
 * @code
 * include_once 'S8f_Progress.php';
 * $total = 100000;
 * $current = 0;
 * $p = new S8f_Progress($total);
 * while ($current++ < $total) {
 *   $p->output();
 * }
 * @code
 *
 * @license MIT
 * @author Brian Link, Carlos Rodriguez
 * @copyright 2011 Terra Eclipse, Inc.
 * @url http://s8f.org/software
 */
class S8f_Progress {
  /**
   * Total number of items to process.
   */
  public $total;
  /**
   * Current item number.
   */
  public $current = 0;
  /**
   * Maximum percent of total time the progressbar is allowed to take during processing.
   * Defaults to 0.5%
   */
  public $max_burden = 0.5;
  /**
   * Whether to show current burden %.
   */
  public $show_burden = FALSE;

  protected $started = FALSE;
  protected $size = 50;
  protected $inner_time = 0;
  protected $outer_time = 0;
  protected $avg_time = 0;
  protected $time_start = 0;
  protected $time_end = 0;
  protected $time_left = 0;
  protected $time_burden = 0;
  protected $skip_steps = 0;
  protected $skipped = 0;

  // Formatting
  protected $bold = "\033[1m";
  protected $close = "\033[0m";

  /**
   * Constructor.
   *
   * @param integer $total
   *   Number of total items to be processed.
   * @param array $options
   *   Associative array which can override properties of the class.
   */
  function __construct($total, $options = array()) {
    $this->total = $total;
    foreach ($options as $name => $value) {
      $this->$name = $value;
    }
  }

  /**
   * Output (and iterate) the progress bar.
   * 
   * @param $current
   *   (optional) Number of processed items. If not specified, the
   *   running total will be incremented.
   * @param $new_total
   *   (optional) Set a new total number of items (use if the batch size is dynamic).
   */
  public function output($current = NULL, $new_total = NULL) {
    if (isset($current)) {
      $this->current = $current;
    }
    else {
      $this->current++;
    }
    if (isset($new_total)) {
      $this->total = $new_total;
    }

    if ($this->current >= $this->total || $this->burden_reached()) {
      return;
    }

    // Perform the main progress bar logic.
    $output = '';
    if (!$this->started) {
      $this->started = microtime(TRUE);
      $output .= "\n\n\n";
    }

    // Start collecting time.
    $this->time_start = microtime(TRUE);
    if ($this->time_end > 0) {
      $this->outer_time = $this->time_start - $this->time_end;
    }
    if ($this->inner_time > 0 && $this->outer_time > 0) {
      // Set Current Burden
      $this->time_burden = ($this->inner_time / ($this->inner_time + $this->outer_time)) * 100;

      // Estimate time left.
      if ($this->avg_time > 0) {
        $this->avg_time = ($this->avg_time + ($this->inner_time + $this->outer_time)) / 2;
      }
      else {
        $this->avg_time = $this->inner_time + $this->outer_time;
      }
      $this->time_left = $this->avg_time * (($this->total - $this->current) / ($this->skip_steps + 1));
      if ($this->time_left < 0) $this->time_left = 0;
    }
    // If our "burden" is too high, increase the skip steps.
    if ($this->time_burden > $this->max_burden && ($this->skip_steps < ($this->total / $this->size))) {
      $this->skip_steps = floor(++$this->skip_steps * 1.3);
    }

    // Output the Progress Bar.
    $output .= "\r" . chr(27) . "[F" . chr(27) . "[F";
    $output .= "Processing: \033[32;42m";
    for ($i = 0; $i < (($this->current / $this->total) * $this->size) - 1 ; $i++) {
       $output .= " ";
    }
    $output .= " \033[37;47m";
    while ($i < $this->size - 1) {
      $output .= " ";
      $i++;
    }
    $output .= $this->close . "\n";
    $output .= "         ";

    // Output numerical stats.
    $this->perc = ($this->current/$this->total)*100;
    $this->perc = str_pad(substr($this->perc, 0, 4), 4, ' ', STR_PAD_LEFT);
    $output .= '   ' . $this->bold . $this->perc . '%' . $this->close;
    $this->total_len = strlen(number_format($this->total));
    $output .= '  ' . $this->bold . str_pad(number_format($this->current), $this->total_len, ' ', STR_PAD_LEFT) . $this->close . '/' . number_format($this->total);

    // Output burden.
    if ($this->show_burden) {
      $output .= '   ' . $this->bold . 'Burden: ' . $this->close . substr($this->time_burden, 0, 4) . '% / ' . $this->skip_steps;
    }

    // Output times.
    $this->elapsed = $this->time_start - $this->started;
    $hours = floor($this->elapsed / 3600);
    $min = floor($this->elapsed % 3600 / 60);
    $sec = $this->elapsed % 60;
    $this->elapsed = ($hours ? sprintf("%dh ", $hours) : "") . ($min ? sprintf("%02dm ", $min) : "") . sprintf("%02ds", $sec);
    $output .= "  " . $this->bold . "Elapsed: " . $this->close . $this->elapsed;
    
    if ($this->time_left){
      $hours = floor($this->time_left / 3600);
      $min = floor($this->time_left % 3600 / 60);
      $sec = $this->time_left % 60;
      $output .= "  " . $this->bold . "Remaining: " . $this->close . ($hours ? sprintf("%dh ", $hours) : "") . ($min ? sprintf("%02dm ", $min) : "") . sprintf("%02ds", $sec);
    }

    // The task is complete.
    if ($this->current >= $this->total) {
      $output .= "\n\n";
      $output .= "Finished in " . $this->bold . $this->elapsed . $this->close . " !";
      $output .= "\n\n";
    }

    // "Clear" the rest of the line.
    $output .= "                                                                         \n";

    print $output;

    // Record end time.
    $this->time_end = microtime(TRUE);
    $this->inner_time = $this->time_end - $this->time_start;
  }

  /**
   * Checks if the burden threshold has been reached.
   */
  protected function burden_reached() {
    // Skip this cycle if the burden has determined we should.
    if ($this->skip_steps > 0 && $this->current < $this->total) {
      if ($this->skipped < $this->skip_steps) {
        $this->skipped++;
        return TRUE;
      }
      else {
        $this->skipped = 0;
      }
    }

    return FALSE;
  }
}

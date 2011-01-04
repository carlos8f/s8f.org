// $Id$
(function ($) {
Drupal.behaviors.ip_address = {
  attach: function (context, settings) {
    $('#ip_address', context).once('ip_address').load(Drupal.settings.basePath + Drupal.settings.ip_address_path + '/ip_address.php');
    $('#ip_geoip', context).once('ip_address_geoip').html(geoip_city() + ', ' + geoip_region() + ', ' + geoip_country_code());
  }
};

})(jQuery);


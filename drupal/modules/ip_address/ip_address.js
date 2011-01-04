// $Id$
(function ($) {
Drupal.behaviors.ip_address = {
  attach: function (context, settings) {
    $('#ip_geoip_country_code', context).once('ip').html(geoip_country_code());
    $('#ip_geoip_country_name', context).once('ip').html(geoip_country_name());
    $('#ip_geoip_city', context).once('ip').html(geoip_city());
    $('#ip_geoip_region', context).once('ip').html(geoip_region());
    $('#ip_geoip_region_name', context).once('ip').html(geoip_region_name());
    $('#ip_geoip_latitude', context).once('ip').html(geoip_latitude());
    $('#ip_geoip_longitude', context).once('ip').html(geoip_longitude());
    $('#ip_geoip_postal_code', context).once('ip').html(geoip_postal_code());
    $('#ip_geoip_area_code', context).once('ip').html(geoip_area_code());
  }
};

})(jQuery);


backend default {
     .host = "127.0.0.1";
     .port = "8080";
}

sub vcl_recv {
     set req.http.X-Forwarded-For = client.ip;

     ## Uncomment return for theme development.
     if (client.ip == "75.149.42.129") {
        ## return (pass);
     }
     if (req.url ~ "^/(install|cron|update|te-monitor\.client)\.php$") {
        return (pass);
     }
     if (req.url ~ "^/server-status") {
        return (pass);
     }

     # Exclude naturally dynamic paths.
     if (req.url ~ "(admin|te_admin|te_attach|ahah|ajax|store|cart|product)") {
        return (pass);
     }

     ## Remove common anonymous cookies.
     set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|_chartbeat|_chartbeat2|CookieTest|splashbox_[0-9]+_[0-9]+)=[^;]*", "");

     ## has_js cookie only useful for batch API.
     if (req.url !~ "^/batch") {
        set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)has_js=[^;]*", "");
     }

     ## Remove a “;” prefix, if present.
     set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");
     ## Remove empty cookies.
     if (req.http.Cookie ~ "^\s*$") {
        unset req.http.Cookie;
     }
     
     ## Catch Drupal theme files
     if (req.url ~ "^/(sites/|misc/|modules/.*\.(js|css))") {
        unset req.http.Cookie;
     }

     # Normalize Accept-Encoding header to improve hit rate.
     if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
           # No point in compressing these
           remove req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
           set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate") {
           set req.http.Accept-Encoding = "deflate";
        } else {
           # unkown algorithm
           remove req.http.Accept-Encoding;
        }
     }

     set req.grace = 30s;
}

sub vcl_hash {
    ## Remove Google advertising GET variable.
    set req.url = regsub(req.url, "\?gclid=.*", "");
    set req.hash += req.url;
    if (req.http.host) {
        set req.hash += req.http.host;
    } else {
        set req.hash += server.ip;
    }
    return (hash);
}

sub vcl_deliver {
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }
}

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";
    synthetic {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>We&rsquo;ll be right back!</title>
  <style type="text/css">
  body { margin: 0; padding: 0; background-color: white; color: black; font-size: 1.2em; font-family: Arial, sans-serif; }
  h1 { font-style: italic; font-weight: normal; font-family: Georgia, "Times New Roman", serif; padding-top: 150px; font-size: 2em; }
  p { line-height: 1.8em; }
  #page { width: 1000px; margin: 50px auto 0 auto; }
  </style>
</head>
<body>
<div id="page">
  <h1>Oops,</h1>
  <p>Our site is experiencing technical difficulties. Please try again in a few minutes.</p>
</div>
</body>
</html>
"};
    return (deliver);
}

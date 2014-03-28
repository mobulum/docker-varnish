import throttle;

backend default {
  .host = "$(eval "echo \$BACKEND_PORT_${BACKEND_ENV_PORT}_TCP_ADDR")";
  .port = "${BACKEND_ENV_PORT}";
}

# Handling of requests that are received from clients.
# First decide whether or not to lookup data in the cache.
sub vcl_recv {
  # Pipe requests that are non-RFC2616 or CONNECT which is weird.
  if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "PATCH" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
    return(pipe);
  }

  if (req.backend.healthy) {
     set req.grace = 30s;
  } else {
     set req.grace = 1h;
  }

  if (req.http.Authorization || req.http.Authenticate) {
    return(pass);
  }

  # Pass requests that are not GET or HEAD
  if (req.request != "GET" && req.request != "HEAD") {
    return(pass);
  }

  if (throttle.is_allowed("ip:" + client.ip, "${THROTTLE_LIMIT}") > 0s) {
    error 429 "Too many requests";
  }

  if (req.http.x-forwarded-for) {
    set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
  } else {
    set req.http.X-Forwarded-For = client.ip;
  }

  # Handle compression correctly. Varnish treats headers literally, not
  # semantically. So it is very well possible that there are cache misses
  # because the headers sent by different browsers aren't the same.
  # @see: http://varnish.projects.linpro.no/wiki/FAQ/Compression
  if (req.http.Accept-Encoding) {
    if (req.http.Accept-Encoding ~ "gzip") {
     # if the browser supports it, we'll use gzip
     set req.http.Accept-Encoding = "gzip";
    } elsif (req.http.Accept-Encoding ~ "deflate") {
     # next, try deflate if it is supported
     set req.http.Accept-Encoding = "deflate";
    } else {
     # unknown algorithm. Probably junk, remove it
     remove req.http.Accept-Encoding;
    }
  }

  # Clear cookie and authorization headers, set grace time, lookup in the cache
  unset req.http.Cookie;
  unset req.http.Authorization;
  return(lookup);
}

# Called when entering pipe mode
sub vcl_pipe {
  set bereq.http.connection = "close";

  if (req.http.X-Forwarded-For) {
    set bereq.http.X-Forwarded-For = req.http.X-Forwarded-For;
  } else {
    set bereq.http.X-Forwarded-For = regsub(client.ip, ":.*", "");
  }
  return (pipe);
}

sub vcl_pass {
  set bereq.http.connection = "close";

  if (req.http.X-Forwarded-For) {
    set bereq.http.X-Forwarded-For = req.http.X-Forwarded-For;
  } else {
    set bereq.http.X-Forwarded-For = regsub(client.ip, ":.*", "");
  }
  #return (pass);
}

# Called when the requested object has been retrieved from the
# backend, or the request to the backend has failed
sub vcl_fetch {
  # Set the grace time
  set beresp.grace = 1h;

  # Do not cache the object if the status is not in the 200s
  if (beresp.status >= 300) {
    # Remove the Set-Cookie header
    remove beresp.http.Set-Cookie;
    return(hit_for_pass);
  }

  # Do not cache the object if the backend application does not want us to.
  if (beresp.http.Cache-Control ~ "(no-cache|no-store|private|must-revalidate)") {
    return(hit_for_pass);
  }

  if (beresp.ttl <= 0s ||
    beresp.http.Set-Cookie ||
    beresp.http.Vary == "*") {
    /*
    * Mark as "Hit-For-Pass" for the next 2 minutes
    */
    set beresp.ttl = 120 s;
    return (hit_for_pass);
  }

  # Everything below here should be cached

  # Remove the Set-Cookie header
  remove beresp.http.Set-Cookie;

  # Deliver the object
  return (deliver);
}

# Called before the response is sent back to the client
sub vcl_deliver {

  # Exclui os assets do revalidate
  if (! (req.url ~ "^/(assets|images|uploads)")) {
    # Force browsers and intermediary caches to always check back with us
    set resp.http.Cache-Control = "private, max-age=0, must-revalidate";
    set resp.http.Pragma = "no-cache";
  }

  # Add a header to indicate a cache HIT/MISS
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }

  return (deliver);
}

sub vcl_error {
  set obj.http.Content-Type = "application/json; charset=utf-8";
  set obj.http.Retry-After = "5";
  synthetic {"{
  "status":""} + obj.status + {"",
  "response":""} + obj.response + {"",
  "xid":""} + req.xid + {"",
  "message":"Varnish cache server error"
  }"};
  return (deliver);
  }

  sub vcl_init {
  return (ok);
}

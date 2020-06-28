## Work VPN terminal settings
#
#

work-vpn-on() {
  # Proxy settings
  export http_proxy=http://www-proxy-hqdc.us.oracle.com:80
  export https_proxy=http://www-proxy-hqdc.us.oracle.com:80
  export no_proxy=localhost,127.0.0.1,us.oracle.com
}

work-vpn-off() {
  unset http_proxy
  unset https_proxy
  unset no_proxy
}

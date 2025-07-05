#!/bin/bash

sitemap=$(curl -s http://localhost/sitemap.xml)

echo "$sitemap" | xmllint --format - 2>/dev/null | grep '<loc>' | sed -E 's/.*<loc>(.*)<\/loc>.*/\1/' | while read -r url; do
  http_url=${url/https:\/\//http:\/\/}
  echo "Warmup: $http_url"
  curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" "$http_url"
done
#!/bin/bash

# Test if URL is passed
if [ -z "$1" ]
  then
    echo "No URL supplied"
    exit 1
fi

# Gets list of URLs from website
echo "Retrieving list of URLs..."
wget -m $1 2>&1 | grep '^--' | awk '{ print $3 }' | grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\)$' > urls.txt

# Prints list of status's from urls.txt
echo "Getting status of URLs..."
while read LINE; do
  curl -o /dev/null --silent --head --write-out "$LINE\nStatus: %{http_code}\n\n" "$LINE" >> status.txt
done < urls.txt

# Push all 301 Redirects to redirect_chains file
echo "Creating pretty reports..."

# add URLs to file
grep -B 1 301 status.txt | grep https | grep -vE '301|^--$' >> TEMP.txt
grep -B 1 404 status.txt | grep -vE '404|^--$' >> not_found.txt

# add redirect chain URL to redirects
while read LINE; do
  redirect=$(curl -Ls -o /dev/null -w %{url_effective} $LINE)
  # echo 'Referrer URL: SHOW CURRENT PAGE'
  echo 'URL: '$LINE >> redirect_chains.txt
  echo 'Redirect URL: '$redirect >> redirect_chains.txt
  echo '' >> redirect_chains.txt
done < TEMP.txt

# this should really be done in the above while loop or using sed
rm TEMP.txt

echo "Completed."
echo "$(grep 'Redirect URL:' redirect_chains.txt | wc -l) redirects found."
echo "$(cat not_found.txt | wc -l) 404's found."

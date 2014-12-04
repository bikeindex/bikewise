git pull --rebase origin master
date=$(expr $(date +%s) - 2592000) 
curl "https://bikewise.org/api/v1/locations?all=true&occurred_since=$date" -k -o 'geojson_data/recent incidents.geojson'
curl "https://bikewise.org/api/v1/locations?all=true" -o geojson_data/all.geojson -k 
git add geojson_data 
git commit -m "Updated with latest mapping data" 
git push origin master
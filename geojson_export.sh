git pull --rebase origin master
date=$(expr $(date +%s) - 2592000)
curl "https://bikewise.org/api/v2/locations?all=true&occurred_after=$date" -k -o 'geojson_data/recent incidents.geojson'
curl "https://bikewise.org/api/v2/locations?all=true" -o geojson_data/all.geojson -k 
git add geojson_data
git commit -m "Updated with latest mapping data" 
git push origin master
rm -f geojson_data/mapbox_geojson.geojson
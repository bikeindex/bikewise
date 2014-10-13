# [BikeWise.org](https://bikewise.org)

A new BikeWise is under development and the data is still in migration.

The updated version of BikeWise (this version) is available at [BikeWise.BikeIndex.org](https://bikewise.bikeindex.org). It will move to [BikeWise.org](https://bikewise.org) once everything has been sorted out.

This documentation might not be perfect, because stuff.

## API useage

BikeWise has a versioned open RESTful API.

There are two endpoints: *locations* and *incidents* ([api/v1/locations](https://bikewise.bikeindex.org/api/v1/locations&updated_since=yesterday), [api/v1/incidents](https://bikewise.bikeindex.org/api/v1/incidents))

*Locations* provides a valid GeoJSON response, while *incidents* provides the information about incidents. Both use the same search methods described below. They both reference the same thing - locations are just incident locations, but in a better format for mapping (they include an id so you can grab the matching location).

Here is a location:

```
{
  "type": "Feature",
  "properties": {
    "id": 1451,
    "type": "Theft"
  },
  "geometry": {
    "type": "Point",
    "coordinates": [
      32.8563846,
      -117.2029363
    ]
  }
}

```

Here is the incident for that location:

```
{
  "id": 1451,
  "title": "Stolen Diamondback Outlook (blue)",
  "description": "Parking Garage Bike Rack Reward: 20",
  "address": "La Jolla/Utc, CA, 92122",
  "type": "Theft",
  "occurred_at": "2014-02-18T00:00:00.000-06:00",
  "updated_at": "2014-10-13T09:22:43.823-05:00",
  "url": "https://bikewise.bikeindex.org/api/v1/incidents/1451",
  "source": {
    "name": "BikeIndex.org",
    "html_url": "https://bikeindex.org/bikes/6638",
    "api_url": "https://bikeindex.org/api/v1/bikes/6638"
  },
  "media": {
    "image_url": null,
    "image_url_thumb": null
  }
}
```


[CORS is enabled](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing), so cross origin requests aren't an issue. Use BikeWise from the browser or server/mobile/party-time.

The API is versioned in the URL path because [pragmatism](http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api#versioning).

### Incidents by area

You can get incidents in an an area.

| property | what it does | blank/default |
| -------- | ------------ | ------------- |
| `location` | Incidents near this location. can be a full or partial address, or latitude, longitude  | Shows from everywhere |
| `proximity_width` | Width of the box for locations, in miles | Defaults to 50  |


### Searching for incidents with the API

You can also search for incidents. All these properties can be combined with the properties that are above.

| property | what it does | blank/default |
| -------- | ------------ | ------------- |
| `query` | Full text search of incidents |   |
| `occurred_since` | Incidents that occurred after this [timestamp](https://en.wikipedia.org/wiki/Unix_time) (integer). | Shows from all time |
| `occurred_before` | Incidents that occurred before this timestamp (integer). | Shows from all time |
| `updated_since` | Incidents created or updated since this timestamp (integer) - *you can pass `yesterday` instead of a timestamp here*. | Shows from all time |
| `incident_type` | Incidents of matching types. Split with commas. Possible types are 'Crash', 'Hazard' and 'Theft'. | Shows all types |


---

Above here, the two endpoints perform essentially the same. 

The following are the ways they're special little snowflakes.


### Pagination

Incidents uses meta for pagination. You can include page number (`page`) and incidents per page (`per_page`) in your query - [api/v1/incidents?page=2&per_page_42](https://bikewise.bikeindex.org/api/v1/incidents?page=2&per_page_42).

Locations is too raw and gritty for that bullshit. Locations returns the first 100 matching your query. Unless you pass `all=true`, in which case it will return all.


### Showing incidents

You can also show an individual incident (particularly useful when you get the id from the location) - [api/v1/locations/42](https://bikewise.bikeindex.org/api/v1/locations/42).


### Creating incidents

You can add incidents to BikeWise. Post a hash to [api/v1/incidents](https://bikewise.bikeindex.org/api/v1/incidents) that looks like this:

```
{
  "latitude": 41.92031,
  "longitude": -87.715781,
  "occurred_at": 1413129174,
  "incident_type": "theft",
  "create_open311_report": false,
  "description": "This is a report that was submitted directly to BikeWise.org",
  "title": "Some new incident",
  "media": {
    "image_url": "https://seeclickfix.com/files/issue_images/0024/8363/1411756212949.jpg",
    "image_url_thumb": "https://seeclickfix.com/files/issue_images/0024/8363/1411756212949.jpg"
  }
}
```

You can also submit an address instead of (or in addition to) latitude and longitude.


**Please note:** Adding separate import strategies for data sources is trivial - so if you've got a bunch of incident data you'd like to add, hit us up, <contact@bikeindex.org>!


## Development, running it locally

This is a [Rails 4.1](http://rubyonrails.org/) app run on [Ruby 2.1](http://www.ruby-lang.org/en/) (we use [RVM](https://rvm.io/)) with PostgreSQL.

### What's up

Immediate Goals:

- Make a homepage

- Improve documentation. Make it interactive-y and stuff

- Add [GitHub maps for GeoJSON export](https://help.github.com/articles/mapping-geojson-files-on-github/) (and automate data export to GitHub)

- Submit open311 reports

- Provide a form to submit incidents

---

Made with all the :princess:
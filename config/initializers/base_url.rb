if Rails.env.production?
  BASE_URL = "https://bikewise.org"
else
  BASE_URL = "http://localhost:3001"
end
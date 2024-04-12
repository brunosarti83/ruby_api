namespace :features do  
  desc "Prints something to the console"
  task :print_console do
    puts "Hello from Rake!"
  end

  desc "Clear database"
  task :clear_db => :environment do
    puts "Clearing database"
    Feature.destroy_all
  end

  desc "Populate database"
  task :get_features do
    require 'httparty'

    url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson' 
    response = HTTParty.get(url)

    if response.success?
      parsed_response = JSON.parse(response.body)
      puts "HTTP GET request was successful!"
      puts "Response body:"
      entry = parsed_response["features"][0]
      Feature.create!(
        external_id: entry["id"],
        latitude: entry["geometry"]["coordinates"][1], 
        longitude: entry["geometry"]["coordinates"][0], 
        magnitude: entry["properties"]["mag"],
        mag_type: entry["properties"]["magType"],
        tsunami: entry["properties"]["tsunami"],
        place: entry["properties"]["place"],
        time: entry["properties"]["time"],
        title: entry["properties"]["title"],
        external_url: entry["properties"]["url"]
      )
    else
      puts "HTTP GET request failed with status code #{response.code}"
    end
  end

end

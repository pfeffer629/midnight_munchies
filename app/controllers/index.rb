client = Yelp::Client.new({ consumer_key: ENV['CONSUMER_KEY'],
                            consumer_secret: ENV['CONSUMER_SECRET'],
                            token: ENV['TOKEN'],
                            token_secret: ENV['TOKEN_SECRET']
                          })

get '/' do
  @user = User.create
  session[:user_id] = @user.id
  erb :index
end

put '/' do
  user = User.find(session[:user_id])
  user.latitude = params[:latitude]
  user.longitude = params[:longitude]
  user.save
end

get '/search' do
  @i = 0

  #Yelp API
  user = User.find(session[:user_id])
  query = {term: 'late night, cheap, 24 hours',
           radius_filter: 1650,
           limit: 20}
  latitude = user.latitude
  longitude = user.longitude
  coordinates = {latitude: latitude, longitude: longitude}
  @list = client.search_by_coordinates(coordinates, query)

  # Google API
  @full_google_info = []
  @list.businesses.each do |business|
    @single_google_info = []
    uri = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{latitude},#{longitude}&radius=5000&types=food&name=#{business.name}&key=#{ENV['API_KEY']}"
    uri.gsub!(' ', '%20')

    #Store google data for each restaurant
    google_business_info = HTTParty.get(uri)

    ap google_business_info
    if google_business_info["results"][0] != nil
      @single_google_info << google_business_info["results"][0]["rating"]
      @single_google_info << google_business_info["results"][0]["price_level"]
      @single_google_info << google_business_info["results"][0]["opening_hours"]["open_now"]
    end

    @full_google_info << @single_google_info
    @location = business.location.display_address
  end

  erb :search
end

post '/search' do
  user = User.find(session[:user_id])
  latitude = user.latitude
  longitude = user.longitude
  HTTParty.post("https://maps.googleapis.com/maps/api/directions/json?origin=#{latitude},#{longitude}&destination=Montreal&key=#{ENV['API_KEY']}")

end

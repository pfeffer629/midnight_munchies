$(document).ready(function() {
  $('.button').hide()

  // Retrieve longitude and latitude, and send data to controller
  navigator.geolocation.getCurrentPosition(function(position) {
    latitude = position.coords.latitude
    longitude = position.coords.longitude
    $.ajax({
      type: 'PUT',
      url: '/',
      data: {latitude: latitude, longitude: longitude}
    }).done(function(){
      $('.loading-image').hide()
      $('.button').show()
      $('.button').fadeTo(1000, 1)
    })
    return false
  })

  $('.button').on("click", function(){
    $('.button').fadeOut(1000, function(){
      $('.loading-image').show()
    })
  })



  // Toggle show and hide for restaurant info
  $('.restaurant-more-info').hide()

  $('.restaurant-display').on("click", function(event){
    $restaurantInfo = ($(event.target).parent().next())
    $restaurantInfo.slideToggle(1000);
  })

  $('.restaurant-more-info').on("click", function(event){
    $restaurantInfo = ($(event.target).parent())
    $restaurantInfo.slideToggle(1000);
  })

});

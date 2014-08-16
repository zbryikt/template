angular.module \map, <[]>
  ..factory \mapOption, -> do
    map-option = do
      center: new google.maps.LatLng 22.624146, 120.320623
      zoom: 13
      minZoom: 8
      maxZoom: 18
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControlOptions: position: google.maps.ControlPosition.LEFT_CENTER
      zoomControlOptions: position: google.maps.ControlPosition.LEFT_CENTER
      mapTypeControlOptions: position: google.maps.ControlPosition.LEFT_CENTER
  ..factory \mapStyle, -> do
    map-style = [
      {
        "featureType": "road",
        "stylers": [
          { "saturation": -100 }
        ]
      },{
        "featureType": "poi",
        "stylers": [
          { "saturation": -100 }
        ]
      },{
        "featureType": "transit",
        "stylers": [
          { "saturation": -100 }
        ]
      }
    ]

  #..provider \map, (mapStyle, mapOption) !->
  ..service \map, (mapStyle, mapOption) -> @ <<< do
    create: (id) ->
      map = new google.maps.Map document.getElementById(id), mapOption
        ..set \styles, mapStyle


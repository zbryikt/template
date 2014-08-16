angular.module \main, <[map]>
  ..controller \main, <[$scope map]> ++ ($scope, map) ->
    $scope.map = map.create \mainMap

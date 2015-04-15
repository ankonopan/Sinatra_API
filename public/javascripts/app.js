'use strict';


// Declare app level module which depends on views, and components
var Consumer = angular.module('Consumer', [
  'ngRoute',
  'restangular'
])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider
  .when('/home', {
    templateUrl: '/views/home.html',
    controller: 'HomeController'
      })
  .otherwise({redirectTo: '/home'});
}])
.controller('HomeController', ['$scope', 'Restangular', function($scope, Restangular) {
  var offersApi = Restangular.oneUrl("offers");
  $scope.offers = [];
  $scope.offerQuery = {};

  $scope.searchOffers = function(event) {
    offersApi.post("" , $scope.offerQuery ).then(function( offers ) {
      $scope.offers = offers.offers;
    });
    return false;
  };


}]);
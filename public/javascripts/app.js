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
  $scope.errorFields = false;
  $scope.offerQuery = { page: "1" };
  $scope.emptyOffers = false;
  $scope.processingOffers = false;

  $scope.searchOffers = function(event) {
    if( _.isString( $scope.offerQuery.uid ) &&  $scope.offerQuery.uid != "" &&
        _.isString( $scope.offerQuery.pub0 ) && $scope.offerQuery.pub0 != "" &&
        _.isString( $scope.offerQuery.page )  && $scope.offerQuery.page != ""
      ){

        $scope.processingOffers = true;
        $scope.errorFields = false;
        offersApi.post("" , $scope.offerQuery ).then(function( offers ) {
          if ( _.isUndefined(offers.offers) || offers.offers.length == 0) {
            $scope.emptyOffers = true;
          }else{
            $scope.emptyOffers = false;
            $scope.offers = offers.offers;
          };
          $scope.processingOffers = false;
        });
    }else{
      $scope.errorFields = true;
    }
    return false;
  };


}]);
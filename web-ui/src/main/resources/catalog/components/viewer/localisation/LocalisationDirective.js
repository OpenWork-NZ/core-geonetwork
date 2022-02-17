/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */

(function () {
  goog.provide("gn_localisation_directive");

  var module = angular.module("gn_localisation_directive", []);

  /**
   * @ngdoc directive
   * @name gn_viewer.directive:gnLocalisationInput
   *
   * @description
   * Panel to load WMS capabilities service and pick layers.
   * The server list is given in global properties.
   */
  module.directive("gnLocalisationInput", [
    "$timeout",
    "gnGlobalSettings",
    "gnViewerSettings",
    "gnGazetteerProvider",
    function ($timeout, gnGlobalSettings, gnViewerSettings, gnGazetteerProvider) {
      return {
        restrict: "A",
        require: "gnLocalisationInput",
        replace: true,
        templateUrl:
          "../../catalog/components/viewer/localisation/" + "partials/localisation.html",
        scope: {
          map: "="
        },
        controllerAs: "locCtrl",
        controller: [
          "$scope",
          "$http",
          "gnGetCoordinate",
          function ($scope, $http, gnGetCoordinate) {
            var parent = $scope.$parent;

            $scope.modelOptions = angular.copy(gnGlobalSettings.modelOptions);

            var zoomTo = function (extent, map) {
              map.getView().fit(extent, map.getSize());
            };
            this.onClick = function (loc, map) {
              return gnGazetteerProvider.onClick($scope, loc, map);
            };
            this.onClickAddr = function (id, map) {
              $http
                .get("https://api-nz.addysolutions.com/address/" + id, {
                  headers: {
                    "addy-api-key": "637df27f625f4f5ebb80a3956e93c303"
                  },
                  responseType: "json"
                })
                .success(function (response) {
                  var position = new ol.geom.Point([response.x, response.y]);
                  var layer = new ol.layer.Vector({
                    source: new ol.source.Vector({
                      features: [new ol.Feature({ geometry: position })]
                    }),
                    style: new ol.style.Style({
                      image: new ol.style.Icon({
                        anchor: [0.5, 30],
                        anchorXUnits: "fraction",
                        anchorYUnits: "pixels",
                        size: [46, 46],
                        src: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAACCgAwAEAAAAAQAAACAAAAAAX7wP8AAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAxJJREFUWAm1lkurjWEYhjfbIQMpRki2GJhJBsohZaYkE5NtaCIMTCTtkdoDEyW/gKEBKaQMtvYPMJCBlJLDUDIg58N9re+9ePdnWdbJU/f3np7D/TzvYa3JicFkUdSXBIuDH5XpZJlnvZ6vVEbvErgtEGkLehDpS/pVxOnXYFlwJDgQbA1WBp+C58F8cC14GSCQ+97pjfCBoFkeSp9AlPhv+Ji184HC1owkOpiJF4N+Th8QTDinzr2saWsCmRpM3PPTMcPxl4BtAJTWYLasM/+hrN1Ni1DFgUX222NJABx/CwhuwAfpXw/mAoO67vhs1hCTaUZ9fCVwK7oEpMQ6f5b+rqCWtRncDNBFD7L03wZrAqTvrVBxKkYE1int64BgCCRBnd2djNFjOwD9YwFS6zUzf/kuLfNct7azk2VtRcuW64lsCTwfXE/srwZIVwJm26gs/E6VIU40vl/mqEwtjDlsT4OHZQE7ZEPTdIiV7u+mFwGz0hFBOFz/kvctheWt8YJhLwIcIITMKCuENgZI2w4diBJsU1BL7aee7/Tbjpg040dFGx0IIKea5hchD6FZTmd9XcBN0Hftp5j3bsgGoX0cQKi+WjMZd5O9mfT+o+9h3FGUIdu3eBOOxwIC7D8Odcp1OxzgfH9wKUAP8AZ4BW+njwwUHAOrQGlfBFYBAmRnsHbrA6TOvugi3qJm1OfXKpyJPoGoggF9aCRkhVg3+/n0Ec9CMxrgaxVWxYYXEOdmKJF2KyHmDwbIUNk3phMTVmE2Ezitq9AOztjS80OFkISJdCYG/Vg+3v93AUF6VUGCR0sgEyjD4RqdXI55ryqY/ZPoSXyk7KWrs82ZMIjXsd4Gsz9RDCWun5FaD9KVeOlWBbflVdb9pRxL9rL2IdlWCFCBugpmf64YjDV7SViFG4WEQc3+TeZXF2W3TduxtBLYHW9sg+fBPx4XSpT/kr0ZmNlcIeHV5PVbX5TU0WasrVXYE6/1DZgtUVwfa9C2Mw/kzixcDKYrhbGe/MrvH91uZR4q+FBGhQ6VgAhb4U0oS/03PwGEoQg08v3mNwAAAABJRU5ErkJggg=="
                      })
                    })
                  });
                  map.addLayer(layer);

                  map
                    .getView()
                    .setCenter(
                      position
                        .transform("EPSG:4326", map.getView().getProjection())
                        .getFirstCoordinate()
                    );
                  map.getView().setZoom(18);
                });
            };

            $scope.zoomToYou = function (map) {
              if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (pos) {
                  var position = new ol.geom.Point([
                    pos.coords.longitude,
                    pos.coords.latitude
                  ]);
                  map
                    .getView()
                    .setCenter(
                      position
                        .transform("EPSG:4326", map.getView().getProjection())
                        .getFirstCoordinate()
                    );
                });
              } else {
              }
            };

            $scope.addresses = [];
            function fetchAddy(query) {
              if (query.length < 5) $scope.addresses = [];
              else
                $http
                  .get("https://api-nz.addysolutions.com/search", {
                    params: { s: query },
                    headers: {
                      "addy-api-key": "637df27f625f4f5ebb80a3956e93c303"
                    },
                    responseType: "json"
                  })
                  .success(function (response) {
                    $scope.addresses = response.addresses;
                  });
            }
            /**
             * Request geonames search. Trigger when user changes
             * the search input.
             *
             * @param {string} query string value of the search input
             */
            this.search = function (loc) {
              fetchAddy($scope.query);
              return gnGazetteerProvider.search($scope, loc, $scope.query);
            };
          }
        ],
        link: function (scope, element, attrs, ctrl) {
          scope.locToolDisabled = gnGlobalSettings.gnCfg.mods.geocoder.enabled === false;

          /** localisation text query */
          scope.query = "";

          scope.collapsed = true;

          /** default localisation */
          scope.localisations = gnViewerSettings.localisations;

          /** Clear input and search results */
          scope.clearInput = function () {
            scope.query = "";
            scope.results = [];
          };

          // Bind events to display the dropdown menu
          element.find("input").bind("focus", function (evt) {
            scope.$apply(function () {
              ctrl.search(scope.query);
              scope.collapsed = false;
            });
          });

          element.on("keydown", "input", function (e) {
            if (e.keyCode === 40) {
              $(this)
                .parents(".search-container")
                .find(".dropdown-menu a")
                .first()
                .focus();
            }
          });

          element.on("keydown", "a", function (e) {
            if (e.keyCode === 40) {
              var links = $(this).parents(".search-container").find(".dropdown-menu a");
              $(links[links.index(this)]).focus();
            }
          });

          scope.map.on("click", function () {
            scope.$apply(function () {
              $(":focus").blur();
              scope.collapsed = true;
            });
          });

          $("body").on("click", function (e) {
            if (!$.contains(element[0], e.target)) {
              return;
            }
            if (
              element.find("input")[0] != e.target &&
              $(e.target).parents(".dropdown-menu")[0] !=
                element.find(".dropdown-menu")[0]
            ) {
              scope.$apply(function () {
                $(":focus").blur();
                scope.collapsed = true;
              });
            }
          });
        }
      };
    }
  ]);
})();

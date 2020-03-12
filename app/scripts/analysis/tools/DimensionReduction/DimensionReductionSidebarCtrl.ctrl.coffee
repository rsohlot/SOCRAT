'use strict'

BaseCtrl = require 'scripts/BaseClasses/BaseController.coffee'

module.exports = class DimensionReductionSidebarCtrl extends BaseCtrl
  @inject 'app_analysis_dimension_reduction_msgService',
    'app_analysis_dimension_reduction_dataService',
    '$scope',
    '$timeout'

  initialize: ->
    # initializing all modules
    @dataService = @app_analysis_dimension_reduction_dataService
    @msgService = @app_analysis_dimension_reduction_msgService

    # TODO: find a way to bypass same origin, and get the json names from github
    # $.ajax 'https://github.com/SOCR/HTML5_WebSite/tree/master/HTML5/SOCR_TensorBoard_UKBB/data/', {}, (response) -> 
    #   console.log(response)
      
    # url = 'https://github.com/SOCR/HTML5_WebSite/tree/master/HTML5/SOCR_TensorBoard_UKBB/data/'

    # $.ajax(
    #   type: 'GET'
    #   url: url
    #   ).done (o) ->
    #   console.log(o)
    #   return
    

    @dataSets = new Array()
    @baseLink = 'https://projector.tensorflow.org/?config=https://raw.githubusercontent.com/SOCR/HTML5_WebSite/master/HTML5/SOCR_TensorBoard_UKBB/data/'
    
    @$scope.$on 'dimensionReduction:fileSet', (event, data) =>
      fileSet = data.fileSet
      for name in fileSet
        tmp = name.split('_projector_config.json')[0]
        # workaround for replace all
        tmp = tmp.split('_').join(' ')
        @dataSets.push(tmp)
      @selectedDataSet = @dataSets[0]
      @link = dateSetNameToLink(@baseLink, @selectedDataSet)
      @msgService.broadcast 'dimensionReduction:initialLink',
        link: fileSet[0]

    # Once the dataSet is updated, broadcast new link to mainArea
  updateDataSet: () ->
    #broadcast dataSet to main controller
    @link = dateSetNameToLink(@baseLink, @selectedDataSet)
    @msgService.broadcast 'dimensionReduction:link',
      @link

  # Helper to convert plane dataset name to url for projector
  dateSetNameToLink = (base, name) ->
    return base + name.split(' ').join('_') + '_projector_config.json'
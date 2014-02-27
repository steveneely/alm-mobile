define ->
  app = require 'application'
  utils = require 'lib/utils'
  LoadingIndicatorView = require 'views/loading_indicator'

  return {
    homeRoute: '/board'

    fetchModelAndShowView: (Model, View, id) ->
      @view = @renderReactComponent LoadingIndicatorView, region: 'main', shared: false
      fieldNames = @getFieldNames()
      model = new Model(ObjectID: id)
      $.when.apply($,
        _.union(
          _.map(fieldNames, model.getAllowedValues, model)
          model.fetch
            data:
              fetch: fieldNames.join ','
            success: (model, response, opts) =>
        )
      ).then (fetches...) =>
        @_setTitle model

        allowedValues = _.reduce(_.initial(fetches), (result, av, index) ->
          result[fieldNames[index]] = av
          result
        , {})
        @view = @renderReactComponent View, model: model, region: 'main', fieldNames: fieldNames, allowedValues: allowedValues
        @markFinished()

      @subscribeEvent 'saveField', @saveField

    showCreateView: (Model, View, defaultValues = {}) ->
      model = new Model defaultValues
      @view = @renderReactComponent View, model: model, region: 'main', newArtifact: true
      @subscribeEvent 'saveField', @saveField
      @subscribeEvent 'save', @saveNew
      @subscribeEvent 'cancel', @cancelNew
      @markFinished()
      model

    saveField: (updates, opts) ->
      if @view.props.newArtifact
        @_saveLocal(updates, opts)
      else
        @_saveRemote(updates, opts)

      @view.props.model.set updates

    saveNew: (model) ->
      model.set { Project: app.session.get('project').get('_ref') }, { silent: true }
      model.sync 'create', model,
        fetch: ['ObjectID'].concat(@getFieldNames()).join ','
        wait: true
        patch: true
        silent: true
        success: (resp, status, xhr) =>
          opts?.success?(model, resp)
          @publishEvent 'router:changeURL', utils.getDetailHash(model), replace: true
          @view.setProps newArtifact: false
          @_setTitle model
        error: (resp, status, xhr) =>
          @view.showError(model, resp)

    cancelNew: ->
      @publishEvent 'router:route', @homeRoute, replace: false

    _saveLocal: (updates) ->
      @view.props.model.set(updates)

    _saveRemote: (updates, opts) ->
      @view.props.model.save updates,
        fetch: ['ObjectID'].concat(@getFieldNames()).join ','
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
        error: (model, resp, options) =>
          opts?.error?(model, resp, options)
          @view.showError(model, resp)

    _setTitle: (model) ->
      @updateTitle "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"
  }
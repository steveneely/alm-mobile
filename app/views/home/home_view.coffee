app = require '../../application'

# Required views/templates
View            = require '../view'
template        = require './templates/home'
UserStoriesView = require './user_stories_view'
DefectsView     = require './defects_view'
TasksView       = require './tasks_view'

# Required Models
UserStoryCollection = require 'models/user_story_collection'
DefectCollection    = require 'models/defect_collection'
TaskCollection      = require 'models/task_collection'

module.exports = View.extend

  el: '#content'
  template: template
  events:
    'click .btn-block': 'onButton'
    'touch .btn-block': 'onButton'

  initialize: (options) ->
    @constructor.__super__.initialize.apply @, [options]
    @render()

    @error = false

    @userStories = new UserStoryCollection()
    @defects = new DefectCollection()
    @tasks = new TaskCollection()

    @userStoriesView = new UserStoriesView
      model: @userStories

    @tasksView = new TasksView
      model: @tasks

    @defectsView = new DefectsView
      model: @defects

    @

  load: ->
    # ToDo: Fix spinner
    # @userStoriesView.$el.html(new Spinner().spin())
    @fetchUserStories()

  fetchUserStories: ->
    @userStories.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @userStoriesView.render()
        @fetchDefects()
        @fetchTasks()
      failure: (collection, xhr, options) =>
        @error = true
    })

  fetchTasks: ->
    @tasks.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @tasksView.render()
      failure: (collection, xhr, options) =>
        @error = true
    })

  fetchDefects: ->
    @defects.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @defectsView.render()
      failure: (collection, xhr, options) =>
        @error = true
    })

  onButton: (event) ->
    url = event.currentTarget.id
    app.router.navigate url, {trigger: true, replace: true}
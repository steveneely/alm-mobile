define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Discussion extends Model
    typePath: 'conversationpost'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/conversationpost'

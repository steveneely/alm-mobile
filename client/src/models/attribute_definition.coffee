define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class AttributeDefinition extends Model
    typePath: 'attributedefinition'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
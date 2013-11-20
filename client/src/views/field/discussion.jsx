/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      Backbone = require('backbone'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin');

  return ReactView.createChaplinClass({
    mixins: [FieldMixin],
    getDefaultProps: function() {
      return {
        field: 'Discussion'
      };
    },
    render: function() {
      if (this.props.editMode) {
        return <div/>;
      };
      var fieldValue = this.getFieldValue();
      return (
        <div className="discussion-field display" onClick={ this._onClick }>
          <div className="well-title control-label" dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>
          <div className="icon">{ fieldValue ? fieldValue.Count ? fieldValue.Count : <i className="icon-add"/> : '' }</div>
        </div>
      );
    },

    _onClick: function() {
      this.routeTo(Backbone.history.fragment + '/discussion');
    }
  });
});
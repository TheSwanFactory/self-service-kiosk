var SwanKiosk;

SwanKiosk = {
  Interpreters: {},
  Components: {},
  Controllers: {
    _find: function(name) {
      return _.find(this, function(value, key) {
        return key.toLowerCase() === name;
      });
    }
  },
  Create: function(klass, args) {
    return new klass(args);
  }
};

SwanKiosk.World = (function() {
  function World(dictionary) {
    this.dictionary = dictionary != null ? dictionary : {};
  }

  World.prototype.get = function() {
    return this.dictionary;
  };

  World.prototype.pipe = function(next) {
    return next(this.get());
  };

  return World;

})();

SwanKiosk.Components = {
  center: function(dictionary) {
    dictionary = {
      "class": 'grid-container',
      contents: dictionary
    };
    return dictionary;
  },
  verticalCenter: function(dictionary) {
    if (dictionary["class"] == null) {
      dictionary["class"] = '';
    }
    dictionary["class"] += ' grid-block vertical align-center';
    return this.center(dictionary);
  },
  link: function(contents, href, options) {
    if (href == null) {
      href = '#';
    }
    if (options == null) {
      options = {};
    }
    if (_.isPlainObject(href) && _.isEqual(options, {})) {
      options = href;
      href = '#';
    }
    return _.extend({
      tag: 'a',
      contents: contents,
      href: href
    }, options);
  }
};

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SwanKiosk.Interpreter = (function(_super) {
  __extends(Interpreter, _super);

  function Interpreter() {
    return Interpreter.__super__.constructor.apply(this, arguments);
  }

  return Interpreter;

})(SwanKiosk.World);

SwanKiosk.Interpreters.Question = (function(_super) {
  __extends(Question, _super);

  function Question() {
    return Question.__super__.constructor.apply(this, arguments);
  }

  Question.prototype.why = 'Why are we asking this question?';

  Question.prototype.header = function() {
    return this._header != null ? this._header : this._header = this.interpretHeader();
  };

  Question.prototype.body = function() {
    return this._body != null ? this._body : this._body = this.interpretBody();
  };

  Question.prototype.navigation = function() {
    return this._navigation != null ? this._navigation : this._navigation = this.interpretNavigation();
  };

  Question.prototype.get = function() {
    return [this.header(), this.body(), this.navigation()];
  };

  Question.prototype.questionOption = function(option, value) {
    return {
      tag: 'a',
      "class": 'answer',
      contents: option,
      value: value
    };
  };

  Question.prototype.interpretBody = function() {
    var options;
    options = _.map(this.dictionary.select, this.questionOption);
    return {
      "class": 'body',
      contents: SwanKiosk.Components.center(options)
    };
  };

  Question.prototype.interpretHeader = function() {
    return {
      "class": 'header',
      contents: [
        {
          "class": 'question',
          contents: {
            tag: 'h1',
            contents: this.dictionary.title
          }
        }, SwanKiosk.Components.verticalCenter({
          "class": 'why-wrapper',
          contents: {
            tag: 'a',
            "class": 'why',
            contents: this.why,
            title: this.dictionary.why
          }
        })
      ]
    };
  };

  Question.prototype.interpretNavigation = function() {
    return {
      "class": 'navigation',
      contents: [
        {
          "class": 'start-over',
          contents: {
            tag: 'a',
            contents: 'Start Over'
          }
        }, {
          "class": 'change-page',
          contents: [
            SwanKiosk.Components.link('Previous', {
              "class": 'previous'
            }), SwanKiosk.Components.link('Next', {
              "class": 'next'
            })
          ]
        }
      ]
    };
  };

  return Question;

})(SwanKiosk.Interpreter);

SwanKiosk.Layout = (function() {
  function Layout() {}

  Layout.specialAttributes = ['contents', 'tag', 'rawHtml'];

  Layout.defaultTag = 'div';

  Layout.build = function(layout) {
    if (layout == null) {
      layout = {};
    }
    Layout.setDefaults(layout);
    return Layout.buildTag(layout);
  };

  Layout.setDefaults = function(layout) {
    if (_.isArray(layout) || _.isString(layout)) {
      layout = {
        contents: layout
      };
    }
    if (layout.tag == null) {
      layout.tag = this.defaultTag;
    }
    return layout;
  };

  Layout.buildTag = function(options) {
    var closeTag, contents, openTag;
    options = this.setDefaults(options);
    openTag = this.buildOpenTag(options);
    contents = this.buildContents(options);
    closeTag = this.buildCloseTag(options);
    return openTag + contents + closeTag;
  };

  Layout.buildOpenTag = function(options) {
    var attributes;
    attributes = this.buildAttributes(options);
    if (attributes.length) {
      attributes = ' ' + attributes;
    }
    return "<" + options.tag + attributes + ">";
  };

  Layout.buildAttributes = function(options) {
    return _(Object.keys(options)).difference(this.specialAttributes).map(this.buildSingleAttribute(options), this).join(' ');
  };

  Layout.buildSingleAttribute = function(options) {
    return function(attribute) {
      var key, value;
      key = SwanKiosk.Utils.dasherize(attribute);
      value = options[attribute];
      if (_.isObject(value)) {
        if (key === 'style') {
          value = this.buildStyleAttribute(value);
        } else {
          value = JSON.stringify(value);
        }
      }
      return "" + key + "=\"" + value + "\"";
    };
  };

  Layout.buildStyleAttribute = function(style) {
    return _(style).map(function(value, key) {
      return "" + (SwanKiosk.Utils.dasherize(key)) + ": " + value + ";";
    }).join('');
  };

  Layout.buildContents = function(options) {
    var contents;
    contents = options.contents;
    if (_.isPlainObject(contents)) {
      contents = [contents];
    }
    if (_.isArray(contents)) {
      contents = this.buildArray(contents);
    } else {
      if (!options.rawHtml) {
        contents = _.escape(contents);
      }
    }
    return contents;
  };

  Layout.buildArray = function(array) {
    return array.map(this.buildTag, this).join('');
  };

  Layout.buildCloseTag = function(options) {
    return "</" + options.tag + ">";
  };

  return Layout;

})();

var OrderedObject, isPlainObject,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

OrderedObject = (function() {
  function OrderedObject(object) {
    if (object == null) {
      object = {};
    }
    this.get = __bind(this.get, this);
    this.remove = __bind(this.remove, this);
    this.unshift = __bind(this.unshift, this);
    this.push = __bind(this.push, this);
    if (!isPlainObject(object)) {
      throw new Error('only plain objects allowed');
    }
    this.set(object);
  }

  OrderedObject.prototype.reset = function() {
    this._keys = [];
    return this._values = [];
  };

  OrderedObject.prototype.push = function(key, value) {
    if (this.has(key)) {
      this.remove(key);
    }
    this._keys.push(key);
    return this._values.push(value);
  };

  OrderedObject.prototype.unshift = function(key, value) {
    if (this.has(key)) {
      this.remove(key);
    }
    this._keys.unshift(key);
    return this._values.unshift(value);
  };

  OrderedObject.prototype.remove = function(key) {
    var index;
    if (!this.has(key)) {
      return;
    }
    index = this.indexOf(key);
    this._keys.splice(index, 1);
    return this._values.splice(index, 1);
  };

  OrderedObject.prototype.set = function(object) {
    var key, value, _results;
    this.reset();
    _results = [];
    for (key in object) {
      value = object[key];
      _results.push(this.push(key, value));
    }
    return _results;
  };

  OrderedObject.prototype.get = function(key) {
    if (!this.has(key)) {
      return void 0;
    }
    return this._values[this.indexOf(key)];
  };

  OrderedObject.prototype.has = function(key) {
    return this.indexOf(key) > -1;
  };

  OrderedObject.prototype.indexOf = function(key) {
    return this._keys.indexOf(key);
  };

  OrderedObject.prototype.forEach = function(cb) {
    var i, key, _i, _len, _ref, _results;
    _ref = this._keys;
    _results = [];
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      key = _ref[i];
      _results.push(cb(key, this._values[i]));
    }
    return _results;
  };

  OrderedObject.prototype.toObject = function() {
    var object;
    object = {};
    this.forEach(function(key, value) {
      return object[key] = value;
    });
    return object;
  };

  return OrderedObject;

})();

isPlainObject = function(obj) {
  return !!obj && typeof obj === 'object' && obj.constructor === Object;
};

var defaultRoute, notFound;

defaultRoute = function(ctx) {
  var controller;
  controller = SwanKiosk.Controllers._find(ctx.params.controller);
  if (!controller) {
    return notFound();
  }
  return SwanKiosk.Create(controller, ctx.params);
};

notFound = function() {
  return $('body').html('404d!');
};

page('/:controller/:action/:id', defaultRoute);

page('*', notFound);

SwanKiosk.Utils = {
  dasherize: function(string) {
    return string.replace(/[^a-zA-Z0-9]/g, '-');
  }
};

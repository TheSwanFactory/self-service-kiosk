var SwanKiosk;

SwanKiosk = {
  Interpreters: {},
  Components: {},
  Config: {},
  Store: {},
  Controllers: {
    _find: function(name) {
      return _.find(this, function(value, key) {
        return key.split('Controller')[0].toLowerCase() === name;
      });
    }
  },
  create: function(klass, args) {
    return new klass(args);
  },
  init: function() {
    return page({
      hashbang: true
    });
  }
};

$(SwanKiosk.init);

$.ajax({
  url: '/assets/config/kiosk-config.json',
  async: false
}).done(function(data) {
  return SwanKiosk.Config = data;
});

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
    dictionary.contents = this.center(dictionary.contents);
    return dictionary;
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
  },
  layout: function(contents) {
    return {
      "class": 'grid-frame vertical',
      contents: contents
    };
  }
};

var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

SwanKiosk.Controller = (function() {
  Controller.prototype.defaultAction = 'index';

  Controller.prototype.bodySelector = 'body';

  Controller.prototype.rendered = false;

  Controller.prototype.layout = false;

  function Controller(params) {
    this.params = params != null ? params : {};
  }

  Controller.prototype._route = function(action) {
    action = action || this.params.action;
    if (__indexOf.call(this._getRoutes(), action) >= 0) {
      action = this[action];
    } else if (this.show != null) {
      this.params.id = this.params.action;
      action = this.show;
    } else if (action == null) {
      action = this[this.defaultAction];
    } else {
      throw new Error("No route found for " + this.constructor.name + "#" + action);
    }
    return this._render(action.call(this));
  };

  Controller.prototype._getRoute = function(route) {
    if (this._getRoutes().indexOf) {
      return console.log;
    }
  };

  Controller.prototype._getRoutes = function() {
    var route, routes;
    routes = [];
    for (route in this) {
      if (!(route === 'constructor' || route.match(/^_/) || typeof this[route] !== 'function')) {
        routes.push(route);
      }
    }
    return routes;
  };

  Controller.prototype._getBody = function() {
    return this._body != null ? this._body : this._body = $(this.bodySelector);
  };

  Controller.prototype._render = function(contents) {
    if (this.rendered || (contents == null)) {
      return false;
    }
    this.rendered = true;
    if (this.layout) {
      contents = this.layout(contents);
    }
    contents._context = this;
    contents = SwanKiosk.Layout.build(contents);
    this._getBody().html('');
    return this._getBody().get(0).appendChild(contents);
  };

  Controller.prototype._renderPlain = function(contents) {
    if (this.rendered) {
      return false;
    }
    this.rendered = true;
    return this._getBody().html(contents);
  };

  return Controller;

})();

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
      value: value,
      events: {
        click: function(e) {
          return this._selectOption(value, e);
        }
      }
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

  Question.prototype.interpretBody = function() {
    var options;
    options = _.map(this.dictionary.select, this.questionOption);
    return {
      "class": 'body',
      contents: SwanKiosk.Components.center(options)
    };
  };

  Question.prototype.interpretNavigation = function() {
    var nextOptions, prevOptions;
    prevOptions = {
      "class": 'previous',
      events: {
        click: function() {
          return this._prevQuestion();
        }
      }
    };
    nextOptions = {
      "class": 'next',
      events: {
        click: function() {
          return this._nextQuestion();
        }
      }
    };
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
          contents: [SwanKiosk.Components.link('Previous', prevOptions), SwanKiosk.Components.link('Next', nextOptions)]
        }
      ]
    };
  };

  return Question;

})(SwanKiosk.Interpreter);

SwanKiosk.Layout = (function() {
  function Layout() {}

  Layout.specialAttributes = ['contents', 'tag', 'rawHtml', '_context'];

  Layout.defaultTag = 'div';

  Layout.build = function(layout) {
    if (layout == null) {
      layout = {};
    }
    Layout.context = layout._context || null;
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

  Layout.buildTag = function(parent, options) {
    var element;
    if (!((options != null) || parent instanceof HTMLElement)) {
      options = parent;
      parent = null;
    }
    options = this.setDefaults(options);
    element = this.buildElement(options);
    this.buildAttributes(element, options);
    this.buildContents(element, options);
    if (parent != null) {
      return parent.appendChild(element);
    } else {
      return element;
    }
  };

  Layout.buildElement = function(options) {
    return document.createElement(options.tag);
  };

  Layout.buildOpenTag = function(options) {
    var attributes;
    attributes = this.buildAttributes(options);
    if (attributes.length) {
      attributes = ' ' + attributes;
    }
    return "<" + options.tag + attributes + ">";
  };

  Layout.buildAttributes = function(element, options) {
    return _(Object.keys(options)).difference(this.specialAttributes).map(this.buildSingleAttribute(element, options), this);
  };

  Layout.buildSingleAttribute = function(element, options) {
    return function(attribute) {
      var key, value;
      key = SwanKiosk.Utils.dasherize(attribute);
      value = options[attribute];
      if (_.isObject(value)) {
        if (key === 'style') {
          value = this.buildStyleAttribute(value);
        } else if (key === 'events') {
          return this.addEventListeners(element, value);
        } else {
          value = JSON.stringify(value);
        }
      }
      return element.setAttribute(key, value);
    };
  };

  Layout.addEventListeners = function(element, events) {
    var func, name, _results, _results1;
    if (this.context) {
      _results = [];
      for (name in events) {
        func = events[name];
        _results.push(element.addEventListener(name, func.bind(this.context)));
      }
      return _results;
    } else {
      _results1 = [];
      for (name in events) {
        func = events[name];
        _results1.push(element.addEventListener(name, func));
      }
      return _results1;
    }
  };

  Layout.buildStyleAttribute = function(style) {
    return _(style).map(function(value, key) {
      return "" + (SwanKiosk.Utils.dasherize(key)) + ": " + value + ";";
    }).join('');
  };

  Layout.buildContents = function(element, options) {
    var contents;
    contents = options.contents || '';
    if (_.isPlainObject(contents)) {
      contents = [contents];
    }
    if (_.isArray(contents)) {
      return this.buildArray(element, contents);
    }
    if (!(contents instanceof HTMLElement)) {
      contents = contents.toString();
      if (!options.rawHtml) {
        contents = _.escape(contents);
      }
      contents = document.createTextNode(contents);
    }
    element.appendChild(contents);
    return contents;
  };

  Layout.buildArray = function(element, array) {
    return array.map(this.buildTagFactory(element), this);
  };

  Layout.buildTagFactory = function(element) {
    return function(contents) {
      return this.buildTag(element, contents);
    };
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
  controller = SwanKiosk.Controllers._find(ctx.params.controller || 'index');
  if (!controller) {
    return notFound();
  }
  controller = SwanKiosk.create(controller, ctx.params);
  return controller._route();
};

notFound = function() {
  return $('body').html('404d!');
};

page('/:controller/:action?/:id?', defaultRoute);

page('', defaultRoute);

page('*', notFound);

SwanKiosk.Utils = {
  dasherize: function(string) {
    return string.replace(/[^a-zA-Z0-9]/g, '-');
  }
};

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SwanKiosk.Controllers.IndexController = (function(_super) {
  __extends(IndexController, _super);

  function IndexController() {
    return IndexController.__super__.constructor.apply(this, arguments);
  }

  IndexController.prototype.index = function() {
    return [
      {
        tag: 'h1',
        contents: 'Index'
      }, {
        tag: 'a',
        href: '/questions/0',
        contents: 'Start Questions'
      }
    ];
  };

  return IndexController;

})(SwanKiosk.Controller);

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SwanKiosk.Controllers.QuestionsController = (function(_super) {
  __extends(QuestionsController, _super);

  function QuestionsController() {
    return QuestionsController.__super__.constructor.apply(this, arguments);
  }

  QuestionsController.prototype.layout = SwanKiosk.Components.layout;

  QuestionsController.prototype.index = function() {
    return [
      {
        tag: 'h1',
        contents: 'Questions'
      }
    ];
  };

  QuestionsController.prototype.show = function() {
    var question;
    this.id = parseInt(this.params.id, 10) || 0;
    this.questionKey = Object.keys(SwanKiosk.Config.questions)[this.id];
    question = SwanKiosk.Config.questions[this.questionKey];
    if (question != null) {
      question = new SwanKiosk.Interpreters.Question(question);
      return question.get();
    } else {
      return page('/questions/results');
    }
  };

  QuestionsController.prototype.results = function() {
    console.log('helo!');
    console.log(SwanKiosk.Store.answers);
    return {
      tag: 'pre',
      rawHtml: true,
      contents: JSON.stringify(SwanKiosk.Store.answers || {})
    };
  };

  QuestionsController.prototype._selectOption = function(value, event) {
    var $answer;
    $answer = $(event.target);
    $answer.siblings().removeClass('selected');
    $answer.addClass('selected');
    return this.answer = value;
  };

  QuestionsController.prototype._nextQuestion = function() {
    return this._storeAnwer();
  };

  QuestionsController.prototype._storeAnwer = function() {
    var _base;
    if ((_base = SwanKiosk.Store).answers == null) {
      _base.answers = {};
    }
    SwanKiosk.Store.answers[this.questionKey] = this.answer;
    return page("/questions/" + (this.id + 1));
  };

  QuestionsController.prototype._prevQuestion = function() {};

  return QuestionsController;

})(SwanKiosk.Controller);

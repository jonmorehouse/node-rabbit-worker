// Generated by CoffeeScript 1.6.3
(function() {
  var ErrorHandler, LogHandler, Manager, TaskHandler, TaskSubscriber, async, stream,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  stream = require('stream');

  async = require('async');

  ErrorHandler = require('./error_handler');

  LogHandler = require('./log_handler');

  TaskHandler = require('./task_handler');

  TaskSubscriber = require('./task_subscriber');

  Manager = (function(_super) {
    __extends(Manager, _super);

    /*
      @opts = 
        queue: required - queue to subscribe to (required)
        max: number of simultaneous workers that we can have (default = 2)
        error: a writable stream that can be written to  (optional)
        logger: a logging writable stream  (optional)
    */


    function Manager(opts, cb) {
      var err, methods,
        _this = this;
      this.opts = opts;
      this._createTaskSubscriber = __bind(this._createTaskSubscriber, this);
      this._createTaskHandler = __bind(this._createTaskHandler, this);
      this._createLogStream = __bind(this._createLogStream, this);
      this._createErrorStream = __bind(this._createErrorStream, this);
      this._pipeErrors = __bind(this._pipeErrors, this);
      Manager.__super__.constructor.call(this, {
        objectMode: true
      });
      if ((this.opts == null) || (this.opts.queue == null)) {
        err = new Error("Missing required parameters");
        if (cb != null) {
          return cb(err);
        }
        throw err;
      }
      if (this.opts.max == null) {
        this.opts.max = 2;
      }
      methods = [this._createErrorStream, this._createLogStream, this._createTaskHandler, this._createTaskSubscriber, this._pipeErrors];
      async.waterfall(methods, function(err) {
        if (err) {
          return typeof cb === "function" ? cb(err) : void 0;
        }
        return typeof cb === "function" ? cb(null, _this) : void 0;
      });
    }

    Manager.prototype.close = function(cb) {
      var _this = this;
      this.subscriber.on("end", function() {
        return _this.handler.close(function() {
          return typeof cb === "function" ? cb() : void 0;
        });
      });
      return this.subscriber.close();
    };

    Manager.prototype._read = function(size) {
      var _this = this;
      this.subscriber.on("data", function(data) {
        return _this.push(data);
      });
      return this.subscriber.on("ready", function() {
        return _this.emit("ready");
      });
    };

    Manager.prototype._write = function(chk, enc, cb) {
      return this.handler.write(chk);
    };

    Manager.prototype._pipeErrors = function(cb) {
      var _this = this;
      this.subscriber.on("error", function(err) {
        return _this.emit(err);
      });
      this.handler.on("error", function(err) {
        return _this.emit(err);
      });
      return typeof cb === "function" ? cb() : void 0;
    };

    Manager.prototype._createErrorStream = function(cb) {
      if (this.opts.errors != null) {
        this.error = this.opts.error;
        return typeof cb === "function" ? cb() : void 0;
      }
      this.error = new ErrorHandler();
      return typeof cb === "function" ? cb() : void 0;
    };

    Manager.prototype._createLogStream = function(cb) {
      if (this.opts.logger != null) {
        this.logger = this.opts.logger;
        return typeof cb === "function" ? cb() : void 0;
      }
      this.logger = new LogHandler();
      return typeof cb === "function" ? cb() : void 0;
    };

    Manager.prototype._createTaskHandler = function(cb) {
      this.handler = new TaskHandler(this.logger, this.error);
      return typeof cb === "function" ? cb() : void 0;
    };

    Manager.prototype._createTaskSubscriber = function(cb) {
      var _this = this;
      return new TaskSubscriber(this.opts.queue, this.opts.max, this.handler, this.logger, this.error, function(err, sub) {
        if (err) {
          return typeof cb === "function" ? cb(err) : void 0;
        }
        _this.subscriber = sub;
        return typeof cb === "function" ? cb() : void 0;
      });
    };

    return Manager;

  })(stream.Duplex);

  module.exports = Manager;

}).call(this);

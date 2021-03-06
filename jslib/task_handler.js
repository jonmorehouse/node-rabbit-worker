// Generated by CoffeeScript 1.6.3
(function() {
  var TaskHandler, async, stream,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  async = require('async');

  stream = require('stream');

  TaskHandler = (function(_super) {
    __extends(TaskHandler, _super);

    function TaskHandler(error, logger) {
      this.error = error;
      this.logger = logger;
      this._addTask = __bind(this._addTask, this);
      this._handleTask = __bind(this._handleTask, this);
      TaskHandler.__super__.constructor.call(this, {
        objectMode: true
      });
      this._tasks = {};
    }

    TaskHandler.prototype.close = function(cb) {
      var id, tasks;
      tasks = (function() {
        var _results;
        _results = [];
        for (id in this._tasks) {
          _results.push({
            id: id,
            err: true
          });
        }
        return _results;
      }).call(this);
      return async.eachSeries(tasks, this._handleTask, function(err) {
        return typeof cb === "function" ? cb() : void 0;
      });
    };

    TaskHandler.prototype._write = function(obj, enc, cb) {
      if (!typeof obj === "object" || (obj.id == null)) {
        return cb(new Error("Invalid parameter"));
      }
      if (this._tasks[obj.id] != null) {
        return this._handleTask(obj, cb);
      } else {
        return this._addTask(obj, cb);
      }
    };

    TaskHandler.prototype._handleTask = function(obj, cb) {
      var task;
      task = this._tasks[obj.id];
      if (task == null) {
        return cb(new Error("Race condition. Task already deleted"));
      }
      delete this._tasks[obj.id];
      if ((obj.error != null) || (obj.err != null)) {
        task.retry();
      } else {
        task.acknowledge();
      }
      return typeof cb === "function" ? cb() : void 0;
    };

    TaskHandler.prototype._addTask = function(obj, cb) {
      this._tasks[obj.id] = obj;
      return typeof cb === "function" ? cb() : void 0;
    };

    return TaskHandler;

  })(stream.Writable);

  module.exports = TaskHandler;

}).call(this);

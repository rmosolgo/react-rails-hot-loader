ReactRailsHotLoader = {
  since: null,
  port: 8082,
  host: window.location.host,
  shouldLog: true,

  start: function() {
    this._resetSince()
    var wsURL = "ws://" + this.host + ":" + this.port
    this.log(" connecting to " + wsURL)
    this._socket = new WebSocket(wsURL)

    var _this = this

    this._socket.onmessage = function(message) {
      var changes = JSON.parse(message.data)
      _this.log("updating " + changes.changed_asset_paths.length + " assets")
      changes.changed_asset_paths.forEach(_this._reloadAsset, _this)
      _this._resetSince()
    }

    this._interval = setInterval(function() {
      if (_this._socket.readyState == WebSocket.OPEN) {
        _this._socket.send(_this.since)
      } else {
        _this.log("WebSocket not ready, readyState: " + _this._socket.readyState)
      }
    }, 1500)
  },

  stop: function() {
    this._socket.close()
    clearInterval(this._interval)
  },

  _reloadAsset: function(path) {
    var _this = this
    var _handleResponse = function(js) {
      try {
        eval.call(window, js)
      } catch (err) {
        _this.log(err)
      }
      ReactRailsUJS.mountComponents()
      var name = path.split("/").pop()
      _this.log("reloaded " + name)
    }

    $.ajax({
      type: "GET",
      url: path,
      success: _handleResponse,
      error: _handleResponse,
    })
  },

  _resetSince: function() {
    // Ruby prefers seconds.
    this.since = Date.now() / 1000
  },

  log: function(msg) {
    if (this.shouldLog) {
      console.log("[HotLoader] " + msg)
    }
  }
}

ReactRailsHotLoader.start()

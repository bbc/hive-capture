var hive_mind_com;
(function() {
  var HiveMindCom = function() {};
  HiveMindCom.prototype = {
    init: function(app, app_name, url) {
      this.app = app;
      this.device = app.getDevice();
      this.url = url;
      this.poll_url = this.url + '/mm_poll/';
      this.id = null;
      this.poll_timeout = 15000;
      this.poll_spacing = this.poll_timeout * 2;
      this.viewers = {};
    },

    poll: function() {
      var self = this;
      if ( this.id ) {
        url = this.poll_url + "?id=" + this.id + "&callback=%callback%";
      } else {
        url = this.poll_url + "?callback=%callback%";
      }
      this.device.getLogger().debug("Polling with timeout " + this.poll_timeout);
      this.device.loadScript(url, /%callback%/, {
        onSuccess: function(json) {
          for (var key in self.viewers) {
            if ( json[key] ) {
              self.viewers[key].setText(json[key]);
            }
          }
          if ( json.id ) {
            self.id = json.id;
          }
          if ( json.action ) {
            if ( json.action.action_type == 'redirect' ) {
alert("Redirecting to " + json.action.body);
              self.app.launchAppFromURL( json.action.body, {}, [], true );
            }
          }
        },
        onError: function(response) {
        }
      }, this.poll_timeout);
    },

    setView: function(key, viewer) {
      this.viewers[key] = viewer;
    },

    nextExecution: function() {
      var self = this;
      setTimeout(function() {
        self.poll();
        self.nextExecution();
      }, this.poll_spacing);
    },

    start: function() {
      this.nextExecution();
    }
    
  };

  hive_mind_com = new HiveMindCom();
})();

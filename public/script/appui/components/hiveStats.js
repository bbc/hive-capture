require.def("hive_capture/appui/components/hiveStats",
  [
    "antie/application",
    "antie/widgets/component",
    "antie/widgets/container",
    "antie/widgets/componentcontainer",
    "antie/widgets/label",
    "antie/widgets/image"
  ],
  function (Application, Component, Container, ComponentContainer, Label, Image) {
    return Component.extend({
      init: function() {
        var self, title;
        self = this;
        this._super("statsContainer");

        this.statsImage = new Image("statsImage", 'delays.png');
        this.statsImage = this.appendChildWidget( this.statsImage );

        // Check for stats
        var getStats = function(){
          // Only delays graph exists at the moment
          // TODO Check if 'device_name' is the correct variable
          //if ( device_name === 'undefined' || device_name === '---' ) {
            self.statsImage.setSrc('delays.png?' + (new Date).getTime());
          //} else {
          //  self.statsImage.setSrc(device_name + '-latest.png');
          //}
          setTimeout(getStats, 5000);
        };

        setTimeout(getStats, 5000);
      }
    });
  }
);

require.def("hive_capture/appui/capture",
  [
    "antie/application",
    "antie/widgets/container",
    "antie/widgets/label"
  ],
  function(Application, Container, Label) {
    return Application.extend( {
      init: function(appDiv, styleDir, imgDir, callback) {
        var self;
        self = this;

        self._super(appDiv, styleDir, imgDir, callback);

        self._setRootContainer = function() {
          var container = new Container();
          container.outputElement = appDiv;
         self.setRootWidget(container);
        };
      },

      run: function() {
        this._setRootContainer();

        this.addComponentContainer("titleComponentContainer", "hive_capture/appui/components/titleContainer");
        this.addComponentContainer("deviceInformationContainer", "hive_capture/appui/components/deviceInformation");
        this.addComponentContainer("hiveStatsContainer", "hive_capture/appui/components/hiveStats");

        // Call Application.ready() once (and only once)
        this.addEventListener("aftershow", function appReady(evt) {
                    self.getCurrentApplication().ready();
                    self.removeEventListener('aftershow', appReady);
                });
      }
    } );
  }
);

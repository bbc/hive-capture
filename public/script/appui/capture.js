require.def("hive_capture/appui/capture",
  [
    "antie/application",
    "antie/widgets/container",
    "antie/widgets/label",
    "antie/events/keyevent",
  ],
  function(Application, Container, Label, KeyEvent) {
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

        self.page_one = [
          this.addComponentContainer("titleComponentContainer", "hive_capture/appui/components/titleContainer"),
          this.addComponentContainer("deviceInformationContainer", "hive_capture/appui/components/deviceInformation"),
          this.addComponentContainer("hiveStatsContainer", "hive_capture/appui/components/hiveStats")
        ];

        self.addEventListener('keydown', function(ev) {
          if (ev.keyCode == KeyEvent.VK_1) {
            for (var i = 0; i < self.page_one.length; i++) {
              self.page_one[i].removeClass('hidden');
            }
          } else if (ev.keyCode == KeyEvent.VK_2) {
            for (var i = 0; i < self.page_one.length; i++) {
              self.page_one[i].addClass('hidden');
            }
          }
        });

        // Call Application.ready() once (and only once)
        this.addEventListener("aftershow", function appReady(evt) {
                    self.getCurrentApplication().ready();
                    self.removeEventListener('aftershow', appReady);
                });
      }
    } );
  }
);

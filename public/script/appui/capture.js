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

        mm_device_id = '?';

        label_id = new Label("mm_id", "?");
        label_name = new Label("mm_name", "---");
      },

      run: function() {
        this._setRootContainer();

        self.page_one = [
          this.addComponentContainer("titleComponentContainer", "hive_capture/appui/components/titleContainer"),
          this.addComponentContainer("deviceInformationContainer", "hive_capture/appui/components/deviceInformation"),
          this.addComponentContainer("hiveStatsContainer", "hive_capture/appui/components/hiveStats")
        ];
        self.page_two = [
          this.addComponentContainer("mm_name_component_container", "hive_capture/appui/components/mm_name"),
        ]
        for (var i = 0; i < self.page_two.length; i++) {
          self.page_two[i].addClass('hidden');
        }

        self.addEventListener('keydown', function(ev) {
          if (ev.keyCode == KeyEvent.VK_1) {
            for (var i = 0; i < self.page_one.length; i++) {
              self.page_one[i].removeClass('hidden');
            }
            for (var i = 0; i < self.page_two.length; i++) {
              self.page_two[i].addClass('hidden');
            }
          } else if (ev.keyCode == KeyEvent.VK_2) {
            for (var i = 0; i < self.page_one.length; i++) {
              self.page_one[i].addClass('hidden');
            }
            for (var i = 0; i < self.page_two.length; i++) {
              self.page_two[i].removeClass('hidden');
            }
          }
        });

        // Start Hive Mind polling
        hive_mind_com.init(Application.getCurrentApplication(), 'TitanTV', mind_meld_url);
        hive_mind_com.setView('id', label_id);
        hive_mind_com.setView('name', label_name);
        hive_mind_com.start();

        // Call Application.ready() once (and only once)
        this.addEventListener("aftershow", function appReady(evt) {
                    self.getCurrentApplication().ready();
                    self.removeEventListener('aftershow', appReady);
                });
      }
    } );
  }
);

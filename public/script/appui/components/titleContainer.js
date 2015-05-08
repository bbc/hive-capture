require.def("hive_capture/appui/components/titleContainer",
  [
    "antie/widgets/component",
    "antie/widgets/container",
    "antie/widgets/label"
  ],
  function (Component, Container, Label) {
    return Component.extend({
      init: function() {
        var self, main_title, title_name;
        self = this;
        this._super("titleContainer");

        main_title = new Container();
        main_title.appendChildWidget(new Label("deviceTitle", appName));
        title_name = new Container();
        deviceName = new Label("deviceName", "---");
        title_name.appendChildWidget(deviceName);
        this.appendChildWidget(main_title);
        this.appendChildWidget(title_name);
      }
    });
  }
);

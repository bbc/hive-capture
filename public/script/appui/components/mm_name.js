require.def("hive_capture/appui/components/mm_name",
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
        this._super("mm_name_container");

        mm_name_container = new Container();
        mm_name_container.appendChildWidget(label_id);
        mm_name_container.appendChildWidget(label_name);
        this.appendChildWidget(mm_name_container);
      }
    });
  }
);

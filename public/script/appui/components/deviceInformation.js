require.def("hive_capture/appui/components/deviceInformation",
  [
    "antie/application",
    "antie/widgets/component",
    "antie/widgets/label",
    "antie/widgets/container",
    "antie/widgets/list"
  ],
  function (Application, Component, Label, Container, List) {
    return Component.extend({
      init: function() {
        var self = this;
        this._super("deviceInformation");

        var widgets = {};

        var ddbid = new Container("ddbid_container");
        device_id='-';
        device_status = '---';
        hive_name = '---';
        ddbid_label = new Label("ddbid", device_id);
        ddbid.appendChildWidget(ddbid_label);
        this.appendChildWidget(ddbid);
        widgets['ddbid'] = ddbid_label;

        var table = new List('device_table');

        var table_rows = {
          status: { name: "Status", value: device_status },
          hive_name: { name: "Hive", value: hive_name },
          device_brand: { name: "Brand", value: device_brand },
          device_model: { name: "Model", value: device_model },
          device_config: { name: "Configuration", value: device_config },
          device_queues: { name: "Queues", value: device_queues.join() },
          device_ipaddr: { name: "IP Address", value: device_ipaddr },
          whoami: { name: "WHOAMI", value: whoami },
          device_mac: { name: "MAC Address", value: device_mac },
          titantv_url: { name: "TitanTV url", value: titantv_url },
          polling_count: { name: "Polling", value: 0 }
        };

        for (var key in table_rows) {
          var row = new Container();
          row.addClass('row');
          label = new Label(key + "_label", table_rows[key]["name"]);
          label.addClass('label');
          value = new Label(key, table_rows[key]["value"]);
          value.addClass('value')
          row.appendChildWidget(label);
          row.appendChildWidget(value);
          table.appendChildWidget(row);
          widgets[key] = value;
        }

        this.appendChildWidget(table);

        message_box = new Container('message_box');
        widgets['message'] = new Label('message', '[No message]');
        message_box.appendChildWidget(widgets['message']);
        this.appendChildWidget(message_box);

        application = Application.getCurrentApplication();
        device = application.getDevice();
        polling_count = 0;

        // Start polling
        p_failed = false;
        messages = ['[No message]'];
        var add_message = function(line){
          messages.unshift(line);
          if (messages.length > 5) {
            messages.pop();
          }
        }
        var poll = function(){
          var callbacks = {
            onSuccess : function( json ) {
              taskInfo = json;
              setTimeout(poll, 5000);
              if ( p_failed ) {
                p_failed = false;
                add_message('Polling recovered');
              }
              if (device_id == parseInt(device_id, 10)) {
                if ( taskInfo.action ) {
                  if ( taskInfo.action.action_type == 'redirect' ) {
                    add_message("Redirect to " + taskInfo.action.body);
                    application.launchAppFromURL(taskInfo.action.body, {}, [], true);
                  } else if ( taskInfo.action.action_type == 'message' ) {
                    add_message(taskInfo.action.body);
                  }
                } else {
                  // Something
                }
              } else {
                //document.getElementById('deviceName').textContent = taskInfo.name;
                deviceName.setText(taskInfo.name);
                device_id=parseInt(taskInfo.id);
                device_queues=[];
                for(var i = 0; i < taskInfo.device_queues.length; i++) {
                  device_queues.push(taskInfo.device_queues[i].name);
                }
                widgets['device_queues'].setText(device_queues.join(", "));
                widgets['ddbid'].setText(device_id);
              }
              widgets['message'].setText(messages.join('<br>'));
              widgets['status'].setText(taskInfo.status);
              widgets['hive_name'].setText(taskInfo.hive ? taskInfo.hive : '<em>None</em>');
            },
            onError : function( response ) {
              setTimeout(poll, 5000);
              add_message("Polling failed: " + response);
              widgets['message'].setText(messages.join('<br>'));
              p_failed = true;
            }
          };

          polling_count = polling_count + 1;
          widgets['polling_count'].setText(polling_count);
          if (device_id == parseInt(device_id, 10)) {
            url = poll_url + device_id + '?callback=%callback%';
          } else {
            url = poll_url + '?callback=%callback%';
          }
          device.loadScript( url, /%callback%/, callbacks, 180 * 1000 );
        };

        poll();
        //setTimeout(poll, 5000);
      }
    });
  }
);

var looptime = 0.3;


ext_slats = func {
  airspeed = getprop("/velocities/airspeed-kt");
    if (airspeed < 180) {
      setprop("/controls/flight/slats", 1.0);
      } else {
        setprop("/controls/flight/slats", 0.0);

      }
     settimer(ext_slats, 0.5);
   }

ext_slats;




toggle_canopy = func {
  canopy = aircraft.door.new ("/controls/canopy/",3);
  if(getprop("/controls/canopy/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }
}

fire_MG = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
     setprop("/controls/armament/trigger", 1);
     } 
}
stop_MG = func {
     setprop("/controls/armament/trigger", 0); 
}

drop_tank = func {
  rcount=getprop("/sim/weight[0]/weight-lb");
  if(rcount > 149){
     setprop("/controls/armament/station/release-tank", 1);
     setprop("/controls/armament/station[1]/release-tank", 1);
     setprop("/sim/weight[0]/selected","none");
     setprop("/sim/weight[1]/selected","none");
     } 
 }

var update_mp_props = func {
	# print ("updating...");
	setprop("sim/multiplay/generic/int[0]", getprop ("/sim/armament/pylon0L/type"));
	setprop("sim/multiplay/generic/int[1]", getprop ("/sim/armament/pylon0R/type"));
	setprop("sim/multiplay/generic/int[2]", getprop ("/sim/armament/pylon1L/type"));
	setprop("sim/multiplay/generic/int[3]", getprop ("/sim/armament/pylon1R/type"));
	setprop("sim/multiplay/generic/int[4]", getprop ("/sim/armament/pylon2L/type"));
	setprop("sim/multiplay/generic/int[5]", getprop ("/sim/armament/pylon2R/type"));
	setprop("sim/multiplay/generic/int[6]", getprop ("/sim/armament/pylon3L/type"));
	setprop("sim/multiplay/generic/int[7]", getprop ("/sim/armament/pylon3R/type"));
	setprop("sim/multiplay/generic/int[8]", getprop ("/sim/armament/sidewinderL/type"));
	setprop("sim/multiplay/generic/int[9]", getprop ("/sim/armament/sidewinderR/type"));


	var state = 0;
	if (getprop ("sim/failure-manager/burning")) {
			state = state +1;
	}
	if (getprop ("sim/failure-manager/smoking")) {
			state = state +2;
	}
	setprop ("sim/failure-manager/fail-type",state);
	# print ("State: ", state);
	setprop("sim/multiplay/generic/int[10]", getprop ("/sim/failure-manager/fail-type"));

 	settimer(update_mp_props, looptime);
}


var config = gui.Dialog.new("/sim/gui/dialogs/appearance/dialog", "Aircraft/F-86/Dialogs/config.xml");
var payload = gui.Dialog.new("/sim/gui/dialogs/payload/dialog", "Aircraft/F-86/Dialogs/payload.xml");


setlistener("/sim/signals/fdm-initialized",update_mp_props);


var save_list = ["/combat/enabled"];

aircraft.data.add(save_list);


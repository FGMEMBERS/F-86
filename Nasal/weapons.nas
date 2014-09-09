var masterarm = props.globals.getNode("controls/armament/master-arm");
var weapselected = props.globals.getNode ("sim/armament/weapon_selected");
var gun0 = props.globals.getNode("sim/armament/gun[0]/fire");
var gun1 = props.globals.getNode("sim/armament/gun[1]/fire");
var gun2 = props.globals.getNode("sim/armament/gun[2]/fire");
var gun3 = props.globals.getNode("sim/armament/gun[3]/fire");
var gun4 = props.globals.getNode("sim/armament/gun[4]/fire");
var gun5 = props.globals.getNode("sim/armament/gun[5]/fire");
var statgun0 = props.globals.getNode("sim/armament/gun[0]/serviceable");
var statgun1 = props.globals.getNode("sim/armament/gun[1]/serviceable");
var statgun2 = props.globals.getNode("sim/armament/gun[2]/serviceable");
var statgun3 = props.globals.getNode("sim/armament/gun[3]/serviceable");
var statgun4 = props.globals.getNode("sim/armament/gun[4]/serviceable");
var statgun5 = props.globals.getNode("sim/armament/gun[5]/serviceable");

var tracerevery = 20;
		var times0 = 49;

var rocket0 = props.globals.getNode("sim/armament/rocket[0]/fire");
var rocket1 = props.globals.getNode("sim/armament/rocket[1]/fire");
var rocket2 = props.globals.getNode("sim/armament/rocket[2]/fire");
var rocket3 = props.globals.getNode("sim/armament/rocket[3]/fire");
var statrocket0 = props.globals.getNode("sim/armament/rocket[0]/serviceable");
var statrocket1 = props.globals.getNode("sim/armament/rocket[1]/serviceable");
var statrocket2 = props.globals.getNode("sim/armament/rocket[2]/serviceable");
var statrocket3 = props.globals.getNode("sim/armament/rocket[3]/serviceable");
var rpmode = props.globals.getNode("sim/armament/rpmode");

setlistener("/controls/armament/trigger", func(n) {
    var stat = n.getValue();
		if 	( stat ) {
				if ( masterarm.getValue() )  {
						if (statgun0.getValue() == 1) {
								gun0.setValue (1);
						}
						if (statgun1.getValue() == 1) {
								gun1.setValue (1);
						}
						if (statgun2.getValue() == 1) {
								gun2.setValue (1);
						}
						if (statgun3.getValue() == 1) {
								gun3.setValue (1);
						}
						if (statgun4.getValue() == 1) {
								gun4.setValue (1);
						}
						if (statgun5.getValue() == 1) {
								gun5.setValue (1);
						}
				}
     } else {
				gun0.setValue (0);
				gun1.setValue (0);
				gun2.setValue (0);
				gun3.setValue (0);
				gun4.setValue (0);
				gun5.setValue (0);
			}
});



setlistener("/controls/armament/trigger1", func(n) {
    var stat = n.getValue();
		if 	( stat ) {
				if ( masterarm.getValue() )  {
						if (weapselected.getValue() == 1 ) {
								drop_bomb();
						}
						if (weapselected.getValue() == 2 ) {
								fire_rocket();
						}
						if (weapselected.getValue() == 3 ) {
								fire_rocketpod();
						}
						if (weapselected.getValue() == 4 ) {
								fire_sidewinder();
						}
			}
		}
});

var drop_bomb = func () {
		print ("dropping bomb!");
		var packet = getprop ("sim/armament/bombpacket");
		var dropped = 0;
		var timed = getprop ("sim/armament/bombtrain");
		var single = getprop ("sim/armament/bombsingle");

		if ( getprop ("sim/armament/pylon0L/type") == 3 or getprop ("sim/armament/pylon0L/type") == 4 ) {
				setprop ("sim/armament/pylon0L/type", 1);
				setprop ("sim/armament/pylon0L/release_bomb", 1);
				setprop ("weight[0]/lbs",0);
				dropped = dropped+1;
		} 
		if ( dropped < packet ) {
				if ( getprop ("sim/armament/pylon0R/type") == 3 or getprop ("sim/armament/pylon0R/type") == 4 ) {
						setprop ("sim/armament/pylon0R/type", 1);
						setprop ("sim/armament/pylon0R/release_bomb", 1);
						setprop ("weight[1]/lbs",0);
						dropped = dropped+1;
				}
		} 
		if ( dropped < packet ) {
				if ( getprop ("sim/armament/pylon1L/type") == 3 or getprop ("sim/armament/pylon1L/type") == 4 ) {
						setprop ("sim/armament/pylon1L/type", 1);
						setprop ("sim/armament/pylon1L/release_bomb", 1);
						setprop ("weight[2]/lbs",0);
						dropped = dropped+1;
				}
		} 
		if ( dropped < packet ) {
				if ( getprop ("sim/armament/pylon1R/type") == 3 or getprop ("sim/armament/pylon1R/type") == 4 ) {
						setprop ("sim/armament/pylon1R/type", 1);
						setprop ("sim/armament/pylon1R/release_bomb", 1);
						setprop ("weight[3]/lbs",0);
						dropped = dropped+1;
				}
		}
		print (dropped);
		if (dropped != 0 and single == 0) { 
				settimer (drop_bomb, timed);
		} else {
				print ("no Bomb left!");
		}
}

var fire_rocket = func () {
		print ("fire rocket!");
		var packet = getprop ("sim/armament/rocketpacket");
		var dropped = 0;
		var timed = getprop ("sim/armament/rockettrain");
		var single = getprop ("sim/armament/rocketsingle");

		if ( getprop ("sim/armament/pylon0L/type") == 7  ) {
				setprop ("sim/armament/pylon0L/type", 6);
				setprop ("sim/armament/pylon0L/release_rocket", 1);
				setprop ("weight[0]/lbs",100);
				dropped = dropped+1;
		}

		if ( dropped < packet ) {
				if ( getprop ("sim/armament/pylon0R/type") == 7 ) {
						setprop ("sim/armament/pylon0R/type", 6);
						setprop ("sim/armament/pylon0R/release_rocket", 1);
						setprop ("weight[1]/lbs",100);
						dropped = dropped+1;
				}

		if ( getprop ("sim/armament/pylon0L/type") == 6  ) {
				setprop ("sim/armament/pylon0L/type", 1);
				setprop ("sim/armament/pylon0L/release_rocket", 1);
				setprop ("weight[0]/lbs",0);
				dropped = dropped+1;
		}

 		if ( getprop ("sim/armament/pylon0R/type") == 6  ) {
				setprop ("sim/armament/pylon0R/type", 1);
				setprop ("sim/armament/pylon0R/release_rocket", 1);
				setprop ("weight[0]/lbs",0);
				dropped = dropped+1;
		}
		}
}

var fire_rocketpod = func () {
		print ("fire rocketpod!");
}

var fire_sidewinder = func () {
		print ("fox one!");
}

#setlistener("/ai/submodels/submodel[1]/count", func(n) {
#    var count = n.getValue();
#		print ( count, " " , times0 * tracerevery);
#		tracergun0.setValue(0);
#		if (count <= times0 * tracerevery) {
#					print ("tracer at§" , count);
#				 tracergun0.setValue(1);
#					times0.setValue(times0 -1 );
#		}
#});

#setlistener("sim/model/aircraft/impact/gun", func(n) {
#    var impact = n.getValue();
#    var solid = getprop(impact ~ "/material/solid");
    
#    if (solid) {
#      var long = getprop(impact ~ "/impact/longitude-deg");    
#      var lat = getprop(impact ~ "/impact/latitude-deg");
#			setprop("sim/model/aircraft/impact/splash",0);
#    }
#		else {
#			setprop("sim/model/aircraft/impact/splash",1);
#		}
#  });




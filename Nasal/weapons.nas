var masterarm = props.globals.getNode("controls/armament/master-arm");
var gun0 = props.globals.getNode("sim/armament/gun[0]/fire");
var gun1 = props.globals.getNode("sim/armament/gun[1]/fire");
var gun2 = props.globals.getNode("sim/armament/gun[2]/fire");
var gun3 = props.globals.getNode("sim/armament/gun[3]/fire");
var gun4 = props.globals.getNode("sim/armament/gun[0]/fire");
var gun5 = props.globals.getNode("sim/armament/gun[1]/fire");
var statgun0 = props.globals.getNode("sim/armament/gun[0]/serviceable");
var statgun1 = props.globals.getNode("sim/armament/gun[1]/serviceable");
var statgun2 = props.globals.getNode("sim/armament/gun[2]/serviceable");
var statgun3 = props.globals.getNode("sim/armament/gun[3]/serviceable");
var statgun4 = props.globals.getNode("sim/armament/gun[0]/serviceable");
var statgun5 = props.globals.getNode("sim/armament/gun[1]/serviceable");

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
						if (statcannon0.getValue() == 1) {
								cannon0.setValue (1);
						}
						if (statcannon1.getValue() == 1) {
								cannon1.setValue (1);
						}
						if (statcannon2.getValue() == 1) {
								cannon2.setValue (1);
						}
						if (statcannon3.getValue() == 1) {
								cannon3.setValue (1);
						}
				}
     } else {
				cannon0.setValue (0);
				cannon1.setValue (0);
				cannon2.setValue (0);
				cannon3.setValue (0);
			}
});

setlistener("/controls/armament/trigger2", func(n) {
    var stat = n.getValue();
		if 	( stat ) {
				if ( masterarm.getValue() )  {
						if ( rpmode.getValue() == 0) {
								if (statrocket0.getValue() == 1) {
										rocket0.setValue (1);
								}
								if (statrocket1.getValue() == 1) {
										rocket1.setValue (1);
								}
								if (statrocket2.getValue() == 1) {
										rocket2.setValue (1);
								}
								if (statrocket3.getValue() == 1) {
										rocket3.setValue (1);
								}
						} else {
								
						}
							
				}
     } else {
				rocket0.setValue (0);
				rocket1.setValue (0);
				rocket2.setValue (0);
				rocket3.setValue (0);
			}
});

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

setlistener("sim/model/aircraft/impact/gun", func(n) {
    var impact = n.getValue();
    var solid = getprop(impact ~ "/material/solid");
    
    if (solid) {
#      var long = getprop(impact ~ "/impact/longitude-deg");    
#      var lat = getprop(impact ~ "/impact/latitude-deg");
			setprop("sim/model/aircraft/impact/splash",0);
    }
		else {
			setprop("sim/model/aircraft/impact/splash",1);
		}
  });




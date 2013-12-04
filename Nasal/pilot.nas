var looptime = 0.05;
var head_x = props.globals.getNode("sim/model/crew/pilot/limb[2]/x-deg");
var head_y = props.globals.getNode("sim/model/crew/pilot/limb[2]/y-deg");
var head_z = props.globals.getNode("sim/model/crew/pilot/limb[2]/z-deg");
var gload = props.globals.getNode("accelerations/pilot-g");

var aileron = props.globals.getNode("controls/flight/aileron");
var elevator = props.globals.getNode("controls/flight/elevator");

var idle_z = 0;
var idle_y = 0;


var init = func {
		io.read_properties("Models/Human/fighterpilot50_pose.xml", "sim/model/crew/pilot");
		print ("Pilot movement initialized");		
		var idle_z = head_z.getValue();
		
  settimer(main_loop, looptime);
}
var main_loop = func {

		var h_z = idle_z + aileron.getValue()*30;
		head_z.setValue(h_z);
		var h_y = idle_y + elevator.getValue()*15;
		head_y.setValue(h_y);

  	settimer(main_loop, looptime);
}

setlistener("/sim/signals/fdm-initialized",init);

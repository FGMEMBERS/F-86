var looptime = 0.2;
var n1 = props.globals.getNode("engines/engine[0]/n1");
var n2 = props.globals.getNode("engines/engine[0]/n2");
var thrust = props.globals.getNode("engines/engine[0]/thrust-lbs",1);
var propthrust = props.globals.getNode("engines/engine[0]/prop-thrust",1);
var engstat = props.globals.getNode("engines/engine[0]/running");
var nofuel = props.globals.getNode("engines/engine[0]/out-of-fuel",1 );
var oiltemp = props.globals.getNode("engines/engine[0]/oil-temperature-degf");
var airspeed = props.globals.getNode("velocities/airspeed-kt");
var envtemp = props.globals.getNode("environment/temperature-degc");
var viscosity = props.globals.getNode("engines/engine[0]/oil-visc");
var rstrain = props.globals.getNode("engines/engine[0]/rev-strain");
var oboost = props.globals.getNode("engines/engine[0]/boost-strain");
var nofuel = props.globals.getNode("engines/engine[0]/out-of-fuel",1 );
var gload = props.globals.getNode("accelerations/pilot-g",1);


var init = func {
	var et0 = envtemp.getValue();
	#	print (et0);

	
  if (getprop("/controls/engines/on-startup-running") != 1) {
		print ("Start without Engine.");
		n1.setValue(0);
		n1.setAttribute("writable",0);
		n2.setValue(0);
		n2.setAttribute("writable",0);
		thrust.setValue(0);
		thrust.setAttribute("writable",0);
		propthrust.setValue(0);
		propthrust.setAttribute("writable",0);
		nofuel.setValue(1);
		nofuel.setAttribute("writable",0);
		engstat.setValue(0);
		engstat.setAttribute("writable",0);
  }  
  settimer(main_loop, looptime);
}
var main_loop = func {
#	print ("engstat: ", engstat.getValue());
	if (engstat.getValue() == 1){
#		engine_update();
#		fluid_update();
#		check_engine();
	} else {
		cool_down();
	}
  settimer(main_loop, looptime);
}


var engine_update = func {
# if someone has suggestions to calculate engine parameters more realistic drop me a note
	var as = airspeed.getValue();
	var cf = cowlflap.getValue();
	var ct = cyltemp.getValue();
	var et0 = envtemp.getValue();
	var egt = exhtempf.getValue();
	var ob = oboost.getValue();
	var rs = rstrain.getValue();
	var thr = thrust.getValue();
	#var thr = getprop("engines/engine[0]/thrust-lbs"); # fixme: don't know why I have to do it this way
	var rpm0 = rpm.getValue();
	var mp = manpress.getValue();
	var mix = mixture.getValue();
	# calculate carburator entry temperature
	var cat = et0 + 0.6 * mp;
	#print ("CET: ",cat);
	carbetemp.setValue(cat);
	# summing up various parameters with a weighing factor
	var temp = 3 * cat + 0.3 * rpm0 + 0.5 * egt - 0.005 * as * as - 0.07* thr * (cf+0.1) -20 * mix ;
	#print ("Temp: ",temp,"Mix: ",mix);
	cyltemp.setDoubleValue (temp * 0.4);
}

var fluid_update = func {
	var otemp = oiltemp.getValue();
	var visc = viscosity.getValue();
	# print (otemp," ",visc);
	interpolate ("engines/engine[0]/oil-press", 8.2 - 2*visc, looptime);
	interpolate ("engines/engine[0]/oil-temp-calc", otemp *visc-70, looptime);
	if (visc < 1.0 ) {
		interpolate ("engines/engine[0]/oil-visc", visc + 0.002);

	}
}
var check_engine = func {
	var rs = rstrain.getValue();
	var ob = oboost.getValue();
	var rpm0 = rpm.getValue();
	var mp = manpress.getValue();
	#check for overrev
	if (rpm0 > 3100) {
		var rs0 = 0.01 * (rpm0 - 3100) * ( rpm0 - 3100);
		rstrain.setValue (rs + rs0);
		# print (rs0, " ",rs + rs0);
	}
	if (rs > 300000 ) {
		setprop("/engines/engine[0]/overrev", 1);
		failure.kill_engine();
	}	
	#check for overboost
	if (mp > 55) {
		var ob0 = ( mp - 57)*(mp - 57);
		oboost.setValue (ob + ob0);
		# print (ob0, " ",ob + ob0);"engines/engine[0]/cylinder-temp-degc"
	}
	if (ob > 500 ) {
		setprop("/engines/engine[0]/overboost", 1);
		failure.kill_engine();
	}
	if ( gload.getValue() < -0.3 ) {
			engine_cough() ;
	}		
}

engine_cough = func {
	var timer = rand()*3;
	var eng_off = func {
		setprop("/engines/engine[0]/running", 0);
		setprop("/engines/engine[0]/out-of-fuel", 1);
		setprop("/sim/failure-manager/engines/engine[0]/coughing", 1);
	};
	settimer(eng_off, timer+0.5);
	var eng_on = func {
		setprop("/engines/engine[0]/running", 1);
		setprop("/engines/engine[0]/out-of-fuel", 0);
		setprop("/sim/failure-manager/engines/engine[0]/coughing", 0);
	};
	settimer(eng_on, timer+2.5);
}


var cool_down = func {
#	print ("cooling");
	var et0 = envtemp.getValue();
	interpolate ("engines/engine[0]/cylinder-temp-degc", et0, 300);
	interpolate ("engines/engine[0]/oil-temp-calc", et0, 500);
	interpolate ("engines/engine[0]/oil-visc" , 0, 500);
}


var master_on = func {
		n1.setAttribute("writable",1);
		n2.setAttribute("writable",1);
}
var master_off = func {
		n1.setValue(0);
		n1.setAttribute("writable",0);
		n2.setValue(0);
		n2.setAttribute("writable",0);
}


setlistener("/sim/signals/fdm-initialized",init);

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

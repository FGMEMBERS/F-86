# ==============================================================================
# Head up display
# ==============================================================================

var pow2 = func(x) { return x * x; };
var vec_length = func(x, y) { return math.sqrt(pow2(x) + pow2(y)); };
var round0 = func(x) { return math.abs(x) > 0.01 ? x : 0; };
var clamp = func(x, min, max) { return x < min ? min : (x > max ? max : x); }
 
var HUD = {
  canvas_settings: {
    "name": "HUD",
    "size": [1024, 1024],
    "view": [512, 512],
    "mipmapping": 1
  },
  new: func(placement)
  {
    debug.dump("Creating new canvas HUD...");
    var m = {
      parents: [HUD],
      canvas: canvas.new(HUD.canvas_settings)
    };
 
    m.canvas.addPlacement(placement);
    m.canvas.setColorBackground(0.8, .8, 0.3, 0.02);
 
    m.root =
      m.canvas.createGroup()
              .setScale(1, 1/math.cos(25 * math.pi/180))
              .setTranslation(240, 180)

              .setDouble("character-size", 18)
              .setDouble("character-aspect-ration", 0.9)
              .set("stroke", "rgba(0,255,0,0.9)");

      m.circle0 = m.root.createChild("path")
           				 .moveTo(-50, 0)
            			 .lineTo(-60, 6)
         				   .lineTo(-70, 0)
        			     .lineTo(-60, -6)
									 .lineTo(-50, 0)
        				   .setStrokeLineWidth(2.0);
 			
      m.circle1 = m.root.createChild("path")
           				 .moveTo(50, 0)
       				     .lineTo(60, 6)
    			         .lineTo(70, 0)
     				       .lineTo(60, -6)
					   			 .lineTo(50, 0)
            			 .setStrokeLineWidth(2.0);

      m.circle2 = m.root.createChild("path")
           				 .moveTo(-50, 0)
            			 .lineTo(-60, 6)
         				   .lineTo(-70, 0)
        			     .lineTo(-60, -6)
									 .lineTo(-50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(10);

      m.circle3 = m.root.createChild("path")
           				 .moveTo(50, 0)
            			 .lineTo(60, 6)
         				   .lineTo(70, 0)
        			     .lineTo(60, -6)
									 .lineTo(50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(10);

      m.circle4 = m.root.createChild("path")
           				 .moveTo(-50, 0)
            			 .lineTo(-60, 6)
         				   .lineTo(-70, 0)
        			     .lineTo(-60, -6)
									 .lineTo(-50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(24);

      m.circle5 = m.root.createChild("path")
           				 .moveTo(50, 0)
            			 .lineTo(60, 6)
         				   .lineTo(70, 0)
        			     .lineTo(60, -6)
									 .lineTo(50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(24);

      m.circle6 = m.root.createChild("path")
           				 .moveTo(-50, 0)
            			 .lineTo(-60, 6)
         				   .lineTo(-70, 0)
        			     .lineTo(-60, -6)
									 .lineTo(-50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(-24);

      m.circle7 = m.root.createChild("path")
           				 .moveTo(50, 0)
            			 .lineTo(60, 6)
         				   .lineTo(70, 0)
        			     .lineTo(60, -6)
									 .lineTo(50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(-24);

      m.circle8 = m.root.createChild("path")
           				 .moveTo(-50, 0)
            			 .lineTo(-60, 6)
         				   .lineTo(-70, 0)
        			     .lineTo(-60, -6)
									 .lineTo(-50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(-10);

      m.circle9 = m.root.createChild("path")
           				 .moveTo(50, 0)
            			 .lineTo(60, 6)
         				   .lineTo(70, 0)
        			     .lineTo(60, -6)
									 .lineTo(50, 0)
        				   .setStrokeLineWidth(2.0)
									 .setRotation(-10);

 
    # Flightpath/Velocity vector
    m.fpv = m.root.createChild("group", "FPV");
    m.fpv.createChild("path")
         .arcSmallCCW(8, 8, 0, -16, 0)
         .arcSmallCCW(8, 8, 0,  16, 0)
         .setStrokeLineWidth(0.9);


 

 
    m.input = {
      pitch:      "/orientation/pitch-deg",
      roll:       "/orientation/roll-deg",
      hdg:        "/orientation/heading-deg",
      speed_n:    "velocities/speed-north-fps",
      speed_e:    "velocities/speed-east-fps",
      speed_d:    "velocities/speed-down-fps",
      alpha:      "/orientation/alpha-deg",
      beta:       "/orientation/side-slip-deg",
      ias:        "/velocities/airspeed-kt",
      gs:         "/velocities/groundspeed-kt",
      vs:         "/velocities/vertical-speed-fps",
      rad_alt:    "/instrumentation/radar-altimeter/radar-altitude-ft",
      wow_nlg:    "/gear/gear[4]/wow",
      airspeed:   "/velocities/airspeed-kt",
      target_spd: "/autopilot/settings/target-speed-kt",
      sightdia:		"/sim/armament/gunsight/sightdiameter",
    };
 
    foreach(var name; keys(m.input))
      m.input[name] = props.globals.getNode(m.input[name], 1);
 
    return m;
  },
  update: func()
  {
 
 
 
    # flight path vector (FPV)
    var vel_gx = me.input.speed_n.getValue();
    var vel_gy = me.input.speed_e.getValue();
    var vel_gz = me.input.speed_d.getValue();
 
    var yaw = me.input.hdg.getValue() * math.pi / 180.0;
    var roll = me.input.roll.getValue() * math.pi / 180.0;
    var pitch = me.input.pitch.getValue() * math.pi / 180.0;
 
    var sy = math.sin(yaw);   var cy = math.cos(yaw);
    var sr = math.sin(roll);  var cr = math.cos(roll);
    var sp = math.sin(pitch); var cp = math.cos(pitch);
 
    var vel_bx = vel_gx * cy * cp
               + vel_gy * sy * cp
               + vel_gz * -sp;
    var vel_by = vel_gx * (cy * sp * sr - sy * cr)
               + vel_gy * (sy * sp * sr + cy * cr)
               + vel_gz * cp * sr;
    var vel_bz = vel_gx * (cy * sp * cr + sy * sr)
               + vel_gy * (sy * sp * cr - cy * sr)
               + vel_gz * cp * cr;
 
    var dir_y = math.atan2(round0(vel_bz), math.max(vel_bx, 0.01)) * 180.0 / math.pi;
    var dir_x  = math.atan2(round0(vel_by), math.max(vel_bx, 0.01)) * 180.0 / math.pi;
 
    me.fpv.setTranslation(dir_x * 18, dir_y * 18);

		var sdia = me.input.sightdia.getValue();

		me.circle0.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle1.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle2.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle3.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle4.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle5.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle6.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle7.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle8.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle9.setTranslation(dir_x * 18 , dir_y * 18);
		me.circle5.setTranslation(dir_x * 18 , dir_y * 18);
 
    var speed_error = 0;
    if( me.input.target_spd.getValue() != nil )
      speed_error = 4 * clamp(
        me.input.target_spd.getValue() - me.input.airspeed.getValue(),
        -15, 15
      );
 

    settimer(func me.update(), 0);
  }
};
 
var init = setlistener("/sim/signals/fdm-initialized", func() {
  removelistener(init); # only call once
  var hud_pilot = HUD.new({"node": "reflectorglass"});
  hud_pilot.update();

});

// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function verlet_system_create(_fps) constructor {
	elaspedTime = 0;
	elaspedTimeInSeconds = 0;
	grav = 0.5;
	bounce = 0;
	fric = 0.999;
	lastTime = current_time;
	//currentTime = 0;
	leftOverTime = 0;
	timesteps = 1;
	useConstraints = true;	
	FPS = _fps;
	timeStepConst = 1 / (_fps/1000);
	warpReduce = 3;
	avgSpeed = 0;
	useTimeSteps = true;
	isEnabled = true;
	points = [];
	sticks = [];
	images = [];
	sleepPoints = [];
	sleepSticks = [];
	
	
	// Constraint Specific
	c_wmax = room_width;
	c_wmin = 0;
	c_hmax = room_height;
	c_hmin = 0;
	
	#region functions 
	
	function image_struct(_p1, _p2, _p3, _p4, _sprite, _index) constructor {
		path = [_p1, _p2, _p3, _p4];
		image = _sprite;
		index = _index;
	}
	
	function image_push(_p1, _p2, _p3, _p4, _sprite, _index) {
		var _size = array_length(images);
		var _struct = new image_struct(_p1, _p2, _p3, _p4, _sprite, _index);
		images[_size] = _struct;
		return _struct;
	}
	
	function mean_array(_array) {
		var _size = array_length(_array);
		var _average = 0;
		for(var _i = 0; _i < _size; ++_i) {
			_average += _array[_i].x - _array[_i].oldx + _array[_i].y - _array[_i].oldy;
		}
		_average /= _size;
		return _average;
	}
	
	function stick_struct(_p1, _p2) constructor {
		p1 = _p1;
		p2 = _p2;
		var dx = _p2.x - _p1.x,	
		dy = _p2.y - _p1.y;
		length = sqrt(dx * dx + dy * dy);
		visible = true;
	}
	
	function stick_add(_p1, _p2) {
		var _size = array_length(sticks);
		sticks[_size] = new stick_struct(_p1, _p2);
		return sticks[_size];
	}
	
	function stick_clear() {
		var _size = array_length(sticks);
		for (var _i = 0; _i < _size; ++_i) {
			delete sticks[_i];	
		}
		array_resize(sticks,0);
	}
	
	function point_add(_verlet_struct) {
		var _size = array_length(points);
		points[_size] = _verlet_struct;
		return _verlet_struct;
	}
	
	function point_clear() {
		var _size = array_length(points);
		for (var _i = 0; _i < _size; ++_i) {
			delete points[_i];	
		}
		array_resize(points,0);
	}
	
	function constraint() {
		// Loop Between points
		if !(useConstraints) return 0;
		var _size = array_length(points);
		for(var _i = 0; _i < _size; ++_i) {
			var p = points[_i];
			if !(p.pinned) {
			var	_vx = (p.x - p.oldx) * fric, 
				_vy = (p.y - p.oldy) * fric;
				// Width Constraint
				if (p.x > c_wmax) {
					p.x = c_wmax;
					p.oldx = p.x + _vx* bounce;
				}	else if (p.x < c_wmin) {
					p.x = c_wmin;
					p.oldx = p.x + _vx * bounce;
				}
				
				// Height Constraint
				if (p.y > c_hmax) {
					p.y = c_hmax;
					p.oldy = p.y + _vy* bounce;
				}	else if (p.y < c_hmin) {
					p.y = c_hmin;
					p.oldy = p.y + _vy* bounce;
				}
			}
		}
	}

	//ideal_delta_time = 1/_fps * 1000000;
	//dt_ratio = delta_time / ideal_delta_time;
	
	/*update_fps = function(_fps) {
		ideal_delta_time = 1/_fps * 1000000;		
	}*/
	
	function update_time() {
		//dt_ratio = delta_time / ideal_delta_time;
		//elaspedTime = lastTime - dt_ratio;
		//lastTime = dt_ratio;
		
		elaspedTime = current_time - lastTime;
		lastTime = current_time;
		
		// Add to Elasped Time
		elaspedTime += leftOverTime;
		
		timesteps = floor(elaspedTime / timeStepConst);
		
		leftOverTime = elaspedTime - timesteps * timeStepConst;
		elaspedTimeInSeconds = 1 / (timeStepConst/elaspedTime);
	}	
	
	function update_stats() {
		avgSpeed = mean_array(points);	
	}
	
	function update_sticks() {
		var _size = array_length(sticks);
		for(var _i = 0; _i < _size; ++_i) {
			var s = sticks[_i], 
				dx = s.p2.x - s.p1.x,	
				dy = s.p2.y - s.p1.y,
			dist = sqrt(dx * dx + dy * dy),
		difference = s.length - dist,
		percent = difference / dist / 2,
		offsetX = dx * percent,
		offsetY = dy * percent;
		
		if !(s.p1.pinned) {
			s.p1.x -= offsetX;
			s.p1.y -= offsetY;
		}
		
		if !(s.p2.pinned) {
			s.p2.x += offsetX;
			s.p2.y += offsetY;
		}
	}
	}
	
	function update_points() {
		var _len = array_length(points);
		for(var _i = 0; _i < _len; ++_i) {
			var p = points[_i];
			if !(p.pinned) {
			var _vx = (p.x - p.oldx) * fric,
			_vy = (p.y - p.oldy) * fric;
		
				p.oldx = p.x;
				p.oldy = p.y;
				p.x += _vx;
				p.y += _vy;
				p.y += grav;
			}
		}
	}
	
	function render_points() {
		var _len = array_length(points);
		for(var _i = 0; _i < _len; ++_i) {
			var p = points[_i];
			draw_circle(p.x,p.y,3,false);
		}
	}
	
	function render_sticks() {
		var _size = array_length(sticks);
		for(var _i = 0; _i < _size; ++_i) {
			var s = sticks[_i];
			if (s.visible) draw_line(s.p1.x,s.p1.y,s.p2.x,s.p2.y);
		}
	}
	
	function render_images() {
		var _size = array_length(images);
		for(var _i = 0; _i < _size; ++_i) {
			var _image = images[_i];
			var _sprite = _image.image,
				_index = _image.index,
				_x1 = _image.path[0].x,
				_y1 = _image.path[0].y, 
				_x2 = _image.path[1].x, 
				_y2 = _image.path[1].y, 
				_x3 = _image.path[2].x, 
				_y3 = _image.path[2].y, 
				_x4 = _image.path[3].x, 
				_y4 = _image.path[3].y;
			draw_sprite_pos(_sprite, _index, _x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, 1);
		}
	}
	
	function step() {
		update_time();	
		if !(isEnabled) exit;
		simulate_physics();
		update_stats();
	}
	
	function simulate_physics() {
		// We update the simulation time
		var _steps = useTimeSteps ? timesteps : 1;
		for(var _t  = 0; _t < _steps; ++_t) {
			update_points();
			for(var _i = 0; _i < warpReduce; ++_i) {
				update_sticks();
				constraint();
			}
		}
	}

	function toString() {
		return "Elasped Time: " + string(elaspedTime) 
		+ "\nLast Time: " + string(lastTime) 
		+ "\nLeft Over Time: " + string(leftOverTime) 
		+ "\nTime Steps: " + string(timesteps)
		+ "\nTime Step Const: " + string(timeStepConst) + "ms/" + string(FPS) +"fps" 
		+ "\nElasped Time in Seconds: " + string(elaspedTimeInSeconds)
		+ "\nTimeStep Enabled: " + string(useTimeSteps)
		+ "\nPhysics Enabled: " + string(isEnabled)
		+ "\nPoints: " + string(array_length(points))
		+ "\nSticks: " + string(array_length(sticks))
		+ "\nAverage Speed: " + string(avgSpeed);
	}
	#endregion
}

function verlet_create_2d(_x, _y) constructor {
	x = _x;
	y = _y;
	//vx = 1;
	//vy = 1;
	oldx = _x;
	oldy = _y;
	pinned = false;
	
}

function verlet_create_square(_system, _x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4) constructor {
	systemID = _system
	p0 = systemID.point_add(new verlet_create_2d(_x1,_y1));
	p1 = systemID.point_add(new verlet_create_2d(_x2,_y2));
	p2 = systemID.point_add(new verlet_create_2d(_x3,_y3));
	p3 = systemID.point_add(new verlet_create_2d(_x4,_y4));
//_p2.x++;

	systemID.stick_add(p0, p1);
	systemID.stick_add(p1, p2);
	systemID.stick_add(p2, p3);
	systemID.stick_add(p3, p0);
	systemID.stick_add(p0, p2).visible = false;
	systemID.stick_add(p1, p3).visible = false;
}

/*function verlet_create_3d(_x, _y, _z) : verlet_create_2d(_x, _y) constructor {
	z = _z;
}*/
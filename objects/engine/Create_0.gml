/// @description Insert description here
// You can write your code in this editor


verlet = new verlet_system_create(60);
verlet.bounce = .95;
show_debug_overlay(true);
repeat(5) {
	/*verlet.stick_add(verlet.point_add(new verlet_create_2d(random(room_width),random(room_height))),
					verlet.point_add(new verlet_create_2d(random(room_width),random(room_height))));*/
					verlet.point_add(new verlet_create_2d(random(room_width),random(room_height)));
	
}

var _test = new verlet_create_square(verlet, 16, 16, 16, 48, 32, 48, 32, 16);
verlet.image_push(_test.p0, _test.p1, _test.p2, _test.p3, spr_chain, 0);
_test.p0.pinned = true;
_test.p3.pinned = true;

var _test2 = new verlet_create_square(verlet, 16, 16+32, 16, 48+32, 32, 48+32, 32, 16+32);
verlet.stick_add(_test2.p1, _test.p2);
verlet.stick_add(_test2.p0, _test.p1);
_test2.p2.oldx -= 25;
verlet.image_push(_test2.p0, _test2.p1, _test2.p2, _test2.p3, spr_chain, 0);

paused = true;
var _min = 512;
var _max = 512+32;
var _p1 = new verlet_create_2d(_min,_min);
var _p2 = new verlet_create_2d(_max,_min);
var _p3 = new verlet_create_2d(_max,_max);
var _p4 = new verlet_create_2d(_min,_max);
var _p5 = new verlet_create_2d(_min-32,_max+32);
p2 = _p2;
p5 = _p5;
//_p2.oldx-;
verlet.point_add(_p1);
verlet.point_add(_p2).pinned = true;
_p4.oldx-=15;
verlet.point_add(_p3);
verlet.point_add(_p4);
verlet.point_add(_p5);
//_p2.x++;

verlet.stick_add(_p1, _p2);
verlet.stick_add(_p2, _p3);
verlet.stick_add(_p3, _p4);
verlet.stick_add(_p4, _p1);
verlet.stick_add(_p1, _p3).visible = false;
verlet.stick_add(_p2, _p4).visible = false;
verlet.stick_add(_p2, _p5);

verlet.image_push(_p1, _p2, _p3, _p4, spr_test, 0);
//verlet.stick_add(_p2, _p4);

var _p1 = new verlet_create_2d(_min,_min);
var _p2 = new verlet_create_2d(_max,_min);
var _p3 = new verlet_create_2d(_max,_max);
var _p4 = new verlet_create_2d(_min,_max);
//_p2.oldx-;
verlet.point_add(_p1);
verlet.point_add(_p2);
_p4.oldx+=1;
verlet.point_add(_p3);
verlet.point_add(_p4);
//_p2.x++;

verlet.stick_add(_p1, _p2);
verlet.stick_add(_p2, _p3);
verlet.stick_add(_p3, _p4);
verlet.stick_add(_p4, _p1);
verlet.stick_add(_p1, _p3).visible = false;
verlet.stick_add(_p2, _p4).visible = false;

var _p1 = new verlet_create_2d(_min,_min);
var _p2 = new verlet_create_2d(_max,_min);
var _p3 = new verlet_create_2d(_max,_max);
var _p4 = new verlet_create_2d(_min,_max);
//_p2.oldx-;
verlet.point_add(_p1);
verlet.point_add(_p2);
_p4.oldx+=15;
verlet.point_add(_p3);
verlet.point_add(_p4);
//_p2.x++;

verlet.stick_add(_p1, _p2);
verlet.stick_add(_p2, _p3);
verlet.stick_add(_p3, _p4);
verlet.stick_add(_p4, _p1);
verlet.stick_add(_p1, _p3).visible = false;
verlet.stick_add(_p2, _p4).visible = false;
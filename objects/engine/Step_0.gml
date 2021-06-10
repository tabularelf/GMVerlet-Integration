/// @description Insert description here
// You can write your code in this editor
verlet.step();

if !(paused) {
	p2.x += cos(current_time/1000)*5;
	p2.y += sin(current_time/1000);	
}
if keyboard_check_released(vk_control) {verlet.useTimeSteps = !verlet.useTimeSteps;}

if (keyboard_check_released(vk_space)) {paused = !paused;}
if (keyboard_check_released(ord("R"))) {room_restart();}
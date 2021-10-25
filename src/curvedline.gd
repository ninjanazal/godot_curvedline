tool
extends Line2D;
class_name CurvedLine


#- - - - - - - - - -
# Max line subdivision val
#- - - - - - - - - -
export (int, 1, 20, 1) var max_tesselation = 5;


#- - - - - - - - - -
# Array with backed points
#- - - - - - - - - -
var _point_array : PoolVector2Array = [];


#- - - - - - - - - -
# Path2D reference
#- - - - - - - - - -
var _path2d_element : Path2D = null;

#- - - - - - - - - -
# Curve2D reference
#- - - - - - - - - -
var _curve_element : Curve2D = null;


##############################
#          PRIVATE           #
##############################


#- - - - - - - - - -
# On enter tree call
#- - - - - - - - - -
func _ready():
	if(get_children().empty()):
		_path2d_element = Path2D.new();
		self.add_child(_path2d_element);
	
		_curve_element = _path2d_element.get_curve();
		_path2d_element.set_owner(get_tree().edited_scene_root);
	else:
		_path2d_element = get_child(0);
		_curve_element = _path2d_element.get_curve();

	__on_item_rect_changed();
	
	if _curve_element.connect('changed', self, '__on_item_rect_changed') != OK:
		print('Something went wront with the signals!');


#- - - - - - - - - -
# Signal callback for the item rect changed on the path2d Object
#- - - - - - - - - -
func __on_item_rect_changed():
	_path2d_element.set_position(Vector2.ZERO);
	_path2d_element.set_scale(Vector2.ONE);
	_path2d_element.set_self_modulate(Color.transparent);

	_point_array = _curve_element.tessellate(max_tesselation);
	set_points(_point_array);

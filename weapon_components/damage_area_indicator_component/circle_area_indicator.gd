class_name CircleAreaIndicator extends BaseAreaIndicator


var radius : float 			## 圆形区域半径
var color := Color(0.862745, 0.0784314, 0.235294, 0.5)		## 指示器颜色


# [override]
func _ready():
	super._ready()
	radius = setup_params.get("radius", 5.0)


func _draw():
	draw_circle(Vector2.ZERO, radius, color)

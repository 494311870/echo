class_name CardView
extends Control

@export var is_locked: bool
@export var is_back: bool
@export var card: Card: set = _set_card
# 抖动参数：可调节数值达到不同效果
@export_group("Shake Effect")
@export var shake_strength: float = 5.0    # 抖动幅度（像素）
@export var scale_strength: float = 0.2    # 缩放抖动强度（建议0.1-0.3）
@export var shake_speed: float = 10.0      # 抖动频率（数值越大抖动越快）
@export var move_duration: float = 0.5     # 整体移动时间

@onready var _art: TextureRect = %Art
@onready var _flip_bottom: Control = %FlipBottom

var _is_dragging: bool = false
var direction: int     = 1
var _shader_material: ShaderMaterial


func _ready() -> void:
	_shader_material = _art.material


func flip() -> void:
	is_back = not is_back
	visible = not is_back


func flip_visuals() -> void:
	_art.flip_h = not _art.flip_h
	direction *= -1


func is_resolved() -> bool:
	return not card


func mark_resolved() -> void:
	var tween = create_tween()
	tween.tween_method(
		func(value: float):
			_shader_material.set_shader_parameter("hurt_intensity", value),
			1.0, 0.0, 0.2
	)
	await tween.finished
	
	_art.texture = null
	card = null
	queue_free()


func can_pass(other: CardView)-> bool:
	if is_resolved():
		return true

	return card.can_pass(other.card)


func interact(other: CardView)  -> void:
	card.view = self
	other.respond()
	other.card.interact(card)


func respond() -> void:
	card.view = self

	var tween = create_tween()
	tween.tween_method(
		func(value: float):
			_shader_material.set_shader_parameter("hurt_intensity", value),
		1.0, 0.0, 0.2
	)


func change_art(value: Texture2D) -> void:
	_art.texture = value


func _set_card(value: Card) -> void:
	card = value
	if not is_node_ready():
		await ready

	if not card:
		return
	print("set card")
	card.view = self
	_art.texture = card.art
	_flip_bottom.visible = card.flip_bottom


func _notification(what: int) -> void:

	if what == NOTIFICATION_DRAG_BEGIN:
		self.set_mouse_filter(MOUSE_FILTER_IGNORE)

	if what == NOTIFICATION_DRAG_END:
		self.set_mouse_filter(MOUSE_FILTER_STOP)
		if _is_dragging:
			_is_dragging = false
			show()


func _get_drag_data(at_position: Vector2) -> Variant:
	if is_locked:
		return null

	_is_dragging = true

	var item: Control = duplicate()
	item.position = -at_position
	item.z_index = 10

	var preview := Control.new()
	preview.add_child(item)

	hide()

	var drag_preview: Node = self.get_tree().get_first_node_in_group("drag_preview")
	if drag_preview is Control:
		drag_preview.set_drag_preview(preview)
	else:
		set_drag_preview(preview)

	return {"item": self, "offset": at_position}


func move_to(target_pos: Vector2) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_pos, move_duration)


func move_with_shake(target_pos: Vector2) -> void:
	self.pivot_offset = self.size / 2

	var tween     = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var start_pos = global_position

	# 添加抖动动画（并行）
	tween.parallel().tween_method(
		_apply_shake_effect.bind(start_pos, target_pos),
		0.0,
		1.0,
		move_duration
	)
	tween.chain().tween_property(self, "rotation_degrees", 0.0, 0.2)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.2)
	tween.parallel().tween_property(self, "global_position", target_pos, 0.2)

	await tween.finished


# 抖动效果核心逻辑
func _apply_shake_effect(progress: float, start: Vector2, end: Vector2) -> void:
	# 基础位置计算
	var base_pos = start.lerp(end, progress)

	# 位置抖动（正弦波 + 随机数）
	var time      = progress * move_duration
	var pos_shake = Vector2(
						sin(time * shake_speed * TAU) * shake_strength * randf(),
						cos(time * shake_speed * TAU) * shake_strength * randf()
					)
	global_position = base_pos + pos_shake

	# 缩放抖动（使用绝对值的正弦波）
	var scale_factor = 1.0 + abs(sin(time * shake_speed * 3)) * scale_strength
	scale = Vector2.ONE * scale_factor

	# 可选：添加旋转抖动
	rotation_degrees = sin(time * shake_speed * 2) * 5.0 * randf()

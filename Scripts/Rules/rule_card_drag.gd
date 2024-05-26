extends Resource
class_name RuleCardDrag

@export_enum(
	"any",
	"same",
	"different",
	"same_color",
	"different_colors",
	"opposite_colors",
	) var _can_drag_pile_suit_rule

@export_enum(
	"any",
	"ascending",
	"descending",
	) var _can_drag_pile_rank_rule

func can_drag(cards : Array) -> bool:
	var rank_rule_met = false
	var suit_rule_met = false
	return rank_rule_met and suit_rule_met

func _is_suit_rule_met(cards : Array) -> bool:
	return false

func _is_rank_rule_met(cards : Array) -> bool:
	return false

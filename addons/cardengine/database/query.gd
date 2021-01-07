tool
class_name Query
extends Reference
# Statements works this way:
#   - Each items of the Array is interpreted as a OR
#   - Within each item comma separated values are interpreted as AND

var _from_stmt: Array = []
var _where_stmt: Array = []
var _contains_stmt: Array = []

func clear() -> Query:
	_from_stmt.clear()
	_where_stmt.clear()
	_contains_stmt.clear()
	return self


# Restriction on categories
# Accepts wildcards * for string and ? for single char
# Example: ["class:armor,type:shield_*", "class:creature"]
#          Cards must be of "class" "armor" and of "type" starting with "shield_"
#          or of "class" "creature"
func from(statements: Array) -> Query:
	for statement in statements:
		var compiled = []
		var expressions = statement.split(",", false)
		for expression in expressions:
			compiled.append(_expr_to_from(expression))

		_from_stmt.append(compiled)
	return self


# Restriction on values
# Example: ["damage > 10,damage <= 20", "shield < 5"]
#          Cards must have damage value strictly superior to 11 and
#          inferior or equal to 20, or shield value strictly inferior to 5
func where(statements: Array) -> Query:
	for statement in statements:
		var compiled = []
		var expressions = statement.split(",", false)
		for expression in expressions:
			var comparison = _expr_to_comp(expression)
			if comparison.empty(): continue
			compiled.append(comparison)

		_where_stmt.append(compiled)
	return self


# Restriction on texts (case insensitive)
# Example: ["title:sword", "body:draw"]
#          Cards must have "sword" in the "title" or "draw" in the "body"
func contains(statements: Array) -> Query:
	for statement in statements:
		var compiled = []
		var expressions = statement.split(",", false)
		for expression in expressions:
			compiled.append(_expr_to_contains(expression))

		_contains_stmt.append(compiled)
	return self


# Executes the query on the give database
# Returns an Array of ids matching the query
func execute(db: CardDatabase) -> Array:
	var result := Array()

	for id in db.cards():
		if match_card(db.get_card(id)):
			result.append(id)

	return result


func match_card(card: CardData) -> bool:
	var from_result = true
	var where_result = true
	var contains_result = true

	if !_from_stmt.empty():
		from_result = _match_categs(card)

	if !_where_stmt.empty():
		where_result = _match_values(card)

	if !_contains_stmt.empty():
		contains_result = _match_texts(card)

	return from_result and where_result and contains_result


func _match_categs(card: CardData) -> bool:
	var or_result = false

	for or_stmt in _from_stmt:
		var and_result = true
		for and_stmt in or_stmt:
			and_result = and_result and card.match_category(and_stmt[0], and_stmt[1])

		or_result = or_result or and_result

	return or_result


func _match_values(card: CardData) -> bool:
	var or_result = false

	for or_stmt in _where_stmt:
		var and_result = true
		for and_stmt in or_stmt:
			if !card.has_value(and_stmt[0]):
				return false

			var card_val = card.get_value(and_stmt[0])

			match and_stmt[1]:
				OP_EQUAL:
					and_result = and_result and card_val == and_stmt[2]
				OP_LESS_EQUAL:
					and_result = and_result and card_val <= and_stmt[2]
				OP_LESS:
					and_result = and_result and card_val  < and_stmt[2]
				OP_GREATER_EQUAL:
					and_result = and_result and card_val >= and_stmt[2]
				OP_GREATER:
					and_result = and_result and card_val  > and_stmt[2]

		or_result = or_result or and_result

	return or_result


func _match_texts(card: CardData) -> bool:
	var or_result = false

	for or_stmt in _contains_stmt:
		var and_result = true
		for and_stmt in or_stmt:
			if !card.has_text(and_stmt[0]):
				return false

			and_result = and_result and card.get_text(and_stmt[0]).to_lower().find(and_stmt[1]) != -1

		or_result = or_result or and_result

	return or_result


func _expr_to_from(input: String) -> Array:
	var result: Array = []

	var operands = input.split(":", false)
	if operands.size() != 2:
		printerr("'%s' is not a valid from expression" % input)
		return []

	result.append(operands[0].strip_edges())
	result.append(operands[1].strip_edges())

	return result


func _expr_to_comp(input: String) -> Array:
	var result: Array = []

	var operands = input.split(" ", false)
	if operands.size() != 3:
		printerr("'%s' is not a valid comparison expression" % input)
		return []

	result.append(operands[0].strip_edges())

	match operands[1].strip_edges():
		"=":
			result.append(OP_EQUAL)
		"<=":
			result.append(OP_LESS_EQUAL)
		"<":
			result.append(OP_LESS)
		">=":
			result.append(OP_GREATER_EQUAL)
		">":
			result.append(OP_GREATER)

	result.append(int(operands[2].strip_edges()))

	return result


func _expr_to_contains(input: String) -> Array:
	var result: Array = []

	var operands = input.split(":", false)
	if operands.size() != 2:
		printerr("'%s' is not a valid contains expression" % input)
		return []

	result.append(operands[0].strip_edges())
	result.append(operands[1].strip_edges().to_lower())

	return result

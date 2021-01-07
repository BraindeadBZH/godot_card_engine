class_name PseudoRng
extends Reference
# Implements the Mersenne Twister algorithm (adapted from Python)
# It allows to have multiple self-contained pseudo-random generator
# running at the same time independently

var index = 624
var mt = []


func _init():
	mt.resize(624)
	randomize()
	set_seed(randi())


func set_string_seed(str_seed: String) -> void:
	set_seed(hash(str_seed))


func set_seed(random_seed: int) -> void:
	mt[0] = random_seed

	for i in range(1, 624):
		mt[i] = _int32(1812433253 * (mt[i - 1] ^ mt[i - 1] >> 30) + i)


func generate() -> int:
	if index >= 624:
		_twist()

	var y = mt[index]

	# Right shift by 11 bits
	y = y ^ y >> 11
	# Shift y left by 7 and take the bitwise and of 2636928640
	y = y ^ y << 7 & 2636928640
	# Shift y left by 15 and take the bitwise and of y and 4022730752
	y = y ^ y << 15 & 4022730752
	# Right shift by 18 bits
	y = y ^ y >> 18

	index = index + 1

	return _int32(y)


func randomi() -> int:
	return generate()


func randomf() -> float:
	return float(generate())/float(0xffffffff)


func random_range(from: int, to: int) -> int:
	return int(round(randomf() * (to-from)+from))


func randomf_range(from: float, to: float) -> float:
	return randomf() * (to-from)+from


func random_vec2_range(from: Vector2, to: Vector2) -> Vector2:
	return Vector2(randomf_range(from.x, to.x), randomf_range(from.y, to.y))


func _twist() -> void:
	for i in range(624):
		# Get the most significant bit and add it to the less significant
		# bits of the next number
		var y = _int32((mt[i] & 0x80000000) + (mt[(i + 1) % 624] & 0x7fffffff))
		mt[i] = mt[(i + 397) % 624] ^ y >> 1

		if y % 2 != 0:
			mt[i] = mt[i] ^ 0x9908b0df
	index = 0


func _int32(x) -> int:
	# Get the 32 least significant bits.
	return int(0xffffffff & x)

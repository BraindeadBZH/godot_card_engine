# CardRng class - Implements the Mersenne Twister algorithm (adapted from Python)
# It allows to have multiple self-contained generator running at the same time independently
extends Reference

var index = 624
var mt = []

# Initializes the RNG with a random seed
func _init():
	mt.resize(624)
	randomize()
	set_seed(randi())

# Changes the seed used to generate pseudo-random numbers
func set_seed(random_seed):
	mt[0] = random_seed
	
	for i in range(1, 624):
		mt[i] = _int32(1812433253 * (mt[i - 1] ^ mt[i - 1] >> 30) + i)

# Generates a pseudo-random number
func generate():
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

# Generates a pseudo-random integer
func randomi():
	return generate()

# Generates a pseudo-random float between 0 and 1
func randomf():
	return float(generate())/float(0xffffffff)

func _twist():
	for i in range(624):
		# Get the most significant bit and add it to the less significant
		# bits of the next number
		var y = _int32((mt[i] & 0x80000000) + (mt[(i + 1) % 624] & 0x7fffffff))
		mt[i] = mt[(i + 397) % 624] ^ y >> 1
		
		if y % 2 != 0:
		    mt[i] = mt[i] ^ 0x9908b0df
	index = 0

func _int32(x):
    # Get the 32 least significant bits.
    return int(0xFFFFFFFF & x)


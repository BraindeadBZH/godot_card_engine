tool
extends Resource
class_name Query

# Statements works this way:
#   - Each items of the Array is interpreted as a OR
#   - Within each item comma separated values are interpreted as AND

# Restriction on categories
# Accepts wildcards * for string and ? for single char
# Example: ["knight,armor_*", "soldier,shield_*"]
#          Cards have to have categories 'knight' and starting with 'armor_' or
#          'soldier' and starting with 'shield'
func from(statement: Array) -> Query:
	return self

# Restriction on values
# Example: ["damage > 10,damage <= 20", "shield < 5"]
#          Cards have to have damage value strictly superior to 11 and 
#          inferior or equal to 20, or shield value strictly inferior to 5 
func where(statement: Array) -> Query:
	return self

# Restriction on texts (case insensitive)
# Example: ["title:sword", "body:draw"]
#          Cards have to have sword in the title or draw in the body
func contains(statement: Array) -> Query:
	return self

func _match(card: CardData) -> bool:
	return false

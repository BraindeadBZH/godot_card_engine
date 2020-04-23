tool
extends AbstractManager
class_name GeneralManager

func validate_form(form_name: String, form: Dictionary) -> Array:
	var errors = []
	
	if form_name == "generic_confirm":
		if !form["confirm"]:
			errors.append("Please confirm first")
	
	return errors

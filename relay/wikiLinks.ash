//Wiki Links v1.1
//By IceColdFever, modified by Bale

// This is meant to be imported by: desc_effects, desc_familiar, desc_item, desc_outfit, desc_skill

// When an effect and skill have same name, need to differentiate. Effect has more useful information.
boolean checkEffect(string name, string check) {
	switch(check) {
	case "effect":
		if(name.to_effect().to_skill().to_string() == name)
			return true;
	case "skill":
		if(name.to_skill().to_effect().to_string() == name)
			return true;
	}
	return false;
}

void addLink(buffer results, int start, int end, string name) {
	name = replace_string(name, " ", "_");
	results.insert(end, "</a>");
	results.insert(start, "<a href=javascript:window.open(\"http://kol.coldfront.net/thekolwiki/index.php/"+name+"\");window.close()>");
}

buffer wikiLink(buffer results, string check) {
	int start = index_of(results, "<b>");
	int end = index_of(results, "</b>");
	if(start < 0 || end < 0) // Generally this happens when the session lapses
		return results;
	string name = substring(results, start+3,end);
	
	if(name == "Blood Sugar Sauce Magic") {
		if(check == "skill")
			name += " (skill)";
		else if(my_class() == $class[Sauceror])
			name += " (Sauceror)";
		else name += " (Offclass)";
	} else if(checkEffect(name, check))
		name += " (effect)";
	
	results.addLink(start, end + 4, name);
	return results;
}

buffer wikiLink(buffer results) {
	return results.wikiLink("");
}
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
	name = replace_string(name, "&quot;", "%5C%22"); // Transforms " into /" because otherwise it inteferes with the javascript to close the window.
	results.insert(end, "</a>");
	results.insert(start, '<a href=javascript:window.open("http://kol.coldfront.net/thekolwiki/index.php/'+name+'");window.close()>');
}

void effect_desc(buffer results) {
	// <br>Effect: <b><a class=nounder href="desc_effect.php?whicheffect=181bf7f091c34f97fa316ac3e5e8ce09" >Oiled-Up</a></b><br>
	matcher potion = create_matcher('<br>Effect: <b><[^>]+>(.+?)</a></b><br>', results);
	if(potion.find()) {
		string mod = string_modifier(potion.group(1), "Evaluated Modifiers");
		if(length(mod) > 0)
			results.insert(potion.end(0), "<div style='margin-left:15px; "
				+ (create_matcher("<blockquote>.+?<p>.+?</blockquote>", results).find()? "margin-top: -12px; ": "")  // This compensates for KoL's bad HTML. Urgh!
				+ "color:blue'>"+ replace_string(mod, ",", "<br>") +"</div>");
	}
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
	results.effect_desc();
	return results;
}

buffer wikiLink(buffer results) {
	return results.wikiLink("");
}
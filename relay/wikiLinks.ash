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

string extraMods(string eff) {
	switch(eff) {
	case "Purr of the Feline": return "Makes Ed's Servants Stronger";
	case "Shield of the Pastalord": return "Reduces physical damage taken by " +(my_class() == $class[Pastamancer]? "30%": "10%");
	}
	return "";
}

void effect_desc(buffer results) {
	// <br>Effect: <b><a class=nounder href="desc_effect.php?whicheffect=181bf7f091c34f97fa316ac3e5e8ce09" >Oiled-Up</a></b><br>
	matcher potion = create_matcher('(?:<br>|<p><Center>Gives )Effect: <b><[^>]+>(.+?)</a></b>', results);
	if(potion.find()) {
		string mod = string_modifier(potion.group(1), "Evaluated Modifiers");
		if(length(mod) == 0) mod = extraMods(potion.group(1));
		if(length(mod) > 0) {
			// Do a little formatting to mod before inserting it into the desc
			buffer eff;
			eff.append("<br><p style='font-size:89%; color:#5858FA; font-weight:bold; text-align:center; border:solid 1px DarkBlue; display:inline-block; padding:3px; margin-left:15px; margin-bottom:2px; ");
			if(create_matcher("<blockquote>.+?<p>(?!<center><b><font color=blue>).+?</blockquote>", results).find())
				eff.append("margin-top: -10px'>");   // This compensates for KoL's bad HTML. Urgh!
			else eff.append("margin-top: 2px'>");
			matcher parse;
			foreach x,s in mod.split_string(", ") {
				if(x > 0)
					eff.append("<br>");
				if(s.contains_text("+") || s.contains_text("-"))
					s = s.replace_string(":", "");
				parse = create_matcher("(Drop|Initiative|Percent):? .?\\d+", s);
				if(parse.find()) {
					if(parse.group(1) == "Percent")
						eff.append(s.replace_string(" Percent", ""));
					else
						eff.append(s);
					eff.append("%");
				} else
					eff.append(s);
			}
			eff.append("</p>");
			results.insert(potion.end(0), eff);
		}
	}
}

// Was being messed up by the tags in ectoplasm <i>au jus</i>
string strip_tags(string name) {
	matcher tags = create_matcher("(?i)<([A-Z][A-Z0-9]*)\\b[^>]*>(.*?)</\\1>", name);
	if(tags.find())
		name = tags.replace_all(tags.group(2));
	return name.entity_encode();
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
	
	results.addLink(start, end + 4, strip_tags(name));
	results.effect_desc();
	return results;
}

buffer wikiLink(buffer results) {
	return results.wikiLink("");
}
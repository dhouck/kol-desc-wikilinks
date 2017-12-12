//Wiki Links v1.1
//By IceColdFever, modified by Bale

import "wikiLinks.ash";

boolean is_absorbable(item it) {
	if($items[interesting clod of dirt, dirty bottlecap, discarded button] contains it) return true;
	return (it.gift || it.tradeable) && it.discardable; #  && !it.quest
}

// Add absorption skill learned for Gelatinous Noob ascensions.
buffer Gelatinous(buffer results) {
	if(my_path() == "Gelatinous Noob") {
		int start = index_of(results, ");'><b>");
		int end = index_of(results, "</b></u></a></center>");
		if(start > 0 && end > 0) {
			item it = to_item(substring(results, start + 7, end));
			if(is_absorbable(it) && (start = index_of(results, "</blockquote>")) > 0) {
				if($slots[none, familiar] contains to_slot(it)) {
					# skill noob = to_skill(to_int(it.descid) % 125 + 23001);
					skill noob = it.noob_skill;  // formula doesn't work for all items, specifically Robortender drops
					buffer desc;
					if(have_skill(noob))
						desc.append('<s>');
					desc.append('<p>Absorption: <b><a class=nounder href="desc_skill.php?whichskill=');
					desc.append(to_int(noob));
					desc.append('">');
					desc.append(noob);
					desc.append('</a></b><br /><span style="display: block; font-weight: bold;text-align: center;color:blue">');
					desc.append(string_modifier(noob,"Evaluated Modifiers"));
					desc.append('</span>');
					if(have_skill(noob))
						desc.append('</s>');
					desc.append('<br />');
					results.insert(start, desc);
				} else
					results.insert(start, '<p>Absorption: <b>No skill</b><br />');
			}
		}
	}
	return results;
}

// Pantogram Pants have a procedurally generated name, so need to set wiki page manually.
buffer pantogram(buffer results) {
	if(results.contains_text("<blockquote>These pants were summoned from the pits of hell")) {
		matcher pants = create_matcher("index\.php/[^\"]+", results);
		if(pants.find())
			return results.replace_string(pants.group(0), "index.php/Pantogram_pants");
	}
	return results;
}

void main()
{
	visit_url().wikiLink().Gelatinous().pantogram().write();
}
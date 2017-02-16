//Wiki Links v1.1
//By IceColdFever, modified by Bale

import "wikiLinks.ash";

boolean is_absorbable(item it) {
    return it.gift || (it.tradeable && it.discardable && !it.quest);
}

buffer Gelatinous(buffer results) {
	if(my_path() == "Gelatinous Noob") {
		int start = index_of(results, ");'><b>");
		int end = index_of(results, "</b></u></a></center>");
		if(start > 0 && end > 0) {
			item it = to_item(substring(results, start + 7, end));
			if(is_absorbable(it) && (start = index_of(results, "</blockquote>")) > 0) {
				skill noob = to_skill(to_int(it.descid) % 125 + 23001);
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
			}
		}
	}
	return results;
}

void main()
{
	visit_url().wikiLink().Gelatinous().write();
}
//Wiki Links v1.1
//By IceColdFever, modified by Bale

import "wikiLinks.ash";

boolean is_pvpable(item it) {
    return it.tradeable && it.discardable && !it.gift && !it.quest;
}

buffer Gelatinous(buffer results) {
	if(my_path() == "Gelatinous Noob") {
		int start = index_of(results, ");><b>");
		int end = index_of(results, "</b></a></center>");
		if(start > 0 && end > 0) {
			item it = to_item(substring(results, start + 6, end));
			if(is_pvpable(it) && (start = index_of(results, "</blockquote>")) > 0) {
				skill noob = to_skill(to_int(it.descid) % 125 + 23001);
				results.insert(start, "<p>Absorption: <b>" +noob+ '</b><br /><span style="display: block; font-weight: bold;text-align: center;color:blue">'
					+string_modifier(noob,"Evaluated Modifiers")+ "</span><br />");
			}
		}
	}
	return results;
}

void main()
{
	visit_url().wikiLink().Gelatinous().write();
}
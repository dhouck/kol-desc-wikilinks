//Wiki Links v1.1
//By IceColdFever, modified by Bale

import "wikiLinks.ash";

buffer wikiThrall(buffer results) {
	matcher thrall = create_matcher("<b>[^\\d]+\\d+ +([^<]+)", results);
	if(thrall.find())
		results.addLink(thrall.start(1), thrall.end(1), thrall.group(1));
	return results;
}

void main()
{
	visit_url().wikiThrall().write();
}
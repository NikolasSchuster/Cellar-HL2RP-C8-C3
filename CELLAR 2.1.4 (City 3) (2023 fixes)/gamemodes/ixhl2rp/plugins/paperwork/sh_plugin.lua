local PLUGIN = PLUGIN

PLUGIN.name = "Paperwork"
PLUGIN.description = "Adds a SS13 Paperwork."
PLUGIN.author = "SchwarzKruppzo"

PLUGIN.maxTitleLength = 128
PLUGIN.maxLength = 10000
PLUGIN.BBCodes = {
	[1] = {
		id = "[b]",
		hint = "pwB",
		find = {"[b]", "[/b]"},
		replace = {"<b>", "</b>"},
		format = "[b]$&[/b]"
	},
	[2] = {
		id = "[i]",
		hint = "pwI",
		find = {"[i]", "[/i]"},
		replace = {"<i>", "</i>"},
		format = "[i]$&[/i]"
	},
	[3] = {
		id = "[u]",
		hint = "pwU",
		find = {"[u]", "[/u]"},
		replace = {"<u>", "</u>"},
		format = "[u]$&[/u]"
	},
	[4] = {
		id = "[large]",
		hint = "pwLarge",
		find = {"[large]", "[/large]"},
		replace = {"<span class=\"large\">", "</span>"},
		format = "[large]$&[/large]"
	},
	[5] = {
		id = "[big]",
		hint = "pwBig",
		find = {"[big]", "[/big]"},
		replace = {"<span class=\"big\">", "</span>"},
		format = "[big]$&[/big]"
	},
	[6] = {
		id = "[small]",
		hint = "pwSmall",
		find = {"[small]", "[/small]"},
		replace = {"<span class=\"small\">", "</span>"},
		format = "[small]$&[/small]"
	},
	[7] = {
		id = "[center]",
		hint = "pwCenter",
		find = {"[center]", "[/center]"},
		replace = {"<center>", "</center>"},
		format = "[center]$&[/center]"
	},
	[8] = {
		id = "[right]",
		hint = "pwRight",
		find = {"[right]", "[/right]"},
		replace = {"<right>", "</right>"},
		format = "[right]$&[/right]"
	},
	[9] = {
		id = "[list]",
		hint = "pwList",
		find = {"[list]", "[/list]"},
		replace = {"<ul type=\"square\">", "</ul>"},
		format = "[list]$&[/list]"
	},
	[10] = {
		id = "[*]",
		hint = "pwListEntry",
		find = {"[*]"},
		replace = {"<li>"},
		format = "[*]"
	},
	[11] = {
		id = "[hr]",
		hint = "pwHR",
		find = {"[hr]"},
		replace = {"<hr>"},
		format = "[hr]"
	},
	[12] = {
		id = "[br]",
		hint = "pwBR",
		find = {"[br]"},	
		replace = {"<br>"},
		format = "[br]"
	},
	[13] = {
		id = "[blue]",
		hint = "pwBlue",
		find = {"[blue]", "[/blue]"},
		replace = {"<div class=\"blue\">", "</div>"},
		format = "[blue]$&[/blue]"
	},
	[14] = {
		id = "[red]",
		hint = "pwRed",
		find = {"[red]", "[/red]"},
		replace = {"<div class=\"red\">", "</div>"},
		format = "[red]$&[/red]"
	},
	[15] = {
		id = "[green]",
		hint = "pwGreen",
		find = {"[green]", "[/green]"},
		replace = {"<div class=\"green\">", "</div>"},
		format = "[green]$&[/green]"
	},
	[16] = {
		id = "[sign]",
		hint = "pwSign",
		find = false,
		replace = false,
		format = "[sign]"
	},
	[17] = {
		id = "[field]",
		hint = "pwField",
		find = false,
		replace = false,
		format = "[field]"
	}
}

ix.util.Include("libs/thirdparty/cl_gxml.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
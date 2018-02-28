keys = {
	:backspace		=>	"\u232B",
	:delete			=>	"\u2326",
	:leftArrow		=>	"\u2190",
	:rightArrow		=>	"\u2192",
	:return			=>	"\u23CE",
	:control		=>	"\u2303"
}

@strings = {
	:output =>	{
		:separator	=>	"\u2012",
		:smileys	=>	{
			:indifferent	=>	':/',
			:happy			=>	':)',
			:sad			=>	':('
		},
		:wpm	=>		'WPM',
		:inTime		=>	'in'
	},
	:help	=>	{
		:banner		=>	"Usage: #{@typeskill} [options] file",
		:colored	=>	"Don't use colored output",
		:backspace	=>	"Block #{keys[:backspace]} backspace (use #{keys[:control]}H instead)",
		:delete		=>	"Block #{keys[:delete]} delete (use #{keys[:control]}D instead)",
		:arrows		=>	"Block #{keys[:leftArrow]}/#{keys[:rightArrow]} arrows (use #{keys[:control]}B/#{keys[:control]}F instead)",
		:return		=>	"Block #{keys[:return]} return (use #{keys[:control]}J instead)",
		:shortcuts	=>	'Show available shortcuts',
		:help		=>	'Show this message',
		:version	=>	'Show version',
		:about		=>	'Show about message',
		:changelog	=>	'Show changelog'
	},
	:shortcuts		=>	"\u2303C		Interrupt program execution\n"\
						"\u2303A		Go to the beginning of line\n"\
						"\u2303E		Go to the end of line\n"\
						"\u2303T		Swap 2 characters\n"\
						"\u2303K		Delete text after the insertion point\n"\
						"\u2303H or \u232B		Backspace\n"\
						"\u2303D or \u2326		Delete\n"\
						"\u2303F or \u2192		Go 1 character forwards\n"\
						"\u2303B or \u2190		Go 1 character backwards\n"\
						"\u2303J or \u23CE		Complete line",
	:about			=>	"TypeSkill #{@version}\n"\
						"Grind experience in typing skill line!\n"\
						"https://github.com/MOPO3OB/TypeSkill",
	:changelog		=>	"1.0.0 (27.02.18) - Initial release",
	:error	=>	{
		:head		=>	"Error",
		:body		=>	"Use #{@typeskill} --help\n"\
						"If you think this is a bug, please report here:\n"\
						"https://github.com/MOPO3OB/TypeSkill/issues",
		:messages	=>	[
						"unknown os: $clarification$",
						"invalid option: \"$clarification$\"",
						"no file specified",
						"file \"$clarification$\" does not exist",
						"\"$clarification$\" is not a file",
						"file \"$clarification$\" is not readable",
						"file \"$clarification$\" is empty"
		]	
	}
}
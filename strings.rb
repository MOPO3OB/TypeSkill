using HashRecursive

def loadStrings(category=:*)
	strings = {
		:keys	=>	{
			:backspace	=>	{
				:name	=>	"backspace",
				:token	=>	"\u232B"
			},
			:delete		=>	{
				:name	=>	"delete",
				:token	=>	"\u2326"
			},
			:leftArrow	=>	{
				:name	=>	"left arrow",
				:token	=>	"\u2190"
			},
			:rightArrow	=>	{
				:name	=>	"right arrow",
				:token	=>	"\u2192"
			},
			:return		=>	{
				:name	=>	"enter",
				:token	=>	"\u23CE"
			},
			:control	=>	{
				:name	=>	"control",
				:token	=>	"\u2303"
			}
		},
		:output	=>	{
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
			:backspace	=>	"Block $key_backspace$ (use $key_control_H$ instead)",
			:delete		=>	"Block $key_delete$ (use $key_control_D$ instead)",
			:arrows		=>	"Block $key_leftArrow$/$key_rightArrow$ (use $key_control_B$/$key_control_F$ instead)",
			:return		=>	"Block $key_return$ (use $key_control_J$ instead)",
			:shortcuts	=>	'Show available shortcuts',
			:help		=>	'Show this message',
			:version	=>	'Show version',
			:about		=>	'Show about message',
			:changelog	=>	'Show changelog'
		},
		:shortcuts		=>	"$key_control_C$			Interrupt program execution\n"\
							"$key_control_A$			Move cursor to the beginning of line\n"\
							"$key_control_E$			Move cursor to the end of line\n"\
							"$key_control_T$			Transpose 2 characters\n"\
							"$key_control_K$			Delete text after the insertion point\n"\
							"$key_control_H$ or $key_backspace$	Backspace\n"\
							"$key_control_D$ or $key_delete$		Delete\n"\
							"$key_control_F$ or $key_rightArrow$	Move cursor 1 character forwards\n"\
							"$key_control_B$ or $key_leftArrow$	Move cursor 1 character backwards\n"\
							"$key_control_J$ or $key_return$		Complete line",
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
							'unknown os: $clarification$',
							'invalid option: $clarification$',
							'no file specified',
							'file $clarification$ does not exist',
							'$clarification$ is not a file',
							'file $clarification$ is not readable',
							'file $clarification$ is empty',
							'neither msvcrt nor crtdll is available',
							'failed to determine Windows version',
							'unknown Windows version: $clarification$'
			]
		},
		:OSspecific	=> {
			:macos		=>	{
				:keys		=>	{
					:return		=>	{
						:name	=>	"return"
					}
				}
			},
			:windows	=>	{
				:output		=>	{
					:separator	=>	"\u2500"
				}
			}
		}
	}
	
	@strings ||= {}

	if category == :*
		strings.each do |key, value|
			if key != :OSspecific
				@strings[key] = value
			elsif ![@os, value[@os]].include?(nil)
				strings[key][@os].each do |keyOSspecific, valueOSspecific|
					@strings[keyOSspecific].merge!(valueOSspecific, recursive=true)
				end
			end
		end
	else
		@strings[category] = strings[category]
		if ![@os, strings[:OSspecific][@os]].include?(nil)
			strings[:OSspecific][@os].each do |keyOSspecific, valueOSspecific|
				@strings[keyOSspecific].merge!(valueOSspecific, recursive=true) if category == keyOSspecific
			end
		end
	end
	if @strings[:keys] != nil
		block = Proc.new { |string|
			string.gsub(/\$key(_[^_$]{1,}){1,}\$/) {
				|key|
				key.gsub!(/_[^_$]{1,}/) {
					|key|
					key = key[1..-1]
					if @strings[:keys][key.to_sym] != nil
						'-'+@strings[:keys][key.to_sym][:name]
					else
						'-'+key.upcase
					end
				}
				'['+key[5..-2]+']'
			}
		}
		@strings.each(recursive=true) do |keychain, value|
			if [:*, :keys, keychain[0]].include?(category)
				if value.is_a?(String)
					@strings[keychain, recursive=true] = block.call(@strings[keychain, recursive=true])
				elsif value.is_a?(Array)
					@strings[keychain, recursive=true].each_with_index do |value, index|
						@strings[keychain, recursive=true][index] = block.call(@strings[keychain, recursive=true][index])
					end
				end
			end
		end
	end
end
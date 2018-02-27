def readChar
	STDIN.echo = false
	STDIN.raw!

	input = STDIN.getc.chr
	if input == "\e" then
		input << STDIN.read_nonblock(3) rescue nil
		input << STDIN.read_nonblock(2) rescue nil
	end
ensure
	STDIN.echo = true
	STDIN.cooked!

	return input
end

def userInput(width, blockBackspace, blockDelete, blockArrows, blockOption, blockReturn)
	input = ""											# 0..width
	cursor = 1											# 1 - left, width+1 - right
	print "\e[?25h"
	interrupted = false
	while true
		char = readChar

		case char
		when "\t"										# Blocks tab
		when "\u0003"									# ⌃C
			interrupted = true
			break
		when "\u0001"									# ⌃A
			cursor = 1
		when "\u0005"									# ⌃E
			cursor = input.length + 1
		when "\u0014"									# ⌃T
			if cursor > 1
				if cursor == input.length + 1
					temp = input[cursor-3]
					input[cursor-3] = input[cursor-2]
					input[cursor-2] = temp
				elsif cursor <= input.length
					temp = input[cursor-2]
					input[cursor-2] = input[cursor-1]
					input[cursor-1] = temp
					cursor = cursor + 1
				end
			end
		when "\v"										# ⌃K
			input.slice!(cursor-1..input.length)
		when "\b"										# ⌃H
			if cursor > 1
				input.slice!(cursor-2)
				cursor = cursor - 1
			end
		when "\177"										# Backspace
			if !blockBackspace and cursor > 1
				input.slice!(cursor-2)
				cursor = cursor - 1
			end
		when "\004"										# ⌃D
			if cursor <= input.length
				input.slice!(cursor-1)
			end
		when "\e[3~"									# Delete
			if !blockDelete and cursor <= input.length
				input.slice!(cursor-1)
			end
		when "\u0002"									# ⌃B
			if cursor > 1
				cursor = cursor - 1
			end
		when "\e[D"										# Left arrow
			if !blockArrows and cursor > 1
				cursor = cursor - 1
			end
		when "\u0006"									# ⌃F
			if cursor < input.length + 1
				cursor = cursor + 1
			end
		when "\e[C"										# Right arrow
			if !blockArrows and cursor < input.length + 1
				cursor = cursor + 1
			end
		when "\n"										# ⌃J
			break
		when "\r"										# Return
			if !blockReturn
				break
			end
		# when "\eb"										# ⌥←
		# 	if cursor > 1
		# 		if input[cursor-2] == ' '
		# 			temp = input[0..cursor-3].rindex(" ")
		# 		else
		# 			temp = input[0..cursor-2].rindex(" ")
		# 		end
		# 		if temp == nil
		# 			cursor = 1
		# 		else
		# 			cursor = temp + 2
		# 		end
		# 	end
		when /^.$/
			if input.length < width and char.ord > 31
				input.insert(cursor-1, char)
				cursor = cursor + 1
			end
		end

		print "\e[2K"
		print "\e[G"
		print "#{input}"

		if cursor == width+1
			print "\e[?25l"
		else
			print "\e[?25h"
		end
		print "\e[#{cursor}G"
		
	end
	print "\e[G"
	return input, interrupted
end

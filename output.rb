class String
	def black;			"\033[30m#{self}\033[0m" end
	def red;			"\033[31m#{self}\033[0m" end
	def green;			"\033[32m#{self}\033[0m" end
	def brown;			"\033[33m#{self}\033[0m" end
	def blue;			"\033[34m#{self}\033[0m" end
	def magenta;		"\033[35m#{self}\033[0m" end
	def cyan;			"\033[36m#{self}\033[0m" end
	def gray;			"\033[37m#{self}\033[0m" end
	def blackBold;		"\033[1;30m#{self}\033[0m" end
	def redBold;		"\033[1;31m#{self}\033[0m" end
	def greenBold;		"\033[1;32m#{self}\033[0m" end
	def brownBold;		"\033[1;33m#{self}\033[0m" end
	def blueBold;		"\033[1;34m#{self}\033[0m" end
	def magentaBold;	"\033[1;35m#{self}\033[0m" end
	def cyanBold;		"\033[1;36m#{self}\033[0m" end
	def grayBold;		"\033[1;37m#{self}\033[0m" end
end

def giveLine(line, width, colored)
	print "\e[2K"
	if colored
		puts line.blue
	else
		puts line
	end
end

def statusBar(width, previous, percentageCompleted, colored)
	separator = @strings[:output][:separator]

	percentage = " #{percentageCompleted}%"
	if percentageCompleted < 10
		if colored
			percentage = separator.gray+percentage
		else
			percentage = separator+percentage
		end
	end
	if colored
		firstPart = separator*(width-7)
		lastPart = separator*2
		puts firstPart.gray+"#{percentage} "+lastPart.gray
	else
		case previous
		when "none"
			smiley = @strings[:output][:smileys][:indifferent]
		when "good"
			smiley = @strings[:output][:smileys][:happy]
		when "bad"
			smiley = @strings[:output][:smileys][:sad]
		end
		puts separator*2+" #{smiley} "+separator*(width-13)+"#{percentage} "+separator*2
	end
end

def showResults(correct, completed, total, time, wordsCompleted, colored)
	print "\e[A"
	if completed < total
		completed = "#{completed}(#{total})"
	end
	seconds = time % 60
	minutes = time / 60
	time = "#{seconds.round(2)}"
	if minutes >= 1
		time = "#{minutes.to_i}:#{time}"
	end
	results = "#{correct}/#{completed} #{@strings[:output][:inTime]} #{time}"
	wordsPerMinute = wordsCompleted/minutes
	results = results + " | #{wordsPerMinute.to_i} #{@strings[:output][:wpm]}"
	puts results
end
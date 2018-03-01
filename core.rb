require 'io/console'

require_relative 'check'
require_relative 'parser'
require_relative 'output'
require_relative 'input'

def core(file, colored, blockBackspace, blockDelete, blockArrows, blockOption, blockReturn)	
	checkFile(file)
	height, width = IO.console.winsize
	lines, wordsOnLine = parse file, width
	total = lines.length
	correct = 0
	completed = 0
	wordsCompleted = 0
	previous = 'none'
	timeStarted = Time.now.getutc
	
	lines.each_with_index do |line, index|
		giveLine line, width, colored

		percentageCompleted = completed*100/total

		statusBar width, previous, percentageCompleted, colored
		input, interrupted = userInput width, blockBackspace, blockDelete, blockArrows, blockOption, blockReturn
		if !interrupted

			completed = completed + 1
			if completed < total
				puts
			end
			if input == line
				correct = correct + 1
				previous = "good"
			else
				previous = "bad"
			end
			
			wordsCompleted = wordsCompleted + wordsOnLine[index]
			
			if completed == total
				print "\e[2A\e[2K\e[B\e[2K\e[A"
				if colored
					if previous == "good"
						print line.green
					else
						print line.red
					end
				else
					print line
				end
				print "\e[2B\e[2K\e[G"
			else
				print "\e[2A\e[2K\e[B\e[2K\e[2A"
				if colored
					if previous == "good"
						puts line.green
					else
						puts line.red
					end
				else
					puts line
				end
			end
		else
			print "\e[2K\e[A\e[2K\e[B"
			break
		end
	end
	time = Time.now.getutc - timeStarted
	showResults correct, completed, total, time, wordsCompleted, colored
	exit 0
end

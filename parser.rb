def parse(file, width)
	lines = []
	wordsTotal = 0
	File.readlines(file).each do |line|
		str = "#{line}".delete "\n"
		
		words = "#{line}".split(' ')
		for i in 0..words.length-1 do
			if words[i].length > width
				words[i] = words[i][0..width-1]
			end
		end
		wordsNumber = words.length
		wordsTotal = wordsTotal + wordsNumber
		wordsPrinted = 0
		while wordsPrinted < wordsNumber do
			symbolsOnLine = 0
			printedLine = ""
			while true and wordsPrinted < wordsNumber do
				symbolsOnLine = symbolsOnLine + words[wordsPrinted].length + " ".length
				if symbolsOnLine <= width + " ".length
					if printedLine.length > 0
						printedLine = printedLine + " " + words[wordsPrinted]
					else
						printedLine = words[wordsPrinted]
					end
					wordsPrinted = wordsPrinted + 1
				else
					printedLine = printedLine[0..symbolsOnLine-1]
					break
				end
			end
			lines.push(printedLine)
		end
	end
	return lines, wordsTotal
end
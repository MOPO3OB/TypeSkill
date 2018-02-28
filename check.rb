def checkFile(file)
	if !File.exist?(file)
		error 4, file
	elsif !File.file?(file)
		error 5, file
	elsif !File.readable?(file)
		error 6, file
	elsif File.zero?(file)
		error 7, file
	else
		return true
	end
end
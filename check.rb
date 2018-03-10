def checkFile(file)
	if !File.exist?(file)
		error 4, file.inspect
	elsif !File.file?(file)
		error 5, file.inspect
	elsif !File.readable?(file)
		error 6, file.inspect
	elsif File.zero?(file)
		error 7, file.inspect
	else
		return true
	end
end
def checkFile(file)
	if !File.exist?(file)
		error "file \"#{file}\" does not exist", 3
	elsif !File.file?(file)
		error "\"#{file}\" is not a file", 4
	elsif !File.readable?(file)
		error "file \"#{file}\" is not readable", 5
	elsif File.zero?(file)
		error "file \"#{file}\" is empty", 6
	else
		return true
	end
end
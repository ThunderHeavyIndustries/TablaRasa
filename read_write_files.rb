# Thunder Heavy Industries Dec 2014
# file IO stuff for TablaRasa
# quesitons comments complaints: thunderheavyindustries@gmail.com

require "open-uri"

class R_W

	def write_to_file file_name, content_to_write
		somefile = File.open( file_name, "w")
		somefile.puts content_to_write
		somefile.close 
		#block formation
		#File.open("sample.txt", "w"){ |somefile| somefile.puts "Hello file!"}
	end

	def remote_pull_and_write url, destination_file #url should be of the form: "http://rishiverma.com/tabla/notebook/"
		remote_data = open( url ).read
		my_local_file = File.open( destination_file, "w") 
		my_local_file.write(remote_data)
		my_local_file.close
	end

	def open_read file_name

		contents = File.open(file_name, "r"){ |file| file.read }
		return contents
	end

	def read_line_by_line file_name #should figure out how i want this all returned, array, string, what?
		
		file = File.open( file_name, 'r')

		while !file.eof?
   			line = file.readline
   			puts line
		end
	end

	def input_column_form file_name, content_to_write

		somefile = File.open( file_name, "w")
		somefile.puts "Bols Times_hit"

		content_to_write.each do |b,n|

			somefile.puts b+" "+n.to_s+"\n"
		end
		somefile.close 
	end
end



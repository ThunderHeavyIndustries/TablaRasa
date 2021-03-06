# Thunder Heavy Industries Dec 2014
# This is to analyze the tabla compositions produced by my generator, as well as the compositions
# of others.
# quesitons comments complaints: thunderheavyindustries@gmail.com
require 'graphviz'
require 'graphviz/theory'
require 'gruff'
require_relative 'read_write_files'

class Composition_analyzer

	ReadWrite= R_W.new
	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-", 19, "Na"]
	@@bi = @@bols.invert


	# Input a composition file, returns a hash with the number of times each hit appears in the composition.
	# if number_of_hits >0 then the function returns the number of hits in an array
	# if frequency_of_hits >0 then it returns the % of the composition that each hit makes up
	# if both are greater than zero it returns both the number of hits, and then frequency of those hits
	def analyze_composition composition_file, return_number_of_hits, return_frequency_of_hits 

		#/////////////////////////////////Initialize necessary items///////////////////////
		bol_count= Hash.new
		bol_freq= Hash.new
		composition = ReadWrite.open_read composition_file #opens the compositon file 
		#//////////////////////////////////////////////////////////////////////////////////

		#///////////////////////////////// Read in composition and prep for usage /////////////////////////////////////////////////
		comp_array = composition.scan(/(\-|\w+)/) #creates an array of arrays of all the hits in the sequence from the composition
		comp_array.flatten! #cleans up the array of arrays into a simple array
		total_hits= comp_array.size #for generating the frequency if a given hit
		#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		#///////////////////////////////// Calculate values for frequency, and number of hits, return desired value(s)///////////////////////////

		if return_frequency_of_hits >0
			@@bols.each do |n, b|# creates a hash with the hits, and their frequency in the composition.
				bol_freq[b] = comp_array.count(b).fdiv(total_hits)
			end
			return bol_freq

		elsif return_number_of_hits >0
			@@bols.each do |n, b|# creates a hash with the hits, and their frequency in the composition.
				bol_count[b] = comp_array.count(b)
			end
			return bol_count
		else
			puts "please specify what values you would like returned number of hits, or frequency of hits"
		end
		#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end

  	# Outputs a .png showing a directed graph of the markov values for one's chosen bol
  	# if no bol is provided, then it chooses one at random.
  	def comp_graph composition_file, output_name, bol, graph_type #bol is the desired hit you want to form a graph based on.

  		#///////////////////////////////////// Initialize and set up//////////////////////////////////////////////////////
  		if graph_type == "circular"
			g = GraphViz.new( :G, :type => :digraph, :use => "twopi", :overlap => :scale )# Create a new graph with circular output
		else 
			g = GraphViz.new( :G, :type => :digraph, :overlap => :scale)# Create a new graph
		end

		data = markov_analysis1 composition_file #pull in the markov data

		if bol.empty? # in case user doesn't pass a desired bol to analyze, this chooses one at random
			bol = @@bols[rand(19)]
		else
		end
		#///////////////////////////////////////////////////////////////////////////////////////////

		#//////////////////////////////Fill in the graph with data/////////////////////////////////////////////////////////////
		home = g.add_nodes(bol+" ") # designate the home node
		(0..18).each do|x,y| # for each bol...

			if data[bol][@@bols[x]]>0 # if othe current bol follows the analyzed bol
				y = g.add_nodes(@@bols[x],:fontsize => 10) #create node for each bol
				edge = home<<y # draw a line from home node to all the created nodes
				edge[:label => " #{data[bol][@@bols[x]]}\%", :fontsize => 12] # mark all the edges with the percentages from the markov data
			else
			end
		end
		#///////////////////////////////////////////////////////////////////////////////////////////

		g.output(:png => "#{output_name}.png" )
  	end

  	# This is the working version that can run at any depth.
  	# Returns a hash of hashes that contains the percentage of times a given bol is followed by any of the others.
	# ie: Ta is followed by Na 30% of the time, by Dha 15% of the time etc...These values are returned as floats 
  	def markov_analysis file, depth


		#/////////////////////////////////Initialize necessary items//////////////////////////////////////////////////
		bol_hash_hash= Hash["Ta"=>Hash.new, "Tin"=>Hash.new, "Tun"=>Hash.new, "Din"=>Hash.new, "Te"=>Hash.new, "Re"=>Hash.new, "Tha"=>Hash.new, "Ge"=>Hash.new, "Ka"=>Hash.new, "Dha"=>Hash.new, "Dha2"=>Hash.new, "Dha3"=>Hash.new, "Dhi"=>Hash.new, "Dhe"=>Hash.new, "Dhet"=>Hash.new, "Kre"=>Hash.new, "The"=>Hash.new, "The2"=>Hash.new, "-"=>Hash.new, "Na"=>Hash.new ]
		##///////////////////////////////////////////////////////////////////////////////////

		#///////////////////////// This pulls in the composition and puts it into an array //////////////////////////////////////////////
		composition = ReadWrite.open_read file #opens the compositon file 
		comp_array = composition.scan(/(\-|\w+)/) #creates an array of arrays of all the hits in the sequence from the composition
		comp_array.flatten! #cleans up the array of arrays into a simple array that is ordered in terms of appearance in the composition
		total_hits= comp_array.size #total number of hits
		#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		(depth..total_hits-1).each do |x| # goes through each hit in the composition
			current_hit = comp_array[x] #current hit 
			previous_hits = "" #initialize

			(x-1).downto(x-depth).each {|d| previous_hits+= comp_array[d]+" "} #create string of previous hits to depth

			bol_hash_hash[current_hit][previous_hits] = 0 #initializing a value of zero
		end

		(depth..total_hits-1).each do |x| # goes through each hit in the composition

			current_hit = comp_array[x] #current hit 
			previous_hits = "" #initializing

			(x-1).downto(x-depth).each {|d| previous_hits+= comp_array[d]+" "} #create string of previous hits to depth

			bol_hash_hash[current_hit][previous_hits]+=1.fdiv(comp_array.count(current_hit)) #adds as a percentage of total times it precedes the current hit
	
		end

		bol_hash_hash.each do |k,h| #goes through each member of the hash

			h.each do |m,n| #goes through each subhash

				bol_hash_hash[k][m] = bol_hash_hash[k][m].round(2) #truncates the value to the 100's place.
			end
		end

		return bol_hash_hash #return hash of hashes of values
  	end


	#///////////////////////////////////////////////////////////////////////////////////////////
	# This creates "output_name.png", a directed graph based on an input composition (compositon_file)
	# if you pass "true" for theory, the command line will ouput a series of graph theory analysis of the composition file
	# and graph_output_type specifies the layout for the output_name.png that is generated
 	#///////////////////////////////////////////////////////////////////////////////////////////
  	def total_composition_graph composition_file, output_name, theory, graph_output_type

  		#///////////////////////////////// initialize values /////////////////////////////////
  		graph_output_options=["circo","dot","fdp","neato","twopi"] #output formats for graph
  		data = markov_analysis1 composition_file #pull in the data from analysis of the composition
  		g = GraphViz.new( :G, :type => :digraph, :overlap => :scale, :use => graph_output_options[graph_output_type]) #create graph
  		t = GraphViz::Theory.new( g ) # call this to run graph theory functions
  		#///////////////////////////////////////////////////////////////////////////////////////////////////

			data.each do |h, k| # go through the results of the markov analysis
				
				current = g.add_node( h, :fontsize => 10 ) #create a node for each bol

				k.each do |l, m| #for each hash associated with current bol
					if m > 0
					new_node = g.add_node(l, :fontsize => 10) # create nodes for all the other bols
					edge= current<<new_node #link them together
					edge[:label => " #{m}\%", :fontsize => 10] # add the % from analysis to the edge
					else
					end
				end
			end

		if theory == true # outputs graph theory analysis of composition graph

			puts "Adjancy matrix : "
			puts t.adjancy_matrix

			puts "Symmetric ? #{t.symmetric?}"

			puts "Incidence matrix :"
			puts t.incidence_matrix

			g.each_node do |name, node|
  				puts "Degree of node `#{name}' = #{t.degree(node)}"
			end

			puts "Laplacian matrix :"
			puts t.laplacian_matrix


			print "Ranges : "
			rr = t.range
			p rr
			puts "Your graph contains circuits" if rr.include?(nil)
		else
		end

		if output_name == "no"
			puts "output_name= #{output_name}, So no graph created"
		else
			puts "graph created using #{graph_output_options[graph_output_type]} with name: #{output_name}.png"
			g.output(:png => "#{output_name}.png" )
		end
	end

	# Outputs charts based on input data, this is a work in progress.
	def charts data_array, chart_title

		#data_array should come in as a hash with bol keys.

		g = Gruff::Bar.new(1100)
		g.title = "#{chart_title}"
		g.labels = @@bols
		g.marker_font_size = 14

		puts "Creating chart"

		data_label = 0
		data_array.each do |arr|

			a =Array.new

			arr.each {|k,h| a<<h }
	
			g.data "comp_#{data_label}".to_sym, a
			data_label+=1
		end

		puts "Writing #{chart_title}"
		puts "."
		puts ".."
		g.write("#{chart_title}.png")
		puts "...done writing #{chart_title}"
	end
end






# Thunder Heavy Industries Dec 2014
# This is to analyze the tabla compositions produced by my generator, as well as the compositions
# of others.
# quesitons comments complaints: thunderheavyindustries@gmail.com
require 'graphviz'
require 'graphviz/theory'
require_relative 'read_write_files'

class Composition_analyzer

	ReadWrite= R_W.new
	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-"]
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
		if return_number_of_hits >0

			@@bols.each do |n, b|# creates a hash with the hits, and how many time they're used in the composition.
				bol_count[b] = comp_array.count(b)	
			end
			return bol_count

		elsif return_frequency_of_hits >0
			@@bols.each do |n, b|# creates a hash with the hits, and their frequency in the composition.
				bol_freq[b] = comp_array.count(b).fdiv(total_hits)
			end
			return bol_freq

		elsif return_frequency_of_hits >0 && return_number_of_hits >0

			@@bols.each do |n, b|# creates a hash with the hits, and how many time they're used in the composition.
				bol_count[b] = comp_array.count(b)	
			end

			@@bols.each do |n, b|# creates a hash with the hits, and their frequency in the composition.
				bol_freq[b] = comp_array.count(b).fdiv(total_hits)
			end

			return bol_count, bol_freq	
		else
			puts "please specify what values you would like returned number of hits, or frequency of hits"
		end
		#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end

	# Returns a hash of hashes that contains the percentage of times a given bol is followed by any of the others.
	# ie: Ta is followed by Na 30% of the time, by Dha 15% of the time etc...These values are returned as floats 
	def markov_analysis composition_file
		
		#/////////////////////////////////Initialize necessary items//////////////////////////////////////////////////
		bol_hash_hash= Hash["Ta"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tin"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tun"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Din"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Te"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Re"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tha"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Ge"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Ka"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha2"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha3"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhi"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhe"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhet"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Kre"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "The"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "The2"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "-"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}]
		##///////////////////////////////////////////////////////////////////////////////////

		#///////////////////////// This pulls in the composition and puts it into an array //////////////////////////////////////////////
		composition = ReadWrite.open_read composition_file #opens the compositon file 
		comp_array = composition.scan(/(\-|\w+)/) #creates an array of arrays of all the hits in the sequence from the composition
		comp_array.flatten! #cleans up the array of arrays into a simple array that is ordered in terms of appearance in the composition
		total_hits= comp_array.size
		#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		#////////////////////// Calculate Frequencies for each hit ///////////
			(0..comp_array.size-2).each do |x| # goes through each hit in the composition

				current_hit = comp_array[x] #current hit 
				next_hit = comp_array[x+1] #next hit 
				bol_hash_hash[current_hit][next_hit]+=1.fdiv(comp_array.count(comp_array[x])) # in the current hit hash, it updates the number of times the next hit occured and calculates the % frequency of the next hit following the current hit.
			end
		#//////////////////////////////////////////////////////////////////////////////////////////

		#/////////////////// Turns the float values into a 1..10 percent value, if you sum the percents of a given bol they don't quite add up to 100%, it's usually around .98 or 1.0000004 so it's pretty damn close, but that's floats right?
		(0..18).each do |c| #loop through first hash
			(0..18).each do |d| #loop through second hash
				bol_hash_hash[@@bols[c]][@@bols[d]] = bol_hash_hash[@@bols[c]][@@bols[d]].round(2) #truncate values, ie 0.0273342 =>0.03
			end
		end
		#///////////////////////////////////////////////////////////////////////////////////////////
		return bol_hash_hash
  	end

  	# Outputs a .png showing a directed graph of the markov values for one's chosen bol
  	# if no bol is provided, then it chooses one at random.
  	def comp_graph composition_file, output_name, bol, graph_type #bol is the desired hit you want to form a graph based on.
  		puts "clean graph output version"
  		#///////////////////////////////////// Initialize and set up//////////////////////////////////////////////////////
  		if graph_type == "circular"
			g = GraphViz.new( :G, :type => :digraph, :use => "twopi", :overlap => :scale )# Create a new graph with circular output
		else 
			g = GraphViz.new( :G, :type => :digraph, :overlap => :scale)# Create a new graph
		end

		data = markov_analysis composition_file #pull in the markov data

		if bol.empty? # in case user doesn't pass a desired bol to analyze, this chooses one at random
			bol = @@bols[rand(19)]
		else
		end
		#///////////////////////////////////////////////////////////////////////////////////////////

		#//////////////////////////////Fill in the graph with data/////////////////////////////////////////////////////////////
		home = g.add_nodes(bol+" ") # designate the home node
		(0..18).each do|x,y| # for each bol...

			y = g.add_nodes(@@bols[x],:fontsize => 10) #create node for each bol
			edge = home<<y # draw a line from home node to all the created nodes
			edge[:label => " #{data[bol][@@bols[x]]}\%", :fontsize => 12] # mark all the edges with the percentages from the markov data
		end
		#///////////////////////////////////////////////////////////////////////////////////////////

		g.output(:png => "#{output_name}.png" )
  	end


  	def markov_analysis_with_depth composition_file, depth
		
		#/////////////////////////////////Initialize necessary items//////////////////////////////////////////////////
		bol_hash_hash= Hash["Ta"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tin"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tun"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Din"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Te"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Re"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Tha"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Ge"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Ka"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha2"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dha3"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhi"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhe"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Dhet"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "Kre"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "The"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "The2"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}, "-"=>{"Ta"=>0, "Tin"=>0, "Tun"=>0, "Din"=>0, "Te"=>0, "Re"=>0, "Tha"=>0, "Ge"=>0, "Ka"=>0, "Dha"=>0, "Dha2"=>0, "Dha3"=>0, "Dhi"=>0, "Dhe"=>0, "Dhet"=>0, "Kre"=>0, "The"=>0, "The2"=>0, "-"=>0}]
		index=depth+1
		##///////////////////////////////////////////////////////////////////////////////////

		#///////////////////////// This pulls in the composition and puts it into an array //////////////////////////////////////////////
		composition = ReadWrite.open_read composition_file #opens the compositon file 
		comp_array = composition.scan(/(\-|\w+)/) #creates an array of arrays of all the hits in the sequence from the composition
		comp_array.flatten! #cleans up the array of arrays into a simple array that is ordered in terms of appearance in the composition
		total_hits= comp_array.size
		two_hit_totals= Hash.new
		d2=Hash.new
		#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		@@bols.each do|hash, key| # Set up d2 as hash of hashes
			d2.store(key, Hash.new)
		end

		(2..total_hits-1).each do |x| # initialize two_hit_totals and d2 hash with empty values
			
			current_hit = comp_array[x]
			previous_two = comp_array[x-1]+" "+comp_array[x-2]

			two_hit_totals.store(previous_two, 0)
			d2[current_hit].store(previous_two, 0)
		end

		(index+1..total_hits-1).each do |x| # Goes through and counts the number of times each pair of hits occurs in the composition
				
			previous_two = comp_array[x-1]+" "+comp_array[x-2]

			two_hit_totals[previous_two] +=1
		end

		(index..total_hits-1).each do |x| # goes through the composition and updates each bol for each time it's preceded by the other two bols
			
			current_hit = comp_array[x]
			previous_two =  comp_array[x-1]+" "+comp_array[x-2]
			d2[current_hit][previous_two]+=1
		end

		total=0
		#/////////////////// Turns the float values into a 1..10 percent value, if you sum the percents of a given bol they don't quite add up to 100%, it's usually around .98 or 1.0000004 so it's pretty damn close, but that's floats right?
		(0..18).each do |c| #for each bol
			d2[@@bols[c]].each do |hash,key| # for each value in the d2 of the current bol

				d2[@@bols[c]][hash] = (d2[@@bols[c]][hash].fdiv(d2[@@bols[c]].size)).round(2) # find %, then truncate values, ie 0.0273342 =>0.03
				total+=d2[@@bols[c]][hash]

			end
			total=0
		end
		#///////////////////////////////////////////////////////////////////////////////////////////
		return d2
  	end


	#///////////////////////////////////////////////////////////////////////////////////////////
	# This creates "output_name.png", a directed graph based on an input composition (compositon_file)
	# if you pass "true" for theory, the command line will ouput a series of graph theory analysis of the composition file
	# and graph_output_type specifies the layout for the output_name.png that is generated
 	#///////////////////////////////////////////////////////////////////////////////////////////
  	def total_composition_graph composition_file, output_name, theory, graph_output_type

  		#///////////////////////////////// initialize values /////////////////////////////////
  		graph_output_options=["circo","dot","fdp","neato","twopi"] #output formats for graph
  		data = markov_analysis composition_file #pull in the data from analysis of the composition
  		g = GraphViz.new( :G, :type => :digraph, :overlap => :scale, :use => graph_output_options[graph_output_type]) #create graph
  		t = GraphViz::Theory.new( g ) # call this to run graph theory functions
  		#///////////////////////////////////////////////////////////////////////////////////////////////////

			data.each do |h, k| # go through the results of the markov analysis
	
				current = g.add_node( h, :fontsize => 10 ) #create a node for each bol

				k.each do |l, m| #for each hash associated with current bol

					new_node = g.add_node(l, :fontsize => 10) # create nodes for all the other bols
					edge= current<<new_node #link them together
					edge[:label => " #{m}\%", :fontsize => 10] # add the % from analysis to the edge
				end
			end

		if theory==true # outputs graph theory analysis of composition graph

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

		if output_name=="false"
			puts "output_name= #{output_name}, So no graph created"
		else
			puts "graph created using #{graph_output_options[graph_output_type]} with name: #{output_name}.png"
			g.output(:png => "#{output_name}.png" )
		end
	end

end






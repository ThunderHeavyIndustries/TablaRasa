# Thunder Heavy Industries Dec 2014
# This is to analyze the tabla compositions produced by my generator, as well as the compositions
# of others.
# quesitons comments complaints: thunderheavyindustries@gmail.com
#
# This will generate "random" compositions in the form of text....well...maybe numbers would be faster
# in any event, it will genearte "compositions" for tabla drums. These are inteneded to be used as
# dummy compositions to explore with my analysis program for tabla patterns.
# there are 14 bols total. 7 right hand, 2 left, 10 combo. Well, there is some dissention, I'm following the format
# as laid out in Aloke Dutta's book. Currently the string outputs are optimized for human reading. IE: they spit out | da din ta | tin ta....

require_relative 'tabla_comp_analyzer'

class TablaCompGen

	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-"]
	@@bols_invert= @@bols.invert
	@@TCA= Composition_analyzer.new


	#this generator creates just strings of hits
	def gen_string_of_hits numberofhits # numberofhits will determine how many bols in the string

		str="" #initializing string

		numberofhits.times do |c|
			c = @@bols[rand(19)] #calls a random bol from the hash of bols
			str+=" "+c #builds a string of hits
		end

		#puts str	
		return str
		
	end

	#this does equalvalent subdivisions for the matra, ie: 4+4+4+4, not 2+3+2+3
	def gen_equal_subdivision numberofhits, matradiv

		count=(-1)  #starts @ -1 for indexing issues, and for placement of | within the output
		str="" #initializing string

		numberofhits.times do |c|
			count += 1
			c = @@bols[rand(19)] #choose random bol

			if count%matradiv==0 #if the current count is equal to the matra subdivision then
				str = str+" | "+c #add the '|' seperator
			else
				str = str+" "+c #otherwise just add the next bol to the string
			end
		end

		puts str+"|" #cap off the string with a the last '|'
		return str
	end

	# This allows for differing subdivisions of the matra, ie 2+3+2+3
	def gen_multi_subdivison numberofhits, sub1, sub2

		str="| " #initialize string
		length=0 #this will be used to keep track of the number of bols in the string
		sub12= sub1+sub2  

		if numberofhits%sub12!=0 #this is just an error warning. It will still output a string, but the matras won't line up with the total number of hits.
			puts "#{sub1} and #{sub2} don't add up to #{numberofhits} you will not end your desired beat cycle appropriately."
		end

		while length< numberofhits #we haven't hit the desired number of bols yet so...

			sub1.times do |c| #add the first subdivision worth of hits
				str = str+" "+ @@bols[rand(19)] +" " #choosing random bols
			end

			str= str+" | " #cap the first subdivision

			sub2.times do |c| #do the second subdivision worth of hits.
				str= str+" "+@@bols[rand(19)]+" " #choosing random bols
			end

			str= str+" | " #cap the string

			length+=sub12 #add the two subdivisions worth of bols to the total length of the sequence.
		end

		#{}`say "#{str}"` # Uncomment this on a Mac to have it speak the sequence generated. Useless, but entertaining.
		return str
	end



	def gen_markov_comp composition, desired_output_length, markov_depth

		#////////////////Initialization/////////////////////
		markov_values_hash = @@TCA.markov_analysis composition, markov_depth #this hash comes in like so  (hash of hashes): markov_values_hash["Ta"]=> {"Ta"=>0.02, "Tin"=>0.23.....}
		dist_hash= Hash["Ta"=>Array.new(),"Tin"=>Array.new(),"Tun"=>Array.new(),"Din"=>Array.new(),"Te"=>Array.new(),"Re"=>Array.new(),"Tha"=>Array.new(),"Ge"=>Array.new(),"Ka"=>Array.new(),"Dha"=>Array.new(),"Dha2"=>Array.new(),"Dha3"=>Array.new(),"Dhi"=>Array.new(),"Dhe"=>Array.new(),"Dhet"=>Array.new(),"Kre"=>Array.new(),"The"=>Array.new(),"The2"=>Array.new(),"-"=>Array.new()] # this is a hash of arrays, the arrays will be filed out based on the percentage of times a hit occurs based on the markov analysis.
		markov_composition= "" # string that will be returned as the composition
		start = @@bols[rand(19)] #initializing the composition with a random hit
		previous_hit= start # keeps track of the previous hit in the actual generation of the composition
		#///////////////////////////////////////////////////

		#///////////////// Fill distribution hash with values ///////////////
		# These distributions vary a little bit, so if we check array.size=> 100, or 97, or 104. So they're not perfect 100 member arrays.
		# this is a remnat of the float division , we lose or gain a little with each calculation, and I'm not too concerned about normalizing the whole thing
		# for what should be an organic process (playing music) a little less than 100% accuracy probably doesn't hurt. If anything I suspect it makes
		# the end product sound a little more organic than it would otherwise.
		@@bols.size.times do |x| #cycle through all the hits
			@@bols.size.times.each do |y| #cycle through all the hits again within whatever hit x happens to be...
				((markov_values_hash[@@bols[x]][@@bols[y]]*100).floor).times do |z| # say Dha occurs 20% of the time, then 0.02*100 = 2, so put Dha into the 2 times array 
					dist_hash[@@bols[x]].push(@@bols[y]) # this fills the array as we iterate so that we get the appropriate distribution of hits in the array for each bol within each bol
				end
			end
		end
		#////////////////////////////////////////////////////////	

		#///////////////////////// Compose the composition using the probabilites generated ///////////////////
		desired_output_length.times do |c| # until the composition has reached the desired length...

			c= dist_hash[previous_hit][rand(100)] #generates a hit based on the probabilites from the markov analysis found in the distribution hash
			markov_composition+=" "+c # add the next hit to the string
			previous_hit= c # keeps track of what the previous hit was for the next iteration
		end
		#//////////////////////////////////////////////////////////////////////////////////////////////////////


		return markov_composition #the completed composition returned in string form.
	end

 end












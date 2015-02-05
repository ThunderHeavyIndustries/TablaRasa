require_relative 'tabla_composition_generator'
require_relative 'read_write_files'
require_relative 'tabla_comp_analyzer'

TG = TablaCompGen.new
CA = Composition_analyzer.new
RW = R_W.new

# This creates a random composition 100 hits long, writes it to file, reads the file and does a markov analyses on the hits,
# then outputs a .png directed graph for a random bol in the composition. 
#///////////////////////////////////////////////////
# composition= TG.gen_string_of_hits 100
# RW.write_to_file "random_composition", composition
# CA.comp_graph "random_composition", "random_composition_graph", "", "circular"
#///////////////////////////////////////////////////


# This creates .png files for each graph output type for the same composition
# consisting of a directed graph representing an entire composition
#///////////////////////////////////////////////////
# composition= TG.gen_string_of_hits 100
# RW.write_to_file "random_composition", composition
# (0..4).each do |x|
# 	 CA.total_composition_graph "random_composition", "Whole_comp_graph_num#{x}", "false", x
# end
 #///////////////////////////////////////////////////


# This ouputs to the command line various graphy theory analyses of the composition
#
 #///////////////////////////////////////////////////
# composition= TG.gen_string_of_hits 100
# RW.write_to_file "random_composition", composition
# CA.total_composition_graph "random_composition", "false", "true", 0
 #///////////////////////////////////////////////////


# This returns a markov depth analysis of depth 2
#
 #///////////////////////////////////////////////////
 #composition= TG.gen_string_of_hits 100
 #RW.write_to_file "random_composition", composition
 #CA.markov_analysis_with_depth "random_composition", 2
 #///////////////////////////////////////////////////













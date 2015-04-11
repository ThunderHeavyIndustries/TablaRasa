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
 #composition= TG.gen_string_of_hits 100
# RW.write_to_file "random_composition", composition
 #(0..4).each do |x|
 	# CA.total_composition_graph "random_composition", "Whole_comp_graph_num#{x}", "false", x
 #end
 #///////////////////////////////////////////////////


# This ouputs to the command line various graphy theory analyses of the composition
 #///////////////////////////////////////////////////
 #composition= TG.gen_string_of_hits 100
 #RW.write_to_file "random_composition", composition
 #CA.total_composition_graph "random_composition", "notAll", true, 0
 #///////////////////////////////////////////////////



#create a chart for the composition
#ran = TG.gen_string_of_hits 100
#RW.write_to_file "random_composition", ran
#num = CA.analyze_composition "random_composition" ,1,0
#CA.charts num
#///////////////////////////////////////////////////

# This generates some charts for comparing markov compositions based on a random composition
=begin
  RW.write_to_file "random_composition", (TG.gen_string_of_hits 500)

  RW.write_to_file "markov_comp1", (TG.gen_markov_comp "random_composition", 500, 2)
  RW.write_to_file "markov_comp2", (TG.gen_markov_comp "random_composition", 500, 2)
  RW.write_to_file "markov_comp3", (TG.gen_markov_comp "random_composition", 500, 2)

  val1 = CA.analyze_composition "markov_comp1" ,0,1
  val2 = CA.analyze_composition "markov_comp2" ,0,1
  val3 = CA.analyze_composition "markov_comp3" ,0,1

  CA.charts val1, val2, val3, "Multi chart percents"

  val1 = CA.analyze_composition "markov_comp1" ,1,0
  val2 = CA.analyze_composition "markov_comp2" ,1,0
  val3 = CA.analyze_composition "markov_comp3" ,1,0

  CA.charts val1, val2, val3, "Multi chart hit nums"
=end



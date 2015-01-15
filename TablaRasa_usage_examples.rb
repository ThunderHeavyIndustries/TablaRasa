require_relative 'tabla_composition_generator'
require_relative 'read_write_files'
require_relative 'tabla_comp_analyzer'

TG = TablaCompGen.new
CA = Composition_analyzer.new
RW = R_W.new

# This creates a random composition 1000 hits long, writes it to file, reads the file and does a markov analyses on the hits, then outputs a .png
# directed graph for a random bol in the composition. 
#///////////////////////////////////////////////////
composition= TG.gen_string_of_hits 1000
RW.write_to_file "random_composition", composition
TG.gen_markov_comp "random_composition", 50, 1
CA.comp_graph "random_composition", "random_composition_graph", "", "circular"
#///////////////////////////////////////////////////

# TablaRasa
##Description
Ruby code for creating [tabla](http://en.wikipedia.org/wiki/Tabla) compositions, for practice or performance. There are also tools that allow for markov analysis of tabla compositions as well as creating new compositions based on the Markov analysis of other works. The quickest way to get started is to check out the "TablaRasa_usage_examples.rb" file. By uncommenting certain chunks you can see usage examples for each bit of functionality to help you get started quicker. The methods are arranged by file into analyzing, generating, usage examples, and read/write functionality.

## Dependancies, you will need these for some methods to work:
* [graphviz](http://www.graphviz.org/)
* [Imagemagick](http://www.imagemagick.org/)
* [gruff](https://github.com/topfunky/gruff)
* [ruby-graphviz](https://github.com/glejeune/Ruby-Graphviz/)
* [rmagick](https://github.com/rmagick/rmagick)

## In progress
* Create graph output for time dependant XYZ plane graphing
* Include midi support for computer performance of generated compositions
* Add matra divisions to markov compositions

## Some Terminology 
For the names of the bols I'm following the framework as set up by Aloke Dutta [as outlined in this book](http://www.alokedutta.com/product/tabla-lessons-and-practice/). Here are some other terms that might be of use if one is unfamiliar with north Indian music:

[bols](http://en.wikipedia.org/wiki/Bol_%28music%29),
[matras](http://en.wikipedia.org/wiki/Matra_(music))

##Method breakdown

### Tabla_composition_generator
In the tabla_composition_generator.rb file there a few options for constructing a composition.

"gen_string_of_hits" can get passed an integer, and it will return a string of random bols as long as the integer passed to it:
```Ruby
 gen_string_of_hits numberofhits

 gen_string_of_hits 5
 =>  Te Dha3 Ge Tun Re
 ```
 
"gen_equal_subdivision" will return a string of length "numberofhits" with equal subdivisions set by "matradiv" 
```Ruby
gen_equal_subdivision numberofhits, matradiv

gen_equal_subdivision 10, 5
 =>   | Dhet Re Te Dhi Tin | Tun Dha Din Te Ta|
 ```
 
 "gen_multi_subdivison" will return a string of length "numberofhits" with alternating subdivisions "sub1" and "sub2"
```Ruby
gen_multi_subdivison numberofhits, sub1, sub2

gen_multi_subdivison 10, 2, 3
=> |  Ka  Din  |  Tin  Dha3  Ka  |  Te  The2  |  Ta  The  The2  |
```

"gen_markov_comp" will return a string of "desired_output_length" based on a Markov analysis of depth "markov_depth" of the "composition" passed. 
```Ruby
gen_markov_comp composition, desired_output_length, markov_depth

gen_markov_comp "My_comp.txt", 10, 2
=>  Te Dha3 Ge Tun Re Dhet Re Te Dhi Tin
 ```
 
### Tabla_comp_analyzer
 
"analyze_composition" will return a hash that contains either the number of times a given bol occurs in a composition (bol_count), or the frequency (bol_freq) of each hit in the composition. If 1 is passed to both num, and frequency it will return both, with number of hits first, then frequency.
```Ruby
 analyze_composition composition_file, return_number_of_hits, return_frequency_of_hits 

 analyze_composition "My_File.txt", 1, 0 
 => bol_count
 bol_count["Ta"]=> 15
 
  analyze_composition "My_File.txt", 0, 1 
 => bol_freq
 bol_freq["Ta"]=> 0.05

  analyze_composition "My_File.txt", 1, 1 
 => bol_count
 => bol_freq
```

"markov_analysis" will do a Markov analysis of a composition of the depth of your choosing. It returns a hash of hashes (bol_hash_hash) containing the percentage of times a given bol is followed by any of the others. In bol_hash_hash the first value passed is the bol you want the values for, the next value passed will return a float giving the percentage of the time that the first bol is followed by the second bol.
```Ruby
markov_analysis composition_file, depth

markov_analysis "My_file.txt", 1
=> bol_hash_hash

bol_hash_hash["Ta"]["Tin"]=> 0.13


markov_analysis "My_file.txt", 2
=> bol_hash_hash

bol_hash_hash["Ta"]["Tin Da"]=> 0.03
```

"comp_graph" will output a .png file graph of the Markov values returned by the markov analyzer. The second parameter passed will be the name of the output .png file. The value passed to bol should be a bol from @@bol, this will be the bol for which all the values will be calculated in the graph. If it's left empty (ie: "") a random bol will be chosen on which to base the graph. "graph_type" will determine the output style, either a top down, or radial style.
```Ruby
comp_graph composition_file, output_name, bol, graph_type

comp_graph "My_file.txt", "My_save_file" "Dha", "circular"
=> My_save_file.png

comp_graph "My_file.txt", "My_save_file" "Dha", " straight"
=> My_save_file.png

```
"total_composition_graph" will output a .png graph of the entire composition. graph_output_type is an integer that corresponds to an entry in the following array: ["circo","dot","fdp","neato","twopi"]. If no string is passed to output_name, then it will not create a .png but you can still get the graph theory output. Theory output is turned on an off by passing true, or false to theory
```Ruby
total_composition_graph composition_file, output_name, theory, graph_output_type

total_composition_graph "My_composition", "My_graph", true, 2
=> My_graph.png
=> "graph theory analysis results output to the command line..."

total_composition_graph "My_composition", "My_graph", false, 2
=> My_graph.png
```

"charts" will output .png bar charts of the data you pass them. Data should be passed as an array of arrays. I highly suggest using "analyze_composition" to create your data. So if you want one compositions chart, Array = [[data]]. If you want to analyze multiple compositions against themselves you can do so by adding more to the array:  Array = [[data1], [data2],..., [data_n]]. Title is just a string.
```Ruby
charts data_array, chart_title

charts my_array, "My_chart"
=> My_chart.png
```

## Graph Example
These are examples of the graph output using [Ruby-Graphiz](https://github.com/glejeune/Ruby-Graphviz/). The first is the circular output, the second the straight output.


![Circular Graph](http://i.imgur.com/jA39HaC.png "Circular Graph output Example")

![LR Graph](http://i.imgur.com/AuPdtFE.png "Left to right output Example")

## Chart Example
These are examples of the chart output using [gruff](https://github.com/topfunky/gruff). The first is the total hits, the second is the percentage output for 3 random markov compositions derived from the same base composition.

![number of hits](http://i.imgur.com/5vgPwmt.png "Number of hits")
![percentage of total hits](http://i.imgur.com/on5YbOB.png "Percentages of hits")

 {TablaRasa}
    Copyright (C) {2015}  {Trace Norris}

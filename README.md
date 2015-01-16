# TablaRasa
##Description
Ruby code for creating [tabla](http://en.wikipedia.org/wiki/Tabla) compositions, for practice or performance. There are also tools that allow for markov analysis of tabla compositions as well as creating new compositions based on the markov analysis of other works. The quickest way to get started is to run the "TablaRasa_usage_examples.rb" file. It will go through a basic usage sequence for the software and generate a graph output.

## Some Terminology 
[bols](http://en.wikipedia.org/wiki/Bol_%28music%29),
[matras](http://en.wikipedia.org/wiki/Matra_(music))

## ToDo
* Increase the depth of the markov analysis.
* Create graph output for time dependant XYZ plane graphing
* Include midi support for computer performance of generated compositions
* Add matra divisions to markov compositions

### Tabla_composition_generator
In the tabla_composition_generator.rb file there a few options for constructing a composition.

This can get passed an integer, and it will return a string of random bols as long as the integer passed to it:
```Ruby
 gen_string_of_hits numberofhits

 gen_string_of_hits 5
 =>  Te Dha3 Ge Tun Re
 ```
 
This will return a string of length "numberofhits" with equal subdivisions set by "matradiv" 
```Ruby
gen_equal_subdivision numberofhits, matradiv

gen_string_of_hits 10, 5
 =>   | Dhet Re Te Dhi Tin | Tun Dha Din Te Ta|
 ```
 
 This will return a string of length "numberofhits" with alternating subdivisions "sub1" and "sub2"
```Ruby
gen_multi_subdivison numberofhits, sub1, sub2

gen_multi_subdivison 10, 2, 3
=> |  Ka  Din  |  Tin  Dha3  Ka  |  Te  The2  |  Ta  The  The2  |
```

This will return a string of "desired_output_length" based on a Markov analysis of the "composition" passed. Currently this only supports a "markov_depth" of 1
```Ruby
gen_markov_comp composition, desired_output_length, markov_depth

gen_markov_comp "My_comp.txt", 10, 1
=>  Te Dha3 Ge Tun Re Dhet Re Te Dhi Tin
 ```
 
 ### Tabla_comp_analyzer
 
 This will return a hash that contains either the number of times a given bol occurs in a composition (bol_count), or the frequency (bol_freq) of each hit in the composition
```Ruby
 analyze_composition composition_file, return_number_of_hits, return_frequency_of_hits 

 analyze_composition "My_File.txt", 1, 0 
 => bol_count
 bol_count["Ta"]=> 15
 
  analyze_composition "My_File.txt", 0, 1 
 => bol_freq
 bol_freq["Ta"]=> 0.05
```

This will do a Markov analysis of a composition (currently only uses a depth of 1). It returns a hash of hashes (bol_hash_hash) containing the percentage of times a given bol is followed by any of the others. In bol_hash_hash the first value passed is the bol you want the values for, the next value passed will return a float givin the percentage of the time that the first bol is followed by the second bol.
```Ruby
markov_analysis composition_file

markov_analysis "My_file.txt"
=> bol_hash_hash

bol_hash_hash["Ta"]["Tin"]=> 0.13

```

## Graph Example
This is an example of the graph output using [Rub-Graphiz](https://github.com/glejeune/Ruby-Graphviz/)

![Circular Graph](http://i.imgur.com/jA39HaC.png "Circular Graph output Example")

![LR Graph](http://i.imgur.com/AuPdtFE.png "Left to right output Example")

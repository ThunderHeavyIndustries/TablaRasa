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

## Usage Examples
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


## Graph Example
This is an example of the graph output using [Rub-Graphiz](https://github.com/glejeune/Ruby-Graphviz/)

![Circular Graph](http://i.imgur.com/jA39HaC.png "Circular Graph output Example")

![LR Graph](http://i.imgur.com/AuPdtFE.png "Left to right output Example")

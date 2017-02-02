# randomization-wtih-parallels
scripts that use GNU parallel for randomization 

### passwordGen
Generates random characters 

#### Docs
```
passwordgen.sh --length=[option] --threads=[option] --sets=[option] --num=[option]
        -l |--length    the length of the password to generate (default 7)
        -s |--sets              the number of sets to use (WARNING: SLOW) (default 1)
                                        WARNING: Using sets with large passowrds can take a long time
        -n | --num              the number of passwords from the set to display (default 1)
        -t |--threads   the number of threads to use
        -h | --help     displays this page
```
Sets - the --sets flag signifies the number of characters that paralell will be given in each data source. When paralell is given multiple data sources it will calculate all combinations therefore this is an expensive task.   
This is the same as doing parallel echo ::: a b c ::: d e f ::: 1 2 3

### iterate-thru-keyspace.sh 
Iterates thru a given keyspace

#### Docs
```
iterate-thru-keyspace.sh  [length] [keyspace] [threads]
Exmaple: iterate-thru-keyspace.sh 5 'combined' 8 
         would iterate thru the combined set with a length of 5 and use 8 threads
         keyspace options=upper, lower, number, special, combined, and alphanum
```
#### Legal
```
  O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
  ;login: The USENIX Magazine, February 2011:42-47.
```

##### License 
```
Copyright

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

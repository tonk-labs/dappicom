# Recursion

The main idea here is to use a kind of map-reduce style approach to recursively aggregate sub-computations into a final proof which we can verify on-chain.

From the trace notes, we will be given the following:
- a segment of computation A, we can denote A_i
  - address sorted tuples of memory
  - opcode partitioned tuples of memory
  - merkle memory tree of A_i_start, A_i_end
  - vector of dirty page bits for the sequence
  - pre-computed challenge r

## Procedure 1

1. check the address sorted memory for consistency 
2. check the challenge r for address sorted, and opcode memory inputs is correct
3. perform permutation check
4.  hash the dirty pages with the final values written to the memory to compute leafs in A_i_end
5. hash memory from the pages read to compute leafs in A_i_start

output -> permutation check result

## Procedure 2

1. check opcode transitions are correct and consistent
2. compute intermediate permutation check, using challenge r

output -> intermediate permutation check result


## Procedure 3

1. verify opcode a and opcode b
2. combine intermediate permutation checks


## Procedure 4

1. verify aggregate opcode checks
2. verify memory procedure
3. verify permutation check from both procedures matches




